Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9314E419B29
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhI0RPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhI0ROf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEF061361;
        Mon, 27 Sep 2021 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762623;
        bh=Fg3r0Sa9za4VvlVWqNVgik2ceW728BMIdPknOBkgBnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9BhyvYY8EnVe7gs8ImWR8hwxZkmGSuaV8zGFktOlYJ3p1uvGraXOXu/aThkEaGI5
         z9tfwKRW77MiANyYuHNEDK37vA8XCDVzjWBGr7PfiRYxzJacY2FIbnFiBJkskDpLnw
         R4OXDCvUeRtSRqh3uUZrT99G+brJL3m+rd54VpCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton.eidelman@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/103] nvme: keep ctrl->namespaces ordered
Date:   Mon, 27 Sep 2021 19:02:33 +0200
Message-Id: <20210927170227.889773417@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 298ba0e3d4af539cc37f982d4c011a0f07fca48c ]

Various places in the nvme code that rely on ctrl->namespace to be
ordered.  Ensure that the namespae is inserted into the list at the
right position from the start instead of sorting it after the fact.

Fixes: 540c801c65eb ("NVMe: Implement namespace list scanning")
Reported-by: Anton Eidelman <anton.eidelman@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9c97628519e0..bbc3efef5027 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
-#include <linux/list_sort.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pr.h>
@@ -3801,15 +3800,6 @@ out_unlock:
 	return ret;
 }
 
-static int ns_cmp(void *priv, const struct list_head *a,
-		const struct list_head *b)
-{
-	struct nvme_ns *nsa = container_of(a, struct nvme_ns, list);
-	struct nvme_ns *nsb = container_of(b, struct nvme_ns, list);
-
-	return nsa->head->ns_id - nsb->head->ns_id;
-}
-
 struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 {
 	struct nvme_ns *ns, *ret = NULL;
@@ -3830,6 +3820,22 @@ struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 }
 EXPORT_SYMBOL_NS_GPL(nvme_find_get_ns, NVME_TARGET_PASSTHRU);
 
+/*
+ * Add the namespace to the controller list while keeping the list ordered.
+ */
+static void nvme_ns_add_to_ctrl_list(struct nvme_ns *ns)
+{
+	struct nvme_ns *tmp;
+
+	list_for_each_entry_reverse(tmp, &ns->ctrl->namespaces, list) {
+		if (tmp->head->ns_id < ns->head->ns_id) {
+			list_add(&ns->list, &tmp->list);
+			return;
+		}
+	}
+	list_add(&ns->list, &ns->ctrl->namespaces);
+}
+
 static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		struct nvme_ns_ids *ids)
 {
@@ -3889,9 +3895,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	}
 
 	down_write(&ctrl->namespaces_rwsem);
-	list_add_tail(&ns->list, &ctrl->namespaces);
+	nvme_ns_add_to_ctrl_list(ns);
 	up_write(&ctrl->namespaces_rwsem);
-
 	nvme_get_ctrl(ctrl);
 
 	device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
@@ -4160,10 +4165,6 @@ static void nvme_scan_work(struct work_struct *work)
 	if (nvme_scan_ns_list(ctrl) != 0)
 		nvme_scan_ns_sequential(ctrl);
 	mutex_unlock(&ctrl->scan_lock);
-
-	down_write(&ctrl->namespaces_rwsem);
-	list_sort(NULL, &ctrl->namespaces, ns_cmp);
-	up_write(&ctrl->namespaces_rwsem);
 }
 
 /*
-- 
2.33.0



