Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124C829C717
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827756AbgJ0S1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752943AbgJ0N5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0E9206D4;
        Tue, 27 Oct 2020 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807067;
        bh=ZnPENhl4i9EH0nQMbyJDFa000wmUTCb8y8kmOoKdyNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdWHlUXBF92vX3HkF9m1YntT0F8abHxT7niVJQMfihEKttwldqhTvwPZ1pJeKLdZV
         t9LD030kqXa9o17bSWeUVuHVlNcjw1ivmTAJGCDXCwFp/Kwspj0LoUv1WrjcwcHVbv
         VjDxRvCqQt7vlSJ4YOwdOJlO0oqqKFZDmhsIDI80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 008/112] compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
Date:   Tue, 27 Oct 2020 14:48:38 +0100
Message-Id: <20201027134900.942338117@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit bdb5ac801af3d81d36732c2f640d6a1d3df83826 upstream.

Instead of having two identical __read_once_size_nocheck() functions
with different attributes, consolidate all the difference in new macro
__no_kasan_or_inline and use it. No functional changes.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -241,23 +241,21 @@ void __read_once_size(const volatile voi
 
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


