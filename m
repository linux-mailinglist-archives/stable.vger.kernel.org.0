Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3CD56085F
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiF2SDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiF2SCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:02:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A8DFCF;
        Wed, 29 Jun 2022 11:02:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x138so13132359pfc.3;
        Wed, 29 Jun 2022 11:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8m1lytctefJudrhC62eHkDYEhgmvtWB/qfcXy6/Skb0=;
        b=Og3VmaHDVYdme9hpcGUXsB/YoBRyCbspqGz5cYDeQyxWJv12QFtuEWQirPqoQfKjaX
         QuyilfFE9G/sv9JaIylOLClgBubpxdV9/yZXFXXcNZH66qYXBP5uG0KbcmaCGNDCOqUU
         zgkXdiTQJPhOtg5jxhfjBkvU8/z+oVZfv8drCXetbzHZnQQErk+HBa74j7sGhqp8R/Km
         vQiqb1pykIDAkpdz/FJELVDwg4TBIAvcBgvrNT8Zp1EMRJWIZNsAikJPKjY7DqwsfyWs
         epF2QVxZBPzk4f2KOrLyONXZf392rLG52xmCjqJMQiOpoysYmxzkW2LYV0mRkuFIaMOr
         0hqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8m1lytctefJudrhC62eHkDYEhgmvtWB/qfcXy6/Skb0=;
        b=DXh4lRL72/gNAXzHpMtHAQ8Ql73m+VvlXSboUYyo6ohoU2R1bV74NjfgVxloiEWw0K
         mYacpQj7uXfhDh2XwVgJVwuekJ5ab7d8pDXSvWd/UJ3ZIThp4YX31opiri+TjSuHfB8x
         UD0RNr4Yglj2m++aswOCxY30USmgvk90DY/kVLgKo8yuQZMUvg4+pV+eOBYSdFk2mSLH
         CZNIFH4NWZWE1u0R9YuEzUKj8irw0xFbczgKeu6A0qJzSb0OLtOGKO9Xl4FHBF7W0dAd
         MShLtjAxtDeZf+eGiYgvXGelN7FgJiRnZEZ39G0YFqWcero9wVGhGunMmGYqtP06dX8v
         Z5Bg==
X-Gm-Message-State: AJIora8xbN92AAowZpn+NAqxp7vm1tWHQsYtgvNt+OpwEqmhSXVJVqRX
        2NFTiCFOc3B79pcNleIQ40lDzcXETR4=
X-Google-Smtp-Source: AGRyM1tVWGP61GpsjRkF+zlIx0GKOr26quUmb5y+nvydkxThM/bfBZLQF+0wLXNbHOyOzYt/11XQlA==
X-Received: by 2002:a63:82c6:0:b0:40d:c2d8:b910 with SMTP id w189-20020a6382c6000000b0040dc2d8b910mr3912728pgd.309.1656525765785;
        Wed, 29 Jun 2022 11:02:45 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
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
Subject: [PATCH stable 5.4 04/11] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
Date:   Wed, 29 Jun 2022 11:02:20 -0700
Message-Id: <20220629180227.3408104-5-f.fainelli@gmail.com>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 54781938ec342cadbe2d76669ef8d3294d909974 upstream

The ADRL pseudo instruction is not an architectural construct, but a
convenience macro that was supported by the ARM proprietary assembler
and adopted by binutils GAS as well, but only when assembling in 32-bit
ARM mode. Therefore, it can only be used in assembler code that is known
to assemble in ARM mode only, but as it turns out, the Clang assembler
does not implement ADRL at all, and so it is better to get rid of it
entirely.

So replace the ADRL instruction with a ADR instruction that refers to
a nearer symbol, and apply the delta explicitly using an additional
instruction.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/crypto/sha256-armv4.pl       | 4 ++--
 arch/arm/crypto/sha256-core.S_shipped | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
index a03cf4dfb781..d927483985c2 100644
--- a/arch/arm/crypto/sha256-armv4.pl
+++ b/arch/arm/crypto/sha256-armv4.pl
@@ -175,7 +175,6 @@ $code=<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -471,7 +470,8 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	$H,sp,#16*4+16
-	adrl	$Ktbl,K256
+	adr	$Ktbl,.Lsha256_block_data_order
+	sub	$Ktbl,$Ktbl,#.Lsha256_block_data_order-K256
 	bic	$H,$H,#15		@ align for 128-bit stores
 	mov	$t2,sp
 	mov	sp,$H			@ alloca
diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
index 054aae0edfce..9deb515f3c9f 100644
--- a/arch/arm/crypto/sha256-core.S_shipped
+++ b/arch/arm/crypto/sha256-core.S_shipped
@@ -56,7 +56,6 @@
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	r11,sp,#16*4+16
-	adrl	r14,K256
+	adr	r14,.Lsha256_block_data_order
+	sub	r14,r14,#.Lsha256_block_data_order-K256
 	bic	r11,r11,#15		@ align for 128-bit stores
 	mov	r12,sp
 	mov	sp,r11			@ alloca
-- 
2.25.1

