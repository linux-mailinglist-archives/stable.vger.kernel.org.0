Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5863C52B9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbhGLHs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346673AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43827611BF;
        Mon, 12 Jul 2021 07:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075740;
        bh=8Yp9lNsy+iOakIq3cbwUDGisQWV9MqX/9kzDmE0CePE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dm6gblnrMf3LAzwHSkYjx3ybpVc5+vQKEMRolGwR0V4mnH7abgPhZBWop3p40Lvq0
         SPsO8ucs5Nda+OhhFXLfcBXOmuDUEUvLaUyHoOZs62+ew6FBfE5K03uqKNs8kvbCKh
         nw3Q7SU1VhuyKdJmKat/se15qgFMPe88LfzxKdd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirko Vogt <mirko-dev|linux@nanl.de>,
        Ralf Schlatterbeck <rsc@runtux.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 345/800] spi: spi-sun6i: Fix chipselect/clock bug
Date:   Mon, 12 Jul 2021 08:06:08 +0200
Message-Id: <20210712061003.695776270@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index cc8401980125..23ad052528db 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -379,6 +379,10 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	}
 
 	sun6i_spi_write(sspi, SUN6I_CLK_CTL_REG, reg);
+	/* Finally enable the bus - doing so before might raise SCK to HIGH */
+	reg = sun6i_spi_read(sspi, SUN6I_GBL_CTL_REG);
+	reg |= SUN6I_GBL_CTL_BUS_ENABLE;
+	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG, reg);
 
 	/* Setup the transfer now... */
 	if (sspi->tx_buf)
@@ -504,7 +508,7 @@ static int sun6i_spi_runtime_resume(struct device *dev)
 	}
 
 	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
-			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
+			SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
 
 	return 0;
 
-- 
2.30.2



