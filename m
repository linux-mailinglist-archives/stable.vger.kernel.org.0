Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E9D6CCE7F
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjC2AIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC2AIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB6E1706
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA3C61A0D
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 00:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A789C4339B;
        Wed, 29 Mar 2023 00:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680048513;
        bh=8G6WyZKBUkvP92kbxlUWP8ZkKK4sAueUvCDnGJm1ks4=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=S/Vjb2agdffTi6SzpWIx8MyKQOGvsFYkfbY781oOIbs/VkV/ewNwhkIX6va5ubWd3
         yQihxOtV7MD8Aw8M8LK0wYt4UZRYS5KtDiKzh6SpcpK1Xuvl3dDyApTBpLebUfm3Bs
         k/rIGDC6ASb3+KNLlVtlybkOVDL0jzeZoG4xAu+jl2meJpafEeDi2Yq/wChZRwv9f2
         aln6ibu6HLfDhm5HaPtNyoUFk2zsyRxHU3L7U7QxKstBoRvz1MZwy38i2r2HJsc/Dm
         dSUxs5vUym/dOhAJ/Afm8KDm6lKHWU5hJ0/V7krRQYYYNR6Wym70jLa609CP6KLY45
         9NbU72AnpynFg==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Tue, 28 Mar 2023 17:08:30 -0700
Subject: [PATCH 5.10 2/4] kbuild: Switch to 'f' variants of integrated
 assembler flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230328-riscv-zifencei-zicsr-5-10-v1-2-bccb3e16dc46@kernel.org>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
In-Reply-To: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     conor@kernel.org, stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2484; i=nathan@kernel.org;
 h=from:subject:message-id; bh=8G6WyZKBUkvP92kbxlUWP8ZkKK4sAueUvCDnGJm1ks4=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnKjfULBNvrt9exiFbsdFS8YDBlT/zJU7MeiFUu3PIup
 Cdw6UW9jlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRI5cZGY7FXZh60rl6zv+K
 U28iRT9HbIhc9FtMwcrNR/LHtYfH3x1j+J87Za341GTWde18poZl0u92aQtvMb71gLei9rj+J2N
 eKyYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2185a7e4b0ade86c2c57fc63d4a7535c40254bd0 upstream.

It has been brought up a few times in various code reviews that clang
3.5 introduced -f{,no-}integrated-as as the preferred way to enable and
disable the integrated assembler, mentioning that -{no-,}integrated-as
are now considered legacy flags.

Switch the kernel over to using those variants in case there is ever a
time where clang decides to remove the non-'f' variants of the flag.

Also, fix a typo in a comment ("intergrated" -> "integrated").

Link: https://releases.llvm.org/3.5.0/tools/clang/docs/ReleaseNotes.html#new-compiler-flags
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: Backport to 5.10]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Makefile              | 4 ++--
 scripts/as-version.sh | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 44d9aff4f66a..1272e482abbe 100644
--- a/Makefile
+++ b/Makefile
@@ -581,9 +581,9 @@ ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
 ifeq ($(LLVM_IAS),1)
-CLANG_FLAGS	+= -integrated-as
+CLANG_FLAGS	+= -fintegrated-as
 else
-CLANG_FLAGS	+= -no-integrated-as
+CLANG_FLAGS	+= -fno-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
diff --git a/scripts/as-version.sh b/scripts/as-version.sh
index 851dcb8a0e68..532270bd4b7e 100755
--- a/scripts/as-version.sh
+++ b/scripts/as-version.sh
@@ -21,14 +21,14 @@ get_canonical_version()
 	echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
 }
 
-# Clang fails to handle -Wa,--version unless -no-integrated-as is given.
-# We check -(f)integrated-as, expecting it is explicitly passed in for the
+# Clang fails to handle -Wa,--version unless -fno-integrated-as is given.
+# We check -fintegrated-as, expecting it is explicitly passed in for the
 # integrated assembler case.
 check_integrated_as()
 {
 	while [ $# -gt 0 ]; do
-		if [ "$1" = -integrated-as -o "$1" = -fintegrated-as ]; then
-			# For the intergrated assembler, we do not check the
+		if [ "$1" = -fintegrated-as ]; then
+			# For the integrated assembler, we do not check the
 			# version here. It is the same as the clang version, and
 			# it has been already checked by scripts/cc-version.sh.
 			echo LLVM 0

-- 
2.40.0

