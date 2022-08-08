Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69A958C0F0
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbiHHB5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiHHBzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:55:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1311BDE9E;
        Sun,  7 Aug 2022 18:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830F460DF5;
        Mon,  8 Aug 2022 01:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A3AC433D7;
        Mon,  8 Aug 2022 01:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922757;
        bh=qLA7A5Br4kr6XCh5cM4QAi+8idAHdklGHyK/3mm2rt8=;
        h=From:To:Cc:Subject:Date:From;
        b=HXANQIerr8cVL//nUnAQgwkkFP3cB6pYuN0Wo7ermCyxq4SbEvgy4EJjefFDKcrqK
         WAIIMnq03gJdzvGJLzWMooxOGrI9yldB7NENFPz+808IQ10uVcEuHkL7kmjsFbZ6Yn
         V3EOXUPD7y9VX1f3AFzBn4GxqtJMDoocI5VS1+E4xH92uKM59kwoek4CEoCqd0b3np
         alpHF2MUES49gP65PSGPKf5tlKQlf2ea71QDJtVAlfYujuUMVA6hivdN0eNVNfeeHX
         aFVFBgJ1cFJDrbYGEtsSBX8pH8bowR/gFamEBtTAvd2/LMB6R3gj1llJSDvrr8C8AQ
         d0DAGYGciu18g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, broonie@kernel.org, keescook@chromium.org,
        peterz@infradead.org, christophe.leroy@csgroup.eu,
        mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/16] arm64: Do not forget syscall when starting a new thread.
Date:   Sun,  7 Aug 2022 21:38:58 -0400
Message-Id: <20220808013914.316709-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index 773ea8e0e442..f81074c68ff3 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -172,8 +172,9 @@ void tls_preserve_current_state(void);
 
 static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 {
+	s32 previous_syscall = regs->syscallno;
 	memset(regs, 0, sizeof(*regs));
-	forget_syscall(regs);
+	regs->syscallno = previous_syscall;
 	regs->pc = pc;
 }
 
-- 
2.35.1

