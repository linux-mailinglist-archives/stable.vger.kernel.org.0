Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707D9F7B93
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKKShh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbfKKShg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638A0204FD;
        Mon, 11 Nov 2019 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497453;
        bh=UUJfsJTjQIR0PVeU3w+49eR4YbkU3H0RuogjCNK6NN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQsh2ZxSjwEgzLiT2mG02o9vst5GN9dlUDvSH2q97GoNRQfJsQNnuJQYCE+bAtO1+
         0nWcisL7wAUu8aUc0cYrfFKk23NPD6kOn5BSYMUaMbF0yX6bW+Xcajp4efjvnxwSQq
         6dmiB41XuEeMRyqXYKP2HeE0/VbSrgmsR/Qi59Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Claudio Foellmi <claudio.foellmi@ergon.ch>,
        Vignesh R <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 059/105] i2c: omap: Trigger bus recovery in lockup case
Date:   Mon, 11 Nov 2019 19:28:29 +0100
Message-Id: <20191111181444.761824937@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Foellmi <claudio.foellmi@ergon.ch>

commit 93367bfca98f36cece57c01dbce6ea1b4ac58245 upstream

A very conservative check for bus activity (to prevent interference
in multimaster setups) prevented the bus recovery methods from being
triggered in the case that SDA or SCL was stuck low.
This defeats the purpose of the recovery mechanism, which was introduced
for exactly this situation (a slave device keeping SDA pulled down).

Also added a check to make sure SDA is low before attempting recovery.
If SDA is not stuck low, recovery will not help, so we can skip it.

Note that bus lockups can persist across reboots. The only other options
are to reset or power cycle the offending slave device, and many i2c
slaves do not even have a reset pin.

If we see that one of the lines is low for the entire timeout duration,
we can actually be sure that there is no other master driving the bus.
It is therefore save for us to attempt a bus recovery.

Signed-off-by: Claudio Foellmi <claudio.foellmi@ergon.ch>
Tested-by: Vignesh R <vigneshr@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
[wsa: fixed one return code to -EBUSY]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -487,6 +487,22 @@ static int omap_i2c_init(struct omap_i2c
 }
 
 /*
+ * Try bus recovery, but only if SDA is actually low.
+ */
+static int omap_i2c_recover_bus(struct omap_i2c_dev *omap)
+{
+	u16 systest;
+
+	systest = omap_i2c_read_reg(omap, OMAP_I2C_SYSTEST_REG);
+	if ((systest & OMAP_I2C_SYSTEST_SCL_I_FUNC) &&
+	    (systest & OMAP_I2C_SYSTEST_SDA_I_FUNC))
+		return 0; /* bus seems to already be fine */
+	if (!(systest & OMAP_I2C_SYSTEST_SCL_I_FUNC))
+		return -EBUSY; /* recovery would not fix SCL */
+	return i2c_recover_bus(&omap->adapter);
+}
+
+/*
  * Waiting on Bus Busy
  */
 static int omap_i2c_wait_for_bb(struct omap_i2c_dev *omap)
@@ -496,7 +512,7 @@ static int omap_i2c_wait_for_bb(struct o
 	timeout = jiffies + OMAP_I2C_TIMEOUT;
 	while (omap_i2c_read_reg(omap, OMAP_I2C_STAT_REG) & OMAP_I2C_STAT_BB) {
 		if (time_after(jiffies, timeout))
-			return i2c_recover_bus(&omap->adapter);
+			return omap_i2c_recover_bus(omap);
 		msleep(1);
 	}
 
@@ -577,8 +593,13 @@ static int omap_i2c_wait_for_bb_valid(st
 		}
 
 		if (time_after(jiffies, timeout)) {
+			/*
+			 * SDA or SCL were low for the entire timeout without
+			 * any activity detected. Most likely, a slave is
+			 * locking up the bus with no master driving the clock.
+			 */
 			dev_warn(omap->dev, "timeout waiting for bus ready\n");
-			return -ETIMEDOUT;
+			return omap_i2c_recover_bus(omap);
 		}
 
 		msleep(1);


