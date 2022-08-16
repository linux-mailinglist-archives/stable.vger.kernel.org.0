Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161BF595766
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiHPKC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiHPKCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:02:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC097D4D;
        Tue, 16 Aug 2022 01:21:20 -0700 (PDT)
Date:   Tue, 16 Aug 2022 08:21:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660638078;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Y1v2IK8+LOJMwik9pqNv5XiNJf0jxVXzKJnsprp5tU=;
        b=vTH6ldSS/xARxGEdfDvF0G19q14tquMuzr35bAR8PpAqWIOUObp9bshs05iNsC9VCCTTrI
        nkPem8jEHUNaCtgZJUajAA2ik3ohKPvDHBEt6Easu9FbPzBZFU38wft0SRTe5czBmFdS4X
        RrWFnbxc+mOpIrb1sgG1iBLd5KSg+utkhM4kRLLPGMxJrlT556BDyQwzhVnCwn8WwMu8YV
        sU9kik8mXQbVUhbgFhS6G3Caw4kJPiPokNcwaKC6JeMfFi8z3TqppManDbhrWIMjeVVL5d
        j5YiptesoXSKN5C11pPcfiKy1qmC26bLzN7A9JqDn+18viTXOncMAtaI+RWSpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660638078;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Y1v2IK8+LOJMwik9pqNv5XiNJf0jxVXzKJnsprp5tU=;
        b=W8+W82bpnAiXRMuyyQP3S3y3C19BQ9xo7m+yuVVvLCo1L2OIsKkClPO/UmEWmTUXCxXJ3+
        t7BEZQYzSm98pMBg==
From:   "tip-bot2 for Juergen Gross" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Fix entry_INT80_compat for Xen PV guests
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Jan Beulich <jbeulich@suse.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220816071137.4893-1-jgross@suse.com>
References: <20220816071137.4893-1-jgross@suse.com>
MIME-Version: 1.0
Message-ID: <166063807735.401.8176366519215058221.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5b9f0c4df1c1152403c738373fb063e9ffdac0a1
Gitweb:        https://git.kernel.org/tip/5b9f0c4df1c1152403c738373fb063e9ffdac0a1
Author:        Juergen Gross <jgross@suse.com>
AuthorDate:    Tue, 16 Aug 2022 09:11:37 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 16 Aug 2022 10:02:52 +02:00

x86/entry: Fix entry_INT80_compat for Xen PV guests

Commit

  c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")

missed one use case of SWAPGS in entry_INT80_compat(). Removing of
the SWAPGS macro led to asm just using "swapgs", as it is accepting
instructions in capital letters, too.

This in turn leads to splats in Xen PV guests like:

  [   36.145223] general protection fault, maybe for address 0x2d: 0000 [#1] PREEMPT SMP NOPTI
  [   36.145794] CPU: 2 PID: 1847 Comm: ld-linux.so.2 Not tainted 5.19.1-1-default #1 \
	  openSUSE Tumbleweed f3b44bfb672cdb9f235aff53b57724eba8b9411b
  [   36.146608] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 11/14/2013
  [   36.148126] RIP: e030:entry_INT80_compat+0x3/0xa3

Fix that by open coding this single instance of the SWAPGS macro.

Fixes: c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@vger.kernel.org> # 5.19
Link: https://lore.kernel.org/r/20220816071137.4893-1-jgross@suse.com
---
 arch/x86/entry/entry_64_compat.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 682338e..4dd1981 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -311,7 +311,7 @@ SYM_CODE_START(entry_INT80_compat)
 	 * Interrupts are off on entry.
 	 */
 	ASM_CLAC			/* Do this early to minimize exposure */
-	SWAPGS
+	ALTERNATIVE "swapgs", "", X86_FEATURE_XENPV
 
 	/*
 	 * User tracing code (ptrace or signal handlers) might assume that
