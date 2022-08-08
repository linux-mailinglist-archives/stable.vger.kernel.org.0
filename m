Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAE58BF6F
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242558AbiHHBj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbiHHBjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AEA101E8;
        Sun,  7 Aug 2022 18:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C75FB80881;
        Mon,  8 Aug 2022 01:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6F9C433D6;
        Mon,  8 Aug 2022 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922456;
        bh=OXZCHrkyCbLkl9jdNZjncEsvl/fTVJvTADUZUqZjCQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQFmdkU41tDMC4A87SJPORp6HYly3/7e4SOJxo/MEODsNaAAIYjF0/wgzK5FDAI70
         sgsCVRuQby2bzxQWVF7mdKdQlEUDi7tUf18BDeQshbZkjsGQHV6G71duwubsSXga1+
         iOcGGpWVMailaN8TRrkoJiuW55QtmB719gvWgnVZ2PMrA0F0vs2FB+IgOs4GLB2aXu
         hqMBoSmAMddk858/PnswGcFPB0zdgu2LwJf5pDHkW+8lRAathNoHDU2z8OIreOO+gj
         st+Ok1buJl7E1HwPAa1Hx85rLb8GIkbGLXgVjAoUgyLm4Ti9oDoMAK1K3YM3C1hQUN
         58vN3w9GeB9lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, broonie@kernel.org, keescook@chromium.org,
        Vincenzo.Frascino@arm.com, mark.rutland@arm.com,
        christophe.leroy@csgroup.eu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 06/53] arm64: Do not forget syscall when starting a new thread.
Date:   Sun,  7 Aug 2022 21:33:01 -0400
Message-Id: <20220808013350.314757-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index 6b1a12c23fe7..7058bf047fa5 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -250,8 +250,9 @@ void tls_preserve_current_state(void);
 
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

