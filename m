Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DDC6B430D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjCJOKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjCJOJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4451184F9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3832B82291
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D77DC433D2;
        Fri, 10 Mar 2023 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457351;
        bh=/klgkCbfemWAdxJo7bRHxEKpc43wKYFdJuMtUQ6Z2e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGDqfVi1epTzNmEG6Qob3kpqUdSZlGSJk5Y4vuSn3Nrnm24Pqh4nrGELSEhLAqFAa
         b7K0OMdr0TbylnlMBp6kWXWWu85d5Ux7ACZOvRDH1veQ7jeYA5caeB8I+3q21JvZHI
         TCKqMcX+dLl7xXzF8cLhPfiH/zu2177ABVFHO+i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nils Hanke <nh@edgeless.systems>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/200] nvme: bring back auto-removal of deleted namespaces during sequential scan
Date:   Fri, 10 Mar 2023 14:38:35 +0100
Message-Id: <20230310133720.407990040@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index 5acc9ae225df3..2031fd960549c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -38,6 +38,7 @@ struct nvme_ns_info {
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
+	bool is_removed;
 };
 
 unsigned int admin_timeout = 60;
@@ -1439,16 +1440,8 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
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
 
@@ -1462,6 +1455,13 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
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
@@ -4388,6 +4388,7 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 {
 	struct nvme_ns_info info = { .nsid = nsid };
 	struct nvme_ns *ns;
+	int ret;
 
 	if (nvme_identify_ns_descs(ctrl, &info))
 		return;
@@ -4404,19 +4405,19 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
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



