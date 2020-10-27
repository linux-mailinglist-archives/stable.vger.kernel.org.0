Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767E629C08E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818018AbgJ0RQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781527AbgJ0Ozs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:55:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F262071A;
        Tue, 27 Oct 2020 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810547;
        bh=mK95Y5EpJLO5QnvBvmW3V/40l56fS/jzkZVuuRNb4VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkV83U4AuYCHr8raPeMjx5myHX7nsJeZLipGtDQjpAhi8buD5RUmTsW+akUs2Oq13
         oQhqeNKJkt5j+5Lgq4IPqFFHGoCrJnYxASnD/FA8TjDz6SqQEvYek18nm3EYmQZqw8
         rq9s2QGby7RGGkoofn0UlG9LW51cxZvIeYCGfjqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 146/633] pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB
Date:   Tue, 27 Oct 2020 14:48:09 +0100
Message-Id: <20201027135529.541903479@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 513034d8b089b9a49dab57845aee70e830fe7334 ]

When PINCTRL_BCM2835 is enabled and GPIOLIB is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for GPIOLIB_IRQCHIP
  Depends on [n]: GPIOLIB [=n]
  Selected by [y]:
  - PINCTRL_BCM2835 [=y] && PINCTRL [=y] && OF [=y] && (ARCH_BCM2835 [=n] || ARCH_BRCMSTB [=n] || COMPILE_TEST [=y])

The reason is that PINCTRL_BCM2835 selects GPIOLIB_IRQCHIP without
depending on or selecting GPIOLIB while GPIOLIB_IRQCHIP is subordinate to
GPIOLIB.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: 85ae9e512f43 ("pinctrl: bcm2835: switch to GPIOLIB_IRQCHIP")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://lore.kernel.org/r/20200914144025.371370-1-fazilyildiran@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index dcf7df797af75..0ed14de0134cf 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -23,6 +23,7 @@ config PINCTRL_BCM2835
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	default ARCH_BCM2835 || ARCH_BRCMSTB
 	help
-- 
2.25.1



