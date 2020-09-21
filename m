Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A702272EF5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgIUQxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgIUQsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7584120874;
        Mon, 21 Sep 2020 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706893;
        bh=R7mR3aLIf2CGGcWqGZaqKCMfrWa7L3YNwpWo4rPGCRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTN3x/5mnkkiBLJZNO22+HD1G6G5FyQ7gCl06uOk7YO9RCwpS4Hzo60L+V5yFSKuq
         ihyCNA1zmuhlhixGBHgSI5ioXrBLy0cha/eHBYLkO1hSCfDZUzq8qewg1XUnaWPYBI
         wICgryI23NnvvthgmJ/oxHoizI3oD/fBibfcevcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/72] openrisc: Fix cache API compile issue when not inlining
Date:   Mon, 21 Sep 2020 18:30:57 +0200
Message-Id: <20200921163122.740158534@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
index 08f56af387ac4..534a52ec5e667 100644
--- a/arch/openrisc/mm/cache.c
+++ b/arch/openrisc/mm/cache.c
@@ -16,7 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-static void cache_loop(struct page *page, const unsigned int reg)
+static __always_inline void cache_loop(struct page *page, const unsigned int reg)
 {
 	unsigned long paddr = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long line = paddr & ~(L1_CACHE_BYTES - 1);
-- 
2.25.1



