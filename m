Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE8D25A2
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbfJJIlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388266AbfJJIlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D010321D7C;
        Thu, 10 Oct 2019 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696868;
        bh=ew0MqeqxkZeCjlz7MmeD69SyuCnfBxiZvDklep9KzFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CE5bN0KQnlVB7vHq6LNBmAqYhNUrcuhTVHC9iXf3fxzN7b3NsRwFAG1Rh3QYbFX1y
         rzZENlgtJMVqNWnfu2fyDxqh5Pza6uP1LaBOTrBbXzR22SFlxQz2plqRsdp4aNCzkr
         ZFR2sMvg4u232IIOEa+AlNKWMpf1kHzRsKxyhrAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.3 037/148] can: mcp251x: mcp251x_hw_reset(): allow more time after a reset
Date:   Thu, 10 Oct 2019 10:34:58 +0200
Message-Id: <20191010083613.400234335@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
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
@@ -612,7 +612,7 @@ static int mcp251x_setup(struct net_devi
 static int mcp251x_hw_reset(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	u8 reg;
+	unsigned long timeout;
 	int ret;
 
 	/* Wait for oscillator startup timer after power up */
@@ -626,10 +626,19 @@ static int mcp251x_hw_reset(struct spi_d
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
 


