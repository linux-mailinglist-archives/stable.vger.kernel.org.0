Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9C106DD3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfKVLDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730607AbfKVLDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAFC207DD;
        Fri, 22 Nov 2019 11:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420616;
        bh=ki+pDiUQ4TAJihOkdBBUuOsWB5MDl13oiTbkGVRNnaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYbsm/YnAoEy6rbWlDEgXjhlC082bmxVzMEozCtSRK+RZrRl7sq8tpdHyrFE+A9HF
         f08W6Islm7vR7Jc3J6gulNFZp3ltcXUJvVNKLMNCN7aKEX5f+sthxycLw2JIqPad8U
         wZscsNKb1HMTSyo2hX8MAnfP0eGjBVlHqyQnvETI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/220] mmc: mmci: expand startbiterr to irqmask and error check
Date:   Fri, 22 Nov 2019 11:28:51 +0100
Message-Id: <20191122100924.727930440@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Barre <ludovic.barre@st.com>

[ Upstream commit daf9713c5ef8c3ffb0bdf7de11b53b2b2756c4f1 ]

All variants don't pretend to have a startbiterr.
-While data error check, if status register return an error
(like  MCI_DATACRCFAIL) we must avoid to check MCI_STARTBITERR
(if not desired).
-expand start_err to MCI_IRQENABLE to avoid to set this bit by default.

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci.c | 27 ++++++++++++++++-----------
 drivers/mmc/host/mmci.h |  6 +++---
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index eb1a65cb878f0..fa6268c0f1232 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -895,14 +895,18 @@ static void
 mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	      unsigned int status)
 {
+	unsigned int status_err;
+
 	/* Make sure we have data to handle */
 	if (!data)
 		return;
 
 	/* First check for errors */
-	if (status & (MCI_DATACRCFAIL | MCI_DATATIMEOUT |
-		      host->variant->start_err |
-		      MCI_TXUNDERRUN | MCI_RXOVERRUN)) {
+	status_err = status & (host->variant->start_err |
+			       MCI_DATACRCFAIL | MCI_DATATIMEOUT |
+			       MCI_TXUNDERRUN | MCI_RXOVERRUN);
+
+	if (status_err) {
 		u32 remain, success;
 
 		/* Terminate the DMA transfer */
@@ -922,18 +926,18 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 		success = data->blksz * data->blocks - remain;
 
 		dev_dbg(mmc_dev(host->mmc), "MCI ERROR IRQ, status 0x%08x at 0x%08x\n",
-			status, success);
-		if (status & MCI_DATACRCFAIL) {
+			status_err, success);
+		if (status_err & MCI_DATACRCFAIL) {
 			/* Last block was not successful */
 			success -= 1;
 			data->error = -EILSEQ;
-		} else if (status & MCI_DATATIMEOUT) {
+		} else if (status_err & MCI_DATATIMEOUT) {
 			data->error = -ETIMEDOUT;
-		} else if (status & MCI_STARTBITERR) {
+		} else if (status_err & MCI_STARTBITERR) {
 			data->error = -ECOMM;
-		} else if (status & MCI_TXUNDERRUN) {
+		} else if (status_err & MCI_TXUNDERRUN) {
 			data->error = -EIO;
-		} else if (status & MCI_RXOVERRUN) {
+		} else if (status_err & MCI_RXOVERRUN) {
 			if (success > host->variant->fifosize)
 				success -= host->variant->fifosize;
 			else
@@ -1790,7 +1794,7 @@ static int mmci_probe(struct amba_device *dev,
 			goto clk_disable;
 	}
 
-	writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+	writel(MCI_IRQENABLE | variant->start_err, host->base + MMCIMASK0);
 
 	amba_set_drvdata(dev, mmc);
 
@@ -1877,7 +1881,8 @@ static void mmci_restore(struct mmci_host *host)
 		writel(host->datactrl_reg, host->base + MMCIDATACTRL);
 		writel(host->pwr_reg, host->base + MMCIPOWER);
 	}
-	writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+	writel(MCI_IRQENABLE | host->variant->start_err,
+	       host->base + MMCIMASK0);
 	mmci_reg_delay(host);
 
 	spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 517591d219e93..613d37ab08d20 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -181,9 +181,9 @@
 #define MMCIFIFO		0x080 /* to 0x0bc */
 
 #define MCI_IRQENABLE	\
-	(MCI_CMDCRCFAILMASK|MCI_DATACRCFAILMASK|MCI_CMDTIMEOUTMASK|	\
-	MCI_DATATIMEOUTMASK|MCI_TXUNDERRUNMASK|MCI_RXOVERRUNMASK|	\
-	MCI_CMDRESPENDMASK|MCI_CMDSENTMASK|MCI_STARTBITERRMASK)
+	(MCI_CMDCRCFAILMASK | MCI_DATACRCFAILMASK | MCI_CMDTIMEOUTMASK | \
+	MCI_DATATIMEOUTMASK | MCI_TXUNDERRUNMASK | MCI_RXOVERRUNMASK |	\
+	MCI_CMDRESPENDMASK | MCI_CMDSENTMASK)
 
 /* These interrupts are directed to IRQ1 when two IRQ lines are available */
 #define MCI_IRQ1MASK \
-- 
2.20.1



