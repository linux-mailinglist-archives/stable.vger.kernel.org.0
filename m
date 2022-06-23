Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B035574A8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiFWH6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiFWH55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:57:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2FFB65;
        Thu, 23 Jun 2022 00:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5818261B89;
        Thu, 23 Jun 2022 07:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50537C3411B;
        Thu, 23 Jun 2022 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655971072;
        bh=BlYOfMCq2JsqV69qlOn0Brwdjr5CZEK7g18REB4tZ78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HvZSrzOaMjyZDkaKdl+Yc2aCSDzpBxZwh9l13VmXLUjYzGr8LOq+s//BrBfacTfO+
         E9adw6U4drivCqV9abdby5yszvqf0ncujSREJR7X1SjizLZ+2WS5nrV86ZtzL4LYS+
         n9DtUrIgjyzv1Wu7uDcQrSCOmFi048kWG87icZ7M=
Date:   Thu, 23 Jun 2022 09:57:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jinzhou Su <Jinzhou.Su@amd.com>
Cc:     rjw@rjwysocki.net, linux-pm@vger.kernel.org, ray.huang@amd.com,
        alexander.deucher@amd.com, xiaojian.du@amd.com, perry.yuan@amd.com,
        li.meng@amd.com, richardqi.liang@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq: amd-pstate: Add resume and suspend callback for
 amd-pstate
Message-ID: <YrQc/T+mARRVbIHl@kroah.com>
References: <20220623031509.555269-1-Jinzhou.Su@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623031509.555269-1-Jinzhou.Su@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 11:15:09AM +0800, Jinzhou Su wrote:
> When system resumes from S3, the CPPC enable register will be
> cleared and reset to 0. So sets this bit to enable CPPC
> interface by writing 1 to this register.
> 
> Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
> ---
>  drivers/cpufreq/amd-pstate.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
> index 7be38bc6a673..9ac75c1cde9c 100644
> --- a/drivers/cpufreq/amd-pstate.c
> +++ b/drivers/cpufreq/amd-pstate.c
> @@ -566,6 +566,28 @@ static int amd_pstate_cpu_exit(struct cpufreq_policy *policy)
>  	return 0;
>  }
>  
> +static int amd_pstate_cpu_resume(struct cpufreq_policy *policy)
> +{
> +	int ret;
> +
> +	ret = amd_pstate_enable(true);
> +	if (ret)
> +		pr_err("failed to enable amd-pstate during resume, return %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int amd_pstate_cpu_suspend(struct cpufreq_policy *policy)
> +{
> +	int ret;
> +
> +	ret = amd_pstate_enable(false);
> +	if (ret)
> +		pr_err("failed to disable amd-pstate during suspend, return %d\n", ret);
> +
> +	return ret;
> +}
> +
>  /* Sysfs attributes */
>  
>  /*
> @@ -636,6 +658,8 @@ static struct cpufreq_driver amd_pstate_driver = {
>  	.target		= amd_pstate_target,
>  	.init		= amd_pstate_cpu_init,
>  	.exit		= amd_pstate_cpu_exit,
> +	.suspend	= amd_pstate_cpu_suspend,
> +	.resume		= amd_pstate_cpu_resume,
>  	.set_boost	= amd_pstate_set_boost,
>  	.name		= "amd-pstate",
>  	.attr           = amd_pstate_attr,
> -- 
> 2.32.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
