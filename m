Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7994D6949FE
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjBMPDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjBMPDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE91E2BC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4366B6112D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFDCC433EF;
        Mon, 13 Feb 2023 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300601;
        bh=RmEmJqi8nHEWRnZN7zfEzZ+dEV/cAgnlnPb8SEltXAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdC2fqc68Ol+vcuD4c/vPoQEjjshy6vcV4R40dfZehUlCVhR/nyztPwXSPkbTMkot
         7f01pxT6tdzUS4WVWsYeihCY5V9mfWilgBzatnmXHUgx1EGzay8aHZAJUb6IrGVh0D
         c1/CDV+qKXYHQFgdbIqyVyKmQSbfeyoYvbqTYE8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 077/139] x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses
Date:   Mon, 13 Feb 2023 15:50:22 +0100
Message-Id: <20230213144749.907047123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 9d2c7203ffdb846399b82b0660563c89e918c751 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/debugreg.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d950612f..ca97442e8d49 100644
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
@@ -66,7 +79,16 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 		asm("mov %0, %%db6"	::"r" (value));
 		break;
 	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
+		/*
+		 * Apply __FORCE_ORDER to DR7 writes to forbid re-ordering them
+		 * with other code.
+		 *
+		 * While is didn't happen with a DR7 write (see the DR7 read
+		 * comment above which explains where it happened), add the
+		 * __FORCE_ORDER here too to avoid similar problems in the
+		 * future.
+		 */
+		asm volatile("mov %0, %%db7"	::"r" (value), __FORCE_ORDER);
 		break;
 	default:
 		BUG();
-- 
2.39.1



