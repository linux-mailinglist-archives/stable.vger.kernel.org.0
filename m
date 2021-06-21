Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC543AEDA4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFUQVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhFUQUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E17FB613CC;
        Mon, 21 Jun 2021 16:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292312;
        bh=9QCDooSLI5lGrufx4gMOLz7/kIWNX/cvUYTiHDEsmU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkyX0ijiPJNVeMiJdNCefNz+en/NdX8V+o2zg3hxKlRsj6Ga6/5GDDWukgkeaSdSD
         i2mjSpklGOsupBQFDi71LzV3bPGecij4+eaG07UDfjAYDulKinr93/sKRc0o+po76h
         mJDf/VkG7oSBOJn2I/Eg09Ejywo3FkNti00DbwB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/90] spi: stm32-qspi: Always wait BUSY bit to be cleared in stm32_qspi_wait_cmd()
Date:   Mon, 21 Jun 2021 18:15:20 +0200
Message-Id: <20210621154905.650401693@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit d38fa9a155b2829b7e2cfcf8a4171b6dd3672808 ]

In U-boot side, an issue has been encountered when QSPI source clock is
running at low frequency (24 MHz for example), waiting for TCF bit to be
set didn't ensure that all data has been send out the FIFO, we should also
wait that BUSY bit is cleared.

To prevent similar issue in kernel driver, we implement similar behavior
by always waiting BUSY bit to be cleared.

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20210603073421.8441-1-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32-qspi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 4e726929bb4f..ea77d915216a 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -291,7 +291,7 @@ static int stm32_qspi_wait_cmd(struct stm32_qspi *qspi,
 	int err = 0;
 
 	if (!op->data.nbytes)
-		return stm32_qspi_wait_nobusy(qspi);
+		goto wait_nobusy;
 
 	if (readl_relaxed(qspi->io_base + QSPI_SR) & SR_TCF)
 		goto out;
@@ -312,6 +312,9 @@ static int stm32_qspi_wait_cmd(struct stm32_qspi *qspi,
 out:
 	/* clear flags */
 	writel_relaxed(FCR_CTCF | FCR_CTEF, qspi->io_base + QSPI_FCR);
+wait_nobusy:
+	if (!err)
+		err = stm32_qspi_wait_nobusy(qspi);
 
 	return err;
 }
-- 
2.30.2



