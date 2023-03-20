Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE89D6C0736
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCTA4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCTAzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:55:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C048113D4;
        Sun, 19 Mar 2023 17:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6668DB80D49;
        Mon, 20 Mar 2023 00:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FFCC4339E;
        Mon, 20 Mar 2023 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273643;
        bh=wIMMwK89KStOb42+4eP014hy8v2pJD2GJYpw7okucq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdPWRZ5QeLDf3CWCTqciZrzF4P6wn26G+X3oes55ZkRHXfq7XV/a4Hagn0C+MXP2C
         qEaJTaMULMhYnjRiDALXO7QFWIjDH206sxjSBijVIlsnJhDwCV5v2qjUlQthKrUM8D
         iaQEA2yV+CIWMkUQm2uqv+IH7X+05wqDMQWSS6TJepYUQagf5qTlrlqjOEylOnLGjo
         32tj7ZgpTJFw7dMGLWLcwWUymvZZTNHTCG9rWyJGh14RMAMnXtOHuCb9VesNQqpIqM
         F8CepsQwi7qxyvU89C5i3wDIkDNIwPZ3OnYIZEhPYY7LOtFdviGMZFChx8C2HYbkIR
         D5vxWbn9g7ltA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Rich Felker <dalias@libc.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ysato@users.sourceforge.jp,
        chenhuacai@kernel.org, akpm@linux-foundation.org,
        mpe@ellerman.id.au, geert@linux-m68k.org, guoren@kernel.org,
        wangkefeng.wang@huawei.com, linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 28/30] sh: sanitize the flags on sigreturn
Date:   Sun, 19 Mar 2023 20:52:53 -0400
Message-Id: <20230320005258.1428043-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 573b22ccb7ce9ab7f0539a2e11a9d3609a8783f5 ]

We fetch %SR value from sigframe; it might have been modified by signal
handler, so we can't trust it with any bits that are not modifiable in
user mode.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/processor_32.h | 1 +
 arch/sh/kernel/signal_32.c         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index 27aebf1e75a20..3ef7adf739c83 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -50,6 +50,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 90f495d35db29..a6bfc6f374911 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -115,6 +115,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -130,6 +131,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;
-- 
2.39.2

