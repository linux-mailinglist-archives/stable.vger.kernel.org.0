Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C89FBA23
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 21:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfKMUnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 15:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfKMUnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 15:43:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FB2206E6;
        Wed, 13 Nov 2019 20:43:12 +0000 (UTC)
Date:   Wed, 13 Nov 2019 15:43:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: ftrace/recordmcount: filter relocation types
Message-ID: <20191113154309.5d333f8c@gandalf.local.home>
In-Reply-To: <20191106154209.118919-1-alexander.sverdlin@nokia.com>
References: <20191106154209.118919-1-alexander.sverdlin@nokia.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Nov 2019 15:42:24 +0000
"Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
wrote:

> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Scenario 1, ARMv7
> =================
> 
> If code in arch/arm/kernel/ftrace.c would operate on mcount() pointer
> the following may be generated:
> 
> 00000230 <prealloc_fixed_plts>:
>  230:   b5f8            push    {r3, r4, r5, r6, r7, lr}
>  232:   b500            push    {lr}
>  234:   f7ff fffe       bl      0 <__gnu_mcount_nc>
>                         234: R_ARM_THM_CALL     __gnu_mcount_nc
>  238:   f240 0600       movw    r6, #0
>                         238: R_ARM_THM_MOVW_ABS_NC      __gnu_mcount_nc
>  23c:   f8d0 1180       ldr.w   r1, [r0, #384]  ; 0x180
> 
> FTRACE currently is not able to deal with it:
> 
> WARNING: CPU: 0 PID: 0 at .../kernel/trace/ftrace.c:1979 ftrace_bug+0x1ad/0x230()
> ...
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.116-... #1
> ...
> [<c0314e3d>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
> [<c03115e9>] (show_stack) from [<c051a7f1>] (dump_stack+0x81/0xa8)
> [<c051a7f1>] (dump_stack) from [<c0321c5d>] (warn_slowpath_common+0x69/0x90)
> [<c0321c5d>] (warn_slowpath_common) from [<c0321cf3>] (warn_slowpath_null+0x17/0x1c)
> [<c0321cf3>] (warn_slowpath_null) from [<c038ee9d>] (ftrace_bug+0x1ad/0x230)
> [<c038ee9d>] (ftrace_bug) from [<c038f1f9>] (ftrace_process_locs+0x27d/0x444)
> [<c038f1f9>] (ftrace_process_locs) from [<c08915bd>] (ftrace_init+0x91/0xe8)
> [<c08915bd>] (ftrace_init) from [<c0885a67>] (start_kernel+0x34b/0x358)
> [<c0885a67>] (start_kernel) from [<00308095>] (0x308095)
> ---[ end trace cb88537fdc8fa200 ]---
> ftrace failed to modify [<c031266c>] prealloc_fixed_plts+0x8/0x60
>  actual: 44:f2:e1:36
> ftrace record flags: 0
>  (0)   expected tramp: c03143e9
> 
> Scenario 2, ARMv4T
> ==================
> 
> ftrace: allocating 14435 entries in 43 pages
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:2029 ftrace_bug+0x204/0x310
> CPU: 0 PID: 0 Comm: swapper Not tainted 4.19.5 #1
> Hardware name: Cirrus Logic EDB9302 Evaluation Board
> [<c0010a24>] (unwind_backtrace) from [<c000ecb0>] (show_stack+0x20/0x2c)
> [<c000ecb0>] (show_stack) from [<c03c72e8>] (dump_stack+0x20/0x30)
> [<c03c72e8>] (dump_stack) from [<c0021c18>] (__warn+0xdc/0x104)
> [<c0021c18>] (__warn) from [<c0021d7c>] (warn_slowpath_null+0x4c/0x5c)
> [<c0021d7c>] (warn_slowpath_null) from [<c0095360>] (ftrace_bug+0x204/0x310)
> [<c0095360>] (ftrace_bug) from [<c04dabac>] (ftrace_init+0x3b4/0x4d4)
> [<c04dabac>] (ftrace_init) from [<c04cef4c>] (start_kernel+0x20c/0x410)
> [<c04cef4c>] (start_kernel) from [<00000000>] (  (null))
> ---[ end trace 0506a2f5dae6b341 ]---
> ftrace failed to modify
> [<c000c350>] perf_trace_sys_exit+0x5c/0xe8
>  actual:   1e:ff:2f:e1
> Initializing ftrace call sites
> ftrace record flags: 0
>  (0)
>  expected tramp: c000fb24
> 
> The analysis for this problem has been already performed previously,
> refer to the link below.
> 
> Fix the above problems by allowing only selected reloc types in
> __mcount_loc. The list itself comes from the legacy recordmcount.pl
> script.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/lkml/56961010.6000806@pengutronix.de/
> Fixes: ed60453fa8 ("ARM: 6511/1: ftrace: add ARM support for C version of recordmcount")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Feel free to take this in whatever tree you want.

-- Steve

> 
> ---
> Changelog:
> v2: Rebased
> 
>  scripts/recordmcount.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
> index 612268e..6872d26 100644
> --- a/scripts/recordmcount.c
> +++ b/scripts/recordmcount.c
> @@ -38,6 +38,10 @@
>  #define R_AARCH64_ABS64	257
>  #endif
>  
> +#define R_ARM_PC24		1
> +#define R_ARM_THM_CALL		10
> +#define R_ARM_CALL		28
> +
>  static int fd_map;	/* File descriptor for file being modified. */
>  static int mmap_failed; /* Boolean flag. */
>  static char gpfx;	/* prefix for global symbol name (sometimes '_') */
> @@ -418,6 +422,18 @@ static char const *already_has_rel_mcount = "success"; /* our work here is done!
>  #define RECORD_MCOUNT_64
>  #include "recordmcount.h"
>  
> +static int arm_is_fake_mcount(Elf32_Rel const *rp)
> +{
> +	switch (ELF32_R_TYPE(w(rp->r_info))) {
> +	case R_ARM_THM_CALL:
> +	case R_ARM_CALL:
> +	case R_ARM_PC24:
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  /* 64-bit EM_MIPS has weird ELF64_Rela.r_info.
>   * http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4658-001.pdf
>   * We interpret Table 29 Relocation Operation (Elf64_Rel, Elf64_Rela) [p.40]
> @@ -523,6 +539,7 @@ static int do_file(char const *const fname)
>  		altmcount = "__gnu_mcount_nc";
>  		make_nop = make_nop_arm;
>  		rel_type_nop = R_ARM_NONE;
> +		is_fake_mcount32 = arm_is_fake_mcount;
>  		gpfx = 0;
>  		break;
>  	case EM_AARCH64:

