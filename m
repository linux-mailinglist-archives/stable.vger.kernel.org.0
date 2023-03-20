Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7D6C082C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjCTBGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjCTBFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E11206A3;
        Sun, 19 Mar 2023 17:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E1A611FA;
        Mon, 20 Mar 2023 00:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8C9C433EF;
        Mon, 20 Mar 2023 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273826;
        bh=6p5ARjw7NtCvfwJniRKWDiBaO/KRjZ5Zm2VYjEBLCuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6SmpHPzQNuE9H5L/cYAfz0l2rBXhm81xgAPTeB3Sc9TXmPjJBM2k/2RyGV4dvQSm
         j1cxgbFGX3rg6ulVmhZcpCUmRRmHzH5h8mhpvWKQIRsDDexJG03zqmDo2OFlt/GLXb
         r4/kaV4lHUEhN9wDE9RRIJN29CFNvk6epw+a9Vji6bca+RXle6MrcVE5FroLZ/GUrU
         6oHYZMwHeZnGlmBmTBdnKBRzcxBAL6bbIbh3nMYCm49q48RB1jWO0L2WEvJpg2rlvL
         /vh9LKpjUyJ6pdeFrioJoresVcNYHrWEvkHw+qd8tQ6K2M79IoHXrg2Nr54jizXBBn
         h1SEJkF4HDeJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Rich Felker <dalias@libc.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ysato@users.sourceforge.jp,
        rmk+kernel@armlinux.org.uk, shorne@gmail.com, bcain@quicinc.com,
        mpe@ellerman.id.au, wangkefeng.wang@huawei.com,
        linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/12] sh: sanitize the flags on sigreturn
Date:   Sun, 19 Mar 2023 20:56:35 -0400
Message-Id: <20230320005636.1429242-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
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
index 0e0ecc0132e3b..58ae979798fa8 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -51,6 +51,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 24473fa6c3b63..f6e1a47ad7ca0 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -116,6 +116,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -131,6 +132,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;
-- 
2.39.2

