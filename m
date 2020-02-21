Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4A91674DE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbgBUISa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbgBUIS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D05BB24692;
        Fri, 21 Feb 2020 08:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273109;
        bh=TWYKJH7EdXk4lvXiINzi24/zw7SjtOiQoX3rzjP6BGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/eKl2WFTgXczsWQFohOwwHpJv5bW8n/sp5Bzp2Gd9o0xYz3dNSKqZ9SQT7q2tecO
         c8bEcmdw6IlX66FdFs7T9grxRg8zJybjt1SOO+vWD2MBNSVzNw0KqCVMyh2ynPrha9
         O7k6VLG3z5BW+8qvQYPvUdCl79GNu0/990wYDYco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zahari Petkov <zahari@balena.io>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/191] leds: pca963x: Fix open-drain initialization
Date:   Fri, 21 Feb 2020 08:39:48 +0100
Message-Id: <20200221072252.982871888@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zahari Petkov <zahari@balena.io>

[ Upstream commit 697529091ac7a0a90ca349b914bb30641c13c753 ]

Before commit bb29b9cccd95 ("leds: pca963x: Add bindings to invert
polarity") Mode register 2 was initialized directly with either 0x01
or 0x05 for open-drain or totem pole (push-pull) configuration.

Afterwards, MODE2 initialization started using bitwise operations on
top of the default MODE2 register value (0x05). Using bitwise OR for
setting OUTDRV with 0x01 and 0x05 does not produce correct results.
When open-drain is used, instead of setting OUTDRV to 0, the driver
keeps it as 1:

Open-drain: 0x05 | 0x01 -> 0x05 (0b101 - incorrect)
Totem pole: 0x05 | 0x05 -> 0x05 (0b101 - correct but still wrong)

Now OUTDRV setting uses correct bitwise operations for initialization:

Open-drain: 0x05 & ~0x04 -> 0x01 (0b001 - correct)
Totem pole: 0x05 | 0x04 -> 0x05 (0b101 - correct)

Additional MODE2 register definitions are introduced now as well.

Fixes: bb29b9cccd95 ("leds: pca963x: Add bindings to invert polarity")
Signed-off-by: Zahari Petkov <zahari@balena.io>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca963x.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca963x.c b/drivers/leds/leds-pca963x.c
index 5c0908113e388..bbcde13b77f16 100644
--- a/drivers/leds/leds-pca963x.c
+++ b/drivers/leds/leds-pca963x.c
@@ -43,6 +43,8 @@
 #define PCA963X_LED_PWM		0x2	/* Controlled through PWM */
 #define PCA963X_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
 
+#define PCA963X_MODE2_OUTDRV	0x04	/* Open-drain or totem pole */
+#define PCA963X_MODE2_INVRT	0x10	/* Normal or inverted direction */
 #define PCA963X_MODE2_DMBLNK	0x20	/* Enable blinking */
 
 #define PCA963X_MODE1		0x00
@@ -462,12 +464,12 @@ static int pca963x_probe(struct i2c_client *client,
 						    PCA963X_MODE2);
 		/* Configure output: open-drain or totem pole (push-pull) */
 		if (pdata->outdrv == PCA963X_OPEN_DRAIN)
-			mode2 |= 0x01;
+			mode2 &= ~PCA963X_MODE2_OUTDRV;
 		else
-			mode2 |= 0x05;
+			mode2 |= PCA963X_MODE2_OUTDRV;
 		/* Configure direction: normal or inverted */
 		if (pdata->dir == PCA963X_INVERTED)
-			mode2 |= 0x10;
+			mode2 |= PCA963X_MODE2_INVRT;
 		i2c_smbus_write_byte_data(pca963x->chip->client, PCA963X_MODE2,
 					  mode2);
 	}
-- 
2.20.1



