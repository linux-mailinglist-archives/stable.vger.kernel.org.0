Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A3240DAA2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbhIPNG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239914AbhIPNG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B09A860F48;
        Thu, 16 Sep 2021 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797507;
        bh=QGI3sFee2fpiRwXbuf07iGwYdhTkIxvYZM5WiLNOnIE=;
        h=Subject:To:Cc:From:Date:From;
        b=HtnJVGLnk7T4HUTnq1CD4pQ7unlYj9ZbRhccDTGADieQo9aj1xVuJq0WAX4rZhKBc
         8XT26FCW1clUorsEWrD+DIVw4N7rWn/697v9HLIhpSWXFN7N6o/1CXWBPXhEqR9gfh
         BgifPwj1MINw0KD7yBxFCJIq+hxxRQ44wDLBImZk=
Subject: FAILED: patch "[PATCH] drm/amd/display: use GFP_ATOMIC in" failed to apply to 5.14-stable tree
To:     Anson.Jacob@amd.com, Aurabindo.Pillai@amd.com,
        alexander.deucher@amd.com, daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:05:04 +0200
Message-ID: <16317975044222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 704bd53543c661428f02f5dc52413cb6369603cf Mon Sep 17 00:00:00 2001
From: Anson Jacob <Anson.Jacob@amd.com>
Date: Fri, 30 Jul 2021 19:46:20 -0400
Subject: [PATCH] drm/amd/display: use GFP_ATOMIC in
 amdgpu_dm_irq_schedule_work

Replace GFP_KERNEL with GFP_ATOMIC as amdgpu_dm_irq_schedule_work
can't sleep.

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:196
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 253, name: kworker/6:1H
CPU: 6 PID: 253 Comm: kworker/6:1H Tainted: G        W  OE     5.11.0-promotion_2021_06_07-18_36_28_prelim_revert_retrain #8
Hardware name: System manufacturer System Product Name/PRIME X570-PRO, BIOS 3405 02/01/2021
Workqueue: events_highpri dm_irq_work_func [amdgpu]
Call Trace:
 <IRQ>
 dump_stack+0x5e/0x74
 ___might_sleep.cold+0x87/0x98
 __might_sleep+0x4b/0x80
 kmem_cache_alloc_trace+0x390/0x4f0
 amdgpu_dm_irq_handler+0x171/0x230 [amdgpu]
 amdgpu_irq_dispatch+0xc0/0x1e0 [amdgpu]
 amdgpu_ih_process+0x81/0x100 [amdgpu]
 amdgpu_irq_handler+0x26/0xa0 [amdgpu]
 __handle_irq_event_percpu+0x49/0x190
 ? __hrtimer_get_next_event+0x4d/0x80
 handle_irq_event_percpu+0x33/0x80
 handle_irq_event+0x33/0x60
 handle_edge_irq+0x82/0x190
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 common_interrupt+0xbb/0x140
 asm_common_interrupt+0x1e/0x40
RIP: 0010:amdgpu_device_rreg.part.0+0x44/0xf0 [amdgpu]
Code: 53 48 89 fb 4c 3b af c8 08 00 00 73 6d 83 e2 02 75 0d f6 87 40 62 01 00 10 0f 85 83 00 00 00 4c 03 ab d0 08 00 00 45 8b 6d 00 <8b> 05 3e b6 52 00 85 c0 7e 62 48 8b 43 08 0f b7 70 3e 65 8b 05 e3
RSP: 0018:ffffae7740fff9e8 EFLAGS: 00000286
RAX: ffffffffc05ee610 RBX: ffff8aaf8f620000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000005430 RDI: ffff8aaf8f620000
RBP: ffffae7740fffa08 R08: 0000000000000001 R09: 000000000000000a
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000005430
R13: 0000000071000000 R14: 0000000000000001 R15: 0000000000005430
 ? amdgpu_cgs_write_register+0x20/0x20 [amdgpu]
 amdgpu_device_rreg+0x17/0x20 [amdgpu]
 amdgpu_cgs_read_register+0x14/0x20 [amdgpu]
 dm_read_reg_func+0x38/0xb0 [amdgpu]
 generic_reg_wait+0x80/0x160 [amdgpu]
 dce_aux_transfer_raw+0x324/0x7c0 [amdgpu]
 dc_link_aux_transfer_raw+0x43/0x50 [amdgpu]
 dm_dp_aux_transfer+0x87/0x110 [amdgpu]
 drm_dp_dpcd_access+0x72/0x110 [drm_kms_helper]
 drm_dp_dpcd_read+0xb7/0xf0 [drm_kms_helper]
 drm_dp_get_one_sb_msg+0x349/0x480 [drm_kms_helper]
 drm_dp_mst_hpd_irq+0xc5/0xe40 [drm_kms_helper]
 ? drm_dp_mst_hpd_irq+0xc5/0xe40 [drm_kms_helper]
 dm_handle_hpd_rx_irq+0x184/0x1a0 [amdgpu]
 ? dm_handle_hpd_rx_irq+0x184/0x1a0 [amdgpu]
 handle_hpd_rx_irq+0x195/0x240 [amdgpu]
 ? __switch_to_asm+0x42/0x70
 ? __switch_to+0x131/0x450
 dm_irq_work_func+0x19/0x20 [amdgpu]
 process_one_work+0x209/0x400
 worker_thread+0x4d/0x3e0
 ? cancel_delayed_work+0xa0/0xa0
 kthread+0x124/0x160
 ? kthread_park+0x90/0x90
 ret_from_fork+0x22/0x30

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index 40f617bbb86f..4aba0e8c84f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -584,7 +584,7 @@ static void amdgpu_dm_irq_schedule_work(struct amdgpu_device *adev,
 		handler_data = container_of(handler_list->next, struct amdgpu_dm_irq_handler_data, list);
 
 		/*allocate a new amdgpu_dm_irq_handler_data*/
-		handler_data_add = kzalloc(sizeof(*handler_data), GFP_KERNEL);
+		handler_data_add = kzalloc(sizeof(*handler_data), GFP_ATOMIC);
 		if (!handler_data_add) {
 			DRM_ERROR("DM_IRQ: failed to allocate irq handler!\n");
 			return;

