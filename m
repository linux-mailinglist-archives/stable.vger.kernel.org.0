Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12D56DEBC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbfGSEEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731289AbfGSEEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC8B218BC;
        Fri, 19 Jul 2019 04:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509094;
        bh=AIrDmP9VAR77MdRRIuZuYxSCjufkUnfa52LZA5iQNro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmETVh2uq58ObPo/5rUNr1KGmt+FjjrWDFQQNz34mT5wR76R8bh5+jZpU/i0kOrH5
         yo67XV3Gwle8D6nglHRmdFFYIkoi8GrvzpfdPpJVqZGolgHxJjrezUBley5D+lqfuq
         cvyqwHR++dQB785LUJ2GYtZaDAVD4posviHCkDJ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Peter Smith <peter.smith@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.1 065/141] kbuild: Add -Werror=unknown-warning-option to CLANG_FLAGS
Date:   Fri, 19 Jul 2019 00:01:30 -0400
Message-Id: <20190719040246.15945-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 589834b3a0097a4908f4112eac0ca2feb486fa32 ]

In commit ebcc5928c5d9 ("arm64: Silence gcc warnings about arch ABI
drift"), the arm64 Makefile added -Wno-psabi to KBUILD_CFLAGS, which is
a GCC only option so clang rightfully complains:

warning: unknown warning option '-Wno-psabi' [-Wunknown-warning-option]

https://clang.llvm.org/docs/DiagnosticsReference.html#wunknown-warning-option

However, by default, this is merely a warning so the build happily goes
on with a slew of these warnings in the process.

Commit c3f0d0bc5b01 ("kbuild, LLVMLinux: Add -Werror to cc-option to
support clang") worked around this behavior in cc-option by adding
-Werror so that unknown flags cause an error. However, this all happens
silently and when an unknown flag is added to the build unconditionally
like -Wno-psabi, cc-option will always fail because there is always an
unknown flag in the list of flags. This manifested as link time failures
in the arm64 libstub because -fno-stack-protector didn't get added to
KBUILD_CFLAGS.

To avoid these weird cryptic failures in the future, make clang behave
like gcc and immediately error when it encounters an unknown flag by
adding -Werror=unknown-warning-option to CLANG_FLAGS. This can be added
unconditionally for clang because it is supported by at least 3.0.0,
according to godbolt [1] and 4.0.0, according to its documentation [2],
which is far earlier than we typically support.

[1]: https://godbolt.org/z/7F7rm3
[2]: https://releases.llvm.org/4.0.0/tools/clang/docs/DiagnosticsReference.html#wunknown-warning-option

Link: https://github.com/ClangBuiltLinux/linux/issues/511
Link: https://github.com/ClangBuiltLinux/linux/issues/517
Suggested-by: Peter Smith <peter.smith@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 01a0a61f86e7..14dd893e929a 100644
--- a/Makefile
+++ b/Makefile
@@ -514,6 +514,7 @@ ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
 CLANG_FLAGS	+= -no-integrated-as
+CLANG_FLAGS	+= -Werror=unknown-warning-option
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
 KBUILD_AFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS
-- 
2.20.1

