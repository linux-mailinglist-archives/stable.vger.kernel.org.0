Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7046AC018
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCFNB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCFNB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:01:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23792CC40;
        Mon,  6 Mar 2023 05:00:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FE26B80DFE;
        Mon,  6 Mar 2023 13:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53AAC433D2;
        Mon,  6 Mar 2023 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678107640;
        bh=Tq+ejnM8EgKEmGpRqfw+eZW2i/bKA895J5AlzxwrEK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qs5sO7oW/Iqwf/4SBfKK0bBIBKsl2SLt7RBxapjEnAm7hU8mv9AYlmYE26eKWU+XV
         1QQHGyJQdf8bUVoiVkoK/F79GJ+IQlyYCXgZMywKaCyyn57WqAQJzvm1pfLwRDAKiA
         cRL8B9YoAvNqzzO/6oxB199bvUG9VNO+Sz9oi/VAwI0cLjgFQmAmXJuwNXrwIJHGa/
         K2qIuPwui4ljBRkgIX3Z+qFAPNjy6EoUPC9pRscBeAtqomZbV+w9mxnFROwpk0YBNJ
         DZPL7YvOJb7DvVpbgg6lgVI4Ort9Q6PPtohFNkfVT/DhnkIXmyRybTfNLKeUhFBH8P
         B3nwh72Bt7pcw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pZASu-0001wC-Go; Mon, 06 Mar 2023 14:01:20 +0100
Date:   Mon, 6 Mar 2023 14:01:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Abel Vesa <abel.vesa@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] soc: qcom: llcc: Fix slice configuration values for
 SC8280XP
Message-ID: <ZAXkIHOom26DlVx0@hovoldconsulting.com>
References: <20230219165701.2557446-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219165701.2557446-1-abel.vesa@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 19, 2023 at 06:57:01PM +0200, Abel Vesa wrote:
> The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
> LLCC config registers. Fix that by using the slice ID values taken from
> the latest LLCC SC table.

This still doesn't really explain what the impact of this bug is (e.g.
for people doing backports), but I guess this will do.

> Fixes: ec69dfbdc426 ("soc: qcom: llcc: Add sc8180x and sc8280xp configurations")
> Cc: stable@vger.kernel.org	# 5.19+
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> Tested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
> Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>

> ---
> 
> The v2 is here:
> https://lore.kernel.org/all/20230127144724.1292580-1-abel.vesa@linaro.org/
> 
> Changes since v2:
>  * specifically mentioned the 3 slice IDs that are being fixed and
>    what is happening without this patch
>  * added stabke Cc line
>  * added Juerg's T-b tag
>  * added Sai's R-b tag
>  * added Konrad's A-b tag
> 
> Changes since v1:
>  * dropped the LLCC_GPU and LLCC_WRCACHE max_cap changes
>  * took the new values from documentatio this time rather than
>    downstream kernel
> 
>  drivers/soc/qcom/llcc-qcom.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> index 23ce2f78c4ed..26efe12012a0 100644
> --- a/drivers/soc/qcom/llcc-qcom.c
> +++ b/drivers/soc/qcom/llcc-qcom.c
> @@ -191,9 +191,9 @@ static const struct llcc_slice_config sc8280xp_data[] = {
>  	{ LLCC_CVP,      28, 512,  3, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
>  	{ LLCC_APTCM,    30, 1024, 3, 1, 0x0,   0x1, 1, 0, 0, 1, 0, 0 },
>  	{ LLCC_WRCACHE,  31, 1024, 1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
> -	{ LLCC_CVPFW,    32, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> -	{ LLCC_CPUSS1,   33, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> -	{ LLCC_CPUHWT,   36, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
> +	{ LLCC_CVPFW,    17, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> +	{ LLCC_CPUSS1,   3, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> +	{ LLCC_CPUHWT,   5, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
>  };
>  
>  static const struct llcc_slice_config sdm845_data[] =  {
