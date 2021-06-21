Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53883AEF59
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhFUQht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhFUQfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EC6613F7;
        Mon, 21 Jun 2021 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292888;
        bh=nyVp8WfSCaHpQ5o9zaEXG5/+O+wQGeiXr28dxmU+gXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpbJbGUx9kL0YaWAtUqXy+MjGvBnkh1mFq57MjpNjaCTe5+vGcw39viKCtL2xy7X1
         B1W7uiqZJmOj7CN8zbQrjxMwDVHSTphLNxViqlvJnCaDBTJfaimp2q3eogZRVABFfP
         lRh0dxegwA5hSdYL4odju/afQhDUydvJtQej6CJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 004/178] dmaengine: xilinx: dpdma: initialize registers before request_irq
Date:   Mon, 21 Jun 2021 18:13:38 +0200
Message-Id: <20210621154921.512139268@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 538ea65a9fd1194352a41313bff876b74b5d90c5 ]

In some scenarios (kdump), dpdma hardware irqs has been enabled when
calling request_irq in probe function, and then the dpdma irq handler
xilinx_dpdma_irq_handler is invoked to access xdev->chan[i]. But at
this moment xdev->chan[i] hasn't been initialized.

We should ensure the dpdma controller to be in a consistent and
clean state before further initialization. So add dpdma_hw_init()
to do this.

Furthermore, in xilinx_dpdma_disable_irq, disable all interrupts
instead of error interrupts.

This patch is to fix the kdump kernel crash as below:

[    3.696128] Unable to handle kernel NULL pointer dereference at virtual address 000000000000012c
[    3.696710] xilinx-zynqmp-dpdma fd4c0000.dma-controller: Xilinx DPDMA engine is probed
[    3.704900] Mem abort info:
[    3.704902]   ESR = 0x96000005
[    3.704905]   EC = 0x25: DABT (current EL), IL = 32 bits
[    3.704907]   SET = 0, FnV = 0
[    3.704912]   EA = 0, S1PTW = 0
[    3.713800] ahci-ceva fd0c0000.ahci: supply ahci not found, using dummy regulator
[    3.715585] Data abort info:
[    3.715587]   ISV = 0, ISS = 0x00000005
[    3.715589]   CM = 0, WnR = 0
[    3.715592] [000000000000012c] user address but active_mm is swapper
[    3.715596] Internal error: Oops: 96000005 [#1] SMP
[    3.715599] Modules linked in:
[    3.715608] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-12170-g60894882155f-dirty #77
[    3.723937] Hardware name: ZynqMP ZCU102 Rev1.0 (DT)
[    3.723942] pstate: 80000085 (Nzcv daIf -PAN -UAO -TCO BTYPE=--)
[    3.723956] pc : xilinx_dpdma_irq_handler+0x418/0x560
[    3.793049] lr : xilinx_dpdma_irq_handler+0x3d8/0x560
[    3.798089] sp : ffffffc01186bdf0
[    3.801388] x29: ffffffc01186bdf0 x28: ffffffc011836f28
[    3.806692] x27: ffffff8023e0ac80 x26: 0000000000000080
[    3.811996] x25: 0000000008000408 x24: 0000000000000003
[    3.817300] x23: ffffffc01186be70 x22: ffffffc011291740
[    3.822604] x21: 0000000000000000 x20: 0000000008000408
[    3.827908] x19: 0000000000000000 x18: 0000000000000010
[    3.833212] x17: 0000000000000000 x16: 0000000000000000
[    3.838516] x15: 0000000000000000 x14: ffffffc011291740
[    3.843820] x13: ffffffc02eb4d000 x12: 0000000034d4d91d
[    3.849124] x11: 0000000000000040 x10: ffffffc0112d2d48
[    3.854428] x9 : ffffffc0112d2d40 x8 : ffffff8021c00268
[    3.859732] x7 : 0000000000000000 x6 : ffffffc011836000
[    3.865036] x5 : 0000000000000003 x4 : 0000000000000000
[    3.870340] x3 : 0000000000000001 x2 : 0000000000000000
[    3.875644] x1 : 0000000000000000 x0 : 000000000000012c
[    3.880948] Call trace:
[    3.883382]  xilinx_dpdma_irq_handler+0x418/0x560
[    3.888079]  __handle_irq_event_percpu+0x5c/0x178
[    3.892774]  handle_irq_event_percpu+0x34/0x98
[    3.897210]  handle_irq_event+0x44/0xb8
[    3.901030]  handle_fasteoi_irq+0xd0/0x190
[    3.905117]  generic_handle_irq+0x30/0x48
[    3.909111]  __handle_domain_irq+0x64/0xc0
[    3.913192]  gic_handle_irq+0x78/0xa0
[    3.916846]  el1_irq+0xc4/0x180
[    3.919982]  cpuidle_enter_state+0x134/0x2f8
[    3.924243]  cpuidle_enter+0x38/0x50
[    3.927810]  call_cpuidle+0x1c/0x40
[    3.931290]  do_idle+0x20c/0x270
[    3.934502]  cpu_startup_entry+0x28/0x58
[    3.938410]  rest_init+0xbc/0xcc
[    3.941631]  arch_call_rest_init+0x10/0x1c
[    3.945718]  start_kernel+0x51c/0x558

Fixes: 7cbb0c63de3f ("dmaengine: xilinx: dpdma: Add the Xilinx DisplayPort DMA engine driver")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210430064041.4058180-1-quanyang.wang@windriver.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index 70b29bd079c9..ff7dfb3fdeb4 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -1459,7 +1459,7 @@ static void xilinx_dpdma_enable_irq(struct xilinx_dpdma_device *xdev)
  */
 static void xilinx_dpdma_disable_irq(struct xilinx_dpdma_device *xdev)
 {
-	dpdma_write(xdev->reg, XILINX_DPDMA_IDS, XILINX_DPDMA_INTR_ERR_ALL);
+	dpdma_write(xdev->reg, XILINX_DPDMA_IDS, XILINX_DPDMA_INTR_ALL);
 	dpdma_write(xdev->reg, XILINX_DPDMA_EIDS, XILINX_DPDMA_EINTR_ALL);
 }
 
@@ -1596,6 +1596,26 @@ static struct dma_chan *of_dma_xilinx_xlate(struct of_phandle_args *dma_spec,
 	return dma_get_slave_channel(&xdev->chan[chan_id]->vchan.chan);
 }
 
+static void dpdma_hw_init(struct xilinx_dpdma_device *xdev)
+{
+	unsigned int i;
+	void __iomem *reg;
+
+	/* Disable all interrupts */
+	xilinx_dpdma_disable_irq(xdev);
+
+	/* Stop all channels */
+	for (i = 0; i < ARRAY_SIZE(xdev->chan); i++) {
+		reg = xdev->reg + XILINX_DPDMA_CH_BASE
+				+ XILINX_DPDMA_CH_OFFSET * i;
+		dpdma_clr(reg, XILINX_DPDMA_CH_CNTL, XILINX_DPDMA_CH_CNTL_ENABLE);
+	}
+
+	/* Clear the interrupt status registers */
+	dpdma_write(xdev->reg, XILINX_DPDMA_ISR, XILINX_DPDMA_INTR_ALL);
+	dpdma_write(xdev->reg, XILINX_DPDMA_EISR, XILINX_DPDMA_EINTR_ALL);
+}
+
 static int xilinx_dpdma_probe(struct platform_device *pdev)
 {
 	struct xilinx_dpdma_device *xdev;
@@ -1622,6 +1642,8 @@ static int xilinx_dpdma_probe(struct platform_device *pdev)
 	if (IS_ERR(xdev->reg))
 		return PTR_ERR(xdev->reg);
 
+	dpdma_hw_init(xdev);
+
 	xdev->irq = platform_get_irq(pdev, 0);
 	if (xdev->irq < 0) {
 		dev_err(xdev->dev, "failed to get platform irq\n");
-- 
2.30.2



