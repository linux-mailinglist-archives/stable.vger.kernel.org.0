Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6796A8407
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjCBOTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 09:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBOTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 09:19:18 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A03813513;
        Thu,  2 Mar 2023 06:19:17 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 378B11FB;
        Thu,  2 Mar 2023 06:20:00 -0800 (PST)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.26.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10BA03F587;
        Thu,  2 Mar 2023 06:19:15 -0800 (PST)
Date:   Thu, 2 Mar 2023 14:18:52 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Check field value in hist_field_name()
Message-ID: <ZACwTKyIkq5MyPHd@FVFF77S0Q05N.cambridge.arm.com>
References: <20230302010051.044209550@goodmis.org>
 <20230302020810.762384440@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302020810.762384440@goodmis.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 08:00:53PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The function hist_field_name() cannot handle being passed a NULL field
> parameter. It should never be NULL, but due to a previous bug, NULL was
> passed to the function and the kernel crashed due to a NULL dereference.
> Mark Rutland reported this to me on IRC.
> 
> The bug was fixed, but to prevent future bugs from crashing the kernel,
> check the field and add a WARN_ON() if it is NULL.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Mark Rutland <mark.rutland@arm.com>

I gave this patch a spin on its own (without the prior patch), and it behaves
as expected. When deliberately triggering the aforementioned bug I hit the
WARN_ON_ONCE() without crashing the kernel:

| # echo 'p:copy_to_user __arch_copy_to_user n=$arg2' >> /sys/kernel/tracing/kprobe_events
| # echo 'hist:keys=n:vals=hitcount.buckets=8:sort=hitcount' > /sys/kernel/tracing/events/kprobes/copy_to_user/trigger
| # cat /sys/kernel/tracing/events/kprobes/copy_to_user/hist 
| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 133 at kernel/trace/trace_events_hist.c:1337 hist_field_name+0x94/0x144
| Modules linked in:
| CPU: 0 PID: 133 Comm: cat Not tainted 6.2.0-00003-g785bb684c534 #2
| Hardware name: linux,dummy-virt (DT)
| pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : hist_field_name+0x94/0x144
| lr : hist_field_name+0xbc/0x144
| sp : ffff800008343a60
| x29: ffff800008343a60 x28: 0000000000000001 x27: 0000000000400cc0
| x26: ffffaed00953fcd0 x25: 0000000000000000 x24: ffff65c743e8bf00
| x23: ffffaed0093d2488 x22: ffff65c743fadc00 x21: 0000000000000001
| x20: ffff65c743ec1000 x19: ffff65c743fadc00 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000000 x13: 203a6f666e692072 x12: 6567676972742023
| x11: 0a230a6d6172676f x10: 000000000000002c x9 : ffffaed007be1fcc
| x8 : 000000000000002c x7 : 7f7f7f7f7f7f7f7f x6 : 000000000000002c
| x5 : ffff65c743b0103e x4 : ffffaed00953fcd1 x3 : 000000000000003d
| x2 : 0000000000020001 x1 : 0000000000000001 x0 : 0000000000000000
| Call trace:
|  hist_field_name+0x94/0x144
|  hist_field_print+0x28/0x14c
|  event_hist_trigger_print+0x174/0x4d0
|  hist_show+0xf8/0x980
|  seq_read_iter+0x1bc/0x4b0
|  seq_read+0x8c/0xc4
|  vfs_read+0xc8/0x2a4
|  ksys_read+0x70/0xfc
|  __arm64_sys_read+0x24/0x30
|  invoke_syscall+0x50/0x120
|  el0_svc_common.constprop.0+0x4c/0x100
|  do_el0_svc+0x44/0xd0
|  el0_svc+0x2c/0x84
|  el0t_64_sync_handler+0xbc/0x140
|  el0t_64_sync+0x190/0x194
| ---[ end trace 0000000000000000 ]---
| # event histogram
| #
| # trigger info: hist:keys=n:vals=hitcount,.buckets=8:sort=hitcount:size=2048 [active]
| #
| 
| { n: 18446574505247538232 } hitcount:          1  :          1
| { n: 18446574505249480120 } hitcount:          1  :          1
| { n: 18446574505255937966 } hitcount:          1  :          1
| { n: 18446574505234423224 } hitcount:          1  :          1

[...]

| Totals:
|     Hits: 371
|     Entries: 263
|     Dropped: 0

Note: the 'n' values are large because '$arg2' is actually the 'from' pointer
here, another mistake of mine (I had meant to capture '$arg3').

Thanks,
Mark.

> ---
>  kernel/trace/trace_events_hist.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 6e8ab726a7b5..486cca3c2b75 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -1331,6 +1331,9 @@ static const char *hist_field_name(struct hist_field *field,
>  {
>  	const char *field_name = "";
>  
> +	if (WARN_ON_ONCE(!field))
> +		return field_name;
> +
>  	if (level > 1)
>  		return field_name;
>  
> -- 
> 2.39.1
