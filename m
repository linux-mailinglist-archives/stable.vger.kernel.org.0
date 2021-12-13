Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50635472723
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhLMJ6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbhLMJ4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67524C0617A1;
        Mon, 13 Dec 2021 01:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35B75B80E1A;
        Mon, 13 Dec 2021 09:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FEAC00446;
        Mon, 13 Dec 2021 09:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388790;
        bh=GrrkshFVfILxXHp+6KEbzkw9qlv/EElZCZ0UOJzap4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFaXzkFgSrrgqY6i2Waf7Ljf2KprVwBhgE2386eNDoRF67kkh6TIOptLxCIdBYcjG
         JDlG58FeLKgAnw2vR4Qvq1/5tK1A4fzu7fyUmvwg7S7/+KrAVgcJNTVIf9dpCMWT+m
         qryyBZOsT1SoV7R0FHw+hbap7/2EoLvMm/o+tioQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: [PATCH 5.10 002/132] gcc-plugins: simplify GCC plugin-dev capability test
Date:   Mon, 13 Dec 2021 10:29:03 +0100
Message-Id: <20211213092939.156328381@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 1e860048c53ee77ee9870dcce94847a28544b753 upstream.

Linus pointed out a third of the time in the Kconfig parse stage comes
from the single invocation of cc1plus in scripts/gcc-plugin.sh [1],
and directly testing plugin-version.h for existence cuts down the
overhead a lot. [2]

This commit takes one step further to kill the build test entirely.

The small piece of code was probably intended to test the C++ designated
initializer, which was not supported until C++20.

In fact, with -pedantic option given, both GCC and Clang emit a warning.

$ echo 'class test { public: int test; } test = { .test = 1 };' | g++ -x c++ -pedantic - -fsyntax-only
<stdin>:1:43: warning: C++ designated initializers only available with '-std=c++2a' or '-std=gnu++2a' [-Wpedantic]
$ echo 'class test { public: int test; } test = { .test = 1 };' | clang++ -x c++ -pedantic - -fsyntax-only
<stdin>:1:43: warning: designated initializers are a C++20 extension [-Wc++20-designator]
class test { public: int test; } test = { .test = 1 };
                                          ^
1 warning generated.

Otherwise, modern C++ compilers should be able to build the code, and
hopefully skipping this test should not make any practical problem.

Checking the existence of plugin-version.h is still needed to ensure
the plugin-dev package is installed. The test code is now small enough
to be embedded in scripts/gcc-plugins/Kconfig.

[1] https://lore.kernel.org/lkml/CAHk-=wjU4DCuwQ4pXshRbwDCUQB31ScaeuDo1tjoZ0_PjhLHzQ@mail.gmail.com/
[2] https://lore.kernel.org/lkml/CAHk-=whK0aQxs6Q5ijJmYF1n2ch8cVFSUzU5yUM_HOjig=+vnw@mail.gmail.com/

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201203125700.161354-1-masahiroy@kernel.org
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugin.sh       |   19 -------------------
 scripts/gcc-plugins/Kconfig |    2 +-
 2 files changed, 1 insertion(+), 20 deletions(-)
 delete mode 100755 scripts/gcc-plugin.sh

--- a/scripts/gcc-plugin.sh
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-
-set -e
-
-srctree=$(dirname "$0")
-
-gccplugins_dir=$($* -print-file-name=plugin)
-
-# we need a c++ compiler that supports the designated initializer GNU extension
-$HOSTCC -c -x c++ -std=gnu++98 - -fsyntax-only -I $srctree/gcc-plugins -I $gccplugins_dir/include 2>/dev/null <<EOF
-#include "gcc-common.h"
-class test {
-public:
-	int test;
-} test = {
-	.test = 1
-};
-EOF
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -9,7 +9,7 @@ menuconfig GCC_PLUGINS
 	bool "GCC plugins"
 	depends on HAVE_GCC_PLUGINS
 	depends on CC_IS_GCC
-	depends on $(success,$(srctree)/scripts/gcc-plugin.sh $(CC))
+	depends on $(success,test -e $(shell,$(CC) -print-file-name=plugin)/include/plugin-version.h)
 	default y
 	help
 	  GCC plugins are loadable modules that provide extra features to the


