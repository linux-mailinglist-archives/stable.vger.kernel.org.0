Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492571A9E5D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897879AbgDOLyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409415AbgDOLsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931AB20732;
        Wed, 15 Apr 2020 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951284;
        bh=9+x2FW9k7r3YtG8FnuuW9O/Ga8X9b8fEaiNci1x3PEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lI6SiKvcteJGoEYmvF4qmNLxFHXn2GJhA0AqE7OKVBP70je9omC582QYcCZvx6OpH
         5FQItpAmkjhqeEZEsWY9leKRhuv/C7kQ81TTcGGAniKlW/SgGw2KQ0XszCbVeO4yJC
         11bQxID7W6eYVcFhEeGp74iGYWW0gURg/Qn568ag=
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
Subject: [PATCH AUTOSEL 4.9 13/21] compiler.h: fix error in BUILD_BUG_ON() reporting
Date:   Wed, 15 Apr 2020 07:47:40 -0400
Message-Id: <20200415114748.15713-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114748.15713-1-sashal@kernel.org>
References: <20200415114748.15713-1-sashal@kernel.org>
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
index 0020ee1cab37a..7837afabbd78e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -546,7 +546,7 @@ unsigned long read_word_at_a_time(const void *addr)
  * compiler has support to do so.
  */
 #define compiletime_assert(condition, msg) \
-	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
 
 #define compiletime_assert_atomic_type(t)				\
 	compiletime_assert(__native_word(t),				\
-- 
2.20.1

