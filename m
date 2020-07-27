Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A3122EF69
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgG0OQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgG0OQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1537620775;
        Mon, 27 Jul 2020 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859368;
        bh=cJk9fZrndJKKdWnZeYkDDzEpUUE2wUwx9/n+2luZ4lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZvEDvFm0Cby8+dnbxr4qdeVW2EQMAUcs23ynA3kAzJv8V5ObLPOBDxm+lafUBLIA
         6JZajJh9P6BRhunm30qUNbsK8uqYIJ/xGDqpjf/mCUXpKvfUVXFyg0NcOKP8fIpIE7
         FhbeIndJc1AOBA32K0g4b+yz97onwHuP6aeMLax0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>,
        kbuild test robot <lkp@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/138] dmaengine: fsl-edma: fix wrong tcd endianness for big-endian cpu
Date:   Mon, 27 Jul 2020 16:04:36 +0200
Message-Id: <20200727134929.426368642@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b1a7ca91701a8..d6010486ee502 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -347,26 +347,28 @@ static void fsl_edma_set_tcd_regs(struct fsl_edma_chan *fsl_chan,
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



