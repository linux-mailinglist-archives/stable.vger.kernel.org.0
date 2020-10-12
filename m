Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6523428B9B6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390404AbgJLOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbgJLNin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 836B420838;
        Mon, 12 Oct 2020 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509903;
        bh=d2QW1SkE0G6O9RE9G4bd6ts85KlbY5IIPeQucO3DEB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSR5vmiubEiW0+tvz/vK8VXqN/8CusGNcGItAX1xhBrv88ARwV2OYnvzJ9tm46jaJ
         PAF7OIf2xThxztz0D8yfJc3J4OXfcPxpN+C1yN8ZxZJJZNPFNhcWbos1H+wiiZh3n3
         2QDMHwmtNKunZfIV4ewz8RliFRXv0lJHh0oI+m20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.14 48/70] i2c: meson: fix clock setting overwrite
Date:   Mon, 12 Oct 2020 15:27:04 +0200
Message-Id: <20201012132632.497901612@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 28683e847e2f20eed22cdd24f185d7783db396d3 upstream.

When the slave address is written in do_start(), SLAVE_ADDR is written
completely. This may overwrite some setting related to the clock rate
or signal filtering.

Fix this by writing only the bits related to slave address. To avoid
causing unexpected changed, explicitly disable filtering or high/low
clock mode which may have been left over by the bootloader.

Fixes: 30021e3707a7 ("i2c: add support for Amlogic Meson I2C controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-meson.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-meson.c
+++ b/drivers/i2c/busses/i2c-meson.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/i2c.h>
@@ -39,6 +40,12 @@
 #define REG_CTRL_CLKDIVEXT_SHIFT 28
 #define REG_CTRL_CLKDIVEXT_MASK	GENMASK(29, 28)
 
+#define REG_SLV_ADDR		GENMASK(7, 0)
+#define REG_SLV_SDA_FILTER	GENMASK(10, 8)
+#define REG_SLV_SCL_FILTER	GENMASK(13, 11)
+#define REG_SLV_SCL_LOW		GENMASK(27, 16)
+#define REG_SLV_SCL_LOW_EN	BIT(28)
+
 #define I2C_TIMEOUT_MS		500
 
 enum {
@@ -142,6 +149,9 @@ static void meson_i2c_set_clk_div(struct
 	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_CLKDIVEXT_MASK,
 			   (div >> 10) << REG_CTRL_CLKDIVEXT_SHIFT);
 
+	/* Disable HIGH/LOW mode */
+	meson_i2c_set_mask(i2c, REG_SLAVE_ADDR, REG_SLV_SCL_LOW_EN, 0);
+
 	dev_dbg(i2c->dev, "%s: clk %lu, freq %u, div %u\n", __func__,
 		clk_rate, freq, div);
 }
@@ -269,7 +279,10 @@ static void meson_i2c_do_start(struct me
 	token = (msg->flags & I2C_M_RD) ? TOKEN_SLAVE_ADDR_READ :
 		TOKEN_SLAVE_ADDR_WRITE;
 
-	writel(msg->addr << 1, i2c->regs + REG_SLAVE_ADDR);
+
+	meson_i2c_set_mask(i2c, REG_SLAVE_ADDR, REG_SLV_ADDR,
+			   FIELD_PREP(REG_SLV_ADDR, msg->addr << 1));
+
 	meson_i2c_add_token(i2c, TOKEN_START);
 	meson_i2c_add_token(i2c, token);
 }
@@ -425,6 +438,10 @@ static int meson_i2c_probe(struct platfo
 		return ret;
 	}
 
+	/* Disable filtering */
+	meson_i2c_set_mask(i2c, REG_SLAVE_ADDR,
+			   REG_SLV_SDA_FILTER | REG_SLV_SCL_FILTER, 0);
+
 	meson_i2c_set_clk_div(i2c, timings.bus_freq_hz);
 
 	return 0;


