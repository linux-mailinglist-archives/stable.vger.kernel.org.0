Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16F27B9F7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgI2Bep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgI2Bba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20E41235F7;
        Tue, 29 Sep 2020 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343085;
        bh=+xqO1hIRMT1BzyNoJJJ5hXgnkxkNhskRD9Xuy98+iq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTgNFJnBdlqOQB/KoHOtHZH8NmHma1Cl9GNeKRfSZZen5/wkuzxetMQ8ovYTgnj5x
         L6UkeeyZRxjA7wqIv+MO+f4qCYgfyH+6BMqMrLYLeGtZdl/8WoUPekUSUBjZ7k4zLC
         WUT06/hOGkaCYD/1f4yf+W8RXeB5S3e/57r5Vi0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/18] spi: fsl-espi: Only process interrupts for expected events
Date:   Mon, 28 Sep 2020 21:31:02 -0400
Message-Id: <20200929013105.2406634-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit b867eef4cf548cd9541225aadcdcee644669b9e1 ]

The SPIE register contains counts for the TX FIFO so any time the irq
handler was invoked we would attempt to process the RX/TX fifos. Use the
SPIM value to mask the events so that we only process interrupts that
were expected.

This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
Implement soft interrupt replay in C").

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20200904002812.7300-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-espi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index f20326714b9d5..215bf6624e7c3 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -555,13 +555,14 @@ static void fsl_espi_cpu_irq(struct fsl_espi *espi, u32 events)
 static irqreturn_t fsl_espi_irq(s32 irq, void *context_data)
 {
 	struct fsl_espi *espi = context_data;
-	u32 events;
+	u32 events, mask;
 
 	spin_lock(&espi->lock);
 
 	/* Get interrupt events(tx/rx) */
 	events = fsl_espi_read_reg(espi, ESPI_SPIE);
-	if (!events) {
+	mask = fsl_espi_read_reg(espi, ESPI_SPIM);
+	if (!(events & mask)) {
 		spin_unlock(&espi->lock);
 		return IRQ_NONE;
 	}
-- 
2.25.1

