Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718796357E6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbiKWJsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiKWJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:47:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A632A7A372
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E9E61B6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36921C433D6;
        Wed, 23 Nov 2022 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196677;
        bh=O+h9eiuiF/bQT9jCuum9Jsyz+WcjeH64eEWEtB902Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOrRIRbPEreJf6DQYiyVqT34FronuH4PEyBPgYDctN5xhGiKYBL6iODANVhiQpBbM
         9wT7rD8R2z51KwVNhUocUEvhQrjhrw7kcrLbvnJkuwf+G634sNdFNVu++WSVmLSiCD
         TJz2XGtqpMkP18YFAc/GZqFyrAZyBPBU4/iRCx9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 094/314] ARM: at91: pm: avoid soft resetting AC DLL
Date:   Wed, 23 Nov 2022 09:48:59 +0100
Message-Id: <20221123084629.757876388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit cef8cdc0d0e7c701fe4dcfba4ed3fd25d28a6020 ]

Do not soft reset AC DLL as controller is buggy and this operation my
introduce glitches in the controller leading to undefined behavior.

Fixes: f0bbf17958e8 ("ARM: at91: pm: add self-refresh support for sama7g5")
Depends-on: a02875c4cbd6 ("ARM: at91: pm: fix self-refresh for sama7g5")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221026124114.985876-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 7 ++++++-
 include/soc/at91/sama7-ddr.h    | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index ffed4d949042..e4904faf1753 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -169,10 +169,15 @@ sr_ena_2:
 	cmp	tmp1, #UDDRC_STAT_SELFREF_TYPE_SW
 	bne	sr_ena_2
 
-	/* Put DDR PHY's DLL in bypass mode for non-backup modes. */
+	/* Disable DX DLLs for non-backup modes. */
 	cmp	r7, #AT91_PM_BACKUP
 	beq	sr_ena_3
 
+	/* Do not soft reset the AC DLL. */
+	ldr	tmp1, [r3, DDR3PHY_ACDLLCR]
+	bic	tmp1, tmp1, DDR3PHY_ACDLLCR_DLLSRST
+	str	tmp1, [r3, DDR3PHY_ACDLLCR]
+
 	/* Disable DX DLLs. */
 	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
 	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index 6ce3bd22f6c6..5ad7ac2e3a7c 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -26,7 +26,10 @@
 #define	DDR3PHY_PGSR				(0x0C)		/* DDR3PHY PHY General Status Register */
 #define		DDR3PHY_PGSR_IDONE		(1 << 0)	/* Initialization Done */
 
-#define DDR3PHY_ACIOCR				(0x24)		/*  DDR3PHY AC I/O Configuration Register */
+#define	DDR3PHY_ACDLLCR				(0x14)		/* DDR3PHY AC DLL Control Register */
+#define		DDR3PHY_ACDLLCR_DLLSRST		(1 << 30)	/* DLL Soft Reset */
+
+#define DDR3PHY_ACIOCR				(0x24)		/* DDR3PHY AC I/O Configuration Register */
 #define		DDR3PHY_ACIOCR_CSPDD_CS0	(1 << 18)	/* CS#[0] Power Down Driver */
 #define		DDR3PHY_ACIOCR_CKPDD_CK0	(1 << 8)	/* CK[0] Power Down Driver */
 #define		DDR3PHY_ACIORC_ACPDD		(1 << 3)	/* AC Power Down Driver */
-- 
2.35.1



