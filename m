Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578092E3CF2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438768AbgL1OJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438776AbgL1OJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A88206E5;
        Mon, 28 Dec 2020 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164533;
        bh=qBGylRh7ELqSRZd0Q54qLZPjhjZWbDHUUKNBEPJQRJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szhWcHPE9CLY1XbTlxz9qI5+JBDggICGM/iXjwA3jtmcfc0m4Y6L3TN47TetRkcRq
         TP02EIpTCN5nF7+nClG2JL+/DMMesZ5NFx7El+sxiFr+HsXDoiLeP/f6lchEqPac3P
         hjwgsmAwlJmgcHiSjiwlJmiV/xe6fp8B7aOdK77s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1bc48bf7f78253f664a9@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/717] RDMA/cma: Fix deadlock on &lock in rdma_cma_listen_on_all() error unwind
Date:   Mon, 28 Dec 2020 13:43:25 +0100
Message-Id: <20201228125030.896722377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit dd37d2f59eb839d51b988f6668ce5f0d533b23fd ]

rdma_detroy_id() cannot be called under &lock - we must instead keep the
error'd ID around until &lock can be released, then destroy it.

This is complicated by the usual way listen IDs are destroyed through
cma_process_remove() which can run at any time and will asynchronously
destroy the same ID.

Remove the ID from visiblity of cma_process_remove() before going down the
destroy path outside the locking.

Fixes: c80a0c52d85c ("RDMA/cma: Add missing error handling of listen_id")
Link: https://lore.kernel.org/r/20201118133756.GK244516@ziepe.ca
Reported-by: syzbot+1bc48bf7f78253f664a9@syzkaller.appspotmail.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 4585f654f8836..c06c87a4dc5e7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2496,7 +2496,8 @@ static int cma_listen_handler(struct rdma_cm_id *id,
 }
 
 static int cma_listen_on_dev(struct rdma_id_private *id_priv,
-			     struct cma_device *cma_dev)
+			     struct cma_device *cma_dev,
+			     struct rdma_id_private **to_destroy)
 {
 	struct rdma_id_private *dev_id_priv;
 	struct net *net = id_priv->id.route.addr.dev_addr.net;
@@ -2504,6 +2505,7 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	lockdep_assert_held(&lock);
 
+	*to_destroy = NULL;
 	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
 		return 0;
 
@@ -2518,7 +2520,6 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 	       rdma_addr_size(cma_src_addr(id_priv)));
 
 	_cma_attach_to_dev(dev_id_priv, cma_dev);
-	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
 	cma_id_get(id_priv);
 	dev_id_priv->internal_id = 1;
 	dev_id_priv->afonly = id_priv->afonly;
@@ -2528,25 +2529,31 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 	ret = rdma_listen(&dev_id_priv->id, id_priv->backlog);
 	if (ret)
 		goto err_listen;
+	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
 	return 0;
 err_listen:
-	list_del(&id_priv->listen_list);
+	/* Caller must destroy this after releasing lock */
+	*to_destroy = dev_id_priv;
 	dev_warn(&cma_dev->device->dev, "RDMA CMA: %s, error %d\n", __func__, ret);
-	rdma_destroy_id(&dev_id_priv->id);
 	return ret;
 }
 
 static int cma_listen_on_all(struct rdma_id_private *id_priv)
 {
+	struct rdma_id_private *to_destroy;
 	struct cma_device *cma_dev;
 	int ret;
 
 	mutex_lock(&lock);
 	list_add_tail(&id_priv->list, &listen_any_list);
 	list_for_each_entry(cma_dev, &dev_list, list) {
-		ret = cma_listen_on_dev(id_priv, cma_dev);
-		if (ret)
+		ret = cma_listen_on_dev(id_priv, cma_dev, &to_destroy);
+		if (ret) {
+			/* Prevent racing with cma_process_remove() */
+			if (to_destroy)
+				list_del_init(&to_destroy->list);
 			goto err_listen;
+		}
 	}
 	mutex_unlock(&lock);
 	return 0;
@@ -2554,6 +2561,8 @@ static int cma_listen_on_all(struct rdma_id_private *id_priv)
 err_listen:
 	list_del(&id_priv->list);
 	mutex_unlock(&lock);
+	if (to_destroy)
+		rdma_destroy_id(&to_destroy->id);
 	return ret;
 }
 
@@ -4855,6 +4864,7 @@ static void cma_process_remove(struct cma_device *cma_dev)
 
 static int cma_add_one(struct ib_device *device)
 {
+	struct rdma_id_private *to_destroy;
 	struct cma_device *cma_dev;
 	struct rdma_id_private *id_priv;
 	unsigned int i;
@@ -4902,7 +4912,7 @@ static int cma_add_one(struct ib_device *device)
 	mutex_lock(&lock);
 	list_add_tail(&cma_dev->list, &dev_list);
 	list_for_each_entry(id_priv, &listen_any_list, list) {
-		ret = cma_listen_on_dev(id_priv, cma_dev);
+		ret = cma_listen_on_dev(id_priv, cma_dev, &to_destroy);
 		if (ret)
 			goto free_listen;
 	}
@@ -4915,6 +4925,7 @@ free_listen:
 	list_del(&cma_dev->list);
 	mutex_unlock(&lock);
 
+	/* cma_process_remove() will delete to_destroy */
 	cma_process_remove(cma_dev);
 	kfree(cma_dev->default_roce_tos);
 free_gid_type:
-- 
2.27.0



