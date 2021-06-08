Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47003A03DD
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhFHTWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236719AbhFHTTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13F16197E;
        Tue,  8 Jun 2021 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178332;
        bh=bjayC/n86ZXi4aIJto0xq4nLfZ8YEKcpop3tqEa+Coo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crIv1icAsceKXFmjiIt2YigAYd6+zKNPflfa5TWlM3dupUd69er3JIiOBJNI8OcPo
         Rz0cLST/PUSpMu1FJBXjTT00JU0M3/LINNqLixy3BeewomtL++Xpk2K5hxIqq0v5jh
         81C5YnLAV5KfqgLFkxHzuZDeC/hT2IPPVyctJHJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Falkowski <maciej.falkowski9@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.12 156/161] ARM: OMAP1: isp1301-omap: Add missing gpiod_add_lookup_table function
Date:   Tue,  8 Jun 2021 20:28:06 +0200
Message-Id: <20210608175950.733646511@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Falkowski <maciej.falkowski9@gmail.com>

commit 7c302314f37b44595f180198fca5ca646bce4a5f upstream.

The gpiod table was added without any usage making it unused
as reported by Clang compilation from omap1_defconfig on linux-next:

arch/arm/mach-omap1/board-h2.c:347:34: warning: unused variable
'isp1301_gpiod_table' [-Wunused-variable]
static struct gpiod_lookup_table isp1301_gpiod_table = {
                                 ^
1 warning generated.

The patch adds the missing gpiod_add_lookup_table() function.

Signed-off-by: Maciej Falkowski <maciej.falkowski9@gmail.com>
Fixes: f3ef38160e3d ("usb: isp1301-omap: Convert to use GPIO descriptors")
Link: https://github.com/ClangBuiltLinux/linux/issues/1325
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap1/board-h2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -320,7 +320,7 @@ static int tps_setup(struct i2c_client *
 {
 	if (!IS_BUILTIN(CONFIG_TPS65010))
 		return -ENOSYS;
-	
+
 	tps65010_config_vregs1(TPS_LDO2_ENABLE | TPS_VLDO2_3_0V |
 				TPS_LDO1_ENABLE | TPS_VLDO1_3_0V);
 
@@ -394,6 +394,8 @@ static void __init h2_init(void)
 	BUG_ON(gpio_request(H2_NAND_RB_GPIO_PIN, "NAND ready") < 0);
 	gpio_direction_input(H2_NAND_RB_GPIO_PIN);
 
+	gpiod_add_lookup_table(&isp1301_gpiod_table);
+
 	omap_cfg_reg(L3_1610_FLASH_CS2B_OE);
 	omap_cfg_reg(M8_1610_FLASH_CS2B_WE);
 


