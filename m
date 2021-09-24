Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4991F41744F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345013AbhIXNEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345994AbhIXNCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A1B6141B;
        Fri, 24 Sep 2021 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488088;
        bh=L2JtrA2yCpB+B9ZayCS/SSBEzm/tPDkPUgRC192/uZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzJgVfgV+sXoLTFqnwNzkSpjTdZAwsfI8KljjCOPAqnHom1cOhUJZg0ZoXe2oHm70
         twUmklazKcp0a4Ja2lb7PcZAvAt6rbL+nRykXxi0ugqrtQQw0xwwDmjvpzyon/dbP7
         B/73WEk9l0jDcjIEyIheJd1MhDFN7IXZZEAHmSLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 080/100] habanalabs: fix race between soft reset and heartbeat
Date:   Fri, 24 Sep 2021 14:44:29 +0200
Message-Id: <20210924124344.145361365@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit 8bb8b505761238be0d6a83dc41188867d65e5d4c ]

There is a scenario where an ongoing soft reset would race with an
ongoing heartbeat routine, eventually causing heartbeat to fail and
thus to escalate into a hard reset.

With this fix, soft-reset procedure will disable heartbeat CPU messages
and flush the (ongoing) current one before continuing with reset code.

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c      | 53 +++++++++++++++-----
 drivers/misc/habanalabs/common/firmware_if.c | 18 +++++--
 drivers/misc/habanalabs/common/habanalabs.h  |  4 +-
 drivers/misc/habanalabs/common/hw_queue.c    | 30 ++++-------
 4 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index ff4cbde289c0..0a788a13f2c1 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -682,6 +682,44 @@ out:
 	return rc;
 }
 
+static void take_release_locks(struct hl_device *hdev)
+{
+	/* Flush anyone that is inside the critical section of enqueue
+	 * jobs to the H/W
+	 */
+	hdev->asic_funcs->hw_queues_lock(hdev);
+	hdev->asic_funcs->hw_queues_unlock(hdev);
+
+	/* Flush processes that are sending message to CPU */
+	mutex_lock(&hdev->send_cpu_message_lock);
+	mutex_unlock(&hdev->send_cpu_message_lock);
+
+	/* Flush anyone that is inside device open */
+	mutex_lock(&hdev->fpriv_list_lock);
+	mutex_unlock(&hdev->fpriv_list_lock);
+}
+
+static void cleanup_resources(struct hl_device *hdev, bool hard_reset)
+{
+	if (hard_reset)
+		device_late_fini(hdev);
+
+	/*
+	 * Halt the engines and disable interrupts so we won't get any more
+	 * completions from H/W and we won't have any accesses from the
+	 * H/W to the host machine
+	 */
+	hdev->asic_funcs->halt_engines(hdev, hard_reset);
+
+	/* Go over all the queues, release all CS and their jobs */
+	hl_cs_rollback_all(hdev);
+
+	/* Release all pending user interrupts, each pending user interrupt
+	 * holds a reference to user context
+	 */
+	hl_release_pending_user_interrupts(hdev);
+}
+
 /*
  * hl_device_suspend - initiate device suspend
  *
@@ -707,16 +745,7 @@ int hl_device_suspend(struct hl_device *hdev)
 	/* This blocks all other stuff that is not blocked by in_reset */
 	hdev->disabled = true;
 
-	/*
-	 * Flush anyone that is inside the critical section of enqueue
-	 * jobs to the H/W
-	 */
-	hdev->asic_funcs->hw_queues_lock(hdev);
-	hdev->asic_funcs->hw_queues_unlock(hdev);
-
-	/* Flush processes that are sending message to CPU */
-	mutex_lock(&hdev->send_cpu_message_lock);
-	mutex_unlock(&hdev->send_cpu_message_lock);
+	take_release_locks(hdev);
 
 	rc = hdev->asic_funcs->suspend(hdev);
 	if (rc)
@@ -894,8 +923,8 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 		return 0;
 	}
 
-	hard_reset = (flags & HL_RESET_HARD) != 0;
-	from_hard_reset_thread = (flags & HL_RESET_FROM_RESET_THREAD) != 0;
+	hard_reset = !!(flags & HL_RESET_HARD);
+	from_hard_reset_thread = !!(flags & HL_RESET_FROM_RESET_THREAD);
 
 	if (!hard_reset && !hdev->supports_soft_reset) {
 		hard_instead_soft = true;
diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 2e4d04ec6b53..653e8f5ef6ac 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -240,11 +240,15 @@ int hl_fw_send_cpu_message(struct hl_device *hdev, u32 hw_queue_id, u32 *msg,
 	/* set fence to a non valid value */
 	pkt->fence = cpu_to_le32(UINT_MAX);
 
-	rc = hl_hw_queue_send_cb_no_cmpl(hdev, hw_queue_id, len, pkt_dma_addr);
-	if (rc) {
-		dev_err(hdev->dev, "Failed to send CB on CPU PQ (%d)\n", rc);
-		goto out;
-	}
+	/*
+	 * The CPU queue is a synchronous queue with an effective depth of
+	 * a single entry (although it is allocated with room for multiple
+	 * entries). We lock on it using 'send_cpu_message_lock' which
+	 * serializes accesses to the CPU queue.
+	 * Which means that we don't need to lock the access to the entire H/W
+	 * queues module when submitting a JOB to the CPU queue.
+	 */
+	hl_hw_queue_submit_bd(hdev, queue, 0, len, pkt_dma_addr);
 
 	if (prop->fw_app_cpu_boot_dev_sts0 & CPU_BOOT_DEV_STS0_PKT_PI_ACK_EN)
 		expected_ack_val = queue->pi;
@@ -2235,6 +2239,10 @@ static int hl_fw_dynamic_init_cpu(struct hl_device *hdev,
 	dev_info(hdev->dev,
 		"Loading firmware to device, may take some time...\n");
 
+	/*
+	 * In this stage, "cpu_dyn_regs" contains only LKD's hard coded values!
+	 * It will be updated from FW after hl_fw_dynamic_request_descriptor().
+	 */
 	dyn_regs = &fw_loader->dynamic_loader.comm_desc.cpu_dyn_regs;
 
 	rc = hl_fw_dynamic_send_protocol_cmd(hdev, fw_loader, COMMS_RST_STATE,
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 6b3cdd7e068a..c63e26da5135 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -2436,7 +2436,9 @@ void destroy_hdev(struct hl_device *hdev);
 int hl_hw_queues_create(struct hl_device *hdev);
 void hl_hw_queues_destroy(struct hl_device *hdev);
 int hl_hw_queue_send_cb_no_cmpl(struct hl_device *hdev, u32 hw_queue_id,
-				u32 cb_size, u64 cb_ptr);
+		u32 cb_size, u64 cb_ptr);
+void hl_hw_queue_submit_bd(struct hl_device *hdev, struct hl_hw_queue *q,
+		u32 ctl, u32 len, u64 ptr);
 int hl_hw_queue_schedule_cs(struct hl_cs *cs);
 u32 hl_hw_queue_add_ptr(u32 ptr, u16 val);
 void hl_hw_queue_inc_ci_kernel(struct hl_device *hdev, u32 hw_queue_id);
diff --git a/drivers/misc/habanalabs/common/hw_queue.c b/drivers/misc/habanalabs/common/hw_queue.c
index bcabfdbf1e01..0afead229e97 100644
--- a/drivers/misc/habanalabs/common/hw_queue.c
+++ b/drivers/misc/habanalabs/common/hw_queue.c
@@ -65,7 +65,7 @@ void hl_hw_queue_update_ci(struct hl_cs *cs)
 }
 
 /*
- * ext_and_hw_queue_submit_bd() - Submit a buffer descriptor to an external or a
+ * hl_hw_queue_submit_bd() - Submit a buffer descriptor to an external or a
  *                                H/W queue.
  * @hdev: pointer to habanalabs device structure
  * @q: pointer to habanalabs queue structure
@@ -80,8 +80,8 @@ void hl_hw_queue_update_ci(struct hl_cs *cs)
  * This function must be called when the scheduler mutex is taken
  *
  */
-static void ext_and_hw_queue_submit_bd(struct hl_device *hdev,
-			struct hl_hw_queue *q, u32 ctl, u32 len, u64 ptr)
+void hl_hw_queue_submit_bd(struct hl_device *hdev, struct hl_hw_queue *q,
+		u32 ctl, u32 len, u64 ptr)
 {
 	struct hl_bd *bd;
 
@@ -222,8 +222,8 @@ static int hw_queue_sanity_checks(struct hl_device *hdev, struct hl_hw_queue *q,
  * @cb_size: size of CB
  * @cb_ptr: pointer to CB location
  *
- * This function sends a single CB, that must NOT generate a completion entry
- *
+ * This function sends a single CB, that must NOT generate a completion entry.
+ * Sending CPU messages can be done instead via 'hl_hw_queue_submit_bd()'
  */
 int hl_hw_queue_send_cb_no_cmpl(struct hl_device *hdev, u32 hw_queue_id,
 				u32 cb_size, u64 cb_ptr)
@@ -231,16 +231,7 @@ int hl_hw_queue_send_cb_no_cmpl(struct hl_device *hdev, u32 hw_queue_id,
 	struct hl_hw_queue *q = &hdev->kernel_queues[hw_queue_id];
 	int rc = 0;
 
-	/*
-	 * The CPU queue is a synchronous queue with an effective depth of
-	 * a single entry (although it is allocated with room for multiple
-	 * entries). Therefore, there is a different lock, called
-	 * send_cpu_message_lock, that serializes accesses to the CPU queue.
-	 * As a result, we don't need to lock the access to the entire H/W
-	 * queues module when submitting a JOB to the CPU queue
-	 */
-	if (q->queue_type != QUEUE_TYPE_CPU)
-		hdev->asic_funcs->hw_queues_lock(hdev);
+	hdev->asic_funcs->hw_queues_lock(hdev);
 
 	if (hdev->disabled) {
 		rc = -EPERM;
@@ -258,11 +249,10 @@ int hl_hw_queue_send_cb_no_cmpl(struct hl_device *hdev, u32 hw_queue_id,
 			goto out;
 	}
 
-	ext_and_hw_queue_submit_bd(hdev, q, 0, cb_size, cb_ptr);
+	hl_hw_queue_submit_bd(hdev, q, 0, cb_size, cb_ptr);
 
 out:
-	if (q->queue_type != QUEUE_TYPE_CPU)
-		hdev->asic_funcs->hw_queues_unlock(hdev);
+	hdev->asic_funcs->hw_queues_unlock(hdev);
 
 	return rc;
 }
@@ -328,7 +318,7 @@ static void ext_queue_schedule_job(struct hl_cs_job *job)
 	cq->pi = hl_cq_inc_ptr(cq->pi);
 
 submit_bd:
-	ext_and_hw_queue_submit_bd(hdev, q, ctl, len, ptr);
+	hl_hw_queue_submit_bd(hdev, q, ctl, len, ptr);
 }
 
 /*
@@ -407,7 +397,7 @@ static void hw_queue_schedule_job(struct hl_cs_job *job)
 	else
 		ptr = (u64) (uintptr_t) job->user_cb;
 
-	ext_and_hw_queue_submit_bd(hdev, q, ctl, len, ptr);
+	hl_hw_queue_submit_bd(hdev, q, ctl, len, ptr);
 }
 
 static int init_signal_cs(struct hl_device *hdev,
-- 
2.33.0



