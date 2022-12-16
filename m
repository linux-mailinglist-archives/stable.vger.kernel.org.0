Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978D164ECC0
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 15:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiLPOPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 09:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiLPOPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 09:15:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C46D1132;
        Fri, 16 Dec 2022 06:15:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E85B81D98;
        Fri, 16 Dec 2022 14:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44912C433EF;
        Fri, 16 Dec 2022 14:15:35 +0000 (UTC)
Date:   Fri, 16 Dec 2022 09:15:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Primiano Tucci <primiano@google.com>
Subject: Re: [PATCH 5.4] tracing/ring-buffer: Only do full wait when cpu !=
 RING_BUFFER_ALL_CPUS
Message-ID: <20221216091533.6a74d5c5@gandalf.local.home>
In-Reply-To: <20221216134241.81381-1-ptyadav@amazon.de>
References: <20221216134241.81381-1-ptyadav@amazon.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Dec 2022 14:42:41 +0100
Pratyush Yadav <ptyadav@amazon.de> wrote:

> full_hit() directly uses cpu as an array index. Since
> RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
> RING_BUFFER_ALL_CPUS will cause an invalid memory access.
> 
> The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
> block on watermark") already does this. This was missed when backporting
> to v5.4.y.
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.

Nice.

> 
> Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
> 
> I am not familiar with this code. This was just pointed out by our
> static analysis tool and I wrote a quick patch fixing this. Only
> compile-tested.
> 
>  kernel/trace/ring_buffer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 176d858903bd..11e8189dd8ae 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> 
>  	if (cpu == RING_BUFFER_ALL_CPUS) {
>  		work = &buffer->irq_work;
> +		full = 0;

Good catch. This was indeed missed in the backport. The backported patch
even added the comment:

 * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS

Greg, please take this patch.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks,

-- Steve

>  	} else {
>  		if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  			return -EINVAL;
> --
> 2.38.1
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

