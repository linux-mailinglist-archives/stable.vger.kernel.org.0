Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A91A592D66
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiHOIsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 04:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiHOIsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 04:48:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F420201BD;
        Mon, 15 Aug 2022 01:48:18 -0700 (PDT)
Date:   Mon, 15 Aug 2022 08:48:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660553295;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQWaK8qY9Rujxh5W8uD3V8R2QS0vMhGEuhjPCTuRwls=;
        b=CFnq38Jv4Tv7DdZXatgSSbvmXgToh6MDdUX2c12W0K20KA+khqiM9npOUq532h9tUywYQe
        SaLXjHFKahEsvLHs/bylDHaZUc1NB5P9Sm8xFZf4COkFck2Hcmn0/5e4KPNAwUpvccDOfd
        2mnj1fE+S0UkDTRXZFtge/EkxULjjvtEBv2OAMWK3GHXg9wNnX4IlbwVTvHqGJ7Y5zyfUn
        B1z0ZZatqB5+uMJQVIIIHP9BcD0rJLWu2QrlYv2sj7rYR9+S6kK3jdSqYCTnnW0cYmJnbz
        nyG8ExWyzNDHsdm550Jr4sdumT6Y2JIKU7Dm2V54FkwUY8PXeO6M1PwDUje1Yw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660553295;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQWaK8qY9Rujxh5W8uD3V8R2QS0vMhGEuhjPCTuRwls=;
        b=Uimj+IhKe/i5RBJFtwJv1o1V+LRKQs2OnOwtNmReyYwZsG5m8KukOKlTRXz9gAOx8//7iq
        0oXBlCVtGFCsTICg==
From:   "tip-bot2 for Nadav Amit" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] x86/kprobes: Fix JNG/JNLE emulation
Cc:     Nadav Amit <namit@vmware.com>, Ingo Molnar <mingo@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220813225943.143767-1-namit@vmware.com>
References: <20220813225943.143767-1-namit@vmware.com>
MIME-Version: 1.0
Message-ID: <166055329407.401.4288744100235226056.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     8924779df820c53875abaeb10c648e9cb75b46d4
Gitweb:        https://git.kernel.org/tip/8924779df820c53875abaeb10c648e9cb75b46d4
Author:        Nadav Amit <namit@vmware.com>
AuthorDate:    Sat, 13 Aug 2022 15:59:43 -07:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sun, 14 Aug 2022 11:27:17 +02:00

x86/kprobes: Fix JNG/JNLE emulation

When kprobes emulates JNG/JNLE instructions on x86 it uses the wrong
condition. For JNG (opcode: 0F 8E), according to Intel SDM, the jump is
performed if (ZF == 1 or SF != OF). However the kernel emulation
currently uses 'and' instead of 'or'.

As a result, setting a kprobe on JNG/JNLE might cause the kernel to
behave incorrectly whenever the kprobe is hit.

Fix by changing the 'and' to 'or'.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220813225943.143767-1-namit@vmware.com
---
 arch/x86/kernel/kprobes/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 74167dc..4c3c27b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -505,7 +505,7 @@ static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
 			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (p->ainsn.jcc.type >= 0xe)
-			match = match && (regs->flags & X86_EFLAGS_ZF);
+			match = match || (regs->flags & X86_EFLAGS_ZF);
 	}
 	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
 }
