Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC8269551
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390710AbfGOOXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730883AbfGOOXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:23:10 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374CF2184E;
        Mon, 15 Jul 2019 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200589;
        bh=uNbRFgTFVlfLBX/aYNoEramw/MRSETRomrDvkiKnYgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIr7TgFeOmG/Q5x23EBPYvH/DOugIC4B0wNGyq9p+P6OjaPzcxda4jM7UJIKLQkzS
         0Nw7WprjT4sjPn3NIVvKHhSrcPJ6jphp1loAPYSbFr+D5tTnq0WI8LUiGkIXGU+Kxi
         B4kZs+HYl5r9sBb3Bt/FDH0ddaRKRsYi3KYLdoMQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 085/158] nvme: fix possible io failures when removing multipathed ns
Date:   Mon, 15 Jul 2019 10:16:56 -0400
Message-Id: <20190715141809.8445-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit 2181e455612a8db2761eabbf126640552a451e96 ]

When a shared namespace is removed, we call blk_cleanup_queue()
when the device can still be accessed as the current path and this can
result in submission to a dying queue. Hence, direct_make_request()
called by our mpath device may fail (propagating the failure to userspace).
Instead, we want to failover this I/O to a different path if one exists.
Thus, before we cleanup the request queue, we make sure that the device is
cleared from the current path nor it can be selected again as such.

Fix this by:
- clear the ns from the head->list and synchronize rcu to make sure there is
  no concurrent path search that restores it as the current path
- clear the mpath current path in order to trigger a subsequent path search
  and sync srcu to wait for any ongoing request submissions
- safely continue to namespace removal and blk_cleanup_queue

Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d8869d978c34..e26d1191c5ad 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3168,6 +3168,14 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 		return;
 
 	nvme_fault_inject_fini(ns);
+
+	mutex_lock(&ns->ctrl->subsys->lock);
+	list_del_rcu(&ns->siblings);
+	mutex_unlock(&ns->ctrl->subsys->lock);
+	synchronize_rcu(); /* guarantee not available in head->list */
+	nvme_mpath_clear_current_path(ns);
+	synchronize_srcu(&ns->head->srcu); /* wait for concurrent submissions */
+
 	if (ns->disk && ns->disk->flags & GENHD_FL_UP) {
 		sysfs_remove_group(&disk_to_dev(ns->disk)->kobj,
 					&nvme_ns_id_attr_group);
@@ -3179,16 +3187,10 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 			blk_integrity_unregister(ns->disk);
 	}
 
-	mutex_lock(&ns->ctrl->subsys->lock);
-	list_del_rcu(&ns->siblings);
-	nvme_mpath_clear_current_path(ns);
-	mutex_unlock(&ns->ctrl->subsys->lock);
-
 	down_write(&ns->ctrl->namespaces_rwsem);
 	list_del_init(&ns->list);
 	up_write(&ns->ctrl->namespaces_rwsem);
 
-	synchronize_srcu(&ns->head->srcu);
 	nvme_mpath_check_last_path(ns);
 	nvme_put_ns(ns);
 }
-- 
2.20.1

