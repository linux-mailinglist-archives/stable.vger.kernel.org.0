Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6311561D2A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiF3OFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiF3OFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77F16EE91;
        Thu, 30 Jun 2022 06:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9831061FF6;
        Thu, 30 Jun 2022 13:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C28BC34115;
        Thu, 30 Jun 2022 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597224;
        bh=RGsatybUy2IVoxQlTGrXAd1ewMgnrCmqFCingxAVs00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEII0HoQzYVzPc9gJ5EowZQicahnr/oxloswEQ3HOwaDVXbj0SHpPB5cSEoaXuRyt
         ijCdfBR/sbzO/9jT+JhSZ2UxGpZNJFd6OP9MWCOJW8UtcRp5QE2WISXo4BxnVJd3x3
         GVz8yCKBpPoQdgX1HxqMvfwRN4I4LHidBDm5sbL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 09/16] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
Date:   Thu, 30 Jun 2022 15:47:03 +0200
Message-Id: <20220630133231.213267670@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/sha256-armv4.pl       |    4 ++--
 arch/arm/crypto/sha256-core.S_shipped |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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


