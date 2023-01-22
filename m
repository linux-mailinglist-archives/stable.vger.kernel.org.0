Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7627676FFB
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjAVP1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAVP1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4099E23130
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0EBA60C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9FCC433EF;
        Sun, 22 Jan 2023 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401230;
        bh=anJhn1xTGF7/2L+AJmuCdPRZxGap8zInwRywMjsYcY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caOg7qbjPr2HUwy3IWC7VrsM5UyZ2CAz+ijG7a0QxuTzfAzqf6Rh60CtP8ZR9Iw/T
         2LMiJ8LbkMWKfHJJTtrmVBFuSHof5gE2sHjsxGEI9TolkYtRo4CnLp1zEM4Ul4ZwH4
         cf1ItQva/LKqbkBwvsmrksBmF3C9Oaisv1AEBqIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vishnu Dasa <vdasa@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Nathan Chancellor <nathan@kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Bryan Tan <bryantan@vmware.com>
Subject: [PATCH 6.1 131/193] VMCI: Use threaded irqs instead of tasklets
Date:   Sun, 22 Jan 2023 16:04:20 +0100
Message-Id: <20230122150252.315661556@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Vishnu Dasa <vdasa@vmware.com>

commit 3daed6345d5880464f46adab871d208e1baa2f3a upstream.

The vmci_dispatch_dgs() tasklet function calls vmci_read_data()
which uses wait_event() resulting in invalid sleep in an atomic
context (and therefore potentially in a deadlock).

Use threaded irqs to fix this issue and completely remove usage
of tasklets.

[   20.264639] BUG: sleeping function called from invalid context at drivers/misc/vmw_vmci/vmci_guest.c:145
[   20.264643] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 762, name: vmtoolsd
[   20.264645] preempt_count: 101, expected: 0
[   20.264646] RCU nest depth: 0, expected: 0
[   20.264647] 1 lock held by vmtoolsd/762:
[   20.264648]  #0: ffff0000874ae440 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: vsock_connect+0x60/0x330 [vsock]
[   20.264658] Preemption disabled at:
[   20.264659] [<ffff80000151d7d8>] vmci_send_datagram+0x44/0xa0 [vmw_vmci]
[   20.264665] CPU: 0 PID: 762 Comm: vmtoolsd Not tainted 5.19.0-0.rc8.20220727git39c3c396f813.60.fc37.aarch64 #1
[   20.264667] Hardware name: VMware, Inc. VBSA/VBSA, BIOS VEFI 12/31/2020
[   20.264668] Call trace:
[   20.264669]  dump_backtrace+0xc4/0x130
[   20.264672]  show_stack+0x24/0x80
[   20.264673]  dump_stack_lvl+0x88/0xb4
[   20.264676]  dump_stack+0x18/0x34
[   20.264677]  __might_resched+0x1a0/0x280
[   20.264679]  __might_sleep+0x58/0x90
[   20.264681]  vmci_read_data+0x74/0x120 [vmw_vmci]
[   20.264683]  vmci_dispatch_dgs+0x64/0x204 [vmw_vmci]
[   20.264686]  tasklet_action_common.constprop.0+0x13c/0x150
[   20.264688]  tasklet_action+0x40/0x50
[   20.264689]  __do_softirq+0x23c/0x6b4
[   20.264690]  __irq_exit_rcu+0x104/0x214
[   20.264691]  irq_exit_rcu+0x1c/0x50
[   20.264693]  el1_interrupt+0x38/0x6c
[   20.264695]  el1h_64_irq_handler+0x18/0x24
[   20.264696]  el1h_64_irq+0x68/0x6c
[   20.264697]  preempt_count_sub+0xa4/0xe0
[   20.264698]  _raw_spin_unlock_irqrestore+0x64/0xb0
[   20.264701]  vmci_send_datagram+0x7c/0xa0 [vmw_vmci]
[   20.264703]  vmci_datagram_dispatch+0x84/0x100 [vmw_vmci]
[   20.264706]  vmci_datagram_send+0x2c/0x40 [vmw_vmci]
[   20.264709]  vmci_transport_send_control_pkt+0xb8/0x120 [vmw_vsock_vmci_transport]
[   20.264711]  vmci_transport_connect+0x40/0x7c [vmw_vsock_vmci_transport]
[   20.264713]  vsock_connect+0x278/0x330 [vsock]
[   20.264715]  __sys_connect_file+0x8c/0xc0
[   20.264718]  __sys_connect+0x84/0xb4
[   20.264720]  __arm64_sys_connect+0x2c/0x3c
[   20.264721]  invoke_syscall+0x78/0x100
[   20.264723]  el0_svc_common.constprop.0+0x68/0x124
[   20.264724]  do_el0_svc+0x38/0x4c
[   20.264725]  el0_svc+0x60/0x180
[   20.264726]  el0t_64_sync_handler+0x11c/0x150
[   20.264728]  el0t_64_sync+0x190/0x194

Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
Suggested-by: Zack Rusin <zackr@vmware.com>
Reported-by: Nadav Amit <namit@vmware.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 463713eb6164 ("VMCI: dma dg: add support for DMA datagrams receive")
Cc: <stable@vger.kernel.org> # v5.18+
Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bryan Tan <bryantan@vmware.com>
Reviewed-by: Bryan Tan <bryantan@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Link: https://lore.kernel.org/r/20221130070511.46558-1-vdasa@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_guest.c | 49 ++++++++++++------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index aa7b05de97dd..4f8d962bb5b2 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -56,8 +56,6 @@ struct vmci_guest_device {
 
 	bool exclusive_vectors;
 
-	struct tasklet_struct datagram_tasklet;
-	struct tasklet_struct bm_tasklet;
 	struct wait_queue_head inout_wq;
 
 	void *data_buffer;
@@ -304,9 +302,8 @@ static int vmci_check_host_caps(struct pci_dev *pdev)
  * This function assumes that it has exclusive access to the data
  * in register(s) for the duration of the call.
  */
-static void vmci_dispatch_dgs(unsigned long data)
+static void vmci_dispatch_dgs(struct vmci_guest_device *vmci_dev)
 {
-	struct vmci_guest_device *vmci_dev = (struct vmci_guest_device *)data;
 	u8 *dg_in_buffer = vmci_dev->data_buffer;
 	struct vmci_datagram *dg;
 	size_t dg_in_buffer_size = VMCI_MAX_DG_SIZE;
@@ -465,10 +462,8 @@ static void vmci_dispatch_dgs(unsigned long data)
  * Scans the notification bitmap for raised flags, clears them
  * and handles the notifications.
  */
-static void vmci_process_bitmap(unsigned long data)
+static void vmci_process_bitmap(struct vmci_guest_device *dev)
 {
-	struct vmci_guest_device *dev = (struct vmci_guest_device *)data;
-
 	if (!dev->notification_bitmap) {
 		dev_dbg(dev->dev, "No bitmap present in %s\n", __func__);
 		return;
@@ -486,13 +481,13 @@ static irqreturn_t vmci_interrupt(int irq, void *_dev)
 	struct vmci_guest_device *dev = _dev;
 
 	/*
-	 * If we are using MSI-X with exclusive vectors then we simply schedule
-	 * the datagram tasklet, since we know the interrupt was meant for us.
+	 * If we are using MSI-X with exclusive vectors then we simply call
+	 * vmci_dispatch_dgs(), since we know the interrupt was meant for us.
 	 * Otherwise we must read the ICR to determine what to do.
 	 */
 
 	if (dev->exclusive_vectors) {
-		tasklet_schedule(&dev->datagram_tasklet);
+		vmci_dispatch_dgs(dev);
 	} else {
 		unsigned int icr;
 
@@ -502,12 +497,12 @@ static irqreturn_t vmci_interrupt(int irq, void *_dev)
 			return IRQ_NONE;
 
 		if (icr & VMCI_ICR_DATAGRAM) {
-			tasklet_schedule(&dev->datagram_tasklet);
+			vmci_dispatch_dgs(dev);
 			icr &= ~VMCI_ICR_DATAGRAM;
 		}
 
 		if (icr & VMCI_ICR_NOTIFICATION) {
-			tasklet_schedule(&dev->bm_tasklet);
+			vmci_process_bitmap(dev);
 			icr &= ~VMCI_ICR_NOTIFICATION;
 		}
 
@@ -536,7 +531,7 @@ static irqreturn_t vmci_interrupt_bm(int irq, void *_dev)
 	struct vmci_guest_device *dev = _dev;
 
 	/* For MSI-X we can just assume it was meant for us. */
-	tasklet_schedule(&dev->bm_tasklet);
+	vmci_process_bitmap(dev);
 
 	return IRQ_HANDLED;
 }
@@ -638,10 +633,6 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	vmci_dev->iobase = iobase;
 	vmci_dev->mmio_base = mmio_base;
 
-	tasklet_init(&vmci_dev->datagram_tasklet,
-		     vmci_dispatch_dgs, (unsigned long)vmci_dev);
-	tasklet_init(&vmci_dev->bm_tasklet,
-		     vmci_process_bitmap, (unsigned long)vmci_dev);
 	init_waitqueue_head(&vmci_dev->inout_wq);
 
 	if (mmio_base != NULL) {
@@ -808,8 +799,9 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * Request IRQ for legacy or MSI interrupts, or for first
 	 * MSI-X vector.
 	 */
-	error = request_irq(pci_irq_vector(pdev, 0), vmci_interrupt,
-			    IRQF_SHARED, KBUILD_MODNAME, vmci_dev);
+	error = request_threaded_irq(pci_irq_vector(pdev, 0), NULL,
+				     vmci_interrupt, IRQF_SHARED,
+				     KBUILD_MODNAME, vmci_dev);
 	if (error) {
 		dev_err(&pdev->dev, "Irq %u in use: %d\n",
 			pci_irq_vector(pdev, 0), error);
@@ -823,9 +815,9 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * between the vectors.
 	 */
 	if (vmci_dev->exclusive_vectors) {
-		error = request_irq(pci_irq_vector(pdev, 1),
-				    vmci_interrupt_bm, 0, KBUILD_MODNAME,
-				    vmci_dev);
+		error = request_threaded_irq(pci_irq_vector(pdev, 1), NULL,
+					     vmci_interrupt_bm, 0,
+					     KBUILD_MODNAME, vmci_dev);
 		if (error) {
 			dev_err(&pdev->dev,
 				"Failed to allocate irq %u: %d\n",
@@ -833,9 +825,11 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 			goto err_free_irq;
 		}
 		if (caps_in_use & VMCI_CAPS_DMA_DATAGRAM) {
-			error = request_irq(pci_irq_vector(pdev, 2),
-					    vmci_interrupt_dma_datagram,
-					    0, KBUILD_MODNAME, vmci_dev);
+			error = request_threaded_irq(pci_irq_vector(pdev, 2),
+						     NULL,
+						    vmci_interrupt_dma_datagram,
+						     0, KBUILD_MODNAME,
+						     vmci_dev);
 			if (error) {
 				dev_err(&pdev->dev,
 					"Failed to allocate irq %u: %d\n",
@@ -871,8 +865,6 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 
 err_free_irq:
 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
-	tasklet_kill(&vmci_dev->datagram_tasklet);
-	tasklet_kill(&vmci_dev->bm_tasklet);
 
 err_disable_msi:
 	pci_free_irq_vectors(pdev);
@@ -943,9 +935,6 @@ static void vmci_guest_remove_device(struct pci_dev *pdev)
 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
 	pci_free_irq_vectors(pdev);
 
-	tasklet_kill(&vmci_dev->datagram_tasklet);
-	tasklet_kill(&vmci_dev->bm_tasklet);
-
 	if (vmci_dev->notification_bitmap) {
 		/*
 		 * The device reset above cleared the bitmap state of the
-- 
2.39.1



