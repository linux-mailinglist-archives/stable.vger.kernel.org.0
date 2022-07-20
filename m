Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA06857AC02
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiGTBQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240232AbiGTBQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:16:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE666BB2;
        Tue, 19 Jul 2022 18:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C937A61730;
        Wed, 20 Jul 2022 01:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B2FC341CA;
        Wed, 20 Jul 2022 01:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279629;
        bh=Egh1VQkfVR4hJgKeZ5W7DzXJ/JKfm5QXE9/VNfb2h8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXqDN+8Ml6sK3TicEaLcu23QfIgsaBen0PZqbba2+SMWJXgT+KjcoueWrd1h2c9Q8
         ezWyyhEthufd9rdhjsFXlhReHPYF43tqTGccnBRG1vYJporUjbpIoVci18iICq+dze
         81+OD0FpfiX/NiR2HxAtEngylRByIoylZmqROrCTZAj/temzXo+eSeqHChcXE3qmt+
         B1pH+I1v3nUyyEgZj39G4aDA9AyTz0aKG+Bwj1szD+6Y6UI22wxDyuEAWjKldm+FM5
         HKHIPHQQ4A2dB4j57Ijln2xOobsSYfHbItcL7AfjkGTSzjkW8x1wyw6o9C22aEE9Or
         X/f6Z1jW2l0bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, keescook@chromium.org,
        akpm@linux-foundation.org, jpoimboe@kernel.org, elver@google.com,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 54/54] ubsan: disable UBSAN_DIV_ZERO for clang
Date:   Tue, 19 Jul 2022 21:10:31 -0400
Message-Id: <20220720011031.1023305-54-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit e5d523f1ae8f2cef01f8e071aeee432654166708 ]

Building with UBSAN_DIV_ZERO with clang produces numerous fallthrough
warnings from objtool.

In the case of uncheck division, UBSAN_DIV_ZERO may introduce new
control flow to check for division by zero.

Because the result of the division is undefined, LLVM may optimize the
control flow such that after the call to __ubsan_handle_divrem_overflow
doesn't matter.  If panic_on_warn was set,
__ubsan_handle_divrem_overflow would panic.

The problem is is that panic_on_warn is run time configurable.  If it's
disabled, then we cannot guarantee that we will be able to recover
safely.  Disable this config for clang until we can come up with a
solution in LLVM.

Link: https://github.com/ClangBuiltLinux/linux/issues/1657
Link: https://github.com/llvm/llvm-project/issues/56289
Link: https://lore.kernel.org/lkml/CAHk-=wj1qhf7y3VNACEexyp5EbkNpdcu_542k-xZpzmYLOjiCg@mail.gmail.com/
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index f3c57ed51838..1846e5e70f0b 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -84,6 +84,9 @@ config UBSAN_SHIFT
 config UBSAN_DIV_ZERO
 	bool "Perform checking for integer divide-by-zero"
 	depends on $(cc-option,-fsanitize=integer-divide-by-zero)
+	# https://github.com/ClangBuiltLinux/linux/issues/1657
+	# https://github.com/llvm/llvm-project/issues/56289
+	depends on !CC_IS_CLANG
 	help
 	  This option enables -fsanitize=integer-divide-by-zero which checks
 	  for integer division by zero. This is effectively redundant with the
-- 
2.35.1

