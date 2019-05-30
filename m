Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F2E2F3DC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbfE3EdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbfE3DNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB4C623D14;
        Thu, 30 May 2019 03:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186010;
        bh=kBdZxLStO5UGZP0SVaC8Xkb/xAYkj+2yoTzWlMQa4ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlCA4uSAHhpWSG7OBtuCqfoCAuUOu+B55XTM08/Bz15Qv+lKxEub7LDfoBfGX4xWM
         4JwaxgX1+ADDmDgYnRafuMA7nPj58CbdePXRI20zcz80QONq9yiRC3T9fI+NwCf5S1
         lL1upmVca2FKGuLAZxmfvskF3iReQB/sbLBOQy+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flavio Suligoi <f.suligoi@asem.it>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 072/346] spi: pxa2xx: fix SCR (divisor) calculation
Date:   Wed, 29 May 2019 20:02:25 -0700
Message-Id: <20190530030544.723205973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 29f2133717c527f492933b0622a4aafe0b3cbe9e ]

Calculate the divisor for the SCR (Serial Clock Rate), avoiding
that the SSP transmission rate can be greater than the device rate.

When the division between the SSP clock and the device rate generates
a reminder, we have to increment by one the divisor.
In this way the resulting SSP clock will never be greater than the
device SPI max frequency.

For example, with:

 - ssp_clk  = 50 MHz
 - dev freq = 15 MHz

without this patch the SSP clock will be greater than 15 MHz:

 - 25 MHz for PXA25x_SSP and CE4100_SSP
 - 16,56 MHz for the others

Instead, with this patch, we have in both case an SSP clock of 12.5MHz,
so the max rate of the SPI device clock is respected.

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 3e82eaad0f2d9..41aadb41a20bf 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -884,10 +884,14 @@ static unsigned int ssp_get_clk_div(struct driver_data *drv_data, int rate)
 
 	rate = min_t(int, ssp_clk, rate);
 
+	/*
+	 * Calculate the divisor for the SCR (Serial Clock Rate), avoiding
+	 * that the SSP transmission rate can be greater than the device rate
+	 */
 	if (ssp->type == PXA25x_SSP || ssp->type == CE4100_SSP)
-		return (ssp_clk / (2 * rate) - 1) & 0xff;
+		return (DIV_ROUND_UP(ssp_clk, 2 * rate) - 1) & 0xff;
 	else
-		return (ssp_clk / rate - 1) & 0xfff;
+		return (DIV_ROUND_UP(ssp_clk, rate) - 1)  & 0xfff;
 }
 
 static unsigned int pxa2xx_ssp_get_clk_div(struct driver_data *drv_data,
-- 
2.20.1



