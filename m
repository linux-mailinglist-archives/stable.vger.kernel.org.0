Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FCF1AA041
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369191AbgDOMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409215AbgDOLpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4389820768;
        Wed, 15 Apr 2020 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951145;
        bh=/KnOurnx6Etk4y412/BZj+JikJrWXkN0RDnFDDfh8k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY7N4FD/DL/q6Y+z3Gyr7SlMF/hXM3edb2oVt/0ByKa2I0u3+sTvRlBq7dQzzUbhj
         /HuXBqqkL3VIut2MAZkrCXWCcgN8MaLd8xlIs6BZ3e/F3TaCUQtEWK1bZfx0IW2qKw
         maJR1+QmruPG5pfofsOeiNt/Xoi4u3ijlj1K0QlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vegard Nossum <vegard.nossum@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Daniel Santos <daniel.santos@pobox.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ian Abbott <abbotti@mev.co.uk>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 53/84] compiler.h: fix error in BUILD_BUG_ON() reporting
Date:   Wed, 15 Apr 2020 07:44:10 -0400
Message-Id: <20200415114442.14166-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

[ Upstream commit af9c5d2e3b355854ff0e4acfbfbfadcd5198a349 ]

compiletime_assert() uses __LINE__ to create a unique function name.  This
means that if you have more than one BUILD_BUG_ON() in the same source
line (which can happen if they appear e.g.  in a macro), then the error
message from the compiler might output the wrong condition.

For this source file:

	#include <linux/build_bug.h>

	#define macro() \
		BUILD_BUG_ON(1); \
		BUILD_BUG_ON(0);

	void foo()
	{
		macro();
	}

gcc would output:

./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_9' declared with attribute error: BUILD_BUG_ON failed: 0
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

However, it was not the BUILD_BUG_ON(0) that failed, so it should say 1
instead of 0. With this patch, we use __COUNTER__ instead of __LINE__, so
each BUILD_BUG_ON() gets a different function name and the correct
condition is printed:

./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_0' declared with attribute error: BUILD_BUG_ON failed: 1
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Joe Perches <joe@perches.com>
Link: http://lkml.kernel.org/r/20200331112637.25047-1-vegard.nossum@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5e88e7e33abec..034b0a644efcc 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -347,7 +347,7 @@ static inline void *offset_to_ptr(const int *off)
  * compiler has support to do so.
  */
 #define compiletime_assert(condition, msg) \
-	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
 
 #define compiletime_assert_atomic_type(t)				\
 	compiletime_assert(__native_word(t),				\
-- 
2.20.1

