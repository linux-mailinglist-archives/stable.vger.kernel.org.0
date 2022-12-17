Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF41E64F5D8
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiLQANi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiLQAMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348DB36D45;
        Fri, 16 Dec 2022 16:11:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C393C622C8;
        Sat, 17 Dec 2022 00:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186B5C433D2;
        Sat, 17 Dec 2022 00:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235868;
        bh=GGH++P1BIAxQRI2nLwZUP/1q16Czvf47MMs+3TpiWu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wnvoa80X19jLZDDSYkfq6IRur3AjmP3m/tPAu9Hkmdo0TVZbBgrwLFFZH5r8Gk35d
         eFTR5k0PvtUsLH7BxKWnn7frLDfGa8mC1YUV8XA9WfYDJZsVKqQAZvQNR9D2Un6pKY
         rkzA6D/aq0y/ZQRWTYAYQUW9A/7vcU8WFfl813F/xSF4DW61RHnSzEltcW2UoIyUe0
         IBNdG66taUTo3t8jmwtyBNzMxjjZq85vylrh0AwYmGvFlWqAxUp6jYtOYc7kEsZQK4
         zYCdma6sIoevSkchuapr9m8TPKKhMkEMjcpS5CLyj2ymkQzD+ymnVdeZOhG99YW+UZ
         J6/CWqyeIYp3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        broonie@kernel.org, keescook@chromium.org,
        wangkefeng.wang@huawei.com, flaniel@linux.microsoft.com,
        christophe.leroy@csgroup.eu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 2/5] arm64: make is_ttbrX_addr() noinstr-safe
Date:   Fri, 16 Dec 2022 19:10:54 -0500
Message-Id: <20221217001058.41426-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001058.41426-1-sashal@kernel.org>
References: <20221217001058.41426-1-sashal@kernel.org>
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
index 7c546c3487c9..c628d8e3a403 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -230,13 +230,13 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
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

