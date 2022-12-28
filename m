Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F796583A1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiL1Qt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiL1QtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:49:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3FC1BE94
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B04261562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931E4C433D2;
        Wed, 28 Dec 2022 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245865;
        bh=n+UO3JEjJNtE6E7bl5JwaGCjw+WpyVJcpCgHb+zK70g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CofhFlf9s+80h2UB7KVjTKqc6m+D9jj5A/Hk2TAXHzyXNicw6yLogfUGLGOEMeXuo
         67H30su6pj+mG31SCXKnKfEjzZ0iUguaPRqo2WKfC5PQuHv0mwFHno98q0TNgRoNtV
         HSXWaGQ3LQVHHH3sp9fTLneUqta5usbNO44BCKW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0938/1146] arm64: make is_ttbrX_addr() noinstr-safe
Date:   Wed, 28 Dec 2022 15:41:17 +0100
Message-Id: <20221228144355.783093949@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 445aa3af3b76..400f8956328b 100644
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



