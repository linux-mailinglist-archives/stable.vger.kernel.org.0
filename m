Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0671561CF3
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiF3OEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbiF3OEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A436B805;
        Thu, 30 Jun 2022 06:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63F9A6210F;
        Thu, 30 Jun 2022 13:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F075C34115;
        Thu, 30 Jun 2022 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597204;
        bh=B6o1vVJE8G5b1r5QxOa5AGOqbLfmPxyGA5Nfo4bviAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3PiiUwyCwYRsMx3/hAjCT5nTaL8eMJKzbJWicGNPkp4omWvzefOsSOVUQbu2yCY4
         9tIo158o7YQ2Ve7bb5MPs6eQokI9wbJQi34+GyUsVY9mNrIqxiJLs1bmJgnuPFBbcJ
         NUrZlBV9lqVufHkOmEwPkkkRFXRxc2nt0xUBze9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Agner <stefan@agner.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 16/16] crypto: arm/ghash-ce - define fpu before fpu registers are referenced
Date:   Thu, 30 Jun 2022 15:47:10 +0200
Message-Id: <20220630133231.416143558@linuxfoundation.org>
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

From: Stefan Agner <stefan@agner.ch>

commit 7548bf8c17d84607c106bd45d81834afd95a2edb upstream

Building ARMv7 with Clang's integrated assembler leads to errors such
as:
arch/arm/crypto/ghash-ce-core.S:34:11: error: register name expected
 t3l .req d16
          ^

Since no FPU has selected yet Clang considers d16 not a valid register.
Moving the FPU directive on-top allows Clang to parse the registers and
allows to successfully build this file with Clang's integrated assembler.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/ghash-ce-core.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -8,6 +8,9 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
+	.arch		armv8-a
+	.fpu		crypto-neon-fp-armv8
+
 	SHASH		.req	q0
 	T1		.req	q1
 	XL		.req	q2
@@ -88,8 +91,6 @@
 	T3_H		.req	d17
 
 	.text
-	.arch		armv8-a
-	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
 	vmull.p64	\rd, \rn, \rm


