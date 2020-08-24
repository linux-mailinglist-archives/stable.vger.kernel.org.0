Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C982504A9
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHXRFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgHXQic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CC1D22C9F;
        Mon, 24 Aug 2020 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287089;
        bh=HN0Isawz2NHgv2bRUqMMnRrlv95OYOY7kAoBjuMpvrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLMP+F5IxWtiTJkVCOOoLPQNAt327QpHY3Xtf+ihePgZXhUXmaRPGHJOjt1PcF4WL
         bK1VmJ5486ZrIZgGaH9Uc57No/V90GtJoiK9tjJK6PDf6IQDsgHWvEDBSsJTawjN+3
         BWMrxKOrWx06SFAFM+t+ZoIY1bIQBs00877EKEjw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 13/38] spi: stm32: always perform registers configuration prior to transfer
Date:   Mon, 24 Aug 2020 12:37:25 -0400
Message-Id: <20200824163751.606577-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163751.606577-1-sashal@kernel.org>
References: <20200824163751.606577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

[ Upstream commit 60ccb3515fc61a0124c70aa37317f75b67560024 ]

SPI registers content may have been lost upon suspend/resume sequence.
So, always compute and apply the necessary configuration in
stm32_spi_transfer_one_setup routine.

Signed-off-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/1597043558-29668-6-git-send-email-alain.volmat@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 42 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 54fc14e08cee9..b0a8e36ac49db 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1589,41 +1589,33 @@ static int stm32_spi_transfer_one_setup(struct stm32_spi *spi,
 	unsigned long flags;
 	unsigned int comm_type;
 	int nb_words, ret = 0;
+	int mbr;
 
 	spin_lock_irqsave(&spi->lock, flags);
 
 	spi->cur_xferlen = transfer->len;
 
-	if (spi->cur_bpw != transfer->bits_per_word) {
-		spi->cur_bpw = transfer->bits_per_word;
-		spi->cfg->set_bpw(spi);
-	}
-
-	if (spi->cur_speed != transfer->speed_hz) {
-		int mbr;
-
-		/* Update spi->cur_speed with real clock speed */
-		mbr = stm32_spi_prepare_mbr(spi, transfer->speed_hz,
-					    spi->cfg->baud_rate_div_min,
-					    spi->cfg->baud_rate_div_max);
-		if (mbr < 0) {
-			ret = mbr;
-			goto out;
-		}
+	spi->cur_bpw = transfer->bits_per_word;
+	spi->cfg->set_bpw(spi);
 
-		transfer->speed_hz = spi->cur_speed;
-		stm32_spi_set_mbr(spi, mbr);
+	/* Update spi->cur_speed with real clock speed */
+	mbr = stm32_spi_prepare_mbr(spi, transfer->speed_hz,
+				    spi->cfg->baud_rate_div_min,
+				    spi->cfg->baud_rate_div_max);
+	if (mbr < 0) {
+		ret = mbr;
+		goto out;
 	}
 
-	comm_type = stm32_spi_communication_type(spi_dev, transfer);
-	if (spi->cur_comm != comm_type) {
-		ret = spi->cfg->set_mode(spi, comm_type);
+	transfer->speed_hz = spi->cur_speed;
+	stm32_spi_set_mbr(spi, mbr);
 
-		if (ret < 0)
-			goto out;
+	comm_type = stm32_spi_communication_type(spi_dev, transfer);
+	ret = spi->cfg->set_mode(spi, comm_type);
+	if (ret < 0)
+		goto out;
 
-		spi->cur_comm = comm_type;
-	}
+	spi->cur_comm = comm_type;
 
 	if (spi->cfg->set_data_idleness)
 		spi->cfg->set_data_idleness(spi, transfer->len);
-- 
2.25.1

