Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6373A50
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391115AbfGXTsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403786AbfGXTsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:48:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA2D205C9;
        Wed, 24 Jul 2019 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997721;
        bh=l3GHEX0nPj43cBt8s7FvWGZ0sCIRvMVfzkJfOmztT6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzA0C/x9VHcmALyOtW+RvdV0V+d61Ses2w5Bo7C84pVu0RMg/Uw9r6useEYUbToPY
         uP7L/pbU5n3DDMaSD454ocgL7q4X0cK7OWxAXXeMf9C2PFGoQ97/95s0X+EJuJ1Q3M
         bewoVm6h+Jn3prC7J0SEfpU31fwTIODO+4j7EbYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 080/371] gpio: omap: fix lack of irqstatus_raw0 for OMAP4
Date:   Wed, 24 Jul 2019 21:17:12 +0200
Message-Id: <20190724191730.877749166@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
index fafd79438bbf..0708e50a27f0 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1728,6 +1728,8 @@ static struct omap_gpio_reg_offs omap4_gpio_regs = {
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



