Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647921A3F4D
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgDJDru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgDJDrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DED2137B;
        Fri, 10 Apr 2020 03:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490467;
        bh=GxDxnQPWte9R8U+Xt5tCwJr2ehCosUudNbeDUGyQaPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fwe11CeYWcPffLCxiWn83gRzsgLRhWlk805xqz0VCgCTAWx1Mz0DSDUSjJsQsecyK
         GacXanmzoGAP/H4hwWZu5LZqYccNrFn+MSLRKWVt9uZJgjVFS6cBWecvoCukS8oVJy
         Nm+pqwkc8II6xHWow+FY7FoEtz/aZylG4O309bqU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 60/68] spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion
Date:   Thu,  9 Apr 2020 23:46:25 -0400
Message-Id: <20200410034634.7731-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4f5ee75ea1718a09149460b3df993f389a67b56a ]

Currently the driver puts the process in interruptible sleep waiting for
the interrupt train to finish transfer to/from the tx_buf and rx_buf.

But exiting the process with ctrl-c may make the kernel panic: the
wait_event_interruptible call will return -ERESTARTSYS, which a proper
driver implementation is perhaps supposed to handle, but nonetheless
this one doesn't, and aborts the transfer altogether.

Actually when the task is interrupted, there is still a high chance that
the dspi_interrupt is still triggering. And if dspi_transfer_one_message
returns execution all the way to the spi_device driver, that can free
the spi_message and spi_transfer structures, leaving the interrupts to
access a freed tx_buf and rx_buf.

hexdump -C /dev/mtd0
00000000  00 75 68 75 0a ff ff ff  ff ff ff ff ff ff ff ff
|.uhu............|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
|................|
*
^C[   38.495955] fsl-dspi 2120000.spi: Waiting for transfer to complete failed!
[   38.503097] spi_master spi2: failed to transfer one message from queue
[   38.509729] Unable to handle kernel paging request at virtual address ffff800095ab3377
[   38.517676] Mem abort info:
[   38.520474]   ESR = 0x96000045
[   38.523533]   EC = 0x25: DABT (current EL), IL = 32 bits
[   38.528861]   SET = 0, FnV = 0
[   38.531921]   EA = 0, S1PTW = 0
[   38.535067] Data abort info:
[   38.537952]   ISV = 0, ISS = 0x00000045
[   38.541797]   CM = 0, WnR = 1
[   38.544771] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000082621000
[   38.551494] [ffff800095ab3377] pgd=00000020fffff003, p4d=00000020fffff003, pud=0000000000000000
[   38.560229] Internal error: Oops: 96000045 [#1] PREEMPT SMP
[   38.565819] Modules linked in:
[   38.568882] CPU: 0 PID: 2729 Comm: hexdump Not tainted 5.6.0-rc4-next-20200306-00052-gd8730cdc8a0b-dirty #193
[   38.578834] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
[   38.587129] pstate: 20000085 (nzCv daIf -PAN -UAO)
[   38.591941] pc : ktime_get_real_ts64+0x3c/0x110
[   38.596487] lr : spi_take_timestamp_pre+0x40/0x90
[   38.601203] sp : ffff800010003d90
[   38.604525] x29: ffff800010003d90 x28: ffff80001200e000
[   38.609854] x27: ffff800011da9000 x26: ffff002079c40400
[   38.615184] x25: ffff8000117fe018 x24: ffff800011daa1a0
[   38.620513] x23: ffff800015ab3860 x22: ffff800095ab3377
[   38.625841] x21: 000000000000146e x20: ffff8000120c3000
[   38.631170] x19: ffff0020795f6e80 x18: ffff800011da9948
[   38.636498] x17: 0000000000000000 x16: 0000000000000000
[   38.641826] x15: ffff800095ab3377 x14: 0720072007200720
[   38.647155] x13: 0720072007200765 x12: 0775076507750771
[   38.652483] x11: 0720076d076f0772 x10: 0000000000000040
[   38.657812] x9 : ffff8000108e2100 x8 : ffff800011dcabe8
[   38.663139] x7 : 0000000000000000 x6 : ffff800015ab3a60
[   38.668468] x5 : 0000000007200720 x4 : ffff800095ab3377
[   38.673796] x3 : 0000000000000000 x2 : 0000000000000ab0
[   38.679125] x1 : ffff800011daa000 x0 : 0000000000000026
[   38.684454] Call trace:
[   38.686905]  ktime_get_real_ts64+0x3c/0x110
[   38.691100]  spi_take_timestamp_pre+0x40/0x90
[   38.695470]  dspi_fifo_write+0x58/0x2c0
[   38.699315]  dspi_interrupt+0xbc/0xd0
[   38.702987]  __handle_irq_event_percpu+0x78/0x2c0
[   38.707706]  handle_irq_event_percpu+0x3c/0x90
[   38.712161]  handle_irq_event+0x4c/0xd0
[   38.716008]  handle_fasteoi_irq+0xbc/0x170
[   38.720115]  generic_handle_irq+0x2c/0x40
[   38.724135]  __handle_domain_irq+0x68/0xc0
[   38.728243]  gic_handle_irq+0xc8/0x160
[   38.732000]  el1_irq+0xb8/0x180
[   38.735149]  spi_nor_spimem_read_data+0xe0/0x140
[   38.739779]  spi_nor_read+0xc4/0x120
[   38.743364]  mtd_read_oob+0xa8/0xc0
[   38.746860]  mtd_read+0x4c/0x80
[   38.750007]  mtdchar_read+0x108/0x2a0
[   38.753679]  __vfs_read+0x20/0x50
[   38.757002]  vfs_read+0xa4/0x190
[   38.760237]  ksys_read+0x6c/0xf0
[   38.763471]  __arm64_sys_read+0x20/0x30
[   38.767319]  el0_svc_common.constprop.3+0x90/0x160
[   38.772125]  do_el0_svc+0x28/0x90
[   38.775449]  el0_sync_handler+0x118/0x190
[   38.779468]  el0_sync+0x140/0x180
[   38.782793] Code: 91000294 1400000f d50339bf f9405e80 (f90002c0)
[   38.788910] ---[ end trace 55da560db4d6bef7 ]---
[   38.793540] Kernel panic - not syncing: Fatal exception in interrupt
[   38.799914] SMP: stopping secondary CPUs
[   38.803849] Kernel Offset: disabled
[   38.807344] CPU features: 0x10002,20006008
[   38.811451] Memory Limit: none
[   38.814513] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

So it is clear that the "interruptible" part isn't handled correctly.
When the process receives a signal, one could either attempt a clean
abort (which appears to be difficult with this hardware) or just keep
restarting the sleep until the wait queue really completes. But checking
in a loop for -ERESTARTSYS is a bit too complicated for this driver, so
just make the sleep uninterruptible, to avoid all that nonsense.

The wait queue was actually restructured as a completion, after polling
other drivers for the most "popular" approach.

Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20200318001603.9650-7-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 2ce65edf16b66..1305030379e82 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -196,8 +196,7 @@ struct fsl_dspi {
 	u8					bytes_per_word;
 	const struct fsl_dspi_devtype_data	*devtype_data;
 
-	wait_queue_head_t			waitq;
-	u32					waitflags;
+	struct completion			xfer_done;
 
 	struct fsl_dspi_dma			*dma;
 };
@@ -714,10 +713,8 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	if (!(spi_sr & SPI_SR_EOQF))
 		return IRQ_NONE;
 
-	if (dspi_rxtx(dspi) == 0) {
-		dspi->waitflags = 1;
-		wake_up_interruptible(&dspi->waitq);
-	}
+	if (dspi_rxtx(dspi) == 0)
+		complete(&dspi->xfer_done);
 
 	return IRQ_HANDLED;
 }
@@ -815,13 +812,9 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				status = dspi_poll(dspi);
 			} while (status == -EINPROGRESS);
 		} else if (trans_mode != DSPI_DMA_MODE) {
-			status = wait_event_interruptible(dspi->waitq,
-							  dspi->waitflags);
-			dspi->waitflags = 0;
+			wait_for_completion(&dspi->xfer_done);
+			reinit_completion(&dspi->xfer_done);
 		}
-		if (status)
-			dev_err(&dspi->pdev->dev,
-				"Waiting for transfer to complete failed!\n");
 
 		spi_transfer_delay_exec(transfer);
 	}
@@ -1161,7 +1154,7 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
-	init_waitqueue_head(&dspi->waitq);
+	init_completion(&dspi->xfer_done);
 
 poll_mode:
 
-- 
2.20.1

