Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76659ADE7
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 14:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiHTM1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344848AbiHTM1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:27:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB76543E8;
        Sat, 20 Aug 2022 05:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBD27CE0E05;
        Sat, 20 Aug 2022 12:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD14C433C1;
        Sat, 20 Aug 2022 12:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660998463;
        bh=assOHwgQdKBmJy5Y6XWkbZif7DaKqia6uNgtfAA8UVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bMyKVb/N/JIQ9vcxfpfpLb0jkYMa6dvUqniv0ut1x7pN/QbxuNJTfrOu6AzWIFKz6
         NtATJmFiUQ8ikRvezwCgb42wepJQIG/cIle1ET4M7cMuUmUyngai/vEoGLWNjG9nEF
         Id+Xw+wOSz+eySeyYxSSsl1B4hSMxsHScapy6tR2Wx5LGqsGeTfnsvYIBwNpnGlmR7
         8u1aA8Lu9zzmCUtTK9fJbowd1xdup7NGfig1nEn5NcXGUkA6A/Nix0nxhfd/NRVx0y
         NpfzIj/lPb3PBafsX7tN3g9CeeYIjKr1qxZ2DZqli6Z3e318n1ULuQzNR3kvmy3Ttx
         AzX0yVCtF70Lg==
Date:   Sat, 20 Aug 2022 21:27:33 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] tracing/eprobes: Fix reading of string fields
Message-Id: <20220820212733.f19ae9f07c0868af3a008077@kernel.org>
In-Reply-To: <20220820014833.220833221@goodmis.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.220833221@goodmis.org>
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

On Fri, 19 Aug 2022 21:40:38 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Currently when an event probe (eprobe) hooks to a string field, it does
> not display it as a string, but instead as a number. This makes the field
> rather useless. Handle the different kinds of strings, dynamic, static,
> relational/dynamic etc.
> 
> Now when a string field is used, the ":string" type can be used to display
> it:
> 
>   echo "e:sw sched/sched_switch comm=$next_comm:string" > dynamic_events

Really nice!

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you!

> 
> Cc: stable@vger.kernel.org
> Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_eprobe.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
> index 550671985fd1..a1d3423ab74f 100644
> --- a/kernel/trace/trace_eprobe.c
> +++ b/kernel/trace/trace_eprobe.c
> @@ -311,6 +311,27 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
>  
>  	addr = rec + field->offset;
>  
> +	if (is_string_field(field)) {
> +		switch (field->filter_type) {
> +		case FILTER_DYN_STRING:
> +			val = (unsigned long)(rec + (*(unsigned int *)addr & 0xffff));
> +			break;
> +		case FILTER_RDYN_STRING:
> +			val = (unsigned long)(addr + (*(unsigned int *)addr & 0xffff));
> +			break;
> +		case FILTER_STATIC_STRING:
> +			val = (unsigned long)addr;
> +			break;
> +		case FILTER_PTR_STRING:
> +			val = (unsigned long)(*(char *)addr);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			return 0;
> +		}
> +		return val;
> +	}
> +
>  	switch (field->size) {
>  	case 1:
>  		if (field->is_signed)
> -- 
> 2.35.1


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
