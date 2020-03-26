Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73379194D05
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgCZX2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgCZXYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CF220714;
        Thu, 26 Mar 2020 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265077;
        bh=JzE8QSLBSji/fwbdetznn6wuAkvze4RHNwUOhEGZU9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqtcyPkLQSKdP/jnrTvMYorZ+/X2VotS10SEvaIiTUlgf/+9d5DJ8+aGThDIgilOa
         ETBF7xeulRDWw7RwdkOnyA910EjwP7/A254GV3UJuxAaGKX4m55wUAfRVgFMONOkOd
         Ok8JTwb6PmQeJMx1+1+Hp482l2E1JiYAxlWy6zGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 04/19] kconfig: introduce m32-flag and m64-flag
Date:   Thu, 26 Mar 2020 19:24:16 -0400
Message-Id: <20200326232431.7816-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 8cc4fd73501d9f1370c3eebb70cfe8cc9e24062b ]

When a compiler supports multiple architectures, some compiler features
can be dependent on the target architecture.

This is typical for Clang, which supports multiple LLVM backends.
Even for GCC, we need to take care of biarch compiler cases.

It is not a problem when we evaluate cc-option in Makefiles because
cc-option is tested against the flag in question + $(KBUILD_CFLAGS).

The cc-option in Kconfig, on the other hand, does not accumulate
tested flags. Due to this simplification, it could potentially test
cc-option against a different target.

At first, Kconfig always evaluated cc-option against the host
architecture.

Since commit e8de12fb7cde ("kbuild: Check for unknown options with
cc-option usage in Kconfig and clang"), in case of cross-compiling
with Clang, the target triple is correctly passed to Kconfig.

The case with biarch GCC (and native build with Clang) is still not
handled properly. We need to pass some flags to specify the target
machine bit.

Due to the design, all the macros in Kconfig are expanded in the
parse stage, where we do not know the target bit size yet.

For example, arch/x86/Kconfig allows a user to toggle CONFIG_64BIT.
If a compiler flag -foo depends on the machine bit, it must be tested
twice, one with -m32 and the other with -m64.

However, -m32/-m64 are not always recognized. So, this commits adds
m64-flag and m32-flag macros. They expand to -m32, -m64, respectively
if supported. Or, they expand to an empty string if unsupported.

The typical usage is like this:

  config FOO
          bool
          default $(cc-option,$(m64-flag) -foo) if 64BIT
          default $(cc-option,$(m32-flag) -foo)

This is clumsy, but there is no elegant way to handle this in the
current static macro expansion.

There was discussion for static functions vs dynamic functions.
The consensus was to go as far as possible with the static functions.
(https://lkml.org/lkml/2018/3/2/22)

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: George Spelvin <lkml@sdf.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kconfig.include | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index bfb44b265a948..77a69ba9cd198 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -40,3 +40,10 @@ $(error-if,$(success, $(LD) -v | grep -q gold), gold linker '$(LD)' not supporte
 
 # gcc version including patch level
 gcc-version := $(shell,$(srctree)/scripts/gcc-version.sh $(CC))
+
+# machine bit flags
+#  $(m32-flag): -m32 if the compiler supports it, or an empty string otherwise.
+#  $(m64-flag): -m64 if the compiler supports it, or an empty string otherwise.
+cc-option-bit = $(if-success,$(CC) -Werror $(1) -E -x c /dev/null -o /dev/null,$(1))
+m32-flag := $(cc-option-bit,-m32)
+m64-flag := $(cc-option-bit,-m64)
-- 
2.20.1

