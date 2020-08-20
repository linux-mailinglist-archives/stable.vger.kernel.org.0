Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C07824BBD5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgHTJsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbgHTJsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9ACF2078D;
        Thu, 20 Aug 2020 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916923;
        bh=CFfNeosnv87tQONZzW6TrZx7td1xXo6DeJgM4alZ3oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxG9Gt3cUM77brK0YB1T4AMZUrX3KCQB0+BMX4RSKWUje3sZW7aQaXdMtBJS9sZpg
         YYU3RK2lpr8Xq2OSaYFzkvZfjN7Jda5N+YunwwezwsvVs6d7gqmbmoXd7Th4iiw5Et
         ZUurpiTNPXdDa2y8qw5r8PYwUMC0oK/lcpCWPNr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Henrique?= <johnnyonflame@hotmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 076/152] pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ
Date:   Thu, 20 Aug 2020 11:20:43 +0200
Message-Id: <20200820091557.629841938@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 84e7a946da71f678affacea301f6d5cb4d9784e8 upstream.

The PAT1 register contains information about the IRQ type (edge/level)
for input GPIOs with IRQ enabled, and the direction for non-IRQ GPIOs.
So it makes sense to read it only if the GPIO has no interrupt
configured, otherwise input GPIOs configured for level IRQs are
misdetected as output GPIOs.

Fixes: ebd6651418b6 ("pinctrl: ingenic: Implement .get_direction for GPIO chips")
Reported-by: João Henrique <johnnyonflame@hotmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200622214548.265417-2-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-ingenic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1644,7 +1644,8 @@ static int ingenic_gpio_get_direction(st
 	unsigned int pin = gc->base + offset;
 
 	if (jzpc->version >= ID_JZ4760)
-		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
+		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
+			ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
 
 	if (ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_SELECT))
 		return true;


