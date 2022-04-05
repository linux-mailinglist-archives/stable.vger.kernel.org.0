Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33F04F39ED
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378872AbiDELjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354128AbiDEKLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C754AE36;
        Tue,  5 Apr 2022 02:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18003B817D3;
        Tue,  5 Apr 2022 09:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678B5C385A1;
        Tue,  5 Apr 2022 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152649;
        bh=5+9KDAL48H0XGF+RquqS/qTbpGXDPw4MvNTSaXTNd/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L76Yh/ekbaYVCUipuD6idhmMB2a8libl7+W+iTplLa3bsE3yt/42avPULxs+xxXLh
         EcarYSdHl4BosA5RKJ7TiBv7UbewdOxdF36bq4EirxC5Ysy2a96gYAILH0zss67xa6
         YRaKkxLpgo1ijMNpm4Kd384AS7Wr1A1SyV3lUaiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungup Moon <sungup.moon@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.15 826/913] nvme: allow duplicate NSIDs for private namespaces
Date:   Tue,  5 Apr 2022 09:31:28 +0200
Message-Id: <20220405070404.589654084@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sungup Moon <sungup.moon@samsung.com>

commit 5974ea7ce0f9a5987fc8cf5e08ad6e3e70bb542e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c      |   15 ++++++++++-----
 drivers/nvme/host/multipath.c |    7 ++++---
 drivers/nvme/host/nvme.h      |   19 +++++++++++++++++++
 include/linux/nvme.h          |    1 +
 4 files changed, 34 insertions(+), 8 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3510,15 +3510,20 @@ static const struct attribute_group *nvm
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
@@ -3686,7 +3691,7 @@ static int nvme_init_ns_head(struct nvme
 	int ret = 0;
 
 	mutex_lock(&ctrl->subsys->lock);
-	head = nvme_find_ns_head(ctrl->subsys, nsid);
+	head = nvme_find_ns_head(ctrl, nsid);
 	if (!head) {
 		head = nvme_alloc_ns_head(ctrl, nsid, ids);
 		if (IS_ERR(head)) {
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -462,10 +462,11 @@ int nvme_mpath_alloc_disk(struct nvme_ct
 
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
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -693,6 +693,25 @@ static inline bool nvme_check_ready(stru
 		return true;
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
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -322,6 +322,7 @@ enum {
 	NVME_CTRL_ONCS_TIMESTAMP		= 1 << 6,
 	NVME_CTRL_VWC_PRESENT			= 1 << 0,
 	NVME_CTRL_OACS_SEC_SUPP                 = 1 << 0,
+	NVME_CTRL_OACS_NS_MNGT_SUPP		= 1 << 3,
 	NVME_CTRL_OACS_DIRECTIVES		= 1 << 5,
 	NVME_CTRL_OACS_DBBUF_SUPP		= 1 << 8,
 	NVME_CTRL_LPA_CMD_EFFECTS_LOG		= 1 << 1,


