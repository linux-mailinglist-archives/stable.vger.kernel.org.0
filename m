Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12E83A84C2
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhFOPvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232125AbhFOPvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7481B61864;
        Tue, 15 Jun 2021 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772167;
        bh=B60Ie+OjEirDWdruJwC0k9ONKwgVsf/7BWwlQr6AOtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bE6DHb4SQ++f39Pb2XHaX3IOqTDKdDC2ynOInAc5oNjQ27UfsVd8gakSZePPyChEG
         SOGODuV7I2yrV78tEdp36GtkaCyji0WIlWvo+0VETPlpbOWQHW4PX3JlMXoBfTVdGA
         WaJ6JmaIcE93PCkF18VZtS+LRpRUEURLV70CboMnrU8K83SPzCHDREVT6ZVsH6yKFT
         annPbEMMDIujewUQuVQKW3GDcR5lZVP9IwTosBxMBWpS/kwhZjKK47p65kphyVyYyv
         g/peHfT75R8I8nCiDBYp3pTeJW54N0Z81rFeiiVhcbfgiysx4/drI+Lvray/W1ffD0
         r8tFW1CX0KsFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrice Chotard <patrice.chotard@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 15/30] spi: stm32-qspi: Always wait BUSY bit to be cleared in stm32_qspi_wait_cmd()
Date:   Tue, 15 Jun 2021 11:48:52 -0400
Message-Id: <20210615154908.62388-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2786470a5201..4f24f6392212 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -293,7 +293,7 @@ static int stm32_qspi_wait_cmd(struct stm32_qspi *qspi,
 	int err = 0;
 
 	if (!op->data.nbytes)
-		return stm32_qspi_wait_nobusy(qspi);
+		goto wait_nobusy;
 
 	if (readl_relaxed(qspi->io_base + QSPI_SR) & SR_TCF)
 		goto out;
@@ -314,6 +314,9 @@ static int stm32_qspi_wait_cmd(struct stm32_qspi *qspi,
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

