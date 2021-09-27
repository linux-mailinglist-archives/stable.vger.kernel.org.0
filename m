Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F8419A33
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhI0RHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235924AbhI0RGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFBB61074;
        Mon, 27 Sep 2021 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762309;
        bh=U30YJd7BTgpQPcWwUafMYEhktGwd7LpVWgvoTRGvjkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP7thwhtyKReK+hnIOTDE15MvxwO6ck05HSM1MWu2gxS/yPMdPfo8xxvtqRvjN7SS
         mR41ctJpkN/PTpgsHMeH8Ki2+ENd9Bt5GeemjspfZJ9MqIJjAUvqCmekSrmF52vDvU
         dvH4UHjuAS4+aTmzezX1en7NKczwku1HUSJUW5FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Miodrag Dinic <miodrag.dinic@mips.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Goran Ferenc <goran.ferenc@mips.com>,
        Aleksandar Markovic <aleksandar.markovic@mips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/68] irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build
Date:   Mon, 27 Sep 2021 19:02:38 +0200
Message-Id: <20210927170221.419004878@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 969ac78db78c723a24e9410666b457cc1b0cb3c3 ]

irq-goldfish-pic uses GENERIC_IRQ_CHIP interfaces so select that symbol
to fix build errors.

Fixes these build errors:

mips-linux-ld: drivers/irqchip/irq-goldfish-pic.o: in function `goldfish_pic_of_init':
irq-goldfish-pic.c:(.init.text+0xc0): undefined reference to `irq_alloc_generic_chip'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0xf4): undefined reference to `irq_gc_unmask_enable_reg'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0xf8): undefined reference to `irq_gc_unmask_enable_reg'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0x100): undefined reference to `irq_gc_mask_disable_reg'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0x104): undefined reference to `irq_gc_mask_disable_reg'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0x11c): undefined reference to `irq_setup_generic_chip'
mips-linux-ld: irq-goldfish-pic.c:(.init.text+0x168): undefined reference to `irq_remove_generic_chip'

Fixes: 4235ff50cf98 ("irqchip/irq-goldfish-pic: Add Goldfish PIC driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Miodrag Dinic <miodrag.dinic@mips.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Goran Ferenc <goran.ferenc@mips.com>
Cc: Aleksandar Markovic <aleksandar.markovic@mips.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210905162519.21507-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 97f9c001d8ff..20f44ef9c4c9 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -415,6 +415,7 @@ config MESON_IRQ_GPIO
 config GOLDFISH_PIC
        bool "Goldfish programmable interrupt controller"
        depends on MIPS && (GOLDFISH || COMPILE_TEST)
+       select GENERIC_IRQ_CHIP
        select IRQ_DOMAIN
        help
          Say yes here to enable Goldfish interrupt controller driver used
-- 
2.33.0



