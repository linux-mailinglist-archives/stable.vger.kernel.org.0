Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4882625D97C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgIDNTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730329AbgIDNQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 09:16:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5FDC061244;
        Fri,  4 Sep 2020 06:16:13 -0700 (PDT)
Date:   Fri, 04 Sep 2020 13:16:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599225365;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYo4oWPndmPH1VpAsfPaaX5l0/5q804nP45ekBNCsvE=;
        b=CXWxcJSwBfNNl7/uWWf2cFw/XH3j/xrEb7IRNn2ww5+xzVxble3MmlvuoqNg/pITFTYRx7
        rvtFsmi6YkDgln7ZXjDcfLBSJD74wjgaXOmUPNPkzO3llg/wisUPXGt8NZqbke9S6+FH5V
        /5a/r0AAZ5K0CvkWNMXKmvruZxYxeMwudWsdDO2Gf7WIh/xWXbXJJwzHailgHrJxoabVfu
        3UU3zmkhs03RnHZIkLb6SwAGVDQj6eMt/NUxSNhcs6hYPh/IT5Cf8yt/QKvOTT/U4x4C+j
        cZ7U6URIJKmA6DKJk0SZqoql7cFVBvbLWm5w430G5aUeZZagIRVdkPUJujRLJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599225365;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYo4oWPndmPH1VpAsfPaaX5l0/5q804nP45ekBNCsvE=;
        b=Lt0gZDkN5FP0WS3HroUN40FXymZBsCp+UjC0KJvIQLtU5U4ejFHdHUSn5/HTuv5NY26KyG
        0DyRfiQqmSjo3yCg==
From:   "tip-bot2 for Peter Zijlstra" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Fix AC assertion
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200902133200.666781610@infradead.org>
References: <20200902133200.666781610@infradead.org>
MIME-Version: 1.0
Message-ID: <159922536478.20229.11152935257298904584.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     662a0221893a3d58aa72719671844264306f6e4b
Gitweb:        https://git.kernel.org/tip/662a0221893a3d58aa72719671844264306f6e4b
Author:        Peter Zijlstra <peterz@infradead.org>
AuthorDate:    Wed, 02 Sep 2020 15:25:50 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 04 Sep 2020 15:09:29 +02:00

x86/entry: Fix AC assertion

The WARN added in commit 3c73b81a9164 ("x86/entry, selftests: Further
improve user entry sanity checks") unconditionally triggers on a IVB
machine because it does not support SMAP.

For !SMAP hardware the CLAC/STAC instructions are patched out and thus if
userspace sets AC, it is still have set after entry.

Fixes: 3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200902133200.666781610@infradead.org

---
 arch/x86/include/asm/entry-common.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index a8f9315..6fe54b2 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -18,8 +18,16 @@ static __always_inline void arch_check_user_regs(struct pt_regs *regs)
 		 * state, not the interrupt state as imagined by Xen.
 		 */
 		unsigned long flags = native_save_fl();
-		WARN_ON_ONCE(flags & (X86_EFLAGS_AC | X86_EFLAGS_DF |
-				      X86_EFLAGS_NT));
+		unsigned long mask = X86_EFLAGS_DF | X86_EFLAGS_NT;
+
+		/*
+		 * For !SMAP hardware we patch out CLAC on entry.
+		 */
+		if (boot_cpu_has(X86_FEATURE_SMAP) ||
+		    (IS_ENABLED(CONFIG_64_BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
+			mask |= X86_EFLAGS_AC;
+
+		WARN_ON_ONCE(flags & mask);
 
 		/* We think we came from user mode. Make sure pt_regs agrees. */
 		WARN_ON_ONCE(!user_mode(regs));
