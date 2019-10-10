Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9EDD252C
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfJJIy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389870AbfJJItw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58AC2064A;
        Thu, 10 Oct 2019 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697392;
        bh=mYrFo0W9gI8djX/nmVkmDQqAzDr5zN+mypISr36JtF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYJWiiKpur8gqnYsjiscfjrQZvU+XL7mClstSEMxkkJe4hJLMFNFHY1blNF2VE0Oq
         O9i8l5GVelv9KHwUpYF88kojmdiqrJBIboZrrzyjLNutwtwe6WEACcwWovzXD+A64A
         BCzo4nGx0Cpk1OZceT1DI3660YxR9pph9MUq5C1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 11/61] can: mcp251x: mcp251x_hw_reset(): allow more time after a reset
Date:   Thu, 10 Oct 2019 10:36:36 +0200
Message-Id: <20191010083456.241092643@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d84ea2123f8d27144e3f4d58cd88c9c6ddc799de upstream.

Some boards take longer than 5ms to power up after a reset, so allow
some retries attempts before giving up.

Fixes: ff06d611a31c ("can: mcp251x: Improve mcp251x_hw_reset()")
Cc: linux-stable <stable@vger.kernel.org>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/spi/mcp251x.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -627,7 +627,7 @@ static int mcp251x_setup(struct net_devi
 static int mcp251x_hw_reset(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	u8 reg;
+	unsigned long timeout;
 	int ret;
 
 	/* Wait for oscillator startup timer after power up */
@@ -641,10 +641,19 @@ static int mcp251x_hw_reset(struct spi_d
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
 
-	reg = mcp251x_read_reg(spi, CANSTAT);
-	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
-		return -ENODEV;
-
+	/* Wait for reset to finish */
+	timeout = jiffies + HZ;
+	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
+	       CANCTRL_REQOP_CONF) {
+		usleep_range(MCP251X_OST_DELAY_MS * 1000,
+			     MCP251X_OST_DELAY_MS * 1000 * 2);
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&spi->dev,
+				"MCP251x didn't enter in conf mode after reset\n");
+			return -EBUSY;
+		}
+	}
 	return 0;
 }
 


