Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7E58C07B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243275AbiHHBw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243329AbiHHBuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB18ACE3A;
        Sun,  7 Aug 2022 18:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BE060EA5;
        Mon,  8 Aug 2022 01:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FE6C433D7;
        Mon,  8 Aug 2022 01:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922668;
        bh=tRMypaLnigkjeLRUmrWAejT49vT0wyzqMWkQO2IPZGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdmZcgGhFViNMtgicsuV4qxIseSgns7vYAYf5m6OKSEJRqUPJiD9JvjAIlISyuSSN
         Z4GBcdyuduKALBSOxtXh34IRJQCxejEzCDfut6J96ZVu42NK20oZVKjThp4Mm0CDQW
         MVAnyXf50CibZQOF6nP0CScfdL6+DoBAS6MOAXflIJh61yONA03wTBuyO+NKjB08/G
         wSrhNXUMHyqzM6pR40CEQmUBV3XscOo0LGl3L7wrdNQWfu76VEqbU75ZUuMlTtetD4
         R6tgWtxFlF5moIGXvkmPCKB5NEm/3aG+Si80z7VFvK/H0fgNLmjgbg/KQ64zLGeiQa
         1c8mLSc53XHCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, broonie@kernel.org, keescook@chromium.org,
        mark.rutland@arm.com, christophe.leroy@csgroup.eu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/29] arm64: Do not forget syscall when starting a new thread.
Date:   Sun,  7 Aug 2022 21:37:12 -0400
Message-Id: <20220808013741.316026-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francis Laniel <flaniel@linux.microsoft.com>

[ Upstream commit de6921856f99c11d3986c6702d851e1328d4f7f6 ]

Enable tracing of the execve*() system calls with the
syscalls:sys_exit_execve tracepoint by removing the call to
forget_syscall() when starting a new thread and preserving the value of
regs->syscallno across exec.

Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220608162447.666494-2-flaniel@linux.microsoft.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index fce8cbecd6bc..7c546c3487c9 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -194,8 +194,9 @@ void tls_preserve_current_state(void);
 
 static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 {
+	s32 previous_syscall = regs->syscallno;
 	memset(regs, 0, sizeof(*regs));
-	forget_syscall(regs);
+	regs->syscallno = previous_syscall;
 	regs->pc = pc;
 
 	if (system_uses_irq_prio_masking())
-- 
2.35.1

