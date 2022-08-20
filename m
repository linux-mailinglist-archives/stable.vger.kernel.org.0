Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1BC59AD6E
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 13:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiHTLSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiHTLSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 07:18:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB7217585;
        Sat, 20 Aug 2022 04:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF628611B6;
        Sat, 20 Aug 2022 11:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52CAC433D6;
        Sat, 20 Aug 2022 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660994309;
        bh=kELYW5Oc9wfTfaOtjKzFb+oTCYYXKgWBwjVIEpvSZzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OKXpMSJ9vYjGxuMUK4WJCfaAgKUhsdFoXl0ESYoKwLeALqiPaBRqsnKgNy1y5tfVP
         POuAAe/pRp8raThz+MWKIPZRQrOyQB+ALR/sYsTCh7ob5Ljs8mWQIA8CcPVFMf5UFO
         qPhDg/8ih9B8aOMwhyWY6ohhs4p04ONPQAGpi4y0z9i/3tdZimjcpPS7keVMAFSpnZ
         7NIeYCwSXRNaLAat5bRKCDrVVFnhFvbJxEc6MoC1+f6ERSgarAks05rB54cL/UyB6f
         PXtDQniCITsSOKNxr4Cxr/oMF/1P3tvLOGpKwn7OhzEUOpsUdfh8q8tWfRbV6c5XZK
         vZ52Htn66kgHw==
Date:   Sat, 20 Aug 2022 20:18:24 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
Message-Id: <20220820201824.5637c4feff4a7674aebde60a@kernel.org>
In-Reply-To: <20220820014833.035925907@goodmis.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.035925907@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 21:40:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The variable $comm is hard coded as a string, which is true for both
> kprobes and uprobes, but for event probes (eprobes) it is a field name. In
> most cases the "comm" field would be a string, but there's no guarantee of
> that fact.
> 
> Do not assume that comm is a string. Not to mention, it currently forces
> comm fields to fault, as string processing for event probes is currently
> broken.

Indeed. There should be an event argument which names "comm".
Eprobe might refer it. BTW, does eprobe use any special common fields?
I originally introduced "$" variable for such special variables.

Thank you,
> 
> Cc: stable@vger.kernel.org
> Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_probe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index dec657af363c..23dcd52ad45c 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -622,9 +622,10 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
>  
>  	/*
>  	 * Since $comm and immediate string can not be dereferenced,
> -	 * we can find those by strcmp.
> +	 * we can find those by strcmp. But ignore for eprobes.
>  	 */
> -	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
> +	if (!(flags & TPARG_FL_TPOINT) &&
> +	    strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
>  		/* The type of $comm must be "string", and not an array. */
>  		if (parg->count || (t && strcmp(t, "string")))
>  			goto out;
> -- 
> 2.35.1


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
