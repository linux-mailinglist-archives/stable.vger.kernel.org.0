Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6B24BFC9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgHTNyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgHTJ0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:26:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD11B22D08;
        Thu, 20 Aug 2020 09:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915553;
        bh=yr1SDa0zPqE6iEOJH7QLxriE/fB8TR/45ppC0A2ud4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIKo5Xwac6JH60PHEUXHNHhd4krhtFo4gMMnof1qG9Dzfkb294BkTLEEkQ/jNDCkJ
         ltFomKv43EtJjjkxGBO3TTsqTP/t9KO+3dFoM6SoMedLwMe1HbYd35k3Z/a68wqnnp
         hJIFzWH063AgfJa7f7ITEeKXf+WH3xBQzIRCq238=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Henrique?= <johnnyonflame@hotmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.8 054/232] pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ
Date:   Thu, 20 Aug 2020 11:18:25 +0200
Message-Id: <20200820091615.399471310@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
@@ -1955,7 +1955,8 @@ static int ingenic_gpio_get_direction(st
 	unsigned int pin = gc->base + offset;
 
 	if (jzpc->info->version >= ID_JZ4760) {
-		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
+		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
+		    ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
 			return GPIO_LINE_DIRECTION_IN;
 		return GPIO_LINE_DIRECTION_OUT;
 	}


