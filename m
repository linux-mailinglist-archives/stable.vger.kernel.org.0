Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A33258BEC5
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241988AbiHHBcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241999AbiHHBcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB201BC9B;
        Sun,  7 Aug 2022 18:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64327B80E05;
        Mon,  8 Aug 2022 01:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CDEC433D7;
        Mon,  8 Aug 2022 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922316;
        bh=VnNBqVs1pLaOy6COvbcSfRz66B+e9FtCkBJlFPM059I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nj+JGsKSd9CAImc48stiY0oESQmtJp8l8t4zKQ0230yToVgb7vj81UZFLkXWPiVQF
         yP8sstbTrzr7zDahw4mH5pkBsCKblvwTy6i0dVRFLWBrji6SdxIhS7T/HcjX4AerZq
         9SjL3vveuM9ri3oOLGEGeHpVzxMIhDRtjNxEEWO3CQoctRKGXrafKTJR6RhbJi67Zs
         rXNAcViNIyTuLvk034+LHhysptabz8Zdw5UJHstDU821vkdre79OGw/u5/AVN9jL2c
         oyQPp6yYnrKI8SgvGD6aCkFLWEAUaG95EWOUO4Nh4SUuMgVDjl9aZzjP/byQ+qbxLU
         v4g41b+YF6iZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, broonie@kernel.org, keescook@chromium.org,
        christophe.leroy@csgroup.eu, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 08/58] arm64: Do not forget syscall when starting a new thread.
Date:   Sun,  7 Aug 2022 21:30:26 -0400
Message-Id: <20220808013118.313965-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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
index 9e58749db21d..86eb0bfe3b38 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -272,8 +272,9 @@ void tls_preserve_current_state(void);
 
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

