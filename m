Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7936029C49E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901154AbgJ0OTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901147AbgJ0OTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:19:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835BE206D4;
        Tue, 27 Oct 2020 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808364;
        bh=sVN485f9iDZkXWHNKQP9Tfqd7hOBI6itlBWUSWO1K1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4e5QM6umrhyVHU06raJ4/KQRZ0kwE98TXPeD1eEaUOyQ05rcXxwAlJQmkg1KJujF
         lD33rvAgateOmLw5QeyZgIrMDGCvZwG0CdE+f8B9xlson8iHtPHy7Q3B68KFlAO/8h
         xczs6HJBWjaoEjG+gEzPbYt2VHWsgBgO69dqEOR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/264] pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB
Date:   Tue, 27 Oct 2020 14:52:01 +0100
Message-Id: <20201027135433.639616267@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 0f38d51f47c64..e6cd314919de1 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -21,6 +21,7 @@ config PINCTRL_BCM2835
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 
 config PINCTRL_IPROC_GPIO
-- 
2.25.1



