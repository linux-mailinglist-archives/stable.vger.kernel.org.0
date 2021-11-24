Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D934045C540
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353030AbhKXNzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352030AbhKXNwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F1E63273;
        Wed, 24 Nov 2021 13:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759113;
        bh=29GL2qkkrAhf/3tt4guf60qRp+JD6OnSf+PZGy3yaPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eQWaa09PKuYWynV81J+sHi1Tgg/g/LCV/gCHUX/eKozRhYLLg0/TWj0WdtHh7vPZ
         i9i7ZrpeN7ANuULWqeFyMIBKzzB7Lz3aOPmYYfnHCVlV7vF3fs/f84c3rTBeOw5hFu
         trW5PEyENUwHgjAp/ZOsMJvn/ZIKcStYs3gNjgj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/279] gpio: rockchip: needs GENERIC_IRQ_CHIP to fix build errors
Date:   Wed, 24 Nov 2021 12:57:04 +0100
Message-Id: <20211124115723.522271135@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d6912b1251b47e6b04ea8c8881dfb35a6e7a3e29 ]

gpio-rockchip uses interfaces that are provided by the Kconfig
symbol GENERIC_IRQ_CHIP, so the driver should select that symbol
in order to prevent build errors.

Fixes these build errors (and more):

aarch64-linux-ld: drivers/gpio/gpio-rockchip.o: in function `rockchip_irq_disable':
gpio-rockchip.c:(.text+0x454): undefined reference to `irq_gc_mask_set_bit'
aarch64-linux-ld: drivers/gpio/gpio-rockchip.o: in function `rockchip_irq_enable':
gpio-rockchip.c:(.text+0x478): undefined reference to `irq_gc_mask_clr_bit'
aarch64-linux-ld: drivers/gpio/gpio-rockchip.o: in function `rockchip_interrupts_register':
gpio-rockchip.c:(.text+0x518): undefined reference to `irq_generic_chip_ops'
aarch64-linux-ld: gpio-rockchip.c:(.text+0x594): undefined reference to `__irq_alloc_domain_generic_chips'
aarch64-linux-ld: gpio-rockchip.c:(.text+0x5cc): undefined reference to `irq_get_domain_generic_chip'
aarch64-linux-ld: gpio-rockchip.c:(.text+0x5e0): undefined reference to `irq_gc_ack_set_bit'
aarch64-linux-ld: gpio-rockchip.c:(.text+0x604): undefined reference to `irq_gc_set_wake'

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index fae5141251e5d..947474f6abb45 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -523,6 +523,7 @@ config GPIO_REG
 config GPIO_ROCKCHIP
 	tristate "Rockchip GPIO support"
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
+	select GENERIC_IRQ_CHIP
 	select GPIOLIB_IRQCHIP
 	default ARCH_ROCKCHIP
 	help
-- 
2.33.0



