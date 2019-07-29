Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA00579423
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfG2T2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbfG2T2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:28:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 427D4217D7;
        Mon, 29 Jul 2019 19:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428500;
        bh=Cd/i1Nq2Ul7QD8KsMj7YacQXpM+qi/Pmf8IQc34zxsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHgsLJMCK0qFT9rLEvDp3wzby6kU1EHaympNsBUwocDCoRPkQ1tPPZp1qe+plW0pV
         9GlE7Jx06G6oKskcGc6lQIRoi0cHn+A+jki8i6h3246HUY3uSlFJqglhmlUw45tuDN
         ND6eANQbIg8W1FzOXn/O9FFR9kT0rREyqYubeaaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/293] gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
Date:   Mon, 29 Jul 2019 21:19:46 +0200
Message-Id: <20190729190831.890070871@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3285170f28a850638794cdfe712eb6d93e51e706 ]

Commit 372e722ea4dd4ca1 ("gpiolib: use descriptors internally") renamed
the functions to use a "gpiod" prefix, and commit 79a9becda8940deb
("gpiolib: export descriptor-based GPIO interface") introduced the "raw"
variants, but both changes forgot to update the comments.

Readd a similar reference to gpiod_set_value(), which was accidentally
removed by commit 1e77fc82110ac36f ("gpio: Add missing open drain/source
handling to gpiod_set_value_cansleep()").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20190701142738.25219-1-geert+renesas@glider.be
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21062cb6b85f..3db0a9b0d259 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2480,7 +2480,7 @@ static int _gpiod_get_raw_value(const struct gpio_desc *desc)
 int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	VALIDATE_DESC(desc);
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_raw_value_cansleep() */
 	WARN_ON(desc->gdev->chip->can_sleep);
 	return _gpiod_get_raw_value(desc);
 }
@@ -2501,7 +2501,7 @@ int gpiod_get_value(const struct gpio_desc *desc)
 	int value;
 
 	VALIDATE_DESC(desc);
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_value_cansleep() */
 	WARN_ON(desc->gdev->chip->can_sleep);
 
 	value = _gpiod_get_raw_value(desc);
@@ -2670,7 +2670,7 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
 void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
 	VALIDATE_DESC_VOID(desc);
-	/* Should be using gpiod_set_value_cansleep() */
+	/* Should be using gpiod_set_raw_value_cansleep() */
 	WARN_ON(desc->gdev->chip->can_sleep);
 	_gpiod_set_raw_value(desc, value);
 }
-- 
2.20.1



