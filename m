Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07B36BFC28
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 19:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCRSfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 14:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRSfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 14:35:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D9C28E99;
        Sat, 18 Mar 2023 11:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDCC160ED4;
        Sat, 18 Mar 2023 18:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45902C4339C;
        Sat, 18 Mar 2023 18:35:35 +0000 (UTC)
Date:   Sat, 18 Mar 2023 14:35:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Tom Zanussi" <zanussi@kernel.org>, <Bobule.chang@mediatek.com>,
        <wsd_upstream@mediatek.com>, Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] tracing: Fix use-after-free and double-free on last_cmd
Message-ID: <20230318143533.1890d9bc@rorschach.local.home>
In-Reply-To: <20230317053044.13828-1-cheng-jui.wang@mediatek.com>
References: <20230317053044.13828-1-cheng-jui.wang@mediatek.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Mar 2023 13:30:44 +0800
Cheng-Jui Wang <cheng-jui.wang@mediatek.com> wrote:

> From: "Tze-nan Wu" <Tze-nan.Wu@mediatek.com>

Hi!

Thanks for the report and the patch. Some nits below.

Also change the subject to:

	tracing/synthetic: Fix races on freeing last_cmd

> ---
>  kernel/trace/trace_events_synth.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
> index 46d0abb32d0f..ce438eccab2e 100644
> --- a/kernel/trace/trace_events_synth.c
> +++ b/kernel/trace/trace_events_synth.c
> @@ -42,16 +42,25 @@ enum { ERRORS };
>  #undef C
>  #define C(a, b)		b
>  
> +static DEFINE_MUTEX(lastcmd_mutex);
> +
>  static const char *err_text[] = { ERRORS };
>  
>  static char *last_cmd;

Please keep the mutex and the variable it protects next to each other:

static DEFINE_MUTEX(lastcmd_mutex);
static char *last_cmd;

>  
>  static int errpos(const char *str)
>  {
> -	if (!str || !last_cmd)
> -		return 0;
> +	int ret = 0;
> +
> +	mutex_lock(&lastcmd_mutex);
> +	if (!str || !last_cmd) {

Change this to just:

	if (!str || !last_cmd)
		goto out;

> +		mutex_unlock(&lastcmd_mutex);
> +		return ret;

> +	}
>  
> -	return err_pos(last_cmd, str);
> +	ret = err_pos(last_cmd, str);

Add:

 out:

> +	mutex_unlock(&lastcmd_mutex);
> +	return ret;
>  }
>  
>  static void last_cmd_set(const char *str)
> @@ -59,18 +68,24 @@ static void last_cmd_set(const char *str)
>  	if (!str)
>  		return;
>  
> +	mutex_lock(&lastcmd_mutex);
>  	kfree(last_cmd);
>  

In this case, you can remove the space:

	mutex_lock(&lastcmd_mutex);
	kfree(last_cmd);
	last_cmd = kstrdup(str, GFP_KERNEL);
	mutex_unlock(&lastcmd_mutex);

>  	last_cmd = kstrdup(str, GFP_KERNEL);
> +	mutex_unlock(&lastcmd_mutex);
>  }
>  
>  static void synth_err(u8 err_type, u16 err_pos)
>  {
> -	if (!last_cmd)
> +	mutex_lock(&lastcmd_mutex);
> +	if (!last_cmd) {

This should be:

	if (!last_cmd)
		goto out;

> +		mutex_unlock(&lastcmd_mutex);
>  		return;
> +	}
>  
>  	tracing_log_err(NULL, "synthetic_events", last_cmd, err_text,
>  			err_type, err_pos);

 out:

> +	mutex_unlock(&lastcmd_mutex);
>  }
>  
>  static int create_synth_event(const char *raw_command);

Thanks,

-- Steve
