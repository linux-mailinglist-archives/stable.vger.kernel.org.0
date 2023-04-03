Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362616D482D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjDCO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbjDCO01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:26:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEACC319B0
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A481EB81C0B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF902C433EF;
        Mon,  3 Apr 2023 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531972;
        bh=P6vD6BAEdEhDdhlgw4psgjaRokQKZmpTxdO+jiaYJFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ow0JX6YoUsPGmYa0eIw0ycsDq1SDADc5bZ+BPpUVpoyzB3UvegYTm39u/oa0bs0cV
         DELoQ7iGQ+gM0iZ/VOp7CEPDLuI3J9GfJMajwUYXTtB1CENEQ2p2HB1rTiD5St7i9n
         aWWc1ndk5ITLOiXPtGSpYBISepQ10EQCoflQpnDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Rich Felker <dalias@libc.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/173] sh: sanitize the flags on sigreturn
Date:   Mon,  3 Apr 2023 16:08:11 +0200
Message-Id: <20230403140416.887428711@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index aa92cc933889d..6c7966e627758 100644
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
index dd3092911efad..dc13702003f0f 100644
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



