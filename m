Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33172271BE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgGTVpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbgGTVhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B47122CBB;
        Mon, 20 Jul 2020 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281056;
        bh=myRiqgsrgu8L7BwSvXexwZdTgvqMXP0UprAQ0a3Razo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sh9daKaNcXiSbHfgTv4CPbPSBwtAhuKeyIk1BGLq7wxNpFUQWwRvFiXHgFmQu+xlZ
         PDLz9TXkQG+B9xU2Qu+cyQfpyL/ONYhJlhc6vEn+9O6QdtjHj8NdSRH4qXHwBD3r+T
         UI1FKzP8JjZViuRxqnQKFUi6MS9x1RhZzqKiBf3o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Angelo Dureghello <angelo.dureghello@timesys.com>,
        kbuild test robot <lkp@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 16/40] dmaengine: fsl-edma: fix wrong tcd endianness for big-endian cpu
Date:   Mon, 20 Jul 2020 17:36:51 -0400
Message-Id: <20200720213715.406997-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo.dureghello@timesys.com>

[ Upstream commit 8678c71c17721e0f771f135967ef0cce8f69ce9a ]

Due to recent fixes in m68k arch-specific I/O accessor macros, this
driver is not working anymore for ColdFire. Fix wrong tcd endianness
removing additional swaps, since edma_writex() functions should already
take care of any eventual swap if needed.

Note, i could only test the change in ColdFire mcf54415 and Vybrid
vf50 / Colibri where i don't see any issue. So, every feedback and
test for all other SoCs involved is really appreciated.

Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Reported-by: kbuild test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20200701225205.1674463-1-angelo.dureghello@timesys.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-common.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index 5697c3622699b..9285884758b27 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -352,26 +352,28 @@ static void fsl_edma_set_tcd_regs(struct fsl_edma_chan *fsl_chan,
 	/*
 	 * TCD parameters are stored in struct fsl_edma_hw_tcd in little
 	 * endian format. However, we need to load the TCD registers in
-	 * big- or little-endian obeying the eDMA engine model endian.
+	 * big- or little-endian obeying the eDMA engine model endian,
+	 * and this is performed from specific edma_write functions
 	 */
 	edma_writew(edma, 0,  &regs->tcd[ch].csr);
-	edma_writel(edma, le32_to_cpu(tcd->saddr), &regs->tcd[ch].saddr);
-	edma_writel(edma, le32_to_cpu(tcd->daddr), &regs->tcd[ch].daddr);
 
-	edma_writew(edma, le16_to_cpu(tcd->attr), &regs->tcd[ch].attr);
-	edma_writew(edma, le16_to_cpu(tcd->soff), &regs->tcd[ch].soff);
+	edma_writel(edma, (s32)tcd->saddr, &regs->tcd[ch].saddr);
+	edma_writel(edma, (s32)tcd->daddr, &regs->tcd[ch].daddr);
 
-	edma_writel(edma, le32_to_cpu(tcd->nbytes), &regs->tcd[ch].nbytes);
-	edma_writel(edma, le32_to_cpu(tcd->slast), &regs->tcd[ch].slast);
+	edma_writew(edma, (s16)tcd->attr, &regs->tcd[ch].attr);
+	edma_writew(edma, tcd->soff, &regs->tcd[ch].soff);
 
-	edma_writew(edma, le16_to_cpu(tcd->citer), &regs->tcd[ch].citer);
-	edma_writew(edma, le16_to_cpu(tcd->biter), &regs->tcd[ch].biter);
-	edma_writew(edma, le16_to_cpu(tcd->doff), &regs->tcd[ch].doff);
+	edma_writel(edma, (s32)tcd->nbytes, &regs->tcd[ch].nbytes);
+	edma_writel(edma, (s32)tcd->slast, &regs->tcd[ch].slast);
 
-	edma_writel(edma, le32_to_cpu(tcd->dlast_sga),
+	edma_writew(edma, (s16)tcd->citer, &regs->tcd[ch].citer);
+	edma_writew(edma, (s16)tcd->biter, &regs->tcd[ch].biter);
+	edma_writew(edma, (s16)tcd->doff, &regs->tcd[ch].doff);
+
+	edma_writel(edma, (s32)tcd->dlast_sga,
 			&regs->tcd[ch].dlast_sga);
 
-	edma_writew(edma, le16_to_cpu(tcd->csr), &regs->tcd[ch].csr);
+	edma_writew(edma, (s16)tcd->csr, &regs->tcd[ch].csr);
 }
 
 static inline
-- 
2.25.1

