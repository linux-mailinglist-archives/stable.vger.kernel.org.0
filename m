Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480472266EE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbgGTQHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732691AbgGTQHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5062C20672;
        Mon, 20 Jul 2020 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261250;
        bh=FGE9fuJm1AloYoqeYR5IGylsoxHhATCeYxY6HzPPikg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTZmODZeL+aSBR/7ZTcjD7kZHeTZ5rJkKeTFBroPTB9wES4nzzhYiOCKbxTM0XPGj
         0h2hXTf5joBXe95Ag2lBmE5vckiuJa5vj3edS0BCciRDSQhchFbSUUVRpicoa/l7yO
         6uClQiG7Rq1sN6OByDmBnWJ5p3YaEdGi3mNFYoiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 049/244] xen/xenbus: let xenbus_map_ring_valloc() return errno values only
Date:   Mon, 20 Jul 2020 17:35:20 +0200
Message-Id: <20200720152828.192668057@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 578c1bb9056263ad3c9e09746b3d6e4daf63bdb0 ]

Today xenbus_map_ring_valloc() can return either a negative errno
value (-ENOMEM or -EINVAL) or a grant status value. This is a mess as
e.g -ENOMEM and GNTST_eagain have the same numeric value.

Fix that by turning all grant mapping errors into -ENOENT. This is
no problem as all callers of xenbus_map_ring_valloc() only use the
return value to print an error message, and in case of mapping errors
the grant status value has already been printed by __xenbus_map_ring()
before.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200701121638.19840-3-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_client.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 9f8372079ecfa..4f168b46fbca5 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -456,8 +456,7 @@ EXPORT_SYMBOL_GPL(xenbus_free_evtchn);
  * Map @nr_grefs pages of memory into this domain from another
  * domain's grant table.  xenbus_map_ring_valloc allocates @nr_grefs
  * pages of virtual address space, maps the pages to that address, and
- * sets *vaddr to that address.  Returns 0 on success, and GNTST_*
- * (see xen/include/interface/grant_table.h) or -ENOMEM / -EINVAL on
+ * sets *vaddr to that address.  Returns 0 on success, and -errno on
  * error. If an error is returned, device will switch to
  * XenbusStateClosing and the error message will be saved in XenStore.
  */
@@ -477,18 +476,11 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, grant_ref_t *gnt_refs,
 		return -ENOMEM;
 
 	info->node = kzalloc(sizeof(*info->node), GFP_KERNEL);
-	if (!info->node) {
+	if (!info->node)
 		err = -ENOMEM;
-		goto out;
-	}
-
-	err = ring_ops->map(dev, info, gnt_refs, nr_grefs, vaddr);
-
-	/* Some hypervisors are buggy and can return 1. */
-	if (err > 0)
-		err = GNTST_general_error;
+	else
+		err = ring_ops->map(dev, info, gnt_refs, nr_grefs, vaddr);
 
- out:
 	kfree(info->node);
 	kfree(info);
 	return err;
@@ -507,7 +499,6 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 			     bool *leaked)
 {
 	int i, j;
-	int err = GNTST_okay;
 
 	if (nr_grefs > XENBUS_MAX_RING_GRANTS)
 		return -EINVAL;
@@ -522,7 +513,6 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 
 	for (i = 0; i < nr_grefs; i++) {
 		if (info->map[i].status != GNTST_okay) {
-			err = info->map[i].status;
 			xenbus_dev_fatal(dev, info->map[i].status,
 					 "mapping in shared page %d from domain %d",
 					 gnt_refs[i], dev->otherend_id);
@@ -531,7 +521,7 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 			handles[i] = info->map[i].handle;
 	}
 
-	return GNTST_okay;
+	return 0;
 
  fail:
 	for (i = j = 0; i < nr_grefs; i++) {
@@ -554,7 +544,7 @@ static int __xenbus_map_ring(struct xenbus_device *dev,
 		}
 	}
 
-	return err;
+	return -ENOENT;
 }
 
 /**
-- 
2.25.1



