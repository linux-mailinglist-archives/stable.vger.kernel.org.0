Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130A559E11A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357268AbiHWLNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243237AbiHWLLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:11:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA96B7EC2;
        Tue, 23 Aug 2022 02:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21B7561226;
        Tue, 23 Aug 2022 09:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D60DC433C1;
        Tue, 23 Aug 2022 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246263;
        bh=dVAKuP0k3jQdgg3zKm/je6I06KVgigLnek50Bw8I6pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apMqfAM3kW4UEpny4YxsRJnbhb13wrr+Ois7AWHCV6KX06g0jhqTQ+I26ZXQinaNy
         aPuSTIPElkN3Scs/6Xic8CntWEf/6UR/wb51U5NyeYm9aAE5RTCuc7ddiTzZ48K3T5
         peFbTLWl7yrOF2O40xLN8h4DqZdRo9L+ArRjbtdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/389] arm64: Do not forget syscall when starting a new thread.
Date:   Tue, 23 Aug 2022 10:22:11 +0200
Message-Id: <20220823080117.834095352@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 5623685c7d13..65834b84f0e1 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -184,8 +184,9 @@ void tls_preserve_current_state(void);
 
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



