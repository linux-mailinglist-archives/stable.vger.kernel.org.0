Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84F5593CF4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346489AbiHOUWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346705AbiHOUU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:20:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EFF98593;
        Mon, 15 Aug 2022 12:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5478661296;
        Mon, 15 Aug 2022 19:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64917C433D7;
        Mon, 15 Aug 2022 19:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590055;
        bh=OXZCHrkyCbLkl9jdNZjncEsvl/fTVJvTADUZUqZjCQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aN1BkbY+KLSQkrTgvUEdYovoo16s5rceueAAgF3lQGRh3NBZKlEqgy+3QCNUbZqad
         dJ4RkAwJ9BeeRmdg+PdJFXp85KDe2bPlfYTiiKcdIckA7wnr/fHjl+as69LDyWfwJ8
         ccAhNdp5Zhdwr6lPtK4TjvoV4lZQ3xgQkOy8hTSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0137/1095] arm64: Do not forget syscall when starting a new thread.
Date:   Mon, 15 Aug 2022 19:52:16 +0200
Message-Id: <20220815180435.259796503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



