Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24859B4FE
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiHUPTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHUPTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED78D13F74;
        Sun, 21 Aug 2022 08:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5520160EFE;
        Sun, 21 Aug 2022 15:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA5FC433C1;
        Sun, 21 Aug 2022 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661095146;
        bh=J34zjnX+gdxLLSVH7y0L1d9EB4KoSbYPwfl1PzsdGp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQqMuHiaD3Dke+dr7z4AjjhA0rT3CUwrbzcIXut0+eeeiLnhdRuv4mPGch7qAoi6X
         8UQ1tto1i35vM5WIUZGq9aTN2MRPFDe710JSYy09EVfJvq4FPjmiiNyGQ3GMGiAZtS
         /5edwTd6dz9jglu7r9DoXXPrk+f9/2jUAN3vUU+ROm83j15Pzhx5AGX3wL8a5FaFOL
         YaT5bHcLKqeJcLSJHv8Cv0LxNRgncOZw/bPcvP336361JCd0hzZGoZsy5QdaiZcALQ
         yaThxbB+l3h2jv+MB+L4CZc7hq0VhgGdDtGOgThDkqlIhZeJ6d9Ay7VVCdcKQf9nH3
         wkBnlyRU0+2IQ==
Date:   Mon, 22 Aug 2022 00:19:02 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/6] tracing/probes: Have kprobes and uprobes use
 $COMM too
Message-Id: <20220822001902.170ae2e078bba021581279e2@kernel.org>
In-Reply-To: <20220820134401.317014913@goodmis.org>
References: <20220820134316.156058831@goodmis.org>
        <20220820134401.317014913@goodmis.org>
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

On Sat, 20 Aug 2022 09:43:21 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Both $comm and $COMM can be used to get current->comm in eprobes and the
> filtering and histogram logic. Make kprobes and uprobes consistent in this
> regard and allow both $comm and $COMM as well. Currently kprobes and
> uprobes only handle $comm, which is inconsistent with the other utilities,
> and can be confusing to users.
> 
> Link: https://lore.kernel.org/all/20220820220442.776e1ddaf8836e82edb34d01@kernel.org/
> 

This looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

(Note that kprobes/uprobes doesn't need to record cpu/pid, because those
 are a part of common field and can be accessed from filter or histogram.
 Only comm must be recorded as string.)

Thank you,

> Cc: stable@vger.kernel.org
> Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
> Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_probe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 4daabbb8b772..36dff277de46 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -314,7 +314,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
>  			}
>  		} else
>  			goto inval_var;
> -	} else if (strcmp(arg, "comm") == 0) {
> +	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
>  		code->op = FETCH_OP_COMM;
>  #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
>  	} else if (((flags & TPARG_FL_MASK) ==
> @@ -625,7 +625,8 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
>  	 * we can find those by strcmp. But ignore for eprobes.
>  	 */
>  	if (!(flags & TPARG_FL_TPOINT) &&
> -	    (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0)) {
> +	    (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0 ||
> +	     strncmp(arg, "\\\"", 2) == 0)) {
>  		/* The type of $comm must be "string", and not an array. */
>  		if (parg->count || (t && strcmp(t, "string")))
>  			goto out;
> -- 
> 2.35.1


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
