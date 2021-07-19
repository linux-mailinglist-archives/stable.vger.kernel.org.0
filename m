Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEB83CD9E5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbhGSOcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243631AbhGSO2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D8160551;
        Mon, 19 Jul 2021 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707299;
        bh=LWgaDsjxuJiUaMVNUtyez3baQyH7MED6hRzLbuOOj3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNXUq3dxmJjBHO13md8DlES2/EYZ3KREnYVETFYJQ1CPUvQWVD2JEIYRWAQBORsKk
         d432IL4e4RviBHd+daQ4pOrB+26+xIPVhzlnTfTyIPzQmy+adkboguPdXlZgJdHNfo
         40p8ugt2W7OLZWXovhpjhmWuYaLFHnXfLwq4Ndtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirko Vogt <mirko-dev|linux@nanl.de>,
        Ralf Schlatterbeck <rsc@runtux.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/245] spi: spi-sun6i: Fix chipselect/clock bug
Date:   Mon, 19 Jul 2021 16:50:13 +0200
Message-Id: <20210719144942.701040735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mirko Vogt <mirko-dev|linux@nanl.de>

[ Upstream commit 0d7993b234c9fad8cb6bec6adfaa74694ba85ecb ]

The current sun6i SPI implementation initializes the transfer too early,
resulting in SCK going high before the transfer. When using an additional
(gpio) chipselect with sun6i, the chipselect is asserted at a time when
clock is high, making the SPI transfer fail.

This is due to SUN6I_GBL_CTL_BUS_ENABLE being written into
SUN6I_GBL_CTL_REG at an early stage. Moving that to the transfer
function, hence, right before the transfer starts, mitigates that
problem.

Fixes: 3558fe900e8af (spi: sunxi: Add Allwinner A31 SPI controller driver)
Signed-off-by: Mirko Vogt <mirko-dev|linux@nanl.de>
Signed-off-by: Ralf Schlatterbeck <rsc@runtux.com>
Link: https://lore.kernel.org/r/20210614144507.y3udezjfbko7eavv@runtux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun6i.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
index 17068e62e792..8c3f5a00fd9e 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -251,6 +251,10 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	}
 
 	sun6i_spi_write(sspi, SUN6I_CLK_CTL_REG, reg);
+	/* Finally enable the bus - doing so before might raise SCK to HIGH */
+	reg = sun6i_spi_read(sspi, SUN6I_GBL_CTL_REG);
+	reg |= SUN6I_GBL_CTL_BUS_ENABLE;
+	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG, reg);
 
 	/* Setup the transfer now... */
 	if (sspi->tx_buf)
@@ -334,7 +338,7 @@ static int sun6i_spi_runtime_resume(struct device *dev)
 	}
 
 	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
-			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
+			SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
 
 	return 0;
 
-- 
2.30.2



