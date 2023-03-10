Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D1B6B423C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCJOBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCJOBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ED4114EEE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FBEEB822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6AEC4339B;
        Fri, 10 Mar 2023 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456854;
        bh=o98BXVun5FyA5Afj6mRI+Q5TYE7BolSij+YxQWDTnJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWb7GFGiidHjwghL3u3bMDPv/DpPaydqLQ0Iml8BmLba5h0cVvsiSOEvBNciN22SP
         BXTM8zXZ7B/2zULA/5ODX1F8Vt598liVoi6fef3agGSQhyXN5LK+WyvDIxAfb8IrC1
         AbnE/BJMJkhWYdiW3+YnAM1mAcyVhWGtZDgYgJ5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nils Hanke <nh@edgeless.systems>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 117/211] nvme: bring back auto-removal of deleted namespaces during sequential scan
Date:   Fri, 10 Mar 2023 14:38:17 +0100
Message-Id: <20230310133722.297795725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0dd6fff2aad4e35633fef1ea72838bec5b47559a ]

Bring back the check of the Identify Namespace return value for the
legacy NVMe 1.0-style sequential scanning.  While NVMe 1.0 does not
support namespace management, there are "modern" cloud solutions like
Google Cloud Platform that claim the obsolete 1.0 compliance for no
good reason while supporting proprietary sideband namespace management.

Fixes: 1a893c2bfef4 ("nvme: refactor namespace probing")
Reported-by: Nils Hanke <nh@edgeless.systems>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Nils Hanke <nh@edgeless.systems>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8b64211411626..fbed8d1a02ef4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -38,6 +38,7 @@ struct nvme_ns_info {
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
+	bool is_removed;
 };
 
 unsigned int admin_timeout = 60;
@@ -1445,16 +1446,8 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	error = nvme_submit_sync_cmd(ctrl->admin_q, &c, *id, sizeof(**id));
 	if (error) {
 		dev_warn(ctrl->device, "Identify namespace failed (%d)\n", error);
-		goto out_free_id;
+		kfree(*id);
 	}
-
-	error = NVME_SC_INVALID_NS | NVME_SC_DNR;
-	if ((*id)->ncap == 0) /* namespace not allocated or attached */
-		goto out_free_id;
-	return 0;
-
-out_free_id:
-	kfree(*id);
 	return error;
 }
 
@@ -1468,6 +1461,13 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	ret = nvme_identify_ns(ctrl, info->nsid, &id);
 	if (ret)
 		return ret;
+
+	if (id->ncap == 0) {
+		/* namespace not allocated or attached */
+		info->is_removed = true;
+		return -ENODEV;
+	}
+
 	info->anagrpid = id->anagrpid;
 	info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
@@ -4418,6 +4418,7 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 {
 	struct nvme_ns_info info = { .nsid = nsid };
 	struct nvme_ns *ns;
+	int ret;
 
 	if (nvme_identify_ns_descs(ctrl, &info))
 		return;
@@ -4434,19 +4435,19 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	 * set up a namespace.  If not fall back to the legacy version.
 	 */
 	if ((ctrl->cap & NVME_CAP_CRMS_CRIMS) ||
-	    (info.ids.csi != NVME_CSI_NVM && info.ids.csi != NVME_CSI_ZNS)) {
-		if (nvme_ns_info_from_id_cs_indep(ctrl, &info))
-			return;
-	} else {
-		if (nvme_ns_info_from_identify(ctrl, &info))
-			return;
-	}
+	    (info.ids.csi != NVME_CSI_NVM && info.ids.csi != NVME_CSI_ZNS))
+		ret = nvme_ns_info_from_id_cs_indep(ctrl, &info);
+	else
+		ret = nvme_ns_info_from_identify(ctrl, &info);
+
+	if (info.is_removed)
+		nvme_ns_remove_by_nsid(ctrl, nsid);
 
 	/*
 	 * Ignore the namespace if it is not ready. We will get an AEN once it
 	 * becomes ready and restart the scan.
 	 */
-	if (!info.is_ready)
+	if (ret || !info.is_ready)
 		return;
 
 	ns = nvme_find_get_ns(ctrl, nsid);
-- 
2.39.2



