Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D964E121494
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbfLPSMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbfLPSMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F6D206E0;
        Mon, 16 Dec 2019 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519957;
        bh=xSVs3r04PT5m97YjF+wZ6dfZTqbLcmVYKcLXLpectC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZl0+9BApED1Sm0b4GfvqcEhVi6eNSNCnR9JrYcMH2cV/lRrfLIsY8lTicV9yyfZP
         Qo6FbcuGosgZYOkHcvBJqpUcNoffZ83TP6aymDT4wwRWO4XvlZLC5bXVI5QKNJiWCY
         CWOQmJx2iS1yURrj1fnEXvkCJxV4G1448UuaPoqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 138/180] scsi: qla2xxx: Fix premature timer expiration
Date:   Mon, 16 Dec 2019 18:49:38 +0100
Message-Id: <20191216174842.676136994@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 3a4b6cc7332130ac5cbf3b505d8cddf0aa2ea745 ]

For any qla2xxx async command, the SRB buffer is used to send it. In
setting up the SRB buffer, the timer for this command is started before all
memory allocation has finished.  Under low memory pressure, memory alloc
can go to sleep and not wake up before the timer expires. Once timer has
expired, the timer thread will access uninitialize fields resulting into
NULL pointer crash.

This patch fixes this crash by moving the start of timer after everything
is setup.

backtrace shows following

PID: 3720   TASK: ffff996928401040  CPU: 0   COMMAND: "qla2xxx_1_dpc"
0 [ffff99652751b698] __schedule at ffffffff965676c7
1 [ffff99652751b728] schedule at ffffffff96567bc9
2 [ffff99652751b738] schedule_timeout at ffffffff965655e8
3 [ffff99652751b7e0] io_schedule_timeout at ffffffff9656726d
4 [ffff99652751b810] congestion_wait at ffffffff95fd8d12
5 [ffff99652751b870] isolate_migratepages_range at ffffffff95fddaf3
6 [ffff99652751b930] compact_zone at ffffffff95fdde96
7 [ffff99652751b980] compact_zone_order at ffffffff95fde0bc
8 [ffff99652751ba20] try_to_compact_pages at ffffffff95fde481
9 [ffff99652751ba80] __alloc_pages_direct_compact at ffffffff9655cc31
10 [ffff99652751bae0] __alloc_pages_slowpath at ffffffff9655d101
11 [ffff99652751bbd0] __alloc_pages_nodemask at ffffffff95fc0e95
12 [ffff99652751bc80] dma_generic_alloc_coherent at ffffffff95e3217f
13 [ffff99652751bcc8] x86_swiotlb_alloc_coherent at ffffffff95e6b7a1
14 [ffff99652751bcf8] qla2x00_rft_id at ffffffffc055b5e0 [qla2xxx]
15 [ffff99652751bd50] qla2x00_loop_resync at ffffffffc0533e71 [qla2xxx]
16 [ffff99652751be68] qla2x00_do_dpc at ffffffffc05210ca [qla2xxx]

PID: 0      TASK: ffffffff96a18480  CPU: 0   COMMAND: "swapper/0"
 0 [ffff99652fc03ae0] machine_kexec at ffffffff95e63674
 1 [ffff99652fc03b40] __crash_kexec at ffffffff95f1ce12
 2 [ffff99652fc03c10] crash_kexec at ffffffff95f1cf00
 3 [ffff99652fc03c28] oops_end at ffffffff9656c758
 4 [ffff99652fc03c50] no_context at ffffffff9655aa7e
 5 [ffff99652fc03ca0] __bad_area_nosemaphore at ffffffff9655ab15
 6 [ffff99652fc03cf0] bad_area_nosemaphore at ffffffff9655ac86
 7 [ffff99652fc03d00] __do_page_fault at ffffffff9656f6b0
 8 [ffff99652fc03d70] do_page_fault at ffffffff9656f915
 9 [ffff99652fc03da0] page_fault at ffffffff9656b758
    [exception RIP: unknown or invalid address]
    RIP: 0000000000000000  RSP: ffff99652fc03e50  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffff99652b79a600  RCX: ffff99652b79a760
    RDX: ffff99652b79a600  RSI: ffffffffc0525ad0  RDI: ffff99652b79a600
    RBP: ffff99652fc03e60   R8: ffffffff96a18a18   R9: ffffffff96ee3c00
    R10: 0000000000000002  R11: ffff99652fc03de8  R12: ffff99652b79a760
    R13: 0000000000000100  R14: ffffffffc0525ad0  R15: ffff99652b79a600
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
10 [ffff99652fc03e50] qla2x00_sp_timeout at ffffffffc0525af8 [qla2xxx]
11 [ffff99652fc03e68] call_timer_fn at ffffffff95ea7f58
12 [ffff99652fc03ea0] run_timer_softirq at ffffffff95eaa3bd
13 [ffff99652fc03f18] __do_softirq at ffffffff95ea0f05
14 [ffff99652fc03f88] call_softirq at ffffffff9657832c
15 [ffff99652fc03fa0] do_softirq at ffffffff95e2e675
16 [ffff99652fc03fc0] irq_exit at ffffffff95ea1285
17 [ffff99652fc03fd8] smp_apic_timer_interrupt at ffffffff965796c8
18 [ffff99652fc03ff0] apic_timer_interrupt at ffffffff96575df2

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 1 +
 drivers/scsi/qla2xxx/qla_iocb.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 674ee2afe2b52..0eb1d5a790b26 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -537,6 +537,7 @@ typedef struct srb {
 	wait_queue_head_t nvme_ls_waitq;
 	struct fc_port *fcport;
 	struct scsi_qla_host *vha;
+	unsigned int start_timer:1;
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9312b19ed708b..1886de92034c7 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2540,7 +2540,7 @@ void qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 	sp->free = qla2x00_sp_free;
 	if (IS_QLAFX00(sp->vha->hw) && sp->type == SRB_FXIOCB_DCMD)
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
-	add_timer(&sp->u.iocb_cmd.timer);
+	sp->start_timer = 1;
 }
 
 static void
@@ -3668,6 +3668,9 @@ qla2x00_start_sp(srb_t *sp)
 		break;
 	}
 
+	if (sp->start_timer)
+		add_timer(&sp->u.iocb_cmd.timer);
+
 	wmb();
 	qla2x00_start_iocbs(vha, qp->req);
 done:
-- 
2.20.1



