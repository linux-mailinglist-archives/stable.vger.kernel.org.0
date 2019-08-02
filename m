Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3E7F2A5
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391965AbfHBJpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391942AbfHBJpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB032086A;
        Fri,  2 Aug 2019 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739131;
        bh=iQP2fSg2U+1c6Xp5RHw7ciIsyiz20F1hyTMk5VXWhX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7lCwHbqUso0LxTtAl0T1OXO8S5aPlCmplViZLfSPI21tcWxXyUNERDbtkWPOAmTi
         TsZx/7gtMcXqRhaolEhmFj5I+ljNV53LaWTMtWnXjIVYq17XaSOvuuEBLCPfd0tKxC
         KercnQYst2f+Ervm/ToxjKUx7jfGF8QyP0YRa+Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 125/223] compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
Date:   Fri,  2 Aug 2019 11:35:50 +0200
Message-Id: <20190802092247.195768384@linuxfoundation.org>
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
index 80a5bc623c47..ced454c03819 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -250,23 +250,21 @@ void __read_once_size(const volatile void *p, void *res, int size)
 
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



