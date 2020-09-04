Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E328525D8F2
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 14:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgIDMts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 08:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbgIDMto (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 08:49:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E77FC061245;
        Fri,  4 Sep 2020 05:49:43 -0700 (PDT)
Date:   Fri, 04 Sep 2020 12:49:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599223780;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDcXx7KcW7BLVNUL2Yp5Fuis4zCu46v+olrott20Pss=;
        b=cK+TYUHg9RPacEFUkVfbkcc4TL2IHl9ghPQKMsus8xbN8NWTwh7hlVS8WkL9DgsTacozVy
        N50ENtULylynP0dIzD5KQwoANNnqmE259R50fioYgkvsWPjk3KW3QxzmlyJI5RdT2hENiX
        anbovKAkQNpcWmcrs/cy8xhgRsc/MTMZ1Kdy9DizHcFg+U39xPZmcTuzO36k+ROyQTt4O/
        JIFUOmCxIs0f+iS8tCzE6pZOd8NU9m2FmQjnFOdxnL1nB7e1smMUaRfRSHEqA+5z9dldqW
        oNmKc0Dy3lGovgSH0c+aoDJgyKOgOwV2KmAM2+8DlHvDo95J4MRCRPgswt5jVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599223780;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDcXx7KcW7BLVNUL2Yp5Fuis4zCu46v+olrott20Pss=;
        b=YGWlVFRGi8Tm5jYWvxTFOtS4EHjjk/1Y+JOvd/555982ggta56GltK/LZJvPXQ+D4ifXzj
        XX6RPznTkz+3cGCg==
From:   "tip-bot2 for Vamshi K Sthambamkadi" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] tracing/kprobes, x86/ptrace: Fix regs argument
 order for i386
Cc:     Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200828113242.GA1424@cosmos>
References: <20200828113242.GA1424@cosmos>
MIME-Version: 1.0
Message-ID: <159922377983.20229.5292058689006247629.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     2356bb4b8221d7dc8c7beb810418122ed90254c9
Gitweb:        https://git.kernel.org/tip/2356bb4b8221d7dc8c7beb810418122ed90254c9
Author:        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
AuthorDate:    Fri, 28 Aug 2020 17:02:46 +05:30
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 04 Sep 2020 14:40:42 +02:00

tracing/kprobes, x86/ptrace: Fix regs argument order for i386

On i386, the order of parameters passed on regs is eax,edx,and ecx
(as per regparm(3) calling conventions).

Change the mapping in regs_get_kernel_argument(), so that arg1=ax
arg2=dx, and arg3=cx.

Running the selftests testcase kprobes_args_use.tc shows the result
as passed.

Fixes: 3c88ee194c28 ("x86: ptrace: Add function argument access API")
Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200828113242.GA1424@cosmos
---
 arch/x86/include/asm/ptrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 40aa69d..d8324a2 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -327,8 +327,8 @@ static inline unsigned long regs_get_kernel_argument(struct pt_regs *regs,
 	static const unsigned int argument_offs[] = {
 #ifdef __i386__
 		offsetof(struct pt_regs, ax),
-		offsetof(struct pt_regs, cx),
 		offsetof(struct pt_regs, dx),
+		offsetof(struct pt_regs, cx),
 #define NR_REG_ARGUMENTS 3
 #else
 		offsetof(struct pt_regs, di),
