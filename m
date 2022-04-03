Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA24F0919
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347222AbiDCLnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiDCLnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:43:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9325A3968F
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 04:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0ED86CE0D07
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 11:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD05C340ED;
        Sun,  3 Apr 2022 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648986069;
        bh=D/YOg3vpON6UXh53ik260Qi0mtLll7Q+Cqj87wLwC4g=;
        h=Subject:To:Cc:From:Date:From;
        b=mc+uknTWg+Krn+II5Y27JHR6sBLVXqzl1RXuSA5AuphOCBelyBhRvboo68jaeV8T+
         XZhevcUJZhaHyfHjutBUIm1Flm6FiRcddqom+YtSw+lDim0oTc2DGYvb5Oos0YT57u
         hgDH4Krx/qHnOAe920xClP68q428ZPVnwK68mtu4=
Subject: FAILED: patch "[PATCH] nvme: allow duplicate NSIDs for private namespaces" failed to apply to 5.10-stable tree
To:     sungup.moon@samsung.com, hch@lst.de, sagi@grimberg.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 13:41:06 +0200
Message-ID: <164898606640119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5974ea7ce0f9a5987fc8cf5e08ad6e3e70bb542e Mon Sep 17 00:00:00 2001
From: Sungup Moon <sungup.moon@samsung.com>
Date: Mon, 14 Mar 2022 20:05:45 +0900
Subject: [PATCH] nvme: allow duplicate NSIDs for private namespaces

A NVMe subsystem with multiple controller can have private namespaces
that use the same NSID under some conditions:

 "If Namespace Management, ANA Reporting, or NVM Sets are supported, the
  NSIDs shall be unique within the NVM subsystem. If the Namespace
  Management, ANA Reporting, and NVM Sets are not supported, then NSIDs:
   a) for shared namespace shall be unique; and
   b) for private namespace are not required to be unique."

Reference: Section 6.1.6 NSID and Namespace Usage; NVM Express 1.4c spec.

Make sure this specific setup is supported in Linux.

Fixes: 9ad1927a3bc2 ("nvme: always search for namespace head")
Signed-off-by: Sungup Moon <sungup.moon@samsung.com>
[hch: refactored and fixed the controller vs subsystem based naming
      conflict]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ccc5877d514b..6dc05c1fa7db 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3627,15 +3627,20 @@ static const struct attribute_group *nvme_dev_attr_groups[] = {
 	NULL,
 };
 
-static struct nvme_ns_head *nvme_find_ns_head(struct nvme_subsystem *subsys,
+static struct nvme_ns_head *nvme_find_ns_head(struct nvme_ctrl *ctrl,
 		unsigned nsid)
 {
 	struct nvme_ns_head *h;
 
-	lockdep_assert_held(&subsys->lock);
+	lockdep_assert_held(&ctrl->subsys->lock);
 
-	list_for_each_entry(h, &subsys->nsheads, entry) {
-		if (h->ns_id != nsid)
+	list_for_each_entry(h, &ctrl->subsys->nsheads, entry) {
+		/*
+		 * Private namespaces can share NSIDs under some conditions.
+		 * In that case we can't use the same ns_head for namespaces
+		 * with the same NSID.
+		 */
+		if (h->ns_id != nsid || !nvme_is_unique_nsid(ctrl, h))
 			continue;
 		if (!list_empty(&h->list) && nvme_tryget_ns_head(h))
 			return h;
@@ -3829,7 +3834,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, unsigned nsid,
 	}
 
 	mutex_lock(&ctrl->subsys->lock);
-	head = nvme_find_ns_head(ctrl->subsys, nsid);
+	head = nvme_find_ns_head(ctrl, nsid);
 	if (!head) {
 		ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, ids);
 		if (ret) {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index c97d7f843977..ba90555124c4 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -482,10 +482,11 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 
 	/*
 	 * Add a multipath node if the subsystems supports multiple controllers.
-	 * We also do this for private namespaces as the namespace sharing data could
-	 * change after a rescan.
+	 * We also do this for private namespaces as the namespace sharing flag
+	 * could change after a rescan.
 	 */
-	if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) || !multipath)
+	if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) ||
+	    !nvme_is_unique_nsid(ctrl, head) || !multipath)
 		return 0;
 
 	head->disk = blk_alloc_disk(ctrl->numa_node);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 1ea908d43e17..1552a48719d6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -722,6 +722,25 @@ static inline bool nvme_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 		return queue_live;
 	return __nvme_check_ready(ctrl, rq, queue_live);
 }
+
+/*
+ * NSID shall be unique for all shared namespaces, or if at least one of the
+ * following conditions is met:
+ *   1. Namespace Management is supported by the controller
+ *   2. ANA is supported by the controller
+ *   3. NVM Set are supported by the controller
+ *
+ * In other case, private namespace are not required to report a unique NSID.
+ */
+static inline bool nvme_is_unique_nsid(struct nvme_ctrl *ctrl,
+		struct nvme_ns_head *head)
+{
+	return head->shared ||
+		(ctrl->oacs & NVME_CTRL_OACS_NS_MNGT_SUPP) ||
+		(ctrl->subsys->cmic & NVME_CTRL_CMIC_ANA) ||
+		(ctrl->ctratt & NVME_CTRL_CTRATT_NVM_SETS);
+}
+
 int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 9dbc3ef4daf7..2dcee34d467d 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -345,6 +345,7 @@ enum {
 	NVME_CTRL_ONCS_TIMESTAMP		= 1 << 6,
 	NVME_CTRL_VWC_PRESENT			= 1 << 0,
 	NVME_CTRL_OACS_SEC_SUPP                 = 1 << 0,
+	NVME_CTRL_OACS_NS_MNGT_SUPP		= 1 << 3,
 	NVME_CTRL_OACS_DIRECTIVES		= 1 << 5,
 	NVME_CTRL_OACS_DBBUF_SUPP		= 1 << 8,
 	NVME_CTRL_LPA_CMD_EFFECTS_LOG		= 1 << 1,

