Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB91581B42
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfHENM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbfHENJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD509217D9;
        Mon,  5 Aug 2019 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010590;
        bh=Y8QJsEx3iQGHlddjHTT8Du+dE5LcgvkKqSkfYJiQt9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXO2sjIJKWHjOQlSg1VLtZaiWuT5YhsFieiUWY111T39ejK1aCwDPeuOq5PttjPTt
         iLW/J9VxlkDPZ3FDrlhWC2t1C7xdiuibUpeJtcb1NjG7bcGgIu5spcjs8GjT41iUaV
         2jDs6OxcrISMh4wri2STfE/ZqKiU+EOWuB6/in/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/74] lib/test_overflow.c: avoid tainting the kernel and fix wrap size
Date:   Mon,  5 Aug 2019 15:02:42 +0200
Message-Id: <20190805124938.092685708@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8e060c21ae2c265a2b596e9e7f9f97ec274151a4 ]

This adds __GFP_NOWARN to the kmalloc()-portions of the overflow test to
avoid tainting the kernel.  Additionally fixes up the math on wrap size
to be architecture and page size agnostic.

Link: http://lkml.kernel.org/r/201905282012.0A8767E24@keescook
Fixes: ca90800a91ba ("test_overflow: Add memory allocation overflow tests")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_overflow.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/test_overflow.c b/lib/test_overflow.c
index fc680562d8b69..7a4b6f6c5473c 100644
--- a/lib/test_overflow.c
+++ b/lib/test_overflow.c
@@ -486,16 +486,17 @@ static int __init test_overflow_shift(void)
  * Deal with the various forms of allocator arguments. See comments above
  * the DEFINE_TEST_ALLOC() instances for mapping of the "bits".
  */
-#define alloc010(alloc, arg, sz) alloc(sz, GFP_KERNEL)
-#define alloc011(alloc, arg, sz) alloc(sz, GFP_KERNEL, NUMA_NO_NODE)
+#define alloc_GFP		 (GFP_KERNEL | __GFP_NOWARN)
+#define alloc010(alloc, arg, sz) alloc(sz, alloc_GFP)
+#define alloc011(alloc, arg, sz) alloc(sz, alloc_GFP, NUMA_NO_NODE)
 #define alloc000(alloc, arg, sz) alloc(sz)
 #define alloc001(alloc, arg, sz) alloc(sz, NUMA_NO_NODE)
-#define alloc110(alloc, arg, sz) alloc(arg, sz, GFP_KERNEL)
+#define alloc110(alloc, arg, sz) alloc(arg, sz, alloc_GFP)
 #define free0(free, arg, ptr)	 free(ptr)
 #define free1(free, arg, ptr)	 free(arg, ptr)
 
-/* Wrap around to 8K */
-#define TEST_SIZE		(9 << PAGE_SHIFT)
+/* Wrap around to 16K */
+#define TEST_SIZE		(5 * 4096)
 
 #define DEFINE_TEST_ALLOC(func, free_func, want_arg, want_gfp, want_node)\
 static int __init test_ ## func (void *arg)				\
-- 
2.20.1



