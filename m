Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5DD529ED1
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiEQKHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343792AbiEQKG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F312A94;
        Tue, 17 May 2022 03:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67B761517;
        Tue, 17 May 2022 10:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC3C385B8;
        Tue, 17 May 2022 10:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652782003;
        bh=XlqTAv1FNt4wuVoQs8XijZak1Ap75Io+Uk9IaLscBbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/MB8FTB5QtP8P1grjTukVw1xkJhMQfj+g7BVQTw4gcPma8D70mVdfzT3qYWLstfZ
         6U3fBQ6QwCjtK11LE/qPXAwVoKGwuA/p3Oo54qCV+stUK4Fisf6KQrjY6rdiG92vxX
         +YzP6YYAzZJLR8TaJLQD9L50TUxBCcCpCuT59LaU=
Date:   Tue, 17 May 2022 12:06:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: fix possible null pointer dereference
Message-ID: <YoNzr1ciY12Bg6Rv@kroah.com>
References: <20220517095723.7426-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095723.7426-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:57:23PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> In hist_trigger_elt_data_alloc(), elt_data is freed by
> hist_elt_data_free() if kcalloc fails.
> 
> static int hist_trigger_elt_data_alloc(struct tracing_map_elt *elt)
> {
> ...
> elt_data->field_var_str = kcalloc(n_str, sizeof(char *), GFP_KERNEL);
>         if (!elt_data->field_var_str) {
>                 hist_elt_data_free(elt_data);
>                 return -EINVAL;
>         }
> ...}
> 
> In hist_elt_data_free() the elt_data->field_var_str field should be
> checked before dereference.
> 
> Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
> ---
>  kernel/trace/trace_events_hist.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 44db5ba9cabb..73177c9f94b2 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -1576,11 +1576,11 @@ static void hist_elt_data_free(struct hist_elt_data *elt_data)
>  {
>  	unsigned int i;
>  
> -	for (i = 0; i < elt_data->n_field_var_str; i++)
> -		kfree(elt_data->field_var_str[i]);
> -
> -	kfree(elt_data->field_var_str);
> -
> +	if (elt_data->field_var_str) {
> +		for (i = 0; i < elt_data->n_field_var_str; i++)
> +			kfree(elt_data->field_var_str[i]);
> +		kfree(elt_data->field_var_str);
> +	}
>  	kfree(elt_data->comm);
>  	kfree(elt_data);
>  }
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
