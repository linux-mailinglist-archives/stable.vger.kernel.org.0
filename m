Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1175650B5F
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiLSMWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiLSMWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:22:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B9CDEDA;
        Mon, 19 Dec 2022 04:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78801B80DD2;
        Mon, 19 Dec 2022 12:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1298C433D2;
        Mon, 19 Dec 2022 12:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671452526;
        bh=+mZzLUqj6zXEyvMlVq+uk5m4h/YoNfw8u2BUFwZG1Xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wPE7tgTbWcsrCsY41lyXjH+1/9nedIQiju7r2JuAglUwVUGi45eYWUXdEslCqmMVf
         qYAB3UPzYySZB7wD9oQb59EC0orFbX5XPFsphrKBBr0SkIS8bJ2mOrIaeG1k9Tm8ig
         aSxlUe1bhOjmW3+9jANyIcPJhqgauAmfeMvGWGEk=
Date:   Mon, 19 Dec 2022 13:21:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Pratyush Yadav <ptyadav@amazon.de>, stable@vger.kernel.org,
        patches@lists.linux.dev,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Primiano Tucci <primiano@google.com>
Subject: Re: [PATCH 5.4] tracing/ring-buffer: Only do full wait when cpu !=
 RING_BUFFER_ALL_CPUS
Message-ID: <Y6BXW+dY6D95QfXG@kroah.com>
References: <20221216134241.81381-1-ptyadav@amazon.de>
 <20221216091533.6a74d5c5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216091533.6a74d5c5@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 09:15:33AM -0500, Steven Rostedt wrote:
> On Fri, 16 Dec 2022 14:42:41 +0100
> Pratyush Yadav <ptyadav@amazon.de> wrote:
> 
> > full_hit() directly uses cpu as an array index. Since
> > RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
> > RING_BUFFER_ALL_CPUS will cause an invalid memory access.
> > 
> > The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
> > block on watermark") already does this. This was missed when backporting
> > to v5.4.y.
> > 
> > This bug was discovered and resolved using Coverity Static Analysis
> > Security Testing (SAST) by Synopsys, Inc.
> 
> Nice.
> 
> > 
> > Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> > ---
> > 
> > I am not familiar with this code. This was just pointed out by our
> > static analysis tool and I wrote a quick patch fixing this. Only
> > compile-tested.
> > 
> >  kernel/trace/ring_buffer.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index 176d858903bd..11e8189dd8ae 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> > 
> >  	if (cpu == RING_BUFFER_ALL_CPUS) {
> >  		work = &buffer->irq_work;
> > +		full = 0;
> 
> Good catch. This was indeed missed in the backport. The backported patch
> even added the comment:
> 
>  * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
> 
> Greg, please take this patch.
> 
> Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Now queued up, thanks.

greg k-h
