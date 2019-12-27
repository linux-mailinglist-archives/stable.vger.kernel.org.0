Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15F012B37B
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 10:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfL0JNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 04:13:23 -0500
Received: from inva020.nxp.com ([92.121.34.13]:55438 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbfL0JNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 04:13:23 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9E80C1A0E97;
        Fri, 27 Dec 2019 10:13:20 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 518A21A02FE;
        Fri, 27 Dec 2019 10:13:16 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 110B3402D8;
        Fri, 27 Dec 2019 17:13:10 +0800 (SGT)
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, gregkh@linuxfoundation.org,
        Peter Chen <peter.chen@nxp.com>,
        "#v5 . 4" <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: cdns3: should not use the same dev_id for shared interrupt handler
Date:   Fri, 27 Dec 2019 17:10:04 +0800
Message-Id: <1577437804-18146-1-git-send-email-peter.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both drd and gadget interrupt handler use the struct cdns3 pointer as
dev_id, it causes devm_free_irq at cdns3_gadget_exit doesn't free
gadget's interrupt handler, it freed drd's handler. So, when the
host interrupt occurs, the gadget's interrupt hanlder is still
called, and causes below oops. To fix it, we use gadget's private
data priv_dev as interrupt dev_id for gadget.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000380
Mem abort info:
  ESR = 0x96000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000006
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000971d79000
[0000000000000380] pgd=0000000971d6f003, pud=0000000971d6e003, pmd=0000000000000000
Internal error: Oops: 96000006 [#1] PREEMPT SMP
Modules linked in: mxc_jpeg_encdec crct10dif_ce fsl_imx8_ddr_perf
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-03486-g69f4e7d9c54a-dirty #254
Hardware name: Freescale i.MX8QM MEK (DT)
pstate: 00000085 (nzcv daIf -PAN -UAO)
pc : cdns3_device_irq_handler+0x1c/0xb8
lr : __handle_irq_event_percpu+0x78/0x2c0
sp : ffff800010003e30
x29: ffff800010003e30 x28: ffff8000129bb000
x27: ffff8000126e9000 x26: ffff0008f61b5600
x25: ffff800011fe1018 x24: ffff8000126ea120
x23: ffff800010003f04 x22: 0000000000000000
x21: 0000000000000093 x20: ffff0008f61b5600
x19: ffff0008f5061a80 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 003d090000000000
x13: 00003d0900000000 x12: 0000000000000000
x11: 00003d0900000000 x10: 0000000000000040
x9 : ffff800012708cb8 x8 : ffff800012708cb0
x7 : ffff0008f7c7a9d0 x6 : 0000000000000000
x5 : ffff0008f7c7a910 x4 : ffff8008ed359000
x3 : ffff800010003f40 x2 : 0000000000000000
x1 : ffff0008f5061a80 x0 : ffff800010161a60
Call trace:
 cdns3_device_irq_handler+0x1c/0xb8
 __handle_irq_event_percpu+0x78/0x2c0
 handle_irq_event_percpu+0x40/0x98
 handle_irq_event+0x4c/0xd0
 handle_fasteoi_irq+0xbc/0x168
 generic_handle_irq+0x34/0x50
 __handle_domain_irq+0x6c/0xc0
 gic_handle_irq+0xd4/0x174
 el1_irq+0xb8/0x180
 arch_cpu_idle+0x3c/0x230
 default_idle_call+0x38/0x40
 do_idle+0x20c/0x298
 cpu_startup_entry+0x28/0x48
 rest_init+0xdc/0xe8
 arch_call_rest_init+0x14/0x1c
 start_kernel+0x48c/0x4b8
Code: aa0103f3 aa1e03e0 d503201f f9409662 (f941c040)
---[ end trace 091dcf4dee011b0e ]---
Kernel panic - not syncing: Fatal exception in interrupt
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x0002,2100600c
Memory Limit: none
---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org> #v5.4
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 4c1e75509303..02f6ca2cb1ba 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1375,13 +1375,10 @@ static void cdns3_check_usb_interrupt_proceed(struct cdns3_device *priv_dev,
  */
 static irqreturn_t cdns3_device_irq_handler(int irq, void *data)
 {
-	struct cdns3_device *priv_dev;
-	struct cdns3 *cdns = data;
+	struct cdns3_device *priv_dev = data;
 	irqreturn_t ret = IRQ_NONE;
 	u32 reg;
 
-	priv_dev = cdns->gadget_dev;
-
 	/* check USB device interrupt */
 	reg = readl(&priv_dev->regs->usb_ists);
 	if (reg) {
@@ -1419,14 +1416,12 @@ static irqreturn_t cdns3_device_irq_handler(int irq, void *data)
  */
 static irqreturn_t cdns3_device_thread_irq_handler(int irq, void *data)
 {
-	struct cdns3_device *priv_dev;
-	struct cdns3 *cdns = data;
+	struct cdns3_device *priv_dev = data;
 	irqreturn_t ret = IRQ_NONE;
 	unsigned long flags;
 	int bit;
 	u32 reg;
 
-	priv_dev = cdns->gadget_dev;
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	reg = readl(&priv_dev->regs->usb_ists);
@@ -2539,7 +2534,7 @@ void cdns3_gadget_exit(struct cdns3 *cdns)
 
 	priv_dev = cdns->gadget_dev;
 
-	devm_free_irq(cdns->dev, cdns->dev_irq, cdns);
+	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
 	pm_runtime_mark_last_busy(cdns->dev);
 	pm_runtime_put_autosuspend(cdns->dev);
@@ -2710,7 +2705,8 @@ static int __cdns3_gadget_init(struct cdns3 *cdns)
 	ret = devm_request_threaded_irq(cdns->dev, cdns->dev_irq,
 					cdns3_device_irq_handler,
 					cdns3_device_thread_irq_handler,
-					IRQF_SHARED, dev_name(cdns->dev), cdns);
+					IRQF_SHARED, dev_name(cdns->dev),
+					cdns->gadget_dev);
 
 	if (ret)
 		goto err0;
-- 
2.17.1

