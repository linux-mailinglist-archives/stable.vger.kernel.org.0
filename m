Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674F54F704D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiDGBVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbiDGBSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F121A396A;
        Wed,  6 Apr 2022 18:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7B861DDC;
        Thu,  7 Apr 2022 01:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CDBC385A1;
        Thu,  7 Apr 2022 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294025;
        bh=uHkminpCFLODGOilaSIsj0VwbWAxm7wdZlU4aEtfu9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2ttaT/N+4Tx6aO4cv4s7jP+cOdsNlLlOK4J9xAgBwVEW/Dg35Vc77peHdaW3ousO
         JS60xTW3i2ybFzzMaAvQ+hOkFh9qBclhFCxS48GTwqgwgw3dAg0gMRCcIM9IR/Jgdl
         uF8cmYWIu3kl3CJWQxeBSDBrUJWgfAUtzcCJUZ5wb7l+oGinLNwQ7Vqe9O3iEcrjPJ
         BnrUbPrtF7+sNRB/Vrj/jnCqh/v5WAXJ8r4CDjGGZ6K/vdI+cS532IOdxhlFMLjMme
         HBNyTH4aCaTtcHLQqOfa1JWNJ9kkFWkrwkSK3CQp/v6kaRI5p3+SSQ9Lr3egkM3Yvj
         saN29lNkjppaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton.eidelman@gmail.com>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 19/27] nvme-multipath: fix hang when disk goes live over reconnect
Date:   Wed,  6 Apr 2022 21:12:49 -0400
Message-Id: <20220407011257.114287-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Anton Eidelman <anton.eidelman@gmail.com>

[ Upstream commit a4a6f3c8f61c3cfbda4998ad94596059ad7e4332 ]

nvme_mpath_init_identify() invoked from nvme_init_identify() fetches a
fresh ANA log from the ctrl.  This is essential to have an up to date
path states for both existing namespaces and for those scan_work may
discover once the ctrl is up.

This happens in the following cases:
  1) A new ctrl is being connected.
  2) An existing ctrl is successfully reconnected.
  3) An existing ctrl is being reset.

While in (1) ctrl->namespaces is empty, (2 & 3) may have namespaces, and
nvme_read_ana_log() may call nvme_update_ns_ana_state().

This result in a hang when the ANA state of an existing namespace changes
and makes the disk live: nvme_mpath_set_live() issues IO to the namespace
through the ctrl, which does NOT have IO queues yet.

See sample hang below.

Solution:
- nvme_update_ns_ana_state() to call set_live only if ctrl is live
- nvme_read_ana_log() call from nvme_mpath_init_identify()
  therefore only fetches and parses the ANA log;
  any erros in this process will fail the ctrl setup as appropriate;
- a separate function nvme_mpath_update()
  is called in nvme_start_ctrl();
  this parses the ANA log without fetching it.
  At this point the ctrl is live,
  therefore, disks can be set live normally.

Sample failure:
    nvme nvme0: starting error recovery
    nvme nvme0: Reconnecting in 10 seconds...
    block nvme0n6: no usable path - requeuing I/O
    INFO: task kworker/u8:3:312 blocked for more than 122 seconds.
          Tainted: G            E     5.14.5-1.el7.elrepo.x86_64 #1
    Workqueue: nvme-wq nvme_tcp_reconnect_ctrl_work [nvme_tcp]
    Call Trace:
     __schedule+0x2a2/0x7e0
     schedule+0x4e/0xb0
     io_schedule+0x16/0x40
     wait_on_page_bit_common+0x15c/0x3e0
     do_read_cache_page+0x1e0/0x410
     read_cache_page+0x12/0x20
     read_part_sector+0x46/0x100
     read_lba+0x121/0x240
     efi_partition+0x1d2/0x6a0
     bdev_disk_changed.part.0+0x1df/0x430
     bdev_disk_changed+0x18/0x20
     blkdev_get_whole+0x77/0xe0
     blkdev_get_by_dev+0xd2/0x3a0
     __device_add_disk+0x1ed/0x310
     device_add_disk+0x13/0x20
     nvme_mpath_set_live+0x138/0x1b0 [nvme_core]
     nvme_update_ns_ana_state+0x2b/0x30 [nvme_core]
     nvme_update_ana_state+0xca/0xe0 [nvme_core]
     nvme_parse_ana_log+0xac/0x170 [nvme_core]
     nvme_read_ana_log+0x7d/0xe0 [nvme_core]
     nvme_mpath_init_identify+0x105/0x150 [nvme_core]
     nvme_init_identify+0x2df/0x4d0 [nvme_core]
     nvme_init_ctrl_finish+0x8d/0x3b0 [nvme_core]
     nvme_tcp_setup_ctrl+0x337/0x390 [nvme_tcp]
     nvme_tcp_reconnect_ctrl_work+0x24/0x40 [nvme_tcp]
     process_one_work+0x1bd/0x360
     worker_thread+0x50/0x3d0

Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/multipath.c | 25 +++++++++++++++++++++++--
 drivers/nvme/host/nvme.h      |  4 ++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d5d5d035d677..17df1c783be3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4338,6 +4338,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
 		nvme_start_queues(ctrl);
+		nvme_mpath_update(ctrl);
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 727520c39710..2105fead04aa 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -573,8 +573,17 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 	ns->ana_grpid = le32_to_cpu(desc->grpid);
 	ns->ana_state = desc->state;
 	clear_bit(NVME_NS_ANA_PENDING, &ns->flags);
-
-	if (nvme_state_is_live(ns->ana_state))
+	/*
+	 * nvme_mpath_set_live() will trigger I/O to the multipath path device
+	 * and in turn to this path device.  However we cannot accept this I/O
+	 * if the controller is not live.  This may deadlock if called from
+	 * nvme_mpath_init_identify() and the ctrl will never complete
+	 * initialization, preventing I/O from completing.  For this case we
+	 * will reprocess the ANA log page in nvme_mpath_update() once the
+	 * controller is ready.
+	 */
+	if (nvme_state_is_live(ns->ana_state) &&
+	    ns->ctrl->state == NVME_CTRL_LIVE)
 		nvme_mpath_set_live(ns);
 }
 
@@ -661,6 +670,18 @@ static void nvme_ana_work(struct work_struct *work)
 	nvme_read_ana_log(ctrl);
 }
 
+void nvme_mpath_update(struct nvme_ctrl *ctrl)
+{
+	u32 nr_change_groups = 0;
+
+	if (!ctrl->ana_log_buf)
+		return;
+
+	mutex_lock(&ctrl->ana_lock);
+	nvme_parse_ana_log(ctrl, &nr_change_groups, nvme_update_ana_state);
+	mutex_unlock(&ctrl->ana_lock);
+}
+
 static void nvme_anatt_timeout(struct timer_list *t)
 {
 	struct nvme_ctrl *ctrl = from_timer(ctrl, t, anatt_timer);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ed79a6c7e804..c1442e6f1b87 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -752,6 +752,7 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl);
+void nvme_mpath_update(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
@@ -826,6 +827,9 @@ static inline int nvme_mpath_init_identify(struct nvme_ctrl *ctrl,
 "Please enable CONFIG_NVME_MULTIPATH for full support of multi-port devices.\n");
 	return 0;
 }
+static inline void nvme_mpath_update(struct nvme_ctrl *ctrl)
+{
+}
 static inline void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 {
 }
-- 
2.35.1

