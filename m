Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4C40D1A3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 04:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhIPCYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 22:24:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41756 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbhIPCYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 22:24:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631758970; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=PEK9TEZywfdNw/09e0JsNMsCaTjkdxWwYJarz23KSOc=;
 b=TcmLAlkZbDmI9Z4Q8Mk6Va3TzNaiv5WCA+MKEn+K/0oxEexDSt2atPbEkh5tGpZF3PHvxkp7
 aWn9sZvl6v2j4DkjwpG2GUGdgjbs9Y700X4KPEwHzWbkZAY+nbzvgVHM0NaB4kzWkiyJ9vd0
 UtYED5UpKs+2nWSlc4+MpENtSW8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6142aa62b585cc7d24d98ba7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 02:22:26
 GMT
Sender: abhinavk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E97FC4360C; Thu, 16 Sep 2021 02:22:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: abhinavk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0266C4338F;
        Thu, 16 Sep 2021 02:22:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Sep 2021 19:22:25 -0700
From:   abhinavk@codeaurora.org
To:     Fabio Estevam <festevam@gmail.com>
Cc:     robdclark@gmail.com, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, dmitry.baryshkov@linaro.org,
        stable@vger.kernel.org
Subject: Re: [Freedreno] [PATCH] drm/msm: Do not run snapshot on non-DPU
 devices
In-Reply-To: <20210914174831.2044420-1-festevam@gmail.com>
References: <20210914174831.2044420-1-festevam@gmail.com>
Message-ID: <96038e06b1141ad3348611a25544356e@codeaurora.org>
X-Sender: abhinavk@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabio

On 2021-09-14 10:48, Fabio Estevam wrote:
> Since commit 98659487b845 ("drm/msm: add support to take dpu snapshot")
> the following NULL pointer dereference is seen on i.MX53:
> 
> [ 3.275493] msm msm: bound 30000000.gpu (ops a3xx_ops)
> [ 3.287174] [drm] Initialized msm 1.8.0 20130625 for msm on minor 0
> [ 3.293915] 8<--- cut here ---
> [ 3.297012] Unable to handle kernel NULL pointer dereference at
> virtual address 00000028
> [ 3.305244] pgd = (ptrval)
> [ 3.307989] [00000028] *pgd=00000000
> [ 3.311624] Internal error: Oops: 805 [#1] SMP ARM
> [ 3.316430] Modules linked in:
> [ 3.319503] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
> 5.14.0+g682d702b426b #1
> [ 3.326652] Hardware name: Freescale i.MX53 (Device Tree Support)
> [ 3.332754] PC is at __mutex_init+0x14/0x54
> [ 3.336969] LR is at msm_disp_snapshot_init+0x24/0xa0
> 
> i.MX53 does not use the DPU controller.
> 
> Fix the problem by only calling msm_disp_snapshot_init() on platforms 
> that
> use the DPU controller.
> 
> Cc: stable@vger.kernel.org
> Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/gpu/drm/msm/msm_drv.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/msm_drv.c 
> b/drivers/gpu/drm/msm/msm_drv.c
> index 2e6fc185e54d..2aa2266454b7 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -630,10 +630,11 @@ static int msm_drm_init(struct device *dev,
> const struct drm_driver *drv)
>  	if (ret)
>  		goto err_msm_uninit;
> 
> -	ret = msm_disp_snapshot_init(ddev);
> -	if (ret)
> -		DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", ret);
> -
> +	if (kms) {
> +		ret = msm_disp_snapshot_init(ddev);
> +		if (ret)
> +			DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", 
> ret);
> +	}
Are you not using DPU or are you not using mdp4/mdp5 as well? Even if 
you are using any of mdps, kms should
not be NULL. Hence wanted to check the test case.

>  	drm_mode_config_reset(ddev);
> 
>  #ifdef CONFIG_DRM_FBDEV_EMULATION
