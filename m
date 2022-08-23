Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA8659D971
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350940AbiHWJdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350344AbiHWJb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:31:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B4943E52;
        Tue, 23 Aug 2022 01:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 416A1B81C6B;
        Tue, 23 Aug 2022 08:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552E5C433C1;
        Tue, 23 Aug 2022 08:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243831;
        bh=ljrqwzOrbT0JrmQUw2UjpfLFC5dyyN3a2eOKGBHBJcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkcNuQtU1zq65TlSGZjzB+Y4xYOPQUMz6jM5u7r8HFlyDM/Mhih+q2pGciBE6C5Ct
         Hb0/A644C3is/CmTxdSncEdblduoSXpHD5wvXhJEZ6bGQenaHYOJZm/7MreTx0OgPw
         mcX+nOuBug1J9f+EFs8ksnbPdaaEpR4QdbuWWcak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.14 008/229] ARM: crypto: comment out gcc warning that breaks clang builds
Date:   Tue, 23 Aug 2022 10:22:49 +0200
Message-Id: <20220823080053.626188301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


