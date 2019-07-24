Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBA273BD2
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392316AbfGXUDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392411AbfGXUDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A01D6206BA;
        Wed, 24 Jul 2019 20:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998633;
        bh=hysILLiMFNV30I4LobGeU/j6HhW22UqMhZCInxUglhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTpSKhfWK3QibrC3TPlqjXQaYXJYek+G5QwVJSYzvY6NXy3pL/iuO2Eh/onxypK27
         0qk8WGkXPdWa3002i/RZ0E2gQOUW4BFTrhoWNQ9gQS/VKcL7XP+VRS0JLLsV3H0CKJ
         WJNKl+NK2IDVpqJsRjn1jVdce3Fj5JloX8v+72q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/271] gpio: omap: fix lack of irqstatus_raw0 for OMAP4
Date:   Wed, 24 Jul 2019 21:18:50 +0200
Message-Id: <20190724191700.414102486@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 64ea3e9094a1f13b96c33244a3fb3a0f45690bd2 ]

Commit 384ebe1c2849 ("gpio/omap: Add DT support to GPIO driver") added
the register definition tables to the gpio-omap driver. Subsequently to
that commit, commit 4e962e8998cc ("gpio/omap: remove cpu_is_omapxxxx()
checks from *_runtime_resume()") added definitions for irqstatus_raw*
registers to the legacy OMAP4 definitions, but missed the DT
definitions.

This causes an unintentional change of behaviour for the 1.101 errata
workaround on OMAP4 platforms. Fix this oversight.

Fixes: 4e962e8998cc ("gpio/omap: remove cpu_is_omapxxxx() checks from *_runtime_resume()")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 6fa430d98517..9254bcf7f647 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1687,6 +1687,8 @@ static struct omap_gpio_reg_offs omap4_gpio_regs = {
 	.clr_dataout =		OMAP4_GPIO_CLEARDATAOUT,
 	.irqstatus =		OMAP4_GPIO_IRQSTATUS0,
 	.irqstatus2 =		OMAP4_GPIO_IRQSTATUS1,
+	.irqstatus_raw0 =	OMAP4_GPIO_IRQSTATUSRAW0,
+	.irqstatus_raw1 =	OMAP4_GPIO_IRQSTATUSRAW1,
 	.irqenable =		OMAP4_GPIO_IRQSTATUSSET0,
 	.irqenable2 =		OMAP4_GPIO_IRQSTATUSSET1,
 	.set_irqenable =	OMAP4_GPIO_IRQSTATUSSET0,
-- 
2.20.1



