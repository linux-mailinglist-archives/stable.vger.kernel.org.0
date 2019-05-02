Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF53911F23
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfEBPY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfEBPY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16BB20675;
        Thu,  2 May 2019 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810696;
        bh=B/P93hTHP71MZC3G562cIshOy7HeUCLMgN4xrTDuKv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HHWiacHGY8bajhMME1RFcOolV2udMCkxZVhgO/tzVTPl4ERc74xsAXHAhfFWqPc7
         a9BMOtJQYU1nlQ3SZTFQ14H5HPesfS0bQrbXm3Ttp8Z9dkETD/6L+dh+KnBVsZvE1F
         nrv70uZDkNzGS/DXqVsiUw4Mb5552TcaKjHSGh/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 45/49] gpio: of: Fix of_gpiochip_add() error path
Date:   Thu,  2 May 2019 17:21:22 +0200
Message-Id: <20190502143329.586626969@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f7299d441a4da8a5088e651ea55023525a793a13 ]

If the call to of_gpiochip_scan_gpios() in of_gpiochip_add() fails, no
error handling is performed.  This lead to the need of callers to call
of_gpiochip_remove() on failure, which causes "BAD of_node_put() on ..."
if the failure happened before the call to of_node_get().

Fix this by adding proper error handling.

Note that calling gpiochip_remove_pin_ranges() multiple times causes no
harm: subsequent calls are a no-op.

Fixes: dfbd379ba9b7431e ("gpio: of: Return error if gpio hog configuration failed")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index ee8c046cab62..d6ed4e891b34 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -499,7 +499,13 @@ int of_gpiochip_add(struct gpio_chip *chip)
 
 	of_node_get(chip->of_node);
 
-	return of_gpiochip_scan_gpios(chip);
+	status = of_gpiochip_scan_gpios(chip);
+	if (status) {
+		of_node_put(chip->of_node);
+		gpiochip_remove_pin_ranges(chip);
+	}
+
+	return status;
 }
 
 void of_gpiochip_remove(struct gpio_chip *chip)
-- 
2.19.1



