Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3E0560881
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiF2SDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbiF2SDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:07 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A26E3DDD8;
        Wed, 29 Jun 2022 11:02:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c205so15804531pfc.7;
        Wed, 29 Jun 2022 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NCbkwfST1EQqulPTwFVqWpX4uMmlgqEO2U6UjuOGwso=;
        b=YKDOtf++A64rAVrVFx8NdAm9CPO5DYjkBnjACHPZkLYas/A1mEPR+SA3nNj512DG1b
         MLORcyl1RCV3xbFiH2FsoHImVaEEfVo45wnWKb38aLRVOylYB8UgEvAJT0Ycdg8g+tCF
         xtsWSpgTUcGcGz1OCyVorDa8TvQ4KM57y0n1tFOmtgmee6QdPoxjy5kGiVqYUTfKViQp
         5vOeB07Wcl8OIkPb3yR3uvdLg/5TZ0dAuiLoo6tQfjDzFPrQK2JpU3nM6YG4PJEz3yDM
         Xqw1fT4wgoOwwTMIwI+o84Q7WY6yhJxJ9dl539WRSX4LC6+RHOG64o2Zsh5yWuI7Q0no
         hGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NCbkwfST1EQqulPTwFVqWpX4uMmlgqEO2U6UjuOGwso=;
        b=ic95jazPeo8tZSDmxKcHj8dWVOZiU46nF/ZGflbMLgwF0SlQFOSOrQZXWkhWyzZbMV
         ETJcyGAZL2fKbgkaxgy4VZU9yZdtYvInvDWRX6sbKU6PpMxT8dE2y53rFAIV14UsCmk9
         6wzY9cvvijnK0SYqN4Q/5wpc46jREHQhJx9MGv4x2PXJtgTKxSzcZk4uyfRQVwQW/dMS
         RlbnbBjOR/HJTYFIUY5w16qdNKSfvy5BIZNAESZJz0ejIYE0uy6Z3rUxN5mBWpSB62f+
         UbkRWRjYhykpCrYEplmxkk/zrPH20MWXQsGvh6/yfzcxHEkRhHOBhx0AI+HSla6L/a1E
         SPkA==
X-Gm-Message-State: AJIora/MZuD/+4YiD2oOP2AjnKu7RjRq5AxeBQwUMap0sGV/apIUbDch
        4RlLy+opN2JYe6V1XaCaeXvyY7O0Ruc=
X-Google-Smtp-Source: AGRyM1uvOmxs69ST+tUZ10d/BtTfrRpBvbiJBh7vwQHCfCWRcquhtkTkiuRCz7bjnP0yAW064EBpOA==
X-Received: by 2002:a05:6a00:80d:b0:525:b61f:6df2 with SMTP id m13-20020a056a00080d00b00525b61f6df2mr10331146pfk.66.1656525773326;
        Wed, 29 Jun 2022 11:02:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>, Tony Lindgren <tony@atomide.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <caij2003@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-omap@vger.kernel.org (open list:OMAP2+ SUPPORT),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.4 08/11] ARM: OMAP2+: drop unnecessary adrl
Date:   Wed, 29 Jun 2022 11:02:24 -0700
Message-Id: <20220629180227.3408104-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629180227.3408104-1-f.fainelli@gmail.com>
References: <20220629180227.3408104-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

commit d85d5247885ef2e8192287b895c2e381fa931b0b upstream

The adrl instruction has been introduced with commit dd31394779aa ("ARM:
omap3: Thumb-2 compatibility for sleep34xx.S"), back when this assembly
file was considerably longer. Today adr seems to have enough reach, even
when inserting about 60 instructions between the use site and the label.
Replace adrl with conventional adr instruction.

This allows to build this file using Clang's integrated assembler (which
does not support the adrl pseudo instruction).

Link: https://github.com/ClangBuiltLinux/linux/issues/430
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/mach-omap2/sleep34xx.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/sleep34xx.S b/arch/arm/mach-omap2/sleep34xx.S
index ac1324c6453b..c4e97d35c310 100644
--- a/arch/arm/mach-omap2/sleep34xx.S
+++ b/arch/arm/mach-omap2/sleep34xx.S
@@ -72,7 +72,7 @@ ENTRY(enable_omap3630_toggle_l2_on_restore)
 	stmfd	sp!, {lr}	@ save registers on stack
 	/* Setup so that we will disable and enable l2 */
 	mov	r1, #0x1
-	adrl	r3, l2dis_3630_offset	@ may be too distant for plain adr
+	adr	r3, l2dis_3630_offset
 	ldr	r2, [r3]		@ value for offset
 	str	r1, [r2, r3]		@ write to l2dis_3630
 	ldmfd	sp!, {pc}	@ restore regs and return
-- 
2.25.1

