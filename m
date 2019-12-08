Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1345C11624C
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLHN7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:59:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59976 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfLHNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0007dX-Kb; Sun, 08 Dec 2019 13:54:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002Ll-Ue; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Sean Nyekjaer" <sean@geanix.com>
Date:   Sun, 08 Dec 2019 13:53:01 +0000
Message-ID: <lsq.1575813165.957212105@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/72] can: mcp251x: mcp251x_hw_reset(): allow more
 time after a reset
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d84ea2123f8d27144e3f4d58cd88c9c6ddc799de upstream.

Some boards take longer than 5ms to power up after a reset, so allow
some retries attempts before giving up.

Fixes: ff06d611a31c ("can: mcp251x: Improve mcp251x_hw_reset()")
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/spi/mcp251x.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -626,7 +626,7 @@ static int mcp251x_setup(struct net_devi
 static int mcp251x_hw_reset(struct spi_device *spi)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
-	u8 reg;
+	unsigned long timeout;
 	int ret;
 
 	/* Wait for oscillator startup timer after power up */
@@ -640,10 +640,19 @@ static int mcp251x_hw_reset(struct spi_d
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
 	
-	reg = mcp251x_read_reg(spi, CANSTAT);
-	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
-		return -ENODEV;
+	/* Wait for reset to finish */
+	timeout = jiffies + HZ;
+	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
+	       CANCTRL_REQOP_CONF) {
+		usleep_range(MCP251X_OST_DELAY_MS * 1000,
+			     MCP251X_OST_DELAY_MS * 1000 * 2);
 
+		if (time_after(jiffies, timeout)) {
+			dev_err(&spi->dev,
+				"MCP251x didn't enter in conf mode after reset\n");
+			return -EBUSY;
+		}
+	}
 	return 0;
 }
 

