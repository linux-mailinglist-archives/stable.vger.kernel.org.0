Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28E22E3855
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgL1NJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbgL1NJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:09:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F7C20728;
        Mon, 28 Dec 2020 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160932;
        bh=w1B80InT3GeQCkzsfsLRnH6hwn/Ke3XQB3TgRmdg73c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1uqwuLM/km/v1MsaUrzDccHIL/GFi9q1e+9g3YA4m8DEajcHqFDeCwJiCj27bYPm
         qNlq3Pwb6bP0/j1TowFrpAqLGU8blruwdI892t5vSs5cx7F/Ub9JVKhiFfVhHuUhhb
         r2dO9f2v4lBAGzSwYxbLvYEhzAQqp/aWrTDvzdcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Kees Cook <keescook@chromium.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 013/242] kbuild: avoid static_assert for genksyms
Date:   Mon, 28 Dec 2020 13:46:58 +0100
Message-Id: <20201228124905.315839390@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 14dc3983b5dff513a90bd5a8cc90acaf7867c3d0 upstream.

genksyms does not know or care about the _Static_assert() built-in, and
sometimes falls back to ignoring the later symbols, which causes
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/build_bug.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/build_bug.h
+++ b/include/linux/build_bug.h
@@ -82,4 +82,9 @@
 
 #endif	/* __CHECKER__ */
 
+#ifdef __GENKSYMS__
+/* genksyms gets confused by _Static_assert */
+#define _Static_assert(expr, ...)
+#endif
+
 #endif	/* _LINUX_BUILD_BUG_H */


