Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008E411910B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 20:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfLJTw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 14:52:59 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:48441 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 14:52:58 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MTikV-1iAh0D2xMz-00U0Gz; Tue, 10 Dec 2019 20:52:04 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Sekhar Nori <nsekhar@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: davinci: select CONFIG_RESET_CONTROLLER
Date:   Tue, 10 Dec 2019 20:51:44 +0100
Message-Id: <20191210195202.622734-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:yzlNRh3NNg4yi3/+SOu84vzqxuE3ALqmc8SzWN8n/eF/oFv9jH3
 pXUf0p+Robr0Mvi0Z5VXk60Q11HWX/ycX9tpw5EN7RlgBnPljnqSjSd+u2UdlVBpdR1xPG3
 dsLC+Dw5cG2sUwDhXndzdJRu2JJhpkp2uOJxSdmuxVZZFUoKZGazSdi525M5KidPgSPCFvi
 QIV4ktU1sNBtL7IVARytA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nkkoiZh+DM8=:HiMiLl6p7f68ae705iW+WW
 /+K5vhIuXifxSPnLe8u2pTUoZL61HepdIzROtYD+VGqOK16vjoxCRfLOyjD8/UWskFA6N4DDC
 cBTKWyP0TLZoZohKUcjDF1uj07cGjE88fDdmdA9G8N5Vfg5iQUU2OcDbTeZRmZ4cj6Q2kXRVu
 CG91KwO/mNFaIZrcFGhI+MsL8lrciilwEzX/ayTAf9jx3aR8QO0CgSnL4OhygxjN6ZXIXvIhv
 ZZ5gfXPk14E3wZQ5iQ/Lw+ocrbT3WaUwT2uX5QrgyNLk5bbacd89kD0ap6l/nW956g7lmMbx0
 OmYZWnDp/f3aKJzs8AHAK46+0v6KqR8rxScuD2y/yACg71oLqzKH8JYJZmIQZuBzvmFuadkW6
 aivmTH6ZYsOxGmjGDcgrKDQJUnAbxsTz1vcpiPpVHQVm89R4FFXqiQ1G7FBnrEDSKTeps3dgN
 Bnlhf4DXGlLI3/VNjHgmOA2+WrQ5vUZdctWq45f1sguM1SUAEIXWBK2RM6MNmJziV6VFVsVFe
 +CctwO6vX8nzbpbMtFP4/MnUs8Vz5oB8qeJqpJ5StboXEdRJEO7h1+JQjGx3HImT6RT+7TUOF
 bxG/5/2mmE0sPCiE1UP7rC6ZJT2rDjXHBKmlrYISXKFneXcuwzKbU+RC5Y6PyZNVjaBh7W0SN
 xQRKPNsEnGnhZwOx0SdF0v7d/pmr848lP1StNa+YAc3ycQtWPdmY5b/Kxi/kIqMFR6OuhEbRn
 J4wqUtJOz9KKy5YcL57Z+d/WTlubpqhCfHNXt4yiyX2eqBFNX8L2xJZkWhYD+lIZwU8B5iQ6v
 5HsJ3qdXA5htkt8CD1+rh02KI9u30r7CXPQMXFCHLL4KaKl3/zQIJvJ7NLrxfhyEF0FYbnQJw
 q+ACtPYVeVTWNIx4eAdQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Selecting RESET_CONTROLLER is actually required, otherwise we
can get a link failure in the clock driver:

drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
psc-da850.c:(.text+0x24): undefined reference to `reset_controller_add_lookup'

Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index dd427bd2768c..02b180ad7245 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -9,6 +9,7 @@ menuconfig ARCH_DAVINCI
 	select PM_GENERIC_DOMAINS if PM
 	select PM_GENERIC_DOMAINS_OF if PM && OF
 	select REGMAP_MMIO
+	select RESET_CONTROLLER
 	select HAVE_IDE
 	select PINCTRL_SINGLE
 
-- 
2.20.0

