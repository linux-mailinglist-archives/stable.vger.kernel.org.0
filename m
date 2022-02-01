Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C84A6875
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 00:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiBAXWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 18:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242825AbiBAXWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 18:22:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E5BC061714;
        Tue,  1 Feb 2022 15:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18599B80ADF;
        Tue,  1 Feb 2022 23:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C362C340EB;
        Tue,  1 Feb 2022 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643757762;
        bh=GSyiEuas7X9TQ7vDaHSUeqwVJQqlDVvyGfSkTQnLBio=;
        h=From:To:Cc:Subject:Date:From;
        b=dbhOgBUEGWKCkicvuYk46wyz6gA2IbEw1DPEzUaVbxPf6+7QmcKfSlWPRbJgGcPkm
         +iXtJjZVgJFBRTtGekgcnK3Rf1Wo5z+QVHCJ8pidqYJx+IaBrTgQ0Q3/TGB+43qt/3
         iztUZM2xSAGG0fwYfHjtlGerDmjjYfOh6qVSLqy8fJdSsHyGiRta+59uAeXxhkCfyo
         c+Ko9mjML8HGLsJgB0z8vH+ZpsdWazaq/suYpbh5z8s3NF9K6q2Au9slwapOPGQQJ5
         UsPG5zUOYysW3lCvtj6Q5Q4fSzD7vrYrHaJvkJHr+TuQvQFMHPnnCu0qoHogZgCv4n
         LLLaNmT6CqCyg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] Makefile.extrawarn: Move -Wunaligned-access to W=2
Date:   Tue,  1 Feb 2022 16:22:29 -0700
Message-Id: <20220201232229.2992968-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-Wunaligned-access is a new warning in clang that is default enabled for
arm and arm64 under certain circumstances within the clang frontend (see
LLVM commit below). Under an ARCH=arm allmodconfig, there are
1284 total/70 unique instances of this warning (most of the instances
are in header files), which is quite noisy.

To keep the build green through CONFIG_WERROR, only allow this warning
with W=2, which seems appropriate according to its description:
"warnings which occur quite often but may still be relevant".

This intentionally does not use the -Wno-... + -W... pattern that the
rest of the Makefile does because this warning is not enabled for
anything other than certain arm and arm64 configurations within clang so
it should only be "not disabled", rather than explicitly enabled, so
that other architectures are not disturbed by the warning.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 scripts/Makefile.extrawarn | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d53825503874..5f75fec4d5ac 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -70,6 +70,20 @@ KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
 
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN2
 
+else
+
+ifdef CONFIG_CC_IS_CLANG
+# While this warning is architecture agnostic, it is only default enabled for
+# 32-bit and 64-bit ARM under certain conditions within clang:
+#
+# https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
+#
+# To allow it to be disabled under a normal build or W=1 but show up under W=2
+# for those configurations, disable it when W=2 is not set, rather than enable
+# -Wunaligned-access in the above block explicitly.
+KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
+endif
+
 endif
 
 #

base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
-- 
2.35.1

