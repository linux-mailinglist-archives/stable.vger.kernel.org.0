Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB60505791
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbiDRNvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiDRNty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:49:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8301434B1;
        Mon, 18 Apr 2022 06:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E3DE60B3C;
        Mon, 18 Apr 2022 13:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E116C385A7;
        Mon, 18 Apr 2022 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286904;
        bh=zMLP5TNIBiQ355nvXboytYzyDZtwOuVe7iSxgjN8PE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oo9197C7XejWPwZQETt1jGVZcA7yCYq4+xt7H2ly51dRPGIFuHGwiTHoYJmacpp78
         N1j3Kcm+mSLXjQw0B2F22uJfxsakEK0Lt2CXz6/hbSHoU4ceC391UJZo6vK75Fgw8A
         bl8Gt6MlIbXKz2HJObAAJgPv2KL5LEKRxN8g1gzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 4.14 282/284] ARM: davinci: da850-evm: Avoid NULL pointer dereference
Date:   Mon, 18 Apr 2022 14:14:23 +0200
Message-Id: <20220418121221.236242740@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 83a1cde5c74bfb44b49cb2a940d044bb2380f4ea upstream.

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

Fixes: bae105879f2f ("davinci: DA850/OMAP-L138 EVM: implement autodetect of RMII PHY")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/YcS4xVWs6bQlQSPC@archlinux-ax161/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-davinci/board-da850-evm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1035,11 +1035,13 @@ static int __init da850_evm_config_emac(
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


