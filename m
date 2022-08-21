Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39459B4EA
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiHUPOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiHUPOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FEA22BF9;
        Sun, 21 Aug 2022 08:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF3D4B80923;
        Sun, 21 Aug 2022 15:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA7C433C1;
        Sun, 21 Aug 2022 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661094875;
        bh=0Xe4FmI6GaYafYaomc5i0AHJjXtykd6YBZmbrE8g8jg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bJjVG6Ub5rFKC8f34OpwUpPqGLhi2t03j2bCDdeOnx5n3SrPntlViIT7cP5tVy2qb
         /7r8gvg3zFyQTnpcK3CqG+rWAwlkr4S8BWLt8RKsXVC66rjNXiCmXoXQ6zs5lQqRnm
         M3FxEWsnQ0RAjy+LLO9HOVKgTTZUZRwCfqHYylKTNKPgM0R3flqQwtkwayStxbUsJU
         SvPpOnauoV/3OIBpi3bxbUOmh26hZ7uBz5vfmZP0cHBltHu70HsGdDKgkb8GW2sb2e
         WUN6Kr2ygaNmdm1dEaS8K0zxn10x60f0SoRG8LY4yWk32FyJkQSbn2bZ2aPNZ4/e3A
         40LvhiqNkps/w==
Date:   Mon, 22 Aug 2022 00:14:30 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 6/6] tracing: Have filter accept "common_cpu" to be
 consistent
Message-Id: <20220822001430.7f885eb32efc53c1388dd132@kernel.org>
In-Reply-To: <20220820134401.513062765@goodmis.org>
References: <20220820134316.156058831@goodmis.org>
        <20220820134401.513062765@goodmis.org>
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

On Sat, 20 Aug 2022 09:43:22 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Make filtering consistent with histograms. As "cpu" can be a field of an
> event, allow for "common_cpu" to keep it from being confused with the
> "cpu" field of the event.
> 
> Link: https://lore.kernel.org/all/20220820220920.e42fa32b70505b1904f0a0ad@kernel.org/
> 

This looks good to me. Thanks!

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

> Cc: stable@vger.kernel.org
> Fixes: 1e3bac71c5053 ("tracing/histogram: Rename "cpu" to "common_cpu"")
> Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 181f08186d32..0356cae0cf74 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -176,6 +176,7 @@ static int trace_define_generic_fields(void)
>  
>  	__generic_field(int, CPU, FILTER_CPU);
>  	__generic_field(int, cpu, FILTER_CPU);
> +	__generic_field(int, common_cpu, FILTER_CPU);
>  	__generic_field(char *, COMM, FILTER_COMM);
>  	__generic_field(char *, comm, FILTER_COMM);
>  
> -- 
> 2.35.1


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
