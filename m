Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D24158DDBE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245754AbiHISEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245235AbiHISEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9B827B00;
        Tue,  9 Aug 2022 11:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C50B7B8171A;
        Tue,  9 Aug 2022 18:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CBDC433D7;
        Tue,  9 Aug 2022 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068130;
        bh=ljrqwzOrbT0JrmQUw2UjpfLFC5dyyN3a2eOKGBHBJcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghxsZwWP2OvjZE5/0OmFLRotORYSlOaQLzejbNGtQPYH3FISyoQ8E6dZ9vR1Dzw+b
         K17t9H5dMltc7zVPrn4Xep6ErKkaaiJeUIq3Gd8YmRer3A4LP3Ve2kLUaz00ewhGXx
         RQXQzUtXPrchUN78lH+dUun6Qs6TmNYCROk28X5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 25/32] ARM: crypto: comment out gcc warning that breaks clang builds
Date:   Tue,  9 Aug 2022 20:00:16 +0200
Message-Id: <20220809175513.878882115@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The gcc build warning prevents all clang-built kernels from working
properly, so comment it out to fix the build.

This is a -stable kernel only patch for now, it will be resolved
differently in mainline releases in the future.

Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/lib/xor-neon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -29,8 +29,9 @@ MODULE_LICENSE("GPL");
  * While older versions of GCC do not generate incorrect code, they fail to
  * recognize the parallel nature of these functions, and emit plain ARM code,
  * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
+ *
+ * #warning This code requires at least version 4.6 of GCC
  */
-#warning This code requires at least version 4.6 of GCC
 #endif
 
 #pragma GCC diagnostic ignored "-Wunused-variable"


