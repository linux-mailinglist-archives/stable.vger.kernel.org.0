Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12E6419AF6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhI0ROn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236855AbhI0RNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53126134F;
        Mon, 27 Sep 2021 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762548;
        bh=fRcENB0qZP/ddppHwMiZuA+VToJM6TbrZ90ysDDTiMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwTGgW5qEhtROtzT5OojfcsDjt3LJkaA9qtJRB638o5qCmP4mlPjP3K4W1ko6laeh
         JI80ztKlJQhlCc5TSI7Xv8NMbrVA13PFD0RqI9BTTihjT2VFX3Y7R99fw0CuxerjvF
         UnV9OhW2+KLYqAgEbATgVXeAzpzhPlUQrsQughyQ=
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
Subject: [PATCH 5.10 066/103] irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build
Date:   Mon, 27 Sep 2021 19:02:38 +0200
Message-Id: <20210927170228.063773529@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 6156a065681b..dc062e8c2caf 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -425,6 +425,7 @@ config MESON_IRQ_GPIO
 config GOLDFISH_PIC
        bool "Goldfish programmable interrupt controller"
        depends on MIPS && (GOLDFISH || COMPILE_TEST)
+       select GENERIC_IRQ_CHIP
        select IRQ_DOMAIN
        help
          Say yes here to enable Goldfish interrupt controller driver used
-- 
2.33.0



