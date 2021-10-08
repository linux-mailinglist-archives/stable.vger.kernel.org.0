Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C84269B5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbhJHLkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243269AbhJHLjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B4761527;
        Fri,  8 Oct 2021 11:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692806;
        bh=PYVc1aUvJeZ0nwOzfsc2cUIMZPX+ebGO2v6h2cvVdlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Om4q2tmxAn8RJmrpKE8VRmQkmsjt/9H8zxdmzqsIKEQHDnNtergQNZ4AQqa+ZPcTd
         31bSXP8dvuEXozFTDpiLl7vNURNaCUJRHZqCwajlsgxHazIkq9w4aIHBMsEwzzclje
         QdHLv9e2PczxpqOt3SNEIfc3wwN8m1K0ign3Lrco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Marco Elver <elver@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 39/48] kasan: always respect CONFIG_KASAN_STACK
Date:   Fri,  8 Oct 2021 13:28:15 +0200
Message-Id: <20211008112721.337335079@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 19532869feb9b0a97d17ddc14609d1e53a5b60db ]

Currently, the asan-stack parameter is only passed along if
CFLAGS_KASAN_SHADOW is not empty, which requires KASAN_SHADOW_OFFSET to
be defined in Kconfig so that the value can be checked.  In RISC-V's
case, KASAN_SHADOW_OFFSET is not defined in Kconfig, which means that
asan-stack does not get disabled with clang even when CONFIG_KASAN_STACK
is disabled, resulting in large stack warnings with allmodconfig:

  drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:117:12: error: stack frame size (14400) exceeds limit (2048) in function 'lb035q02_connect' [-Werror,-Wframe-larger-than]
  static int lb035q02_connect(struct omap_dss_device *dssdev)
             ^
  1 error generated.

Ensure that the value of CONFIG_KASAN_STACK is always passed along to
the compiler so that these warnings do not happen when
CONFIG_KASAN_STACK is disabled.

Link: https://github.com/ClangBuiltLinux/linux/issues/1453
Link: https://lkml.kernel.org/r/20210922205525.570068-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.kasan | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 801c415bac59..b9e94c5e7097 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -33,10 +33,11 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
+CFLAGS_KASAN += $(call cc-param,asan-stack=$(stack_enable))
+
 endif # CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_SW_TAGS
-- 
2.33.0



