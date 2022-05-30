Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DC95380AC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiE3Nyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbiE3Nxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:53:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70583D491;
        Mon, 30 May 2022 06:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C799B80DA9;
        Mon, 30 May 2022 13:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5157C36AE5;
        Mon, 30 May 2022 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917865;
        bh=TLR9qUvj/0sLCsIOv3xfnFG3iF0rfWWP61ap7+Ebwaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrBMNO3dJaWLBo2/Mj+8HoRK1+BCTB6KNHdTT2jJXxSsIWVlpCxbwsQfNUXPAk/t4
         pL3bIXIJ3ICWQLc2/bpZ4LbByGUjaEhFscFqj98X0OTwRBV7DQLuUkZJL7Pe1XnWVJ
         Tm75o7jo2Wgibf0daiW13eK2qjiNK7epjd/X0jhdBmGc2T+160wMDpTq7sG3szM/qf
         VXNcE8/8Lzg8vfTZSoSnCJGBpV0jeaMbD8XOmt1rZhwx6Pu66V81c0eKBRuNtKdZX0
         ASEH3NmKSgR79IM+jjDUfxHuo9Aeb0TrLox1RgazF4Gt0xbr7EJ9SOvOfPawtnhf+y
         i8NzsDvPAnSdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 121/135] nvme: set non-mdts limits in nvme_scan_work
Date:   Mon, 30 May 2022 09:31:19 -0400
Message-Id: <20220530133133.1931716-121-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0abd772c57f0..79ef46356d40 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3096,10 +3096,6 @@ int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ret = nvme_init_non_mdts_limits(ctrl);
-	if (ret < 0)
-		return ret;
-
 	ret = nvme_configure_apst(ctrl);
 	if (ret < 0)
 		return ret;
@@ -4160,11 +4156,26 @@ static void nvme_scan_work(struct work_struct *work)
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

