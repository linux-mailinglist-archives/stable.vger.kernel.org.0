Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4746FFD7
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbhLJLdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:33:24 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51786 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbhLJLdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:33:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00116CE2AB9
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BFDC00446;
        Fri, 10 Dec 2021 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639135786;
        bh=NirLhppcjhlL+kvj+JB3OaSLzBv0XQpHRTifa3ehEfs=;
        h=Subject:To:Cc:From:Date:From;
        b=rDSnbVJtsxV5N/OU6HFR2HIPfhd6mNMVz7diQGv2+p7eCjpBe8HvQ7NqpN/OtVJ+j
         TKAmwbGFlXPFXP4CkPfwXDGnp55apYisWWYM1W16PSWSG/CGbwpOrsldpSwgum84Ye
         hZ0JDrQqEGO69xiJCGITnh77Ink1gCm5eYxRWNjk=
Subject: FAILED: patch "[PATCH] IB/hfi1: Fix early init panic" failed to apply to 4.19-stable tree
To:     mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:29:43 +0100
Message-ID: <163913578315427@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6a3cfec3c01f9983e961c3327cef0db129a3c43 Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Date: Mon, 29 Nov 2021 14:20:03 -0500
Subject: [PATCH] IB/hfi1: Fix early init panic

The following trace can be observed with an init failure such as firmware
load failures:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
  PGD 0 P4D 0
  Oops: 0010 [#1] SMP PTI
  CPU: 0 PID: 537 Comm: kworker/0:3 Tainted: G           OE    --------- -  - 4.18.0-240.el8.x86_64 #1
  Workqueue: events work_for_cpu_fn
  RIP: 0010:0x0
  Code: Bad RIP value.
  RSP: 0000:ffffae5f878a3c98 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: ffff95e48e025c00 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff95e48e025c00
  RBP: ffff95e4bf3660a4 R08: 0000000000000000 R09: ffffffff86d5e100
  R10: ffff95e49e1de600 R11: 0000000000000001 R12: ffff95e4bf366180
  R13: ffff95e48e025c00 R14: ffff95e4bf366028 R15: ffff95e4bf366000
  FS:  0000000000000000(0000) GS:ffff95e4df200000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffffffffffffd6 CR3: 0000000f86a0a003 CR4: 00000000001606f0
  Call Trace:
   receive_context_interrupt+0x1f/0x40 [hfi1]
   __free_irq+0x201/0x300
   free_irq+0x2e/0x60
   pci_free_irq+0x18/0x30
   msix_free_irq.part.2+0x46/0x80 [hfi1]
   msix_clean_up_interrupts+0x2b/0x70 [hfi1]
   hfi1_init_dd+0x640/0x1a90 [hfi1]
   do_init_one.isra.19+0x34d/0x680 [hfi1]
   local_pci_probe+0x41/0x90
   work_for_cpu_fn+0x16/0x20
   process_one_work+0x1a7/0x360
   worker_thread+0x1cf/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x112/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x35/0x40

The free_irq() results in a callback to the registered interrupt handler,
and rcd->do_interrupt is NULL because the receive context data structures
are not fully initialized.

Fix by ensuring that the do_interrupt is always assigned and adding a
guards in the slow path handler to detect and handle a partially
initialized receive context and noop the receive.

Link: https://lore.kernel.org/r/20211129192003.101968.33612.stgit@awfm-01.cornelisnetworks.com
Cc: stable@vger.kernel.org
Fixes: b0ba3c18d6bf ("IB/hfi1: Move normal functions from hfi1_devdata to const array")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ec37f4fd8e96..f1245c94ae26 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8415,6 +8415,8 @@ static void receive_interrupt_common(struct hfi1_ctxtdata *rcd)
  */
 static void __hfi1_rcd_eoi_intr(struct hfi1_ctxtdata *rcd)
 {
+	if (!rcd->rcvhdrq)
+		return;
 	clear_recv_intr(rcd);
 	if (check_packet_present(rcd))
 		force_recv_intr(rcd);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 61f341c3005c..e2c634af40e9 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1012,6 +1012,8 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 	struct hfi1_packet packet;
 	int skip_pkt = 0;
 
+	if (!rcd->rcvhdrq)
+		return RCV_PKT_OK;
 	/* Control context will always use the slow path interrupt handler */
 	needset = (rcd->ctxt == HFI1_CTRL_CTXT) ? 0 : 1;
 
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8e1236be46e1..6422dd6cae60 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -113,7 +113,6 @@ static int hfi1_create_kctxt(struct hfi1_devdata *dd,
 	rcd->fast_handler = get_dma_rtail_setting(rcd) ?
 				handle_receive_interrupt_dma_rtail :
 				handle_receive_interrupt_nodma_rtail;
-	rcd->slow_handler = handle_receive_interrupt;
 
 	hfi1_set_seq_cnt(rcd, 1);
 
@@ -334,6 +333,8 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, int numa,
 		rcd->numa_id = numa;
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 		rcd->rhf_rcv_function_map = normal_rhf_rcv_functions;
+		rcd->slow_handler = handle_receive_interrupt;
+		rcd->do_interrupt = rcd->slow_handler;
 		rcd->msix_intr = CCE_NUM_MSIX_VECTORS;
 
 		mutex_init(&rcd->exp_mutex);
@@ -898,8 +899,6 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 		if (!rcd)
 			continue;
 
-		rcd->do_interrupt = &handle_receive_interrupt;
-
 		lastfail = hfi1_create_rcvhdrq(dd, rcd);
 		if (!lastfail)
 			lastfail = hfi1_setup_eagerbufs(rcd);

