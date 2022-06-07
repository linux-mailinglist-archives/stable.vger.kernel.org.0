Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81235418AE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376561AbiFGVOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346961AbiFGVNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE121AC46;
        Tue,  7 Jun 2022 11:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8077B82018;
        Tue,  7 Jun 2022 18:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19785C385A5;
        Tue,  7 Jun 2022 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628066;
        bh=q3LpIfPSwOGe/mvSWUmd9l5vhrYfQkqCQRcFEYW08qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4z/K2928vMxMevcc+2G6zT+bjnLBhNCx/rz67Xcy1zlulZoY/geWqQ+zHkVrR/ND
         RNxAVj9G28/DFrCIets1+nX7B6FH9Hbu8q65/0jg+KYAycqeCGbE6gBRelzmU2W7Do
         bKIM6Zbg2tLK7jjC6xMSyRCzlopH5I4n0HmD/IZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 192/879] nvme: set non-mdts limits in nvme_scan_work
Date:   Tue,  7 Jun 2022 18:55:10 +0200
Message-Id: <20220607165008.414623997@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 78288665b5d0154978fed431985310cb4f166836 ]

In current implementation we set the non-mdts limits by calling
nvme_init_non_mdts_limits() from nvme_init_ctrl_finish().
This also tries to set the limits for the discovery controller which
has no I/O queues resulting in the warning message reported by the
nvme_log_error() when running blktest nvme/002: -

[ 2005.155946] run blktests nvme/002 at 2022-04-09 16:57:47
[ 2005.192223] loop: module loaded
[ 2005.196429] nvmet: adding nsid 1 to subsystem blktests-subsystem-0
[ 2005.200334] nvmet: adding nsid 1 to subsystem blktests-subsystem-1

<------------------------------SNIP---------------------------------->

[ 2008.958108] nvmet: adding nsid 1 to subsystem blktests-subsystem-997
[ 2008.962082] nvmet: adding nsid 1 to subsystem blktests-subsystem-998
[ 2008.966102] nvmet: adding nsid 1 to subsystem blktests-subsystem-999
[ 2008.973132] nvmet: creating discovery controller 1 for subsystem nqn.2014-08.org.nvmexpress.discovery for NQN testhostnqn.
*[ 2008.973196] nvme1: Identify(0x6), Invalid Field in Command (sct 0x0 / sc 0x2) MORE DNR*
[ 2008.974595] nvme nvme1: new ctrl: "nqn.2014-08.org.nvmexpress.discovery"
[ 2009.103248] nvme nvme1: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"

Move the call of nvme_init_non_mdts_limits() to nvme_scan_work() after
we verify that I/O queues are created since that is a converging point
for each transport where these limits are actually used.

1. FC :
nvme_fc_create_association()
 ...
 nvme_fc_create_io_queues(ctrl);
 ...
 nvme_start_ctrl()
  nvme_scan_queue()
   nvme_scan_work()

2. PCIe:-
nvme_reset_work()
 ...
 nvme_setup_io_queues()
  nvme_create_io_queues()
   nvme_alloc_queue()
 ...
 nvme_start_ctrl()
  nvme_scan_queue()
   nvme_scan_work()

3. RDMA :-
nvme_rdma_setup_ctrl
 ...
  nvme_rdma_configure_io_queues
  ...
  nvme_start_ctrl()
   nvme_scan_queue()
    nvme_scan_work()

4. TCP :-
nvme_tcp_setup_ctrl
 ...
  nvme_tcp_configure_io_queues
  ...
  nvme_start_ctrl()
   nvme_scan_queue()
    nvme_scan_work()

* nvme_scan_work()
...
nvme_validate_or_alloc_ns()
  nvme_alloc_ns()
   nvme_update_ns_info()
    nvme_update_disk_info()
     nvme_config_discard() <---
     blk_queue_max_write_zeroes_sectors() <---

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e1846d04817f..ac32d1cd8477 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3080,10 +3080,6 @@ int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ret = nvme_init_non_mdts_limits(ctrl);
-	if (ret < 0)
-		return ret;
-
 	ret = nvme_configure_apst(ctrl);
 	if (ret < 0)
 		return ret;
@@ -4237,11 +4233,26 @@ static void nvme_scan_work(struct work_struct *work)
 {
 	struct nvme_ctrl *ctrl =
 		container_of(work, struct nvme_ctrl, scan_work);
+	int ret;
 
 	/* No tagset on a live ctrl means IO queues could not created */
 	if (ctrl->state != NVME_CTRL_LIVE || !ctrl->tagset)
 		return;
 
+	/*
+	 * Identify controller limits can change at controller reset due to
+	 * new firmware download, even though it is not common we cannot ignore
+	 * such scenario. Controller's non-mdts limits are reported in the unit
+	 * of logical blocks that is dependent on the format of attached
+	 * namespace. Hence re-read the limits at the time of ns allocation.
+	 */
+	ret = nvme_init_non_mdts_limits(ctrl);
+	if (ret < 0) {
+		dev_warn(ctrl->device,
+			"reading non-mdts-limits failed: %d\n", ret);
+		return;
+	}
+
 	if (test_and_clear_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events)) {
 		dev_info(ctrl->device, "rescanning namespaces.\n");
 		nvme_clear_changed_ns_log(ctrl);
-- 
2.35.1



