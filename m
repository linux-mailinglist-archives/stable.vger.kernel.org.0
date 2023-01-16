Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFACC66C8CD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjAPQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjAPQmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:42:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0FC30B03
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 190FF6108B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD96C433F0;
        Mon, 16 Jan 2023 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886632;
        bh=sDwQr0Wn1l01rcLgMrwtjowdjVfEvBNikKRTBJ+29/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/gU4P8g718x8L18Ke/toLJRVccLTX42wHU2bVVbDiLs12RzZxMRZQqrKQ4fWsFSr
         qgECXEj0KSEMk5Xinqg8gpIzDQkm3+uHbqacZSe1MkqVplW5DMV2LWF0TJ/XY6smXh
         pzj3MMd+Y4S7/91IM8QuAgd6VNcMn2lGlx8jrlx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 503/658] ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod
Date:   Mon, 16 Jan 2023 16:49:51 +0100
Message-Id: <20230116154932.519923439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Nick Desaulniers <ndesaulniers@google.com>

commit 3220022038b9a3845eea762af85f1c5694b9f861 upstream.

clang-15's ability to elide loops completely became more aggressive when
it can deduce how a variable is being updated in a loop. Counting down
one variable by an increment of another can be replaced by a modulo
operation.

For 64b variables on 32b ARM EABI targets, this can result in the
compiler generating calls to __aeabi_uldivmod, which it does for a do
while loop in float64_rem().

For the kernel, we'd generally prefer that developers not open code 64b
division via binary / operators and instead use the more explicit
helpers from div64.h. On arm-linux-gnuabi targets, failure to do so can
result in linkage failures due to undefined references to
__aeabi_uldivmod().

While developers can avoid open coding divisions on 64b variables, the
compiler doesn't know that the Linux kernel has a partial implementation
of a compiler runtime (--rtlib) to enforce this convention.

It's also undecidable for the compiler whether the code in question
would be faster to execute the loop vs elide it and do the 64b division.

While I actively avoid using the internal -mllvm command line flags, I
think we get better code than using barrier() here, which will force
reloads+spills in the loop for all toolchains.

Link: https://github.com/ClangBuiltLinux/linux/issues/1666

Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/nwfpe/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/nwfpe/Makefile
+++ b/arch/arm/nwfpe/Makefile
@@ -11,3 +11,9 @@ nwfpe-y				+= fpa11.o fpa11_cpdo.o fpa11
 				   entry.o
 
 nwfpe-$(CONFIG_FPE_NWFPE_XP)	+= extended_cpdo.o
+
+# Try really hard to avoid generating calls to __aeabi_uldivmod() from
+# float64_rem() due to loop elision.
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_softfloat.o	+= -mllvm -replexitval=never
+endif


