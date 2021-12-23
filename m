Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0410647E945
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 23:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245286AbhLWWWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 17:22:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48390 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhLWWWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 17:22:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6DFAB82218;
        Thu, 23 Dec 2021 22:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30437C36AE5;
        Thu, 23 Dec 2021 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640298122;
        bh=UxoJa3uQnvxGZMIg6OiN0I0O5ZfIJYWcZNx7h6H53CM=;
        h=From:To:Cc:Subject:Date:From;
        b=gvcIZgp1w4b70jBT6xQhf1FtELSTyqzhPA0uszhahayD0lWs95U4D3+nsK1t9nNhW
         s5H/dhNELRQdRVj7O9Sc7AD+spZlpNQGrpv0orvXDI+BMnUJPzG8KiTd6+9kJ+wg7/
         F7Tv1U0TeOvRb0sy1Vm/SaT72LXJKY4W9QRars3QgReSKVqJB4oYNSdCg5aR5/yeuD
         d4IIh2HYI4kzL31QquxqOBddA0JC0QQNvadkeTryVKrID85ahP/W2/jPJkzO1gCiCG
         +55DAVNevrAtdmJMMlwRAWdtgCbW/S1fy/m7goFojt3ZgOlI0el3YlP/u5O0Z4pbRw
         GTMyzFV2YfMLQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sekhar Nori <nsekhar@ti.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ARM: davinci: da850-evm: Avoid NULL pointer dereference
Date:   Thu, 23 Dec 2021 15:21:41 -0700
Message-Id: <20211223222141.1253092-1-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With newer versions of GCC, there is a panic in da850_evm_config_emac()
when booting multi_v5_defconfig in QEMU under the palmetto-bmc machine:

Unable to handle kernel NULL pointer dereference at virtual address 00000020
pgd = (ptrval)
[00000020] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.15.0 #1
Hardware name: Generic DT based system
PC is at da850_evm_config_emac+0x1c/0x120
LR is at do_one_initcall+0x50/0x1e0

The emac_pdata pointer in soc_info is NULL because davinci_soc_info only
gets populated on davinci machines but da850_evm_config_emac() is called
on all machines via device_initcall().

Move the rmii_en assignment below the machine check so that it is only
dereferenced when running on a supported SoC.

Cc: stable@vger.kernel.org
Fixes: bae105879f2f ("davinci: DA850/OMAP-L138 EVM: implement autodetect of RMII PHY")
Link: https://lore.kernel.org/r/YcS4xVWs6bQlQSPC@archlinux-ax161/
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm/mach-davinci/board-da850-evm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 428012687a80..7f7f6bae21c2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1101,11 +1101,13 @@ static int __init da850_evm_config_emac(void)
 	int ret;
 	u32 val;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	u8 rmii_en = soc_info->emac_pdata->rmii_en;
+	u8 rmii_en;
 
 	if (!machine_is_davinci_da850_evm())
 		return 0;
 
+	rmii_en = soc_info->emac_pdata->rmii_en;
+
 	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
 
 	val = __raw_readl(cfg_chip3_base);

base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
-- 
2.34.1

