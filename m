Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDFD2348
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbfJJIk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387585AbfJJIkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B7A218AC;
        Thu, 10 Oct 2019 08:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696854;
        bh=Ck7sX0+FXelRH0DMHdATlyjDNhesOgfQM+4Zk78puy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3DFLrCwmWQtST2iZ3F6KldVcuFoHWVz4c2NT2fiZXq3KRwE66csr3Q5Va4PuQH/l
         jCsw9KB4QUIRIaarnBncPyJxzDl+gqLJM8riup7uVuWUeR3CJ48yPraUvf8U/K9rg9
         ACcik8MU4DhzIEqAVax5Y2cuOZu+PZ9ZocwC9kBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.3 075/148] mmc: sdhci: improve ADMA error reporting
Date:   Thu, 10 Oct 2019 10:35:36 +0200
Message-Id: <20191010083615.913134034@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit d1c536e3177390da43d99f20143b810c35433d1f upstream.

ADMA errors are potentially data corrupting events; although we print
the register state, we do not usefully print the ADMA descriptors.
Worse than that, we print them by referencing their virtual address
which is meaningless when the register state gives us the DMA address
of the failing descriptor.

Print the ADMA descriptors giving their DMA addresses rather than their
virtual addresses, and print them using SDHCI_DUMP() rather than DBG().

We also do not show the correct value of the interrupt status register;
the register dump shows the current value, after we have cleared the
pending interrupts we are going to service.  What is more useful is to
print the interrupts that _were_ pending at the time the ADMA error was
encountered.  Fix that too.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2857,6 +2857,7 @@ static void sdhci_cmd_irq(struct sdhci_h
 static void sdhci_adma_show_error(struct sdhci_host *host)
 {
 	void *desc = host->adma_table;
+	dma_addr_t dma = host->adma_addr;
 
 	sdhci_dumpregs(host);
 
@@ -2864,18 +2865,21 @@ static void sdhci_adma_show_error(struct
 		struct sdhci_adma2_64_desc *dma_desc = desc;
 
 		if (host->flags & SDHCI_USE_64_BIT_DMA)
-			DBG("%p: DMA 0x%08x%08x, LEN 0x%04x, Attr=0x%02x\n",
-			    desc, le32_to_cpu(dma_desc->addr_hi),
+			SDHCI_DUMP("%08llx: DMA 0x%08x%08x, LEN 0x%04x, Attr=0x%02x\n",
+			    (unsigned long long)dma,
+			    le32_to_cpu(dma_desc->addr_hi),
 			    le32_to_cpu(dma_desc->addr_lo),
 			    le16_to_cpu(dma_desc->len),
 			    le16_to_cpu(dma_desc->cmd));
 		else
-			DBG("%p: DMA 0x%08x, LEN 0x%04x, Attr=0x%02x\n",
-			    desc, le32_to_cpu(dma_desc->addr_lo),
+			SDHCI_DUMP("%08llx: DMA 0x%08x, LEN 0x%04x, Attr=0x%02x\n",
+			    (unsigned long long)dma,
+			    le32_to_cpu(dma_desc->addr_lo),
 			    le16_to_cpu(dma_desc->len),
 			    le16_to_cpu(dma_desc->cmd));
 
 		desc += host->desc_sz;
+		dma += host->desc_sz;
 
 		if (dma_desc->cmd & cpu_to_le16(ADMA2_END))
 			break;
@@ -2951,7 +2955,8 @@ static void sdhci_data_irq(struct sdhci_
 			!= MMC_BUS_TEST_R)
 		host->data->error = -EILSEQ;
 	else if (intmask & SDHCI_INT_ADMA_ERROR) {
-		pr_err("%s: ADMA error\n", mmc_hostname(host->mmc));
+		pr_err("%s: ADMA error: 0x%08x\n", mmc_hostname(host->mmc),
+		       intmask);
 		sdhci_adma_show_error(host);
 		host->data->error = -EIO;
 		if (host->ops->adma_workaround)


