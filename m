Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805F411D98
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfEBPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbfEBPby (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6600A20C01;
        Thu,  2 May 2019 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811113;
        bh=HbsuwdOIgem/E0Mlci7TCiK8L+RXj1IGzfey9vqEvCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItgcUYSBqnY+6Xvgh2QsxxieaUgwaDFaEa1fR+hNc002Nzl0ZKtxSePmXj8m/RnRY
         S3Gg7tySvqECIvfi0uQyTdesxXxUOUnjVKEmS3wQMKBW7V/AvzWwD7pirFXt4yEpnU
         e7zylUW0MaNSUyHyNqjVip4HyrsWtRLLi79TvvqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chris Healy <cphealy@gmail.com>, linux-gpio@vger.kernel.org,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 080/101] gpio: of: Check propname before applying "cs-gpios" quirks
Date:   Thu,  2 May 2019 17:21:22 +0200
Message-Id: <20190502143345.235274686@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e5545c94e43b8f6599ffc01df8d1aedf18ee912a ]

SPI GPIO device has more than just "cs-gpio" property in its node and
would request those GPIOs as a part of its initialization. To avoid
applying CS-specific quirk to all of them add a check to make sure
that propname is "cs-gpios".

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index a1dd2f1c0d02..9470563f2506 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -119,7 +119,8 @@ static void of_gpio_flags_quirks(struct device_node *np,
 	 * to determine if the flags should have inverted semantics.
 	 */
 	if (IS_ENABLED(CONFIG_SPI_MASTER) &&
-	    of_property_read_bool(np, "cs-gpios")) {
+	    of_property_read_bool(np, "cs-gpios") &&
+	    !strcmp(propname, "cs-gpios")) {
 		struct device_node *child;
 		u32 cs;
 		int ret;
-- 
2.19.1



