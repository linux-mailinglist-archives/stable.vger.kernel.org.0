Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3117948E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfG2Tct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbfG2Tcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:32:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA9321773;
        Mon, 29 Jul 2019 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428765;
        bh=yil9+l6j76IKsza5SzZwEPu+xQ6omTD0jl61lKC4i5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7Z8fYDpqxskIK8UtUljP5fwmFdVENuuoIgqmhOyfDF6iq6DtBuAaAQ96OKbhgFge
         GPaEIseC8P3IwcJU1pauZru4Ut0cLqfQhY/y7sDQ24oeGfNKHxnDX8g1nvhH1f2uWj
         RM9MwXyVG8gV5JvC4J0utmxZsDiPnwyeVbZAU4oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 178/293] compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
Date:   Mon, 29 Jul 2019 21:21:09 +0200
Message-Id: <20190729190838.145729782@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bdb5ac801af3d81d36732c2f640d6a1d3df83826 ]

Instead of having two identical __read_once_size_nocheck() functions
with different attributes, consolidate all the difference in new macro
__no_kasan_or_inline and use it. No functional changes.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a704d032713b..f490d8d93ec3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -185,23 +185,21 @@ void __read_once_size(const volatile void *p, void *res, int size)
 
 #ifdef CONFIG_KASAN
 /*
- * This function is not 'inline' because __no_sanitize_address confilcts
+ * We can't declare function 'inline' because __no_sanitize_address confilcts
  * with inlining. Attempt to inline it may cause a build failure.
  * 	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
  * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
  */
-static __no_sanitize_address __maybe_unused
-void __read_once_size_nocheck(const volatile void *p, void *res, int size)
-{
-	__READ_ONCE_SIZE;
-}
+# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
 #else
-static __always_inline
+# define __no_kasan_or_inline __always_inline
+#endif
+
+static __no_kasan_or_inline
 void __read_once_size_nocheck(const volatile void *p, void *res, int size)
 {
 	__READ_ONCE_SIZE;
 }
-#endif
 
 static __always_inline void __write_once_size(volatile void *p, void *res, int size)
 {
-- 
2.20.1



