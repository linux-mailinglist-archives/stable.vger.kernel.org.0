Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5BA682AA4
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjAaKha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 05:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjAaKh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 05:37:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C731422A;
        Tue, 31 Jan 2023 02:37:28 -0800 (PST)
Date:   Tue, 31 Jan 2023 10:37:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675161446;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nyVX6UzHAlhc/7AFEArzgMDPUZiXMu6IpVjRekl/mg=;
        b=P8+toq3p29CR4+cYjcPhrOy9rdktq6yNXLxJP6hIqwM8wHGP/49aeHHGHsCWDeUjEwK1yF
        WVTO/k43BZSK6joUQUHJ7jqzwwxxSgO2YyJiyN9EYf7x/HuhlISHOuI2ddRTRHcYBo32C0
        3xWF4kFIpEGHWnO6bGasc4cC4FyePdru2atKWxSt7fDcIpEJSpWLXP56ZSDPQPfpZmqukI
        vlHMXtIdWdjLvKxCNLEkioG7vJCXjI5DqEPItx9vy/ht8o1vSPk6PEjA2ycVl3wYSFYpSP
        nK1i9SELJCkrAHWOKg8EQXHVRV259lG+/U5e+14JPalvtM8phbYDBsCzOLuPxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675161446;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nyVX6UzHAlhc/7AFEArzgMDPUZiXMu6IpVjRekl/mg=;
        b=862MNdN/AdQilGpLLXF0q2fYC3z6FUutTf6yN5I+/hEg2a04AfLTzgWkeijDVPCmzkdUf2
        sOdTFNySdPGjvqBQ==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/debug: Fix stack recursion caused by wrongly
 ordered DR7 accesses
Cc:     Alexey Kardashevskiy <aik@amd.com>, Joerg Roedel <jroedel@suse.de>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230127035616.508966-1-aik@amd.com>
References: <20230127035616.508966-1-aik@amd.com>
MIME-Version: 1.0
Message-ID: <167516144628.4906.13176618976353474076.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     31859551393bc00f705cae2e1f9d31b80c62f365
Gitweb:        https://git.kernel.org/tip/31859551393bc00f705cae2e1f9d31b80c62f365
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Tue, 31 Jan 2023 09:57:18 +01:00
Committer:     Borislav Petkov (AMD) <bp@alien8.de>
CommitterDate: Tue, 31 Jan 2023 11:26:15 +01:00

x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

In kernels compiled with CONFIG_PARAVIRT=n, the compiler re-orders the
DR7 read in exc_nmi() to happen before the call to sev_es_ist_enter().

This is problematic when running as an SEV-ES guest because in this
environment the DR7 read might cause a #VC exception, and taking #VC
exceptions is not safe in exc_nmi() before sev_es_ist_enter() has run.

The result is stack recursion if the NMI was caused on the #VC IST
stack, because a subsequent #VC exception in the NMI handler will
overwrite the stack frame of the interrupted #VC handler.

As there are no compiler barriers affecting the ordering of DR7
reads/writes, make the accesses to this register volatile, forbidding
the compiler to re-order them.

  [ bp: Massage text, make them volatile too, to make sure some
  aggressive compiler optimization pass doesn't discard them. ]

Fixes: 315562c9af3d ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Reported-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230127035616.508966-1-aik@amd.com
---
 arch/x86/include/asm/debugreg.h | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d95..ff1a924 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -39,7 +39,20 @@ static __always_inline unsigned long native_get_debugreg(int regno)
 		asm("mov %%db6, %0" :"=r" (val));
 		break;
 	case 7:
-		asm("mov %%db7, %0" :"=r" (val));
+		/*
+		 * Apply __FORCE_ORDER to DR7 reads to forbid re-ordering them
+		 * with other code.
+		 *
+		 * This is needed because a DR7 access can cause a #VC exception
+		 * when running under SEV-ES. Taking a #VC exception is not a
+		 * safe thing to do just anywhere in the entry code and
+		 * re-ordering might place the access into an unsafe location.
+		 *
+		 * This happened in the NMI handler, where the DR7 read was
+		 * re-ordered to happen before the call to sev_es_ist_enter(),
+		 * causing stack recursion.
+		 */
+		asm volatile("mov %%db7, %0" : "=r" (val) : __FORCE_ORDER);
 		break;
 	default:
 		BUG();
@@ -66,8 +79,16 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 		asm("mov %0, %%db6"	::"r" (value));
 		break;
 	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
-		break;
+		/*
+		 * Apply __FORCE_ORDER to DR7 writes to forbid re-ordering them
+		 * with other code.
+		 *
+		 * While is didn't happen with a DR7 write (see the DR7 read
+		 * comment above which explains where it happened), add the
+		 * __FORCE_ORDER here too to avoid similar problems in the
+		 * future.
+		 */
+		asm volatile("mov %0, %%db7"	::"r" (value), __FORCE_ORDER); break;
 	default:
 		BUG();
 	}
