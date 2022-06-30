Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC2561D3B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbiF3OGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236474AbiF3OFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F226EEA2;
        Thu, 30 Jun 2022 06:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C176210F;
        Thu, 30 Jun 2022 13:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6163EC34115;
        Thu, 30 Jun 2022 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597226;
        bh=B38O70NoaMcu4XQpJfrxymGHgtMsHJvKZHqlKigsZx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOCnsTJq0DHvO/x2wrtpPhmShPGn3srI4Rri7ABdPS9TDnTvJ4nTJGLSZmJ+oS6V1
         glEi9nfJJVk5VcLpsSnQeTfJgXu6BdMQ9bEb1LSl6iogg7KASVaz7r6PXXNZ2/DQIb
         LIpCVcgC/oHsvn+vaiz7DJQYK+jso6KH2EzE+9oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 10/16] crypto: arm/sha512-neon - avoid ADRL pseudo instruction
Date:   Thu, 30 Jun 2022 15:47:04 +0200
Message-Id: <20220630133231.243227230@linuxfoundation.org>
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

commit 0f5e8323777bfc1c1d2cba71242db6a361de03b6 upstream

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
 arch/arm/crypto/sha512-armv4.pl       |    4 ++--
 arch/arm/crypto/sha512-core.S_shipped |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/crypto/sha512-armv4.pl
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -212,7 +212,6 @@ $code=<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -602,7 +601,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	$len,$inp,$len,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	$Ktbl,K512
+	adr	$Ktbl,.Lsha512_block_data_order
+	sub	$Ktbl,$Ktbl,.Lsha512_block_data_order-K512
 	vldmia	$ctx,{$A-$H}		@ load context
 .Loop_neon:
 ___
--- a/arch/arm/crypto/sha512-core.S_shipped
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -79,7 +79,6 @@
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -543,7 +542,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	r3,K512
+	adr	r3,.Lsha512_block_data_order
+	sub	r3,r3,.Lsha512_block_data_order-K512
 	vldmia	r0,{d16-d23}		@ load context
 .Loop_neon:
 	vshr.u64	d24,d20,#14	@ 0


