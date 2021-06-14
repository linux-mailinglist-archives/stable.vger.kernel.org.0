Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00E13A6471
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhFNLZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235112AbhFNLWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C399C611CA;
        Mon, 14 Jun 2021 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667952;
        bh=5j+UuKM1H9kfB9W91AEjqQUEDdJ/O8DXtfhWcR0/Mx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzdXykEpe5TU/Daqjm4KKN59RogVFNzoSgJKXf0JPD34tJobXQR/8UCXZezNVYiSD
         QtpvX87NSfQ+aspYDccjxkzMujqXFYvvXAuCLRhkMkCcvPEdXr12N8ZmG1kCy5EKDt
         8TXMQ4kxMqjCZugWEcw+DwtcBR0de/CbQReiMqb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.12 105/173] usb: cdnsp: Fix deadlock issue in cdnsp_thread_irq_handler
Date:   Mon, 14 Jun 2021 12:27:17 +0200
Message-Id: <20210614102701.660621135@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit a9aecef198faae3240921b707bc09b602e966fce upstream.

Patch fixes the following critical issue caused by deadlock which has been
detected during testing NCM class:

smp: csd: Detected non-responsive CSD lock (#1) on CPU#0
smp:     csd: CSD lock (#1) unresponsive.
....
RIP: 0010:native_queued_spin_lock_slowpath+0x61/0x1d0
RSP: 0018:ffffbc494011cde0 EFLAGS: 00000002
RAX: 0000000000000101 RBX: ffff9ee8116b4a68 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ee8116b4658
RBP: ffffbc494011cde0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116b4658
R13: ffff9ee8116b4670 R14: 0000000000000246 R15: ffff9ee8116b4658
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7bcc41a830 CR3: 000000007a612003 CR4: 00000000001706e0
Call Trace:
 <IRQ>
 do_raw_spin_lock+0xc0/0xd0
 _raw_spin_lock_irqsave+0x95/0xa0
 cdnsp_gadget_ep_queue.cold+0x88/0x107 [cdnsp_udc_pci]
 usb_ep_queue+0x35/0x110
 eth_start_xmit+0x220/0x3d0 [u_ether]
 ncm_tx_timeout+0x34/0x40 [usb_f_ncm]
 ? ncm_free_inst+0x50/0x50 [usb_f_ncm]
 __hrtimer_run_queues+0xac/0x440
 hrtimer_run_softirq+0x8c/0xb0
 __do_softirq+0xcf/0x428
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 do_softirq_own_stack+0x61/0x70
 irq_exit_rcu+0xc1/0xd0
 sysvec_apic_timer_interrupt+0x52/0xb0
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:do_raw_spin_trylock+0x18/0x40
RSP: 0018:ffffbc494138bda8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff9ee8116b4658 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff9ee8116b4658
RBP: ffffbc494138bda8 R08: 0000000000000001 R09: 0000000000000000
R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116b4658
R13: ffff9ee8116b4670 R14: ffff9ee7b5c73d80 R15: ffff9ee8116b4000
 _raw_spin_lock+0x3d/0x70
 ? cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
 cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
 ? cdnsp_remove_request+0x1f0/0x1f0 [cdnsp_udc_pci]
 ? cdnsp_thread_irq_handler+0x5/0xa0 [cdnsp_udc_pci]
 ? irq_thread+0xa0/0x1c0
 irq_thread_fn+0x28/0x60
 irq_thread+0x105/0x1c0
 ? __kthread_parkme+0x42/0x90
 ? irq_forced_thread_fn+0x90/0x90
 ? wake_threads_waitq+0x30/0x30
 ? irq_thread_check_affinity+0xe0/0xe0
 kthread+0x12a/0x160
 ? kthread_park+0x90/0x90
 ret_from_fork+0x22/0x30

The root cause of issue is spin_lock/spin_unlock instruction instead
spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
function.

Cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210526060527.7197-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int
 {
 	struct cdnsp_device *pdev = (struct cdnsp_device *)data;
 	union cdnsp_trb *event_ring_deq;
+	unsigned long flags;
 	int counter = 0;
 
-	spin_lock(&pdev->lock);
+	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
 		cdnsp_died(pdev);
-		spin_unlock(&pdev->lock);
+		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}
 
@@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int
 
 	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
 
-	spin_unlock(&pdev->lock);
+	spin_unlock_irqrestore(&pdev->lock, flags);
 
 	return IRQ_HANDLED;
 }


