Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD667F26A
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405823AbfHBJsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405817AbfHBJsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:48:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9D3F20880;
        Fri,  2 Aug 2019 09:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739292;
        bh=ddcEfqeo6v3OSjK2Q2P8/JvVXUdCv5mMfd3jq3ExwGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD/78nnJTYVwZjWhgxXML2KpOngaWJMffUd7WcvVEZQ9TOowM3+8ahOGhYNQ8Qvkj
         3qzxEVYRhfk0nWtW6O/PWzR2uwTDTZa82B1gLO7/uXfBslyP4XkVVj28qgmNaBnw4R
         tdR3XevltTVzGrVy6liPUMvwq6Ay7TGArHpew8Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Smith <peter.smith@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 177/223] kbuild: Add -Werror=unknown-warning-option to CLANG_FLAGS
Date:   Fri,  2 Aug 2019 11:36:42 +0200
Message-Id: <20190802092249.235107260@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 1ab22a85118f..03ff09d789b4 100644
--- a/Makefile
+++ b/Makefile
@@ -515,6 +515,7 @@ ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
 CLANG_FLAGS	+= -no-integrated-as
+CLANG_FLAGS	+= -Werror=unknown-warning-option
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
 KBUILD_AFLAGS	+= $(CLANG_FLAGS)
 endif
-- 
2.20.1



