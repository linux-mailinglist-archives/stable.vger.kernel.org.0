Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BCE26BD38
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgIPGds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIPGdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:33:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CAA3206A5;
        Wed, 16 Sep 2020 06:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600238026;
        bh=v98Ux7dwZYwFgt6/Idh2G0/wQfplByJeeDP1GaXQ/FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k7kKxMSaCXIv5jy6MoB51KJ0ASDE7hbYwh7xV3MIy0q0EQsGJhoDlCAiQUMQLQlwN
         bihJ25tIvji6rGQsGKtw9KVTIMbOAzKgWHg4XiNHZidwMJ/1nxFKZ5R99hQNXd1ZJV
         Zc15TMbH1Tb6Ug10L9F7m9Z3RHOaLMVwaECDw+ak=
Date:   Wed, 16 Sep 2020 08:34:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: apr: Fixup the error displayed on lookup
 failure
Message-ID: <20200916063416.GM142621@kroah.com>
References: <20200915154232.27523-1-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915154232.27523-1-sibis@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 09:12:32PM +0530, Sibi Sankar wrote:
> APR client incorrectly prints out "ret" variable on pdr_add_lookup failure,
> it should be printing the error value returned by the lookup instead.
> 
> Fixes: 8347356626028 ("soc: qcom: apr: Add avs/audio tracking functionality")
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> ---
>  drivers/soc/qcom/apr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
> index 1f35b097c6356..7abfc8c4fdc72 100644
> --- a/drivers/soc/qcom/apr.c
> +++ b/drivers/soc/qcom/apr.c
> @@ -328,7 +328,7 @@ static int of_apr_add_pd_lookups(struct device *dev)
>  
>  		pds = pdr_add_lookup(apr->pdr, service_name, service_path);
>  		if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
> -			dev_err(dev, "pdr add lookup failed: %d\n", ret);
> +			dev_err(dev, "pdr add lookup failed: %ld\n", PTR_ERR(pds));
>  			return PTR_ERR(pds);
>  		}
>  	}
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
