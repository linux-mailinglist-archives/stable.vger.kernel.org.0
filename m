Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE04E1D3
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 10:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFUIVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 04:21:45 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34310 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfFUIVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 04:21:44 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2CE1C1A09BC;
        Fri, 21 Jun 2019 10:21:43 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 124901A09B4;
        Fri, 21 Jun 2019 10:21:37 +0200 (CEST)
Received: from mega.ap.freescale.net (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 59F24402CF;
        Fri, 21 Jun 2019 16:21:29 +0800 (SGT)
From:   yibin.gong@nxp.com
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        vkoul@kernel.org, dan.j.williams@intel.com, thesven73@gmail.com,
        m.olbrich@pengutronix.de
Cc:     linux-imx@nxp.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
Date:   Fri, 21 Jun 2019 16:23:06 +0800
Message-Id: <20190621082306.34415-1-yibin.gong@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

It is possible for an irq triggered by channel0 to be received later
after clks are disabled once firmware loaded during sdma probe. If
that happens then clearing them by writing to SDMA_H_INTR won't work
and the kernel will hang processing infinite interrupts. Actually,
don't need interrupt triggered on channel0 since it's pollling
SDMA_H_STATSTOP to know channel0 done rather than interrupt in
current code, just clear BD_INTR to disable channel0 interrupt to
avoid the above case.
This issue was brought by commit 1d069bfa3c78 ("dmaengine: imx-sdma:
ack channel 0 IRQ in the interrupt handler") which didn't take care
the above case.

Fixes: 1d069bfa3c78 ("dmaengine: imx-sdma: ack channel 0 IRQ in the interrupt handler")
Cc: stable@vger.kernel.org #5.0+
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Reported-by: Sven Van Asbroeck <thesven73@gmail.com>
Tested-by: Sven Van Asbroeck <thesven73@gmail.com>
---
 drivers/dma/imx-sdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index deea9aa..b5a1ee2 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -742,7 +742,7 @@ static int sdma_load_script(struct sdma_engine *sdma, void *buf, int size,
 	spin_lock_irqsave(&sdma->channel_0_lock, flags);
 
 	bd0->mode.command = C0_SETPM;
-	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
 	bd0->mode.count = size / 2;
 	bd0->buffer_addr = buf_phys;
 	bd0->ext_buffer_addr = address;
@@ -1064,7 +1064,7 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 	context->gReg[7] = sdmac->watermark_level;
 
 	bd0->mode.command = C0_SETDM;
-	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
 	bd0->mode.count = sizeof(*context) / 4;
 	bd0->buffer_addr = sdma->context_phys;
 	bd0->ext_buffer_addr = 2048 + (sizeof(*context) / 4) * channel;
-- 
2.7.4

