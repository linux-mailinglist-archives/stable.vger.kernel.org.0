Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184A02CE266
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 00:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLCXKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 18:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgLCXKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 18:10:43 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: avoid static_assert for genksyms
Date:   Fri,  4 Dec 2020 00:09:44 +0100
Message-Id: <20201203230955.1482058-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

genksyms does not know or care about the _Static_assert() built-in,
and sometimes falls back to ignoring the later symbols, which causes
undefined behavior such as

WARNING: modpost: EXPORT symbol "ethtool_set_ethtool_phy_ops" [vmlinux] version generation failed, symbol will not be versioned.
ld: net/ethtool/common.o: relocation R_AARCH64_ABS32 against `__crc_ethtool_set_ethtool_phy_ops' can not be used when making a shared object
net/ethtool/common.o:(_ftrace_annotated_branch+0x0): dangerous relocation: unsupported relocation

Redefine static_assert for genksyms to avoid that.

Cc: stable@vger.kernel.org
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/build_bug.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/build_bug.h b/include/linux/build_bug.h
index e3a0be2c90ad..7bb66e15b481 100644
--- a/include/linux/build_bug.h
+++ b/include/linux/build_bug.h
@@ -77,4 +77,9 @@
 #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
 
+#ifdef __GENKSYMS__
+/* genksyms gets confused by _Static_assert */
+#define _Static_assert(expr, ...)
+#endif
+
 #endif	/* _LINUX_BUILD_BUG_H */
-- 
2.27.0

