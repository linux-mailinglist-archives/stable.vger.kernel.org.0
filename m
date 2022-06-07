Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F56554146E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358583AbiFGUSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359253AbiFGUOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591316F912;
        Tue,  7 Jun 2022 11:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0979A611B9;
        Tue,  7 Jun 2022 18:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF5C385A2;
        Tue,  7 Jun 2022 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626498;
        bh=HIQk/uw7vS5y7k9V6eMIFVegpbu+WXgZ8oYpaSKok5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jttEN5czCg+WY5Kl0aYewm0ZYwI+Svk3zfoFcdPmV3tCL+8a+t01TnOCZ+kT1ttkg
         OviOQYtbPBxRpGNIrwa3E+iJTsapEXS6yfPc8VxLPLvB5xChgbcfgG7+P3Faz9ra+Z
         4PvaPUMSbO3FtQsR+zECKOCKMIG6X+nbfWqXnWKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 401/772] kselftest/arm64: bti: force static linking
Date:   Tue,  7 Jun 2022 18:59:53 +0200
Message-Id: <20220607165000.828181528@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit d7a49291d786b4400996afe3afcc3ef5eeb6f0ef ]

The "bti" selftests are built with -nostdlib, which apparently
automatically creates a statically linked binary, which is what we want
and need for BTI (to avoid interactions with the dynamic linker).

However this is not true when building a PIE binary, which some
toolchains (Ubuntu) configure as the default.
When compiling btitest with such a toolchain, it will create a
dynamically linked binary, which will probably fail some tests, as the
dynamic linker might not support BTI:
===================
TAP version 13
1..18
not ok 1 nohint_func/call_using_br_x0
not ok 2 nohint_func/call_using_br_x16
not ok 3 nohint_func/call_using_blr
....
===================

To make sure we create static binaries, add an explicit -static on the
linker command line. This forces static linking even if the toolchain
defaults to PIE builds, and fixes btitest runs on BTI enabled machines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Fixes: 314bcbf09f14 ("kselftest: arm64: Add BTI tests")
Link: https://lore.kernel.org/r/20220511172129.2078337-1-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/bti/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/bti/Makefile b/tools/testing/selftests/arm64/bti/Makefile
index 73e013c082a6..dafa1c2aa5c4 100644
--- a/tools/testing/selftests/arm64/bti/Makefile
+++ b/tools/testing/selftests/arm64/bti/Makefile
@@ -39,7 +39,7 @@ BTI_OBJS =                                      \
 	teststubs-bti.o                         \
 	trampoline-bti.o
 gen/btitest: $(BTI_OBJS)
-	$(CC) $(CFLAGS_BTI) $(CFLAGS_COMMON) -nostdlib -o $@ $^
+	$(CC) $(CFLAGS_BTI) $(CFLAGS_COMMON) -nostdlib -static -o $@ $^
 
 NOBTI_OBJS =                                    \
 	test-nobti.o                         \
@@ -50,7 +50,7 @@ NOBTI_OBJS =                                    \
 	teststubs-nobti.o                       \
 	trampoline-nobti.o
 gen/nobtitest: $(NOBTI_OBJS)
-	$(CC) $(CFLAGS_BTI) $(CFLAGS_COMMON) -nostdlib -o $@ $^
+	$(CC) $(CFLAGS_BTI) $(CFLAGS_COMMON) -nostdlib -static -o $@ $^
 
 # Including KSFT lib.mk here will also mangle the TEST_GEN_PROGS list
 # to account for any OUTPUT target-dirs optionally provided by
-- 
2.35.1



