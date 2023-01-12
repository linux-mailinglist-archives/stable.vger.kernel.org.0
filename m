Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D145667692
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjALOdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbjALOcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:32:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEA25E66D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 959F5B81DB2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE65FC433D2;
        Thu, 12 Jan 2023 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533454;
        bh=GGH++P1BIAxQRI2nLwZUP/1q16Czvf47MMs+3TpiWu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV70j0njSynIwbYhYY68dALTeW8kKpyETIs9wTd7QwV0x27ppp8537uLH0S68BU3G
         koEj1GH/uYGN860yjChgtZzKvqOVgJCmm5ZSwic7evCKBk4rheInVyzuV2aIn3a8dS
         DsHYJdUIz+07rnFhkJBb5xDpNlK+8M28R0Uxld/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/783] arm64: make is_ttbrX_addr() noinstr-safe
Date:   Thu, 12 Jan 2023 14:53:20 +0100
Message-Id: <20230112135546.623935220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



