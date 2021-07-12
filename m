Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447C43C492F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhGLGmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234726AbhGLGlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD75D61004;
        Mon, 12 Jul 2021 06:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071902;
        bh=cRihPaoRihsuA6DTjujpIiIJ2JBvDndLgo48WOan2BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+eKiyZs3r3zoXH2UdhGJUNQ1rSX9SgXpsuotVetwDEjZYaf4TL5Zb1L/VOyhDS5J
         U/w24/oapnsiw9suz/EdgWVfNDImJkxLrH4y8C56p2kdOPmnnWIf7HKn7GBRZCUF2A
         6HxV2DupQA6+c8O3P/7U9NuN8FqEJN/q+mRXmdwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirko Vogt <mirko-dev|linux@nanl.de>,
        Ralf Schlatterbeck <rsc@runtux.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/593] spi: spi-sun6i: Fix chipselect/clock bug
Date:   Mon, 12 Jul 2021 08:07:09 +0200
Message-Id: <20210712060913.111592483@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 19238e1b76b4..803d92f8d031 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -290,6 +290,10 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	}
 
 	sun6i_spi_write(sspi, SUN6I_CLK_CTL_REG, reg);
+	/* Finally enable the bus - doing so before might raise SCK to HIGH */
+	reg = sun6i_spi_read(sspi, SUN6I_GBL_CTL_REG);
+	reg |= SUN6I_GBL_CTL_BUS_ENABLE;
+	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG, reg);
 
 	/* Setup the transfer now... */
 	if (sspi->tx_buf)
@@ -398,7 +402,7 @@ static int sun6i_spi_runtime_resume(struct device *dev)
 	}
 
 	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
-			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
+			SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
 
 	return 0;
 
-- 
2.30.2



