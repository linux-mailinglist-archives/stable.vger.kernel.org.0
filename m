Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACCF26F04B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgIRCKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgIRCKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C1D235FA;
        Fri, 18 Sep 2020 02:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395048;
        bh=NM+pV2xFne5voKMEuTRmE4BSRip2u7Hd2NQ0ApveeOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqYJKtiQdpX+H3tFZ5P9iXv0d2qWqXercFCvqi3FyMduFXwtjGAH7jN7CchBbYNh2
         dHhxQ4SqO+b1n8fX6kq9wAkOlRil1qDGeYNZ3ogqvehcNr9W9Dz4y+igxBRUGgNRn4
         v8TOrWOAeLFeQUNvttsv8VjXUsRR6bmIFvu2I9VE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 137/206] mm/kmemleak.c: use address-of operator on section symbols
Date:   Thu, 17 Sep 2020 22:06:53 -0400
Message-Id: <20200918020802.2065198-137-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b0d14fc43d39203ae025f20ef4d5d25d9ccf4be1 ]

Clang warns:

  mm/kmemleak.c:1955:28: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
                                  ^
  mm/kmemleak.c:1955:60: warning: array comparison always evaluates to a constant [-Wtautological-compare]
        if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/895
Link: http://lkml.kernel.org/r/20200220051551.44000-1-natechancellor@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5eeabece0c178..f54734abf9466 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2039,7 +2039,7 @@ void __init kmemleak_init(void)
 	create_object((unsigned long)__bss_start, __bss_stop - __bss_start,
 		      KMEMLEAK_GREY, GFP_ATOMIC);
 	/* only register .data..ro_after_init if not within .data */
-	if (__start_ro_after_init < _sdata || __end_ro_after_init > _edata)
+	if (&__start_ro_after_init < &_sdata || &__end_ro_after_init > &_edata)
 		create_object((unsigned long)__start_ro_after_init,
 			      __end_ro_after_init - __start_ro_after_init,
 			      KMEMLEAK_GREY, GFP_ATOMIC);
-- 
2.25.1

