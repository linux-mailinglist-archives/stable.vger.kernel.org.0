Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6611918BE9
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfEIOfF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 May 2019 10:35:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfEIOfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 10:35:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 504D0ABD4;
        Thu,  9 May 2019 14:35:03 +0000 (UTC)
Date:   Thu, 9 May 2019 16:35:02 +0200
From:   Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190509163502.4a9e1f77@kitsune.suse.cz>
In-Reply-To: <ace9aeac-f632-c004-1528-8c242def0904@roeck-us.net>
References: <20190508202642.GA28212@roeck-us.net>
        <20190509065324.GA3864@kroah.com>
        <20190509114923.696222cb@naga>
        <e8aa590e-a02f-19de-96df-6728ded7aab3@roeck-us.net>
        <20190509152649.2e3ef94d@kitsune.suse.cz>
        <ace9aeac-f632-c004-1528-8c242def0904@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 May 2019 07:06:32 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 5/9/19 6:26 AM, Michal Suchánek wrote:
> > On Thu, 9 May 2019 06:07:31 -0700
> > Guenter Roeck <linux@roeck-us.net> wrote:
> >   
> >> On 5/9/19 2:49 AM, Michal Suchánek wrote:  
> >>> On Thu, 9 May 2019 08:53:24 +0200
> >>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>>      
> >>>> On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:  
> >>>>> I see multiple instances of:
> >>>>>
> >>>>> arch/powerpc/kernel/exceptions-64s.S:839: Error:
> >>>>> 	attempt to move .org backwards
> >>>>>
> >>>>> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
> >>>>>
> >>>>> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
> >>>>> forwarding barrier at kernel entry/exit"), which is part of a large patch
> >>>>> series and can not easily be reverted.
> >>>>>
> >>>>> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?  
> >>>>
> >>>> Michael, I thought this patch series was supposed to fix ppc issues, not
> >>>> add to them :)
> >>>>
> >>>> Any ideas on what to do here?  
> >>>
> >>> What exact code do you build?
> >>>     
> >> $ make ARCH=powerpc CROSS_COMPILE=powerpc64-linux- allmodconfig
> >> $ powerpc64-linux-gcc --version
> >> powerpc64-linux-gcc (GCC) 8.3.0
> >>  
> > 
> > Gcc should not see this file. I am asking because I do not see an .org
> > directive at line 839 of 4.4.179. I probably need some different repo
> > or extra patches to see the same code as you do.
> >   
> v4.4.179-143-gc4db218e9451 from
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> branch linux-4.4.y

Still don't see it. That branch is at 4.4.179 and c4db218e9451 does not
exist after fetching from the repo.

Anyway, here is a patch (untested):

Subject: [PATCH] Move out-of-line exception handlers after relon exception
 handlers.

The relon exception handlers need to be at specific location and code
inflation in the common handler code can cause

Error: attempt to move .org backwards

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/powerpc/kernel/exceptions-64s.S | 88 ++++++++++++++--------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 938a30fef031..1d477d21ff09 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -772,50 +772,6 @@ kvmppc_skip_Hinterrupt:
 	b	.
 #endif
 
-/*
- * Code from here down to __end_handlers is invoked from the
- * exception prologs above.  Because the prologs assemble the
- * addresses of these handlers using the LOAD_HANDLER macro,
- * which uses an ori instruction, these handlers must be in
- * the first 64k of the kernel image.
- */
-
-/*** Common interrupt handlers ***/
-
-	STD_EXCEPTION_COMMON(0x100, system_reset, system_reset_exception)
-
-	STD_EXCEPTION_COMMON_ASYNC(0x500, hardware_interrupt, do_IRQ)
-	STD_EXCEPTION_COMMON_ASYNC(0x900, decrementer, timer_interrupt)
-	STD_EXCEPTION_COMMON(0x980, hdecrementer, hdec_interrupt)
-#ifdef CONFIG_PPC_DOORBELL
-	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, doorbell_exception)
-#else
-	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, unknown_exception)
-#endif
-	STD_EXCEPTION_COMMON(0xb00, trap_0b, unknown_exception)
-	STD_EXCEPTION_COMMON(0xd00, single_step, single_step_exception)
-	STD_EXCEPTION_COMMON(0xe00, trap_0e, unknown_exception)
-	STD_EXCEPTION_COMMON(0xe40, emulation_assist, emulation_assist_interrupt)
-	STD_EXCEPTION_COMMON_ASYNC(0xe60, hmi_exception, handle_hmi_exception)
-#ifdef CONFIG_PPC_DOORBELL
-	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, doorbell_exception)
-#else
-	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, unknown_exception)
-#endif
-	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, performance_monitor_exception)
-	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, instruction_breakpoint_exception)
-	STD_EXCEPTION_COMMON(0x1502, denorm, unknown_exception)
-#ifdef CONFIG_ALTIVEC
-	STD_EXCEPTION_COMMON(0x1700, altivec_assist, altivec_assist_exception)
-#else
-	STD_EXCEPTION_COMMON(0x1700, altivec_assist, unknown_exception)
-#endif
-#ifdef CONFIG_CBE_RAS
-	STD_EXCEPTION_COMMON(0x1200, cbe_system_error, cbe_system_error_exception)
-	STD_EXCEPTION_COMMON(0x1600, cbe_maintenance, cbe_maintenance_exception)
-	STD_EXCEPTION_COMMON(0x1800, cbe_thermal, cbe_thermal_exception)
-#endif /* CONFIG_CBE_RAS */
-
 	/*
 	 * Relocation-on interrupts: A subset of the interrupts can be delivered
 	 * with IR=1/DR=1, if AIL==2 and MSR.HV won't be changed by delivering
@@ -969,6 +925,50 @@ system_call_entry:
 ppc64_runlatch_on_trampoline:
 	b	__ppc64_runlatch_on
 
+/*
+ * Code from here down to __end_handlers is invoked from the
+ * exception prologs above.  Because the prologs assemble the
+ * addresses of these handlers using the LOAD_HANDLER macro,
+ * which uses an ori instruction, these handlers must be in
+ * the first 64k of the kernel image.
+ */
+
+/*** Common interrupt handlers ***/
+
+	STD_EXCEPTION_COMMON(0x100, system_reset, system_reset_exception)
+
+	STD_EXCEPTION_COMMON_ASYNC(0x500, hardware_interrupt, do_IRQ)
+	STD_EXCEPTION_COMMON_ASYNC(0x900, decrementer, timer_interrupt)
+	STD_EXCEPTION_COMMON(0x980, hdecrementer, hdec_interrupt)
+#ifdef CONFIG_PPC_DOORBELL
+	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, doorbell_exception)
+#else
+	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, unknown_exception)
+#endif
+	STD_EXCEPTION_COMMON(0xb00, trap_0b, unknown_exception)
+	STD_EXCEPTION_COMMON(0xd00, single_step, single_step_exception)
+	STD_EXCEPTION_COMMON(0xe00, trap_0e, unknown_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, emulation_assist_interrupt)
+	STD_EXCEPTION_COMMON_ASYNC(0xe60, hmi_exception, handle_hmi_exception)
+#ifdef CONFIG_PPC_DOORBELL
+	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, doorbell_exception)
+#else
+	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, unknown_exception)
+#endif
+	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, performance_monitor_exception)
+	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, instruction_breakpoint_exception)
+	STD_EXCEPTION_COMMON(0x1502, denorm, unknown_exception)
+#ifdef CONFIG_ALTIVEC
+	STD_EXCEPTION_COMMON(0x1700, altivec_assist, altivec_assist_exception)
+#else
+	STD_EXCEPTION_COMMON(0x1700, altivec_assist, unknown_exception)
+#endif
+#ifdef CONFIG_CBE_RAS
+	STD_EXCEPTION_COMMON(0x1200, cbe_system_error, cbe_system_error_exception)
+	STD_EXCEPTION_COMMON(0x1600, cbe_maintenance, cbe_maintenance_exception)
+	STD_EXCEPTION_COMMON(0x1800, cbe_thermal, cbe_thermal_exception)
+#endif /* CONFIG_CBE_RAS */
+
 /*
  * Here r13 points to the paca, r9 contains the saved CR,
  * SRR0 and SRR1 are saved in r11 and r12,
-- 
2.20.1

