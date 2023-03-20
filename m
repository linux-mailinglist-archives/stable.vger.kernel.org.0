Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD926C08A1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCTBjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCTBjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:39:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0539E1E2BD;
        Sun, 19 Mar 2023 18:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF891B80D4D;
        Mon, 20 Mar 2023 00:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE6EC433EF;
        Mon, 20 Mar 2023 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273876;
        bh=Q24NRcEzhgVm8UiR9gH3LzWlYm2ehh+5ZgK6JcpA32o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnQdgeL/KBZR9NO8fuCw1aYsQEO/cMMpZ+WuB/XAPP9wBvK68JSncVYTAFSeW3gSu
         1Y2lXJ1/OGLia4+0B8ctftXaLRf069QvYKzy5GS5PV2dHeOS+HoKdk7zzQrb72aHQO
         sMqIWr4NHal1YdfXTNVp2RMMJyr1HMeZ/2L72F9HIk3L1ipk+dWFUxjWRG+KYGqsnM
         EwywAOvF329T+mZ9XWKWqIDyuagYcQHyVrL3Qxug4kWmfvWGpKOhjHoWdGdG/3ZOHd
         j3+Wy0Z3ycHAMim/dm83ti2VeC1T5iVwHd9aWutdMfAhLjRjrXq4JzStK5/Vg56rS3
         XfoVrWSJiDtyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Rich Felker <dalias@libc.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ysato@users.sourceforge.jp,
        catalin.marinas@arm.com, mpe@ellerman.id.au, geert@linux-m68k.org,
        akpm@linux-foundation.org, shorne@gmail.com,
        wangkefeng.wang@huawei.com, linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 9/9] sh: sanitize the flags on sigreturn
Date:   Sun, 19 Mar 2023 20:57:32 -0400
Message-Id: <20230320005732.1429533-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005732.1429533-1-sashal@kernel.org>
References: <20230320005732.1429533-1-sashal@kernel.org>
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
index 95100d8a0b7b4..fc94603724b86 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -57,6 +57,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index c46c0020ff55e..ce93ae78c3002 100644
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

