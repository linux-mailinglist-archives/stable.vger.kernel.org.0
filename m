Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69157F3F2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405064AbfHBJnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405058AbfHBJnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D291020B7C;
        Fri,  2 Aug 2019 09:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739010;
        bh=2QSgyNPJN6dKbqt5jQJ+/1Zq6KKwdzdzhlBw0Os0vr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHmg1MsPm6Qn3GwDa+T/QEQmCgmqWyjkRE+9aOsNLvfICks8Uw2vyCaRvEDmzYQPO
         fzloC59niuzKSnldB4EStN7803Q2ckNE/9rm/K52LHKqg1oigcLpfYGSlKbIliKaXQ
         GKSqVd+Q1t90loUr5Gqmca7KECvw/2bpjXL2ZL3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/223] gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
Date:   Fri,  2 Aug 2019 11:34:52 +0200
Message-Id: <20190802092243.164470611@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
index 9e2fe12c2858..a3251faa3ed8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2411,7 +2411,7 @@ static int _gpiod_get_raw_value(const struct gpio_desc *desc)
 int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	VALIDATE_DESC(desc);
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_raw_value_cansleep() */
 	WARN_ON(desc->gdev->chip->can_sleep);
 	return _gpiod_get_raw_value(desc);
 }
@@ -2432,7 +2432,7 @@ int gpiod_get_value(const struct gpio_desc *desc)
 	int value;
 
 	VALIDATE_DESC(desc);
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_value_cansleep() */
 	WARN_ON(desc->gdev->chip->can_sleep);
 
 	value = _gpiod_get_raw_value(desc);
@@ -2608,7 +2608,7 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
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



