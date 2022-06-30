Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4008056127D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 08:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiF3Gd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 02:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiF3Gd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 02:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFE51D31D;
        Wed, 29 Jun 2022 23:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B63A3621E3;
        Thu, 30 Jun 2022 06:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFCCC341C8;
        Thu, 30 Jun 2022 06:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656570807;
        bh=nPEFPrPtdVh2QLJJmOrwjSXNzitArnEp1EbX64wR4Jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kN7mLsawPOzmKuEVqFES3B4pP/gB9GaJbuPRvDquP0ryJLs/Gi3I9vWhMNQOiPDtG
         5N+H6ckUZahTt2vgE/xnVG8rPON9mfgWJzMjII0pdhShiTHaEUZnQYngiaUKVUzott
         r3qZePmujv0GG/HU1zdODlk+o5ejWrYbNLZcNugU=
Date:   Thu, 30 Jun 2022 08:33:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     rostedt@goodmis.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        trix@redhat.com, stable@vger.kernel.org, zhangjinhao2@huawei.com
Subject: Re: [PATCH] tracing/histograms: Simplify create_hist_fields()
Message-ID: <Yr1DtC4Gvg00SVfr@kroah.com>
References: <20220630013152.164871-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630013152.164871-1-zhengyejian1@huawei.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 09:31:52AM +0800, Zheng Yejian wrote:
> When I look into implements of create_hist_fields(), I think there can be
> following two simplifications:
>   1. If something wrong happened in parse_var_defs(), free_var_defs() would
>      have been called in it, so no need goto free again after calling it;
>   2. After calling create_key_fields(), regardless of the value of 'ret', it
>      then always runs into 'out: ', so the judge of 'ret' is redundant.
> 
> No functional changes.
> 
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/trace/trace_events_hist.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 2784951e0fc8..832c4ccf41ab 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4454,7 +4454,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>  
>  	ret = parse_var_defs(hist_data);
>  	if (ret)
> -		goto out;
> +		return ret;
>  
>  	ret = create_val_fields(hist_data, file);
>  	if (ret)
> @@ -4465,8 +4465,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>  		goto out;
>  
>  	ret = create_key_fields(hist_data, file);
> -	if (ret)
> -		goto out;
> +
>   out:
>  	free_var_defs(hist_data);
>  
> -- 
> 2.32.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
