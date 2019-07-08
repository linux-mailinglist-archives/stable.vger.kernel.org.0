Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2728F62453
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388784AbfGHP0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388777AbfGHP0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C18021738;
        Mon,  8 Jul 2019 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599574;
        bh=7i5TIOHDCJrnRJK3is1Oicb1skMDjv9yLBrDM4cBtmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr7Y0Eg3e8OcJDo3fVdfPM9H63TBPiBTMFq9Pp23JxtpRVQCvRvWf7fkUtwuSowgN
         3RMn7QKnAf8vUkts6YXotV8+fpzIUCnXD9LxLljYhh5XzHSaOTWbSx1cC/0LVuW8zR
         4P25lley9fLZzbYb4oBIVxTaUAytNAYScEF6pozY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 55/56] dmaengine: imx-sdma: remove BD_INTR for channel0
Date:   Mon,  8 Jul 2019 17:13:47 +0200
Message-Id: <20190708150524.291969254@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

commit 3f93a4f297961c12bb17aa16cb3a4d1291823cae upstream.

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
Reviewed-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-sdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -632,7 +632,7 @@ static int sdma_load_script(struct sdma_
 	spin_lock_irqsave(&sdma->channel_0_lock, flags);
 
 	bd0->mode.command = C0_SETPM;
-	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
 	bd0->mode.count = size / 2;
 	bd0->buffer_addr = buf_phys;
 	bd0->ext_buffer_addr = address;
@@ -909,7 +909,7 @@ static int sdma_load_context(struct sdma
 	context->gReg[7] = sdmac->watermark_level;
 
 	bd0->mode.command = C0_SETDM;
-	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
 	bd0->mode.count = sizeof(*context) / 4;
 	bd0->buffer_addr = sdma->context_phys;
 	bd0->ext_buffer_addr = 2048 + (sizeof(*context) / 4) * channel;


