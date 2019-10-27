Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F39CE6913
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfJ0VeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbfJ0VLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1359D205C9;
        Sun, 27 Oct 2019 21:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210705;
        bh=gQSgm9615ylTqStbQ+zmWn2KzgDQK2vHXBXyg1Y7cJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z78QIg3HMWqrpMDF/QI9pHg2HqJSnmRL4TzUbHYkIv7pYte6A5z/Azftb6kixua2F
         z21Fqp0oWNvtsSXbC+No59/3Ev/21JsGdqfiB9Fdmp8c1Xf9JiGUq9ZZwtDFFDXGIy
         BBaT9zx4YdRTMJWM9UvQuHB5da9g84kIzmmPgGA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Williams <alpawi@amazon.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 109/119] pinctrl: armada-37xx: swap polarity on LED group
Date:   Sun, 27 Oct 2019 22:01:26 +0100
Message-Id: <20191027203349.467637020@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Williams <alpawi@amazon.com>

commit b835d6953009dc350d61402a854b5a7178d8c615 upstream.

The configuration registers for the LED group have inverted
polarity, which puts the GPIO into open-drain state when used in
GPIO mode.  Switch to '0' for GPIO and '1' for LED modes.

Fixes: 87466ccd9401 ("pinctrl: armada-37xx: Add pin controller support for Armada 37xx")
Signed-off-by: Patrick Williams <alpawi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191001155154.99710-1-alpawi@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -170,10 +170,10 @@ static struct armada_37xx_pin_group arma
 	PIN_GRP_EXTRA("uart2", 9, 2, BIT(1) | BIT(13) | BIT(14) | BIT(19),
 		      BIT(1) | BIT(13) | BIT(14), BIT(1) | BIT(19),
 		      18, 2, "gpio", "uart"),
-	PIN_GRP_GPIO("led0_od", 11, 1, BIT(20), "led"),
-	PIN_GRP_GPIO("led1_od", 12, 1, BIT(21), "led"),
-	PIN_GRP_GPIO("led2_od", 13, 1, BIT(22), "led"),
-	PIN_GRP_GPIO("led3_od", 14, 1, BIT(23), "led"),
+	PIN_GRP_GPIO_2("led0_od", 11, 1, BIT(20), BIT(20), 0, "led"),
+	PIN_GRP_GPIO_2("led1_od", 12, 1, BIT(21), BIT(21), 0, "led"),
+	PIN_GRP_GPIO_2("led2_od", 13, 1, BIT(22), BIT(22), 0, "led"),
+	PIN_GRP_GPIO_2("led3_od", 14, 1, BIT(23), BIT(23), 0, "led"),
 
 };
 


