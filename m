Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F7D64F5AD
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiLQALs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiLQALQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61264897EF;
        Fri, 16 Dec 2022 16:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E0D0B81E2C;
        Sat, 17 Dec 2022 00:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14C9C433D2;
        Sat, 17 Dec 2022 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235823;
        bh=9IANVcxo4crwHzH7bFhCY9wy6lN3O5MCEPTQI0+8p+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lv+P7YbmWwumrcW2REJx4tOAypvFaf+C3kgsSE1j9TNmZAiinx65jvMcwsg4/SrVw
         uLN2RJrLvWhF0U8BlX9dodFyDG8eb0U9Cd6PQV5aO70+F2svecRxIt8D1reQz9tKpk
         Uoh4En0qnx2sTy+c6zH0e9KKhPQucsc4AIlgn7FpERQynUQJW+aL1e7T4twUN0LgBb
         qZhEHQhCLdtHkUv3FQzlJXEgE4UY9hPPnQOaSU8MhZ2sJhAmi1aD8UvPHJCaRzjYjk
         raUKgQuYf4uZPvqu0JGIKLcyEihNehRlEPhFyL5gAyLFU/+uR6CjPzDMnFrfX1/awm
         RzI8ayTidzO2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        broonie@kernel.org, keescook@chromium.org,
        christophe.leroy@csgroup.eu, flaniel@linux.microsoft.com,
        wangkefeng.wang@huawei.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 2/8] arm64: make is_ttbrX_addr() noinstr-safe
Date:   Fri, 16 Dec 2022 19:10:06 -0500
Message-Id: <20221217001013.41239-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001013.41239-1-sashal@kernel.org>
References: <20221217001013.41239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit d8c1d798a2e5091128c391c6dadcc9be334af3f5 ]

We use is_ttbr0_addr() in noinstr code, but as it's only marked as
inline, it's theoretically possible for the compiler to place it
out-of-line and instrument it, which would be problematic.

Mark is_ttbr0_addr() as __always_inline such that that can safely be
used from noinstr code. For consistency, do the same to is_ttbr1_addr().
Note that while is_ttbr1_addr() calls arch_kasan_reset_tag(), this is a
macro (and its callees are either macros or __always_inline), so there
is not a risk of transient instrumentation.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221114144042.3001140-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 86eb0bfe3b38..d9144b6e078c 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -308,13 +308,13 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 }
 #endif
 
-static inline bool is_ttbr0_addr(unsigned long addr)
+static __always_inline bool is_ttbr0_addr(unsigned long addr)
 {
 	/* entry assembly clears tags for TTBR0 addrs */
 	return addr < TASK_SIZE;
 }
 
-static inline bool is_ttbr1_addr(unsigned long addr)
+static __always_inline bool is_ttbr1_addr(unsigned long addr)
 {
 	/* TTBR1 addresses may have a tag if KASAN_SW_TAGS is in use */
 	return arch_kasan_reset_tag(addr) >= PAGE_OFFSET;
-- 
2.35.1

