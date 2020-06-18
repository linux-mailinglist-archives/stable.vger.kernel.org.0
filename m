Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757B21FE1AE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgFRB4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbgFRBZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C9F2083B;
        Thu, 18 Jun 2020 01:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443524;
        bh=PxFzWUc3KfQ5I3k1U+pE3XbukGa2kzAl/7kPmT8qxY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkTDQ7RflkPB3gmOMuHeSsPVV8YzOUwvWxEmbQmE58VTyZj9U6xRG7tCz85H92x25
         EENqxS+TKR9F57uEHFGbaC3X1wys6MzGl6bTxsNmaSCx9sflNltm2w+REUlXYmcbxA
         F7GRlCXEWZO87q4rPEHCiqHR5CozpJbgMlGeWBME=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 146/172] include/linux/bitops.h: avoid clang shift-count-overflow warnings
Date:   Wed, 17 Jun 2020 21:21:52 -0400
Message-Id: <20200618012218.607130-146-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bd93f003b7462ae39a43c531abca37fe7073b866 ]

Clang normally does not warn about certain issues in inline functions when
it only happens in an eliminated code path. However if something else
goes wrong, it does tend to complain about the definition of hweight_long()
on 32-bit targets:

  include/linux/bitops.h:75:41: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
          return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
                                                 ^~~~~~~~~~~~
  include/asm-generic/bitops/const_hweight.h:29:49: note: expanded from macro 'hweight64'
   define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
                                                  ^~~~~~~~~~~~~~~~~~~~
  include/asm-generic/bitops/const_hweight.h:21:76: note: expanded from macro '__const_hweight64'
   define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
                                                                             ^  ~~
  include/asm-generic/bitops/const_hweight.h:20:49: note: expanded from macro '__const_hweight32'
   define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
                                                  ^
  include/asm-generic/bitops/const_hweight.h:19:72: note: expanded from macro '__const_hweight16'
   define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
                                                                         ^
  include/asm-generic/bitops/const_hweight.h:12:9: note: expanded from macro '__const_hweight8'
            (!!((w) & (1ULL << 2))) +     \

Adding an explicit cast to __u64 avoids that warning and makes it easier
to read other output.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: http://lkml.kernel.org/r/20200505135513.65265-1-arnd@arndb.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index e02cbca3cfaf..5c1522ed2d7c 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -50,7 +50,7 @@ static inline int get_bitmask_order(unsigned int count)
 
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+	return sizeof(w) == 4 ? hweight32(w) : hweight64((__u64)w);
 }
 
 /**
-- 
2.25.1

