Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440B02D812F
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 22:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405729AbgLKVh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 16:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391347AbgLKVhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 16:37:20 -0500
Date:   Fri, 11 Dec 2020 13:36:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607722599;
        bh=Vql5KOdLOKsBXzP2w5ZiC+qjVWkaxgNf8DRqZZ8o81Q=;
        h=From:To:Subject:In-Reply-To:From;
        b=CJ66+UyGOg3XzYy/gi1PKYit4+7U8A9Ty8YTE88QtD19cNGEJQAZ6tBj7lG0yqbKx
         BO05d7uToJukoTHenflTliJi242O+cNJ6DqdqByntwtUwN6Zy/GyAyG0Mc3gGw4QY5
         U2tDS9xpDFc4ec17q8hclOP785sl89Q4cYhWv47s=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
        elver@google.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 4/8] kbuild: avoid static_assert for genksyms
Message-ID: <20201211213638.89W7IFB2b%akpm@linux-foundation.org>
In-Reply-To: <20201211133555.88407977f082963499ed343c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: kbuild: avoid static_assert for genksyms

genksyms does not know or care about the _Static_assert() built-in,
and sometimes falls back to ignoring the later symbols, which causes
undefined behavior such as

WARNING: modpost: EXPORT symbol "ethtool_set_ethtool_phy_ops" [vmlinux] version generation failed, symbol will not be versioned.
ld: net/ethtool/common.o: relocation R_AARCH64_ABS32 against `__crc_ethtool_set_ethtool_phy_ops' can not be used when making a shared object
net/ethtool/common.o:(_ftrace_annotated_branch+0x0): dangerous relocation: unsupported relocation

Redefine static_assert for genksyms to avoid that.

Link: https://lkml.kernel.org/r/20201203230955.1482058-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/build_bug.h~kbuild-avoid-static_assert-for-genksyms
+++ a/include/linux/build_bug.h
@@ -77,4 +77,9 @@
 #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
 
+#ifdef __GENKSYMS__
+/* genksyms gets confused by _Static_assert */
+#define _Static_assert(expr, ...)
+#endif
+
 #endif	/* _LINUX_BUILD_BUG_H */
_
