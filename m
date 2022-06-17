Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3141654F53B
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 12:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380961AbiFQKVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 06:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiFQKVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 06:21:48 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD76A058;
        Fri, 17 Jun 2022 03:21:47 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b8so5560602edj.11;
        Fri, 17 Jun 2022 03:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1gyXVsIhrLNPJrdyWtNBJe4UGWrCbFBxMLTRYov+4hk=;
        b=MrrsjJZ7Xg+X8ZgiineV5L4+flDD7zT5NAfgJ1is3b4d7vTHeMmECYAgYe5Q9Nfu4A
         rUyV0NoU7PNBWZUZlWPkJGUWU7SoOfRH2Q8EHh3TW8N9Dg7NEomE6ukzoNqazYcbGaEs
         K47TZsdkEo2cOS4b+JC087cuwjSKRf9f6PkwWLHXJv90ay1VlVJB9ousn+HSY73XHA6n
         hCLTt/imY0qwIOsvYBueJGwbxV7ncyrhAq093etIofXohWs7zDu5671z92WiTce73un3
         7OCVbYNCSAq8Uqd8F6DmZ0t+hGwTe/Di057OSZxO/ERV0+3isZIq+ckcnksviY68Ets5
         gVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1gyXVsIhrLNPJrdyWtNBJe4UGWrCbFBxMLTRYov+4hk=;
        b=puinX2EI6OHoTQboILGCEOcJAjcDmcd3XuHj58+hlTejMQqKlg17cjC+CcJ2Ft9BS+
         ScFG+UvB9FUNnUkjlS6zuKyK8EMAJQOCwxUuC+VMrIt3qE1jB1VDZgyeM7dDKyO0Mpzn
         Gif9eJAg8ITX/7075YyjQ+7NNXf+mZN8pOnzesCBeV1vqEnA6NkU1b8yzwz0dY4lwb02
         20HJgJ+dTMAvilvK5iaGpEl7IvonqUIFAQJmQQfFgbX3KQPYm9HEVaiTbQIlzztZbGgg
         cM2rmJeAgtOETLzz55PAufyeOJWz4H0+K7tWnSfEoGTGuoN1rjkGhNUh4cQSdgwVFYYw
         nltQ==
X-Gm-Message-State: AJIora+KmEjgLilcOxrDp2Xv+79tRYvvPF6F/XCv+qkUxhdRO0cIoout
        92+qDVcW3DeJzSlisLmTuAw=
X-Google-Smtp-Source: AGRyM1srWN7X/BOxcDMj7JdYRHWaINLoUpIb354qnBf8uviawJkdpr6+taDx4Q2BZCqDJOLnYr9zGg==
X-Received: by 2002:a05:6402:3808:b0:435:5a6c:9dd9 with SMTP id es8-20020a056402380800b004355a6c9dd9mr4874558edb.368.1655461305760;
        Fri, 17 Jun 2022 03:21:45 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id r1-20020a170906280100b006fefd1d5c2bsm1987782ejc.148.2022.06.17.03.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:21:45 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 17 Jun 2022 12:21:43 +0200
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
Message-ID: <YqxVt4KoSIMHUH+/@krava>
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165366693881.797669.16926184644089588731.stgit@devnote2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 12:55:39AM +0900, Masami Hiramatsu (Google) wrote:
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> There is a small chance that get_kretprobe(ri) returns NULL in
> kretprobe_dispatcher() when another CPU unregisters the kretprobe
> right after __kretprobe_trampoline_handler().
> 
> To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
> return value again. And if it is NULL, it returns soon because that
> kretprobe is under unregistering process.
> 
> This issue has been introduced when the kretprobe is decoupled
> from the struct kretprobe_instance by commit d741bf41d7c7
> ("kprobes: Remove kretprobe hash"). Before that commit, the
> struct kretprob_instance::rp directly points the kretprobe
> and it is never be NULL.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> ---
>  kernel/trace/trace_kprobe.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 93507330462c..a245ea673715 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1718,8 +1718,17 @@ static int
>  kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>  {
>  	struct kretprobe *rp = get_kretprobe(ri);
> -	struct trace_kprobe *tk = container_of(rp, struct trace_kprobe, rp);
> +	struct trace_kprobe *tk;
> +
> +	/*
> +	 * There is a small chance that get_kretprobe(ri) returns NULL when
> +	 * the kretprobe is unregister on another CPU between kretprobe's
> +	 * trampoline_handler and this function.
> +	 */
> +	if (unlikely(!rp))
> +		return 0;
>  
> +	tk = container_of(rp, struct trace_kprobe, rp);
>  	raw_cpu_inc(*tk->nhit);
>  
>  	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
> 
