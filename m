Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72DC60892C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiJVIbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiJVI3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF4804BC;
        Sat, 22 Oct 2022 01:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2594FB82D9F;
        Sat, 22 Oct 2022 07:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE4FC4314B;
        Sat, 22 Oct 2022 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425213;
        bh=PZgXAmve0+9tpL8ySnD8fCg3VhGqRFl3MW4egjYXpyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fbsq+3ELGDwR09M5GSkucOZCgCspJyOJ7qSA3D1ZBf/cJRxB65ap65d6fZZBalgw4
         htiZRueanqwJmGDctr6VVS77WxipGK6/hGic/Hwq++G4Kubdwhnr7wkIUslA1iCKLU
         8jBOJQfdTT33FmF58z2+JAzBCuN78Fb5BslkxPe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 399/717] media: amphion: fix a bug that vpu core may not resume after suspend
Date:   Sat, 22 Oct 2022 09:24:38 +0200
Message-Id: <20221022072515.523812141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 0202a665bf17fbe98fed954944aabbcb4f14a4cc ]

driver will enable the vpu core when request the first instance
on the core.
one vpu core can only support 8 streaming instances in the same
time, the instance won't be added to core's list before streamon.

so the actual instance count may be greater then the number in
the core's list.

in pm resume callback, driver will resume the core immediately if
core's list is not empty.
but this check is not accurate,
if suspend during one instance is requested, but not streamon,
then after suspend, the core won't be resume, and led to instance failure.

use the request_count instead of the core's list to check
whether is the core needed to resume immediately after suspend.

And it can make the pm suspend and resume callback more clear.

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu.h      |  1 -
 drivers/media/platform/amphion/vpu_core.c | 84 ++++++++++++-----------
 drivers/media/platform/amphion/vpu_core.h |  1 +
 drivers/media/platform/amphion/vpu_dbg.c  |  9 ++-
 4 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu.h b/drivers/media/platform/amphion/vpu.h
index f914de6ed81e..beac0309ca8d 100644
--- a/drivers/media/platform/amphion/vpu.h
+++ b/drivers/media/platform/amphion/vpu.h
@@ -119,7 +119,6 @@ struct vpu_mbox {
 enum vpu_core_state {
 	VPU_CORE_DEINIT = 0,
 	VPU_CORE_ACTIVE,
-	VPU_CORE_SNAPSHOT,
 	VPU_CORE_HANG
 };
 
diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 51a764713159..21a416b8e483 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -89,7 +89,7 @@ static int vpu_core_boot_done(struct vpu_core *core)
 		core->supported_instance_count = min(core->supported_instance_count, count);
 	}
 	core->fw_version = fw_version;
-	core->state = VPU_CORE_ACTIVE;
+	vpu_core_set_state(core, VPU_CORE_ACTIVE);
 
 	return 0;
 }
@@ -172,10 +172,26 @@ int vpu_alloc_dma(struct vpu_core *core, struct vpu_buffer *buf)
 	return __vpu_alloc_dma(core->dev, buf);
 }
 
-static void vpu_core_check_hang(struct vpu_core *core)
+void vpu_core_set_state(struct vpu_core *core, enum vpu_core_state state)
 {
-	if (core->hang_mask)
-		core->state = VPU_CORE_HANG;
+	if (state != core->state)
+		vpu_trace(core->dev, "vpu core state change from %d to %d\n", core->state, state);
+	core->state = state;
+	if (core->state == VPU_CORE_DEINIT)
+		core->hang_mask = 0;
+}
+
+static void vpu_core_update_state(struct vpu_core *core)
+{
+	if (!vpu_iface_get_power_state(core)) {
+		if (core->request_count)
+			vpu_core_set_state(core, VPU_CORE_HANG);
+		else
+			vpu_core_set_state(core, VPU_CORE_DEINIT);
+
+	} else if (core->state == VPU_CORE_ACTIVE && core->hang_mask) {
+		vpu_core_set_state(core, VPU_CORE_HANG);
+	}
 }
 
 static struct vpu_core *vpu_core_find_proper_by_type(struct vpu_dev *vpu, u32 type)
@@ -188,11 +204,13 @@ static struct vpu_core *vpu_core_find_proper_by_type(struct vpu_dev *vpu, u32 ty
 		dev_dbg(c->dev, "instance_mask = 0x%lx, state = %d\n", c->instance_mask, c->state);
 		if (c->type != type)
 			continue;
+		mutex_lock(&c->lock);
+		vpu_core_update_state(c);
+		mutex_unlock(&c->lock);
 		if (c->state == VPU_CORE_DEINIT) {
 			core = c;
 			break;
 		}
-		vpu_core_check_hang(c);
 		if (c->state != VPU_CORE_ACTIVE)
 			continue;
 		if (c->request_count < request_count) {
@@ -412,6 +430,12 @@ int vpu_inst_register(struct vpu_inst *inst)
 	}
 
 	mutex_lock(&core->lock);
+	if (core->state != VPU_CORE_ACTIVE) {
+		dev_err(core->dev, "vpu core is not active, state = %d\n", core->state);
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	if (inst->id >= 0 && inst->id < core->supported_instance_count)
 		goto exit;
 
@@ -453,7 +477,7 @@ int vpu_inst_unregister(struct vpu_inst *inst)
 		vpu_core_release_instance(core, inst->id);
 		inst->id = VPU_INST_NULL_ID;
 	}
-	vpu_core_check_hang(core);
+	vpu_core_update_state(core);
 	if (core->state == VPU_CORE_HANG && !core->instance_mask) {
 		int err;
 
@@ -462,7 +486,7 @@ int vpu_inst_unregister(struct vpu_inst *inst)
 		err = vpu_core_sw_reset(core);
 		mutex_lock(&core->lock);
 		if (!err) {
-			core->state = VPU_CORE_ACTIVE;
+			vpu_core_set_state(core, VPU_CORE_ACTIVE);
 			core->hang_mask = 0;
 		}
 	}
@@ -612,7 +636,7 @@ static int vpu_core_probe(struct platform_device *pdev)
 	mutex_init(&core->cmd_lock);
 	init_completion(&core->cmp);
 	init_waitqueue_head(&core->ack_wq);
-	core->state = VPU_CORE_DEINIT;
+	vpu_core_set_state(core, VPU_CORE_DEINIT);
 
 	core->res = of_device_get_match_data(dev);
 	if (!core->res)
@@ -761,33 +785,18 @@ static int __maybe_unused vpu_core_resume(struct device *dev)
 	mutex_lock(&core->lock);
 	pm_runtime_resume_and_get(dev);
 	vpu_core_get_vpu(core);
-	if (core->state != VPU_CORE_SNAPSHOT)
-		goto exit;
 
-	if (!vpu_iface_get_power_state(core)) {
-		if (!list_empty(&core->instances)) {
+	if (core->request_count) {
+		if (!vpu_iface_get_power_state(core))
 			ret = vpu_core_boot(core, false);
-			if (ret) {
-				dev_err(core->dev, "%s boot fail\n", __func__);
-				core->state = VPU_CORE_DEINIT;
-				goto exit;
-			}
-		} else {
-			core->state = VPU_CORE_DEINIT;
-		}
-	} else {
-		if (!list_empty(&core->instances)) {
+		else
 			ret = vpu_core_sw_reset(core);
-			if (ret) {
-				dev_err(core->dev, "%s sw_reset fail\n", __func__);
-				core->state = VPU_CORE_HANG;
-				goto exit;
-			}
+		if (ret) {
+			dev_err(core->dev, "resume fail\n");
+			vpu_core_set_state(core, VPU_CORE_HANG);
 		}
-		core->state = VPU_CORE_ACTIVE;
 	}
-
-exit:
+	vpu_core_update_state(core);
 	pm_runtime_put_sync(dev);
 	mutex_unlock(&core->lock);
 
@@ -801,18 +810,11 @@ static int __maybe_unused vpu_core_suspend(struct device *dev)
 	int ret = 0;
 
 	mutex_lock(&core->lock);
-	if (core->state == VPU_CORE_ACTIVE) {
-		if (!list_empty(&core->instances)) {
-			ret = vpu_core_snapshot(core);
-			if (ret) {
-				mutex_unlock(&core->lock);
-				return ret;
-			}
-		}
-
-		core->state = VPU_CORE_SNAPSHOT;
-	}
+	if (core->request_count)
+		ret = vpu_core_snapshot(core);
 	mutex_unlock(&core->lock);
+	if (ret)
+		return ret;
 
 	vpu_core_cancel_work(core);
 
diff --git a/drivers/media/platform/amphion/vpu_core.h b/drivers/media/platform/amphion/vpu_core.h
index 00a662997da4..65b562642603 100644
--- a/drivers/media/platform/amphion/vpu_core.h
+++ b/drivers/media/platform/amphion/vpu_core.h
@@ -11,5 +11,6 @@ u32 csr_readl(struct vpu_core *core, u32 reg);
 int vpu_alloc_dma(struct vpu_core *core, struct vpu_buffer *buf);
 void vpu_free_dma(struct vpu_buffer *buf);
 struct vpu_inst *vpu_core_find_instance(struct vpu_core *core, u32 index);
+void vpu_core_set_state(struct vpu_core *core, enum vpu_core_state state);
 
 #endif
diff --git a/drivers/media/platform/amphion/vpu_dbg.c b/drivers/media/platform/amphion/vpu_dbg.c
index da62bd718fb8..ad41060ce46e 100644
--- a/drivers/media/platform/amphion/vpu_dbg.c
+++ b/drivers/media/platform/amphion/vpu_dbg.c
@@ -15,6 +15,7 @@
 #include <linux/debugfs.h>
 #include "vpu.h"
 #include "vpu_defs.h"
+#include "vpu_core.h"
 #include "vpu_helpers.h"
 #include "vpu_cmds.h"
 #include "vpu_rpc.h"
@@ -233,6 +234,10 @@ static int vpu_dbg_core(struct seq_file *s, void *data)
 	if (seq_write(s, str, num))
 		return 0;
 
+	num = scnprintf(str, sizeof(str), "power %s\n",
+			vpu_iface_get_power_state(core) ? "on" : "off");
+	if (seq_write(s, str, num))
+		return 0;
 	num = scnprintf(str, sizeof(str), "state = %d\n", core->state);
 	if (seq_write(s, str, num))
 		return 0;
@@ -346,10 +351,10 @@ static ssize_t vpu_dbg_core_write(struct file *file,
 
 	pm_runtime_resume_and_get(core->dev);
 	mutex_lock(&core->lock);
-	if (core->state != VPU_CORE_DEINIT && !core->instance_mask) {
+	if (vpu_iface_get_power_state(core) && !core->request_count) {
 		dev_info(core->dev, "reset\n");
 		if (!vpu_core_sw_reset(core)) {
-			core->state = VPU_CORE_ACTIVE;
+			vpu_core_set_state(core, VPU_CORE_ACTIVE);
 			core->hang_mask = 0;
 		}
 	}
-- 
2.35.1



