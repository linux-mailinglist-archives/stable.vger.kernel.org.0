Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA96CCE82
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjC2AIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjC2AIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:08:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0299D1FDB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAF1B81F86
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 00:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F37C433B0;
        Wed, 29 Mar 2023 00:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680048514;
        bh=xz6iQWtfTHw4fW5rNLS2uk5zoKOhjUwzoHJEzLhjxd0=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=ZY+nEQBaZdi3YWXUJ++5Dw431bgWtDX/mCcYABp972J768SSXAWMY9WrN7uDD099y
         5txb8VECYy8t2P3AASUTCAv6U5duGxTjgmtzRr/D2lYKEwCCuyjrE3YiJjaVFNrMuX
         H97Irw8areTrnicSe4yU/qwooBWDmvvU1imDtQsnfZdzz6Abc7qdbmC3uKG8ravlgw
         49ug3FWclY+DO/VNk1ilX+RU5sAsxcc/edpCmHMmoIR8szEJdaahL/ZWREkFpSkDxR
         KAbemT+9BlrjVNQYH81ya09oqfCL52ak8xT4kSaqV98tDTisVDDVthHwLnCmh34K0I
         yKdnkdbE8f6CA==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Tue, 28 Mar 2023 17:08:31 -0700
Subject: [PATCH 5.10 3/4] kbuild: check CONFIG_AS_IS_LLVM instead of
 LLVM_IAS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230328-riscv-zifencei-zicsr-5-10-v1-3-bccb3e16dc46@kernel.org>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
In-Reply-To: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     conor@kernel.org, stable@vger.kernel.org, llvm@lists.linux.dev,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1871; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/vv+m0cxrgDgJD0iQw6D6no6dDHViKM6q7Yr0bGU6E4=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnKjfUbUiu1b0ofOe7imSBXvGraU98Fj1cUKce7TStZY
 GUY3GnYUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYy5zvD/1CTR9Ud4pWzO/jf
 l85VnGdluUfJ1dk0I+mF4oznXiEcHowMLzwdP4dNPib93oiZdc3fdc2nc7c7P/TavmmGxsSVR0q
 O8AIA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 52cc02b910284d6bddba46cce402044ab775f314 upstream.

LLVM_IAS is the user interface to set the -(no-)integrated-as flag,
and it should be used only for that purpose.

LLVM_IAS is checked in some places to determine the assembler type,
but it is not precise.

For example,

 $ make CC=gcc LLVM_IAS=1

... will use the GNU assembler (i.e. binutils) since LLVM_IAS=1 is
effective only when $(CC) is clang.

Of course, 'CC=gcc LLVM_IAS=1' is an odd combination, but the build
system can be more robust against such insane input.

Commit ba64beb17493a ("kbuild: check the minimum assembler version in
Kconfig") introduced CONFIG_AS_IS_GNU/LLVM, which is more precise
because Kconfig checks the version string from the assembler in use.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
[nathan: Backport to 5.10]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Makefile            | 2 +-
 arch/riscv/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1272e482abbe..3dfacb6fa973 100644
--- a/Makefile
+++ b/Makefile
@@ -851,7 +851,7 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifeq ($(LLVM_IAS),1)
+ifdef CONFIG_AS_IS_LLVM
 KBUILD_AFLAGS	+= -g
 else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 9446282b52ba..14cdeaa2bb32 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -40,7 +40,7 @@ ifeq ($(CONFIG_LD_IS_LLD),y)
 ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
-ifneq ($(LLVM_IAS),1)
+ifndef CONFIG_AS_IS_LLVM
 	KBUILD_CFLAGS += -Wa,-mno-relax
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif

-- 
2.40.0

