Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53F59AA96
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 03:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiHTB4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 21:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiHTB4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 21:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2FCE191B;
        Fri, 19 Aug 2022 18:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462656194C;
        Sat, 20 Aug 2022 01:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C302BC433D6;
        Sat, 20 Aug 2022 01:56:47 +0000 (UTC)
Date:   Fri, 19 Aug 2022 21:57:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
Message-ID: <20220819215700.549b4dac@gandalf.local.home>
In-Reply-To: <20220820014833.035925907@goodmis.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.035925907@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 21:40:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

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

And my tests fail shortly after I send this. It complains about a new
warning. The above needs parenthesis around it.

Will send a v2 after my tests pass, in case it finds something else I
missed.

-- Steve



>  		/* The type of $comm must be "string", and not an array. */
>  		if (parg->count || (t && strcmp(t, "string")))
>  			goto out;
> -- 
