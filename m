Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A72CE28E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 00:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgLCXUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 18:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgLCXUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 18:20:20 -0500
Date:   Thu, 03 Dec 2020 15:19:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607037579;
        bh=db5rRAH85wgDQfhH0ycOb7YfOT+7cqn9LTL2Rt7n5qU=;
        h=From:To:Subject:From;
        b=xPeikDfRZL/MCEZQLMO2/eA/YTBPaoeLTZ12DxTH8fN6AmnIIyvtWBEpkOKMxFGgS
         rmN9jSW7ysNfp2lqFutkh+aTKCf5dQIazV61ZkG8a8zQ9LkPoeJzKbJ3fpLh2uHhBD
         Y25fWDpZkbJum2XgXUWAEsGmgKcUp80wCojLwkXY=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, arnd@kernel.org,
        keescook@chromium.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, stable@vger.kernel.org
Subject:  + kbuild-avoid-static_assert-for-genksyms.patch added to
 -mm tree
Message-ID: <20201203231938.H9QeK_2X3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kbuild: avoid static_assert for genksyms
has been added to the -mm tree.  Its filename is
     kbuild-avoid-static_assert-for-genksyms.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kbuild-avoid-static_assert-for-genksyms.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kbuild-avoid-static_assert-for-genksyms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@kernel.org>
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

Patches currently in -mm which might be from arnd@kernel.org are

kbuild-avoid-static_assert-for-genksyms.patch

