Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4D5272DB5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgIUQmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgIUQmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E71962076B;
        Mon, 21 Sep 2020 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706550;
        bh=JjI7tmlTe6V+0LJ0iEocrtfons5BMVWa14ZnxKc5uF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIgoscwAfcAJeWNjf03/w99p0WGqtN7AYymr0IAYSYCzpQ4SAOr/PS3Hmyo+7rSlw
         KhxAYQWUUrd87711EB9IEyR8jTaOc2jNoUk8o8aVRc9+lcbELTI15UQWPq3SDws1z7
         lWDupMM3+CVrAihNpT7J3F5lg2jfWOALtG4tTEkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/49] openrisc: Fix cache API compile issue when not inlining
Date:   Mon, 21 Sep 2020 18:28:02 +0200
Message-Id: <20200921162035.473614391@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 3ae90d764093dfcd6ab8ab6875377302892c87d4 ]

I found this when compiling a kbuild random config with GCC 11.  The
config enables CONFIG_DEBUG_SECTION_MISMATCH, which sets CFLAGS
-fno-inline-functions-called-once. This causes the call to cache_loop in
cache.c to not be inlined causing the below compile error.

    In file included from arch/openrisc/mm/cache.c:13:
    arch/openrisc/mm/cache.c: In function 'cache_loop':
    ./arch/openrisc/include/asm/spr.h:16:27: warning: 'asm' operand 0 probably does not match constraints
       16 | #define mtspr(_spr, _val) __asm__ __volatile__ (  \
	  |                           ^~~~~~~
    arch/openrisc/mm/cache.c:25:3: note: in expansion of macro 'mtspr'
       25 |   mtspr(reg, line);
	  |   ^~~~~
    ./arch/openrisc/include/asm/spr.h:16:27: error: impossible constraint in 'asm'
       16 | #define mtspr(_spr, _val) __asm__ __volatile__ (  \
	  |                           ^~~~~~~
    arch/openrisc/mm/cache.c:25:3: note: in expansion of macro 'mtspr'
       25 |   mtspr(reg, line);
	  |   ^~~~~
    make[1]: *** [scripts/Makefile.build:283: arch/openrisc/mm/cache.o] Error 1

The asm constraint "K" requires a immediate constant argument to mtspr,
however because of no inlining a register argument is passed causing a
failure.  Fix this by using __always_inline.

Link: https://lore.kernel.org/lkml/202008200453.ohnhqkjQ%25lkp@intel.com/
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/mm/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/openrisc/mm/cache.c b/arch/openrisc/mm/cache.c
index b747bf1fc1b63..4272d9123f9ed 100644
--- a/arch/openrisc/mm/cache.c
+++ b/arch/openrisc/mm/cache.c
@@ -20,7 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-static void cache_loop(struct page *page, const unsigned int reg)
+static __always_inline void cache_loop(struct page *page, const unsigned int reg)
 {
 	unsigned long paddr = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long line = paddr & ~(L1_CACHE_BYTES - 1);
-- 
2.25.1



