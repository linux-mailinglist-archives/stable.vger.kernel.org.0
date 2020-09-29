Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D237727B993
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgI2Bbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbgI2Bbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3254322262;
        Tue, 29 Sep 2020 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343102;
        bh=BzMNSrDRWu5PHra6SIrk//x0rIMv7+Gij9DQf6TWKqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWjRT9e6tVPiWOg1vyLTt+s5Hicrvsp3YMS0mle+JQwvVIxF00C2oVhbzgrPwhZl7
         tI6kcnQO6VS5mryk2IEeFhIE+kQoYlA8YD5Pz81OnhOakwzLfwpomg9OGAutKQUmvH
         4+ZvzRmYHnlKc/1qKkgk9S+IqZwBteuRRg+i/z9g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/11] spi: fsl-espi: Only process interrupts for expected events
Date:   Mon, 28 Sep 2020 21:31:28 -0400
Message-Id: <20200929013129.2406832-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013129.2406832-1-sashal@kernel.org>
References: <20200929013129.2406832-1-sashal@kernel.org>
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
index 1e8ff6256079f..b8dd75b8518b5 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -559,13 +559,14 @@ static void fsl_espi_cpu_irq(struct fsl_espi *espi, u32 events)
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

