Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ABC3C5567
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355668AbhGLIKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353612AbhGLICh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CC8761CEB;
        Mon, 12 Jul 2021 07:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076561;
        bh=HTJqpn40mcfBkEgWdKi/YdgVL0bQEle/cZVol9slRp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1bmwWlvtc+9mLaBXU3fCaX0tivizOF2fn5hAztQGpLIVcv1XcNWEUAyf9eBBmk8V
         naymd4uP8EILCOH9ROkMD6+TjCkis8jKg2MUIFEFp1rhIG8vmqreRbvGP559iR/5pa
         et/d5v73F1XKJsBcQXOTc+C6HXn2tAWKFEL0c47Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 659/800] leds: lm3697: Dont spam logs when probe is deferred
Date:   Mon, 12 Jul 2021 08:11:22 +0200
Message-Id: <20210712061037.067210998@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 807553f8bf4afa673750e52905e0f9488179112f ]

When requesting GPIO line the probe can be deferred.
In such case don't spam logs with an error message.
This can be achieved by switching to dev_err_probe().

Fixes: 5c1d824cda9f ("leds: lm3697: Introduce the lm3697 driver")
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3697.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lm3697.c b/drivers/leds/leds-lm3697.c
index 7d216cdb91a8..912e8bb22a99 100644
--- a/drivers/leds/leds-lm3697.c
+++ b/drivers/leds/leds-lm3697.c
@@ -203,11 +203,9 @@ static int lm3697_probe_dt(struct lm3697 *priv)
 
 	priv->enable_gpio = devm_gpiod_get_optional(dev, "enable",
 						    GPIOD_OUT_LOW);
-	if (IS_ERR(priv->enable_gpio)) {
-		ret = PTR_ERR(priv->enable_gpio);
-		dev_err(dev, "Failed to get enable gpio: %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(priv->enable_gpio))
+		return dev_err_probe(dev, PTR_ERR(priv->enable_gpio),
+					  "Failed to get enable GPIO\n");
 
 	priv->regulator = devm_regulator_get(dev, "vled");
 	if (IS_ERR(priv->regulator))
-- 
2.30.2



