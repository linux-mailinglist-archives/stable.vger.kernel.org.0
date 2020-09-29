Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407A827BA1E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgI2Ba6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgI2Ba6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F3721D92;
        Tue, 29 Sep 2020 01:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343058;
        bh=21FkWTn97faQnwphOoikRmtJOI5pXA5VMosofT5D3sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOPpJZTGMWCRLvUGYw9hwzGersGSWVMbASEu/0f4DzKwfX2qDm5a2ORp7b5lnyALD
         AghnddGwrkObQdcsDBXEyjAjdiMzJn4RJ9ZTIkoYn54fw5SEB/0m9rcD/0fpB22mAv
         3j/32NSsuj0tHTO7WnTv50jfvKH0MOF+TAEcSR+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 24/29] spi: fsl-espi: Only process interrupts for expected events
Date:   Mon, 28 Sep 2020 21:30:21 -0400
Message-Id: <20200929013027.2406344-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
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
index e60581283a247..6d148ab70b93e 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -564,13 +564,14 @@ static void fsl_espi_cpu_irq(struct fsl_espi *espi, u32 events)
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

