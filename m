Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5348B682854
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjAaJLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjAaJLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 04:11:30 -0500
X-Greylist: delayed 583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 01:08:30 PST
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 582F24B185;
        Tue, 31 Jan 2023 01:08:30 -0800 (PST)
Received: from cap.home.8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 0403F22407A;
        Tue, 31 Jan 2023 09:57:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1675155440;
        bh=tjpmrJmEC8/t0L/DgQl6lz3ODpFwS2ZQUFHcwjQbBD4=;
        h=From:To:Cc:Subject:Date:From;
        b=G4EJSS3ZR19gw9wllrj689Nrveho1wdJgPwWYf6gmIAFBmGd4SNBbBS2/zGqwo6mj
         ejnOjzP2RB+vZKyFmZ7T90e/UtIqDerJ1gMjDXjok6JXT9bsHe+mlkjc2ORkZi31Oy
         TdLqsoldJbbWY2TUTL/w3Z11aV+GhCx5+70y+oysVX6Y/hkLHD+56Y6n+BNGDRUrVf
         viu0RDsT9HXGWFPVpRNUFm1PdaJhCgSyydpgu9GA3gtCmNlD4NXbU6Gi2FYYWOJzlt
         SBmJJvPvMYZRT527Qz3vItuYSr/EPAm1VP9bKYIjmY5MZwpivhFB4gL17jAWPtq60s
         9G0ZMLp3rZ/Rw==
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, hpa@zytor.com,
        Joerg Roedel <jroedel@suse.de>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        Alexey Kardashevskiy <aik@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] x86/debug: Fix stack recursion caused by DR7 accesses
Date:   Tue, 31 Jan 2023 09:57:18 +0100
Message-Id: <20230131085718.16009-1-joro@8bytes.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

In kernels compiled with CONFIG_PARAVIRT=n the compiler re-orders the
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

  [ bp: Massage text. ]

Cc: stable@vger.kernel.org
Fixes: 315562c9af3d ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/debugreg.h | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d950612f..d54d5dbfb4b9 100644
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
+		asm("mov %%db7, %0" : "=r" (val) : __FORCE_ORDER);
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
+		asm("mov %0, %%db7"	::"r" (value), __FORCE_ORDER); break;
 	default:
 		BUG();
 	}
-- 
2.39.0

