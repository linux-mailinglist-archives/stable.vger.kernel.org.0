Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529F959AE5E
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346796AbiHTNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347001AbiHTNEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:04:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1973ED58;
        Sat, 20 Aug 2022 06:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F4B4B80CD4;
        Sat, 20 Aug 2022 13:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFDEC433C1;
        Sat, 20 Aug 2022 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661000687;
        bh=ATtdrvkcuR3hWHOKkXQy2ngqguA00ip7E0D3sTSPCIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lTknPk5Qu1GhYlavME8toSuj/c3jFiy1/xPvG2xC8vOYoXsKhK3Qk4Bkb+6NyIpTS
         NcvtERb/4zFVzL52C6/uBzC6ILEQllG0JtjIPcbtwLERFJTYVsiXVktksbrOxfAPQa
         TLIY5XGpagt2tBshaNoAAc3Z/odvWet61uDZt6/W6KprRdQ48j7Y9nxtyjWhGZr7h/
         Am1hqf86HfIuaUpvTOzKm8C/NmMusyzOp0TKxCOgf2QOsPfgDFjloGKvphsnOtdE/i
         Qlzvg0S7yUKd1G7veEnI+Zj2uiXWqdVRcA0sGB+Hi5InBFQRCfj6a1q6t3Xl1rB/N5
         DUbSLjWXAUoaw==
Date:   Sat, 20 Aug 2022 22:04:42 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/eprobes: Have event probes be consistent
 with kprobes and uprobes
Message-Id: <20220820220442.776e1ddaf8836e82edb34d01@kernel.org>
In-Reply-To: <20220820014833.395997394@goodmis.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.395997394@goodmis.org>
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

On Fri, 19 Aug 2022 21:40:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Currently, if a symbol "@" is attempted to be used with an event probe
> (eprobes), it will cause a NULL pointer dereference crash.
> 
> Both kprobes and uprobes can reference data other than the main registers.
> Such as immediate address, symbols and the current task name. Have eprobes
> do the same thing.
> 
> For "comm", if "comm" is used and the event being attached to does not
> have the "comm" field, then make it the "$comm" that kprobes has. This is
> consistent to the way histograms and filters work.

Hmm, I think I would better allow user to use $COMM to get comm string
for kprobe/uprobe event users too. (There are many special variables...)
Anyway, this looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you!

> 
> Cc: stable@vger.kernel.org
> Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_eprobe.c | 67 +++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
> index a1d3423ab74f..63218a541217 100644
> --- a/kernel/trace/trace_eprobe.c
> +++ b/kernel/trace/trace_eprobe.c
> @@ -227,6 +227,7 @@ static int trace_eprobe_tp_arg_update(struct trace_eprobe *ep, int i)
>  	struct probe_arg *parg = &ep->tp.args[i];
>  	struct ftrace_event_field *field;
>  	struct list_head *head;
> +	int ret = -ENOENT;
>  
>  	head = trace_get_fields(ep->event);
>  	list_for_each_entry(field, head, link) {
> @@ -236,9 +237,17 @@ static int trace_eprobe_tp_arg_update(struct trace_eprobe *ep, int i)
>  			return 0;
>  		}
>  	}
> +
> +	/* Argument no found on event. But allow for comm and COMM to be used */
> +	if (strcmp(parg->code->data, "COMM") == 0 ||
> +	    strcmp(parg->code->data, "comm") == 0) {
> +		parg->code->op = FETCH_OP_COMM;
> +		ret = 0;
> +	}
> +
>  	kfree(parg->code->data);
>  	parg->code->data = NULL;
> -	return -ENOENT;
> +	return ret;
>  }
>  
>  static int eprobe_event_define_fields(struct trace_event_call *event_call)
> @@ -363,16 +372,38 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
>  
>  static int get_eprobe_size(struct trace_probe *tp, void *rec)
>  {
> +	struct fetch_insn *code;
>  	struct probe_arg *arg;
>  	int i, len, ret = 0;
>  
>  	for (i = 0; i < tp->nr_args; i++) {
>  		arg = tp->args + i;
> -		if (unlikely(arg->dynamic)) {
> +		if (arg->dynamic) {
>  			unsigned long val;
>  
> -			val = get_event_field(arg->code, rec);
> -			len = process_fetch_insn_bottom(arg->code + 1, val, NULL, NULL);
> +			code = arg->code;
> + retry:
> +			switch (code->op) {
> +			case FETCH_OP_TP_ARG:
> +				val = get_event_field(code, rec);
> +				break;
> +			case FETCH_OP_IMM:
> +				val = code->immediate;
> +				break;
> +			case FETCH_OP_COMM:
> +				val = (unsigned long)current->comm;
> +				break;
> +			case FETCH_OP_DATA:
> +				val = (unsigned long)code->data;
> +				break;
> +			case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
> +				code++;
> +				goto retry;
> +			default:
> +				continue;
> +			}
> +			code++;
> +			len = process_fetch_insn_bottom(code, val, NULL, NULL);
>  			if (len > 0)
>  				ret += len;
>  		}
> @@ -390,8 +421,28 @@ process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
>  {
>  	unsigned long val;
>  
> -	val = get_event_field(code, rec);
> -	return process_fetch_insn_bottom(code + 1, val, dest, base);
> + retry:
> +	switch (code->op) {
> +	case FETCH_OP_TP_ARG:
> +		val = get_event_field(code, rec);
> +		break;
> +	case FETCH_OP_IMM:
> +		val = code->immediate;
> +		break;
> +	case FETCH_OP_COMM:
> +		val = (unsigned long)current->comm;
> +		break;
> +	case FETCH_OP_DATA:
> +		val = (unsigned long)code->data;
> +		break;
> +	case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
> +		code++;
> +		goto retry;
> +	default:
> +		return -EILSEQ;
> +	}
> +	code++;
> +	return process_fetch_insn_bottom(code, val, dest, base);
>  }
>  NOKPROBE_SYMBOL(process_fetch_insn)
>  
> @@ -866,6 +917,10 @@ static int trace_eprobe_tp_update_arg(struct trace_eprobe *ep, const char *argv[
>  			trace_probe_log_err(0, BAD_ATTACH_ARG);
>  	}
>  
> +	/* Handle symbols "@" */
> +	if (!ret)
> +		ret = traceprobe_update_arg(&ep->tp.args[i]);
> +
>  	return ret;
>  }
>  
> -- 
> 2.35.1


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
