Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D832D8BF3
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 07:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgLMGGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 01:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbgLMGF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Dec 2020 01:05:56 -0500
Date:   Sat, 12 Dec 2020 22:05:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607839516;
        bh=AQE66dma2JaAhR6j8gtFFTDrZhlUgu1sh1kFi9eVAZM=;
        h=From:To:Subject:From;
        b=bm494jXcLCM4Cav4r6t1RJbCJYHErUIhvcgh71ufkXLItbmyz1nGym7BujdupWedu
         ue2z9SpY1pXFhS/1ppGL2LkRsEW75XoZ0gZjSoZdMfPP8CCpXAhcl7AjuYnzD0Io/e
         Y/GVTVvU25/apPsaLM6wn9mfkwpWqosbXNvtcA8g=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, elver@google.com,
        keescook@chromium.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, stable@vger.kernel.org
Subject:  [merged] kbuild-avoid-static_assert-for-genksyms.patch
 removed from -mm tree
Message-ID: <20201213060515.yAjN3k7sP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kbuild: avoid static_assert for genksyms
has been removed from the -mm tree.  Its filename was
     kbuild-avoid-static_assert-for-genksyms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are


