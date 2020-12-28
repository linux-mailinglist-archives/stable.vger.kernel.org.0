Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D052E42F0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407028AbgL1NwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407020AbgL1NwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8444D2078D;
        Mon, 28 Dec 2020 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163506;
        bh=+BX30Muo3N8nrMf5o7DdFK8Z9Rz7Mnxn3P3Us7RTOos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKVzjt8E2f4BKMHk7xOS7eNAOGKzIeccTzFJkBVBZ5VzzBGOFYp6Mbzzlv3UtE/W1
         uQyXdFzfiZfR2YQvkbplbYzbrUxk89kIBISJIEUCoiH6ik4XAA+eeisWc8sEQwyeoJ
         IKikKvMkpCQToBqFDYZbk7sgCr/LLqbR1cydvKPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Han Xu <han.xu@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 269/453] mtd: rawnand: gpmi: Fix the random DMA timeout issue
Date:   Mon, 28 Dec 2020 13:48:25 +0100
Message-Id: <20201228124950.172115398@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 7671edeb193910482a9b0c22cd32176e7de7b2ed ]

To get better performance, current gpmi driver collected and chained all
small DMA transfers in gpmi_nfc_exec_op, the whole chain triggered and
wait for complete at the end.

But some random DMA timeout found in this new driver, with the help of
ftrace, we found the root cause is as follows:

Take gpmi_ecc_read_page() as an example, gpmi_nfc_exec_op collected 6
DMA transfers and the DMA chain triggered at the end. It waits for bch
completion and check jiffies if it's timeout. The typical function graph
shown below,

   63.216351 |   1)               |  gpmi_ecc_read_page() {
   63.216352 |   1)   0.750 us    |    gpmi_bch_layout_std();
   63.216354 |   1)               |    gpmi_nfc_exec_op() {
   63.216355 |   1)               |      gpmi_chain_command() {
   63.216356 |   1)               |        mxs_dma_prep_slave_sg() {
   63.216357 |   1)               |          /* mxs chan ccw idx: 0 */
   63.216358 |   1)   1.750 us    |        }
   63.216359 |   1)               |        mxs_dma_prep_slave_sg() {
   63.216360 |   1)               |          /* mxs chan ccw idx: 1 */
   63.216361 |   1)   2.000 us    |        }
   63.216361 |   1)   6.500 us    |      }
   63.216362 |   1)               |      gpmi_chain_command() {
   63.216363 |   1)               |        mxs_dma_prep_slave_sg() {
   63.216364 |   1)               |          /* mxs chan ccw idx: 2 */
   63.216365 |   1)   1.750 us    |        }
   63.216366 |   1)               |        mxs_dma_prep_slave_sg() {
   63.216367 |   1)               |          /* mxs chan ccw idx: 3 */
   63.216367 |   1)   1.750 us    |        }
   63.216368 |   1)   5.875 us    |      }
   63.216369 |   1)               |      /* gpmi_chain_wait_ready */
   63.216370 |   1)               |      mxs_dma_prep_slave_sg() {
   63.216372 |   1)               |        /* mxs chan ccw idx: 4 */
   63.216373 |   1)   3.000 us    |      }
   63.216374 |   1)               |      /* gpmi_chain_data_read */
   63.216376 |   1)               |      mxs_dma_prep_slave_sg() {
   63.216377 |   1)               |        /* mxs chan ccw idx: 5 */
   63.216378 |   1)   2.000 us    |      }
   63.216379 |   1)   1.125 us    |      mxs_dma_tx_submit();
   63.216381 |   1)   1.000 us    |      mxs_dma_enable_chan();
   63.216712 |   0)   2.625 us    |  mxs_dma_int_handler();
   63.216717 |   0)   4.250 us    |  bch_irq();
   63.216723 |   0)   1.250 us    |  mxs_dma_tasklet();
   63.216723 |   1)               |      /* jiffies left 250 */
   63.216725 |   1) ! 372.000 us  |    }
   63.216726 |   1)   2.625 us    |    gpmi_count_bitflips();
   63.216730 |   1) ! 379.125 us  |  }

but it's not gurantee that bch irq handled always after dma irq handled,
sometimes bch_irq comes first and gpmi_nfc_exec_op won't wait anymore,
another gpmi_nfc_exec_op may get invoked before last DMA chain IRQ
handled, this messed up the next DMA chain and causes DMA timeout. Check
the trace log when issue happened.

   63.218923 |   1)               |  gpmi_ecc_read_page() {
   63.218924 |   1)   0.625 us    |    gpmi_bch_layout_std();
   63.218926 |   1)               |    gpmi_nfc_exec_op() {
   63.218927 |   1)               |      gpmi_chain_command() {
   63.218928 |   1)               |        mxs_dma_prep_slave_sg() {
   63.218929 |   1)               |          /* mxs chan ccw idx: 0 */
   63.218929 |   1)   1.625 us    |        }
   63.218931 |   1)               |        mxs_dma_prep_slave_sg() {
   63.218931 |   1)               |          /* mxs chan ccw idx: 1 */
   63.218932 |   1)   1.750 us    |        }
   63.218933 |   1)   5.875 us    |      }
   63.218934 |   1)               |      gpmi_chain_command() {
   63.218934 |   1)               |        mxs_dma_prep_slave_sg() {
   63.218935 |   1)               |          /* mxs chan ccw idx: 2 */
   63.218936 |   1)   1.875 us    |        }
   63.218937 |   1)               |        mxs_dma_prep_slave_sg() {
   63.218938 |   1)               |          /* mxs chan ccw idx: 3 */
   63.218939 |   1)   1.625 us    |        }
   63.218939 |   1)   5.875 us    |      }
   63.218940 |   1)               |      /* gpmi_chain_wait_ready */
   63.218941 |   1)               |      mxs_dma_prep_slave_sg() {
   63.218942 |   1)               |        /* mxs chan ccw idx: 4 */
   63.218942 |   1)   1.625 us    |      }
   63.218943 |   1)               |      /* gpmi_chain_data_read */
   63.218944 |   1)               |      mxs_dma_prep_slave_sg() {
   63.218945 |   1)               |        /* mxs chan ccw idx: 5 */
   63.218947 |   1)   2.375 us    |      }
   63.218948 |   1)   0.625 us    |      mxs_dma_tx_submit();
   63.218949 |   1)   1.000 us    |      mxs_dma_enable_chan();
   63.219276 |   0)   5.125 us    |  bch_irq();                  <----
   63.219283 |   1)               |      /* jiffies left 250 */
   63.219285 |   1) ! 358.625 us  |    }
   63.219286 |   1)   2.750 us    |    gpmi_count_bitflips();
   63.219289 |   1) ! 366.000 us  |  }
   63.219290 |   1)               |  gpmi_ecc_read_page() {
   63.219291 |   1)   0.750 us    |    gpmi_bch_layout_std();
   63.219293 |   1)               |    gpmi_nfc_exec_op() {
   63.219294 |   1)               |      gpmi_chain_command() {
   63.219295 |   1)               |        mxs_dma_prep_slave_sg() {
   63.219295 |   0)   1.875 us    |  mxs_dma_int_handler();      <----
   63.219296 |   1)               |          /* mxs chan ccw idx: 6 */
   63.219297 |   1)   2.250 us    |        }
   63.219298 |   1)               |        mxs_dma_prep_slave_sg() {
   63.219298 |   0)   1.000 us    |  mxs_dma_tasklet();
   63.219299 |   1)               |          /* mxs chan ccw idx: 0 */
   63.219300 |   1)   1.625 us    |        }
   63.219300 |   1)   6.375 us    |      }
   63.219301 |   1)               |      gpmi_chain_command() {
   63.219302 |   1)               |        mxs_dma_prep_slave_sg() {
   63.219303 |   1)               |          /* mxs chan ccw idx: 1 */
   63.219304 |   1)   1.625 us    |        }
   63.219305 |   1)               |        mxs_dma_prep_slave_sg() {
   63.219306 |   1)               |          /* mxs chan ccw idx: 2 */
   63.219306 |   1)   1.875 us    |        }
   63.219307 |   1)   6.000 us    |      }
   63.219308 |   1)               |      /* gpmi_chain_wait_ready */
   63.219308 |   1)               |      mxs_dma_prep_slave_sg() {
   63.219309 |   1)               |        /* mxs chan ccw idx: 3 */
   63.219310 |   1)   2.000 us    |      }
   63.219311 |   1)               |      /* gpmi_chain_data_read */
   63.219312 |   1)               |      mxs_dma_prep_slave_sg() {
   63.219313 |   1)               |        /* mxs chan ccw idx: 4 */
   63.219314 |   1)   1.750 us    |      }
   63.219315 |   1)   0.625 us    |      mxs_dma_tx_submit();
   63.219316 |   1)   0.875 us    |      mxs_dma_enable_chan();
   64.224227 |   1)               |      /* jiffies left 0 */

In the first gpmi_nfc_exec_op, bch_irq comes first and gpmi_nfc_exec_op
exits, but DMA IRQ still not happened yet until the middle of following
gpmi_nfc_exec_op, the first DMA transfer index get messed and DMA get
timeout.

To fix the issue, when there is bch ops in DMA chain, the
gpmi_nfc_exec_op should wait for both completions rather than bch
completion only.

Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
Signed-off-by: Han Xu <han.xu@nxp.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201209035104.22679-3-han.xu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 30 +++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 89239d9c4ea63..2390ed077a2fc 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2408,7 +2408,7 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 	void *buf_read = NULL;
 	const void *buf_write = NULL;
 	bool direct = false;
-	struct completion *completion;
+	struct completion *dma_completion, *bch_completion;
 	unsigned long to;
 
 	this->ntransfers = 0;
@@ -2502,22 +2502,24 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 		       this->resources.bch_regs + HW_BCH_FLASH0LAYOUT1);
 	}
 
+	desc->callback = dma_irq_callback;
+	desc->callback_param = this;
+	dma_completion = &this->dma_done;
+	bch_completion = NULL;
+
+	init_completion(dma_completion);
+
 	if (this->bch && buf_read) {
 		writel(BM_BCH_CTRL_COMPLETE_IRQ_EN,
 		       this->resources.bch_regs + HW_BCH_CTRL_SET);
-		completion = &this->bch_done;
-	} else {
-		desc->callback = dma_irq_callback;
-		desc->callback_param = this;
-		completion = &this->dma_done;
+		bch_completion = &this->bch_done;
+		init_completion(bch_completion);
 	}
 
-	init_completion(completion);
-
 	dmaengine_submit(desc);
 	dma_async_issue_pending(get_dma_chan(this));
 
-	to = wait_for_completion_timeout(completion, msecs_to_jiffies(1000));
+	to = wait_for_completion_timeout(dma_completion, msecs_to_jiffies(1000));
 	if (!to) {
 		dev_err(this->dev, "DMA timeout, last DMA\n");
 		gpmi_dump_info(this);
@@ -2525,6 +2527,16 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 		goto unmap;
 	}
 
+	if (this->bch && buf_read) {
+		to = wait_for_completion_timeout(bch_completion, msecs_to_jiffies(1000));
+		if (!to) {
+			dev_err(this->dev, "BCH timeout, last DMA\n");
+			gpmi_dump_info(this);
+			ret = -ETIMEDOUT;
+			goto unmap;
+		}
+	}
+
 	writel(BM_BCH_CTRL_COMPLETE_IRQ_EN,
 	       this->resources.bch_regs + HW_BCH_CTRL_CLR);
 	gpmi_clear_bch(this);
-- 
2.27.0



