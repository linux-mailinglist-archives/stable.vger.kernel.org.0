Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA0423BFC
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbhJFLKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbhJFLKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:10:20 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756AAC061753
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 04:08:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r10so7608445wra.12
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NPYO1x8t8q66IiDTyVlrAaxm7/2JWwiYPINC/gUajk0=;
        b=teGOKFdDhDsSTSXzlKK/3F6rCmpFIHzypmyst45m2zsOMJvdqVwxTBuWIpItl00H9B
         YdNO9ZlryPCTJ+LAB4/bOYdPAzARCQmx5BEYYbk1xsVHSy84eL9lW6PoLTzJhC6G/ylZ
         fStW2ibbzcM69WecqB69/rlps535APGOs+loGZeZoOvJ1qInElCX2tVpMZEOS2Fdn8X/
         5nDlEtdHaC0HwT1hmF4sWLznBxPkafMSE96WIWxWkIKK08cvN15zfVxQkh9LyT/RF+Qr
         8u0cJNnX8pVEoTfLTBHoCg6KNeXPh+9a/bCmB1Xs8mRH+xFPReNqrJcbEX6qFrrwksp5
         39lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NPYO1x8t8q66IiDTyVlrAaxm7/2JWwiYPINC/gUajk0=;
        b=L3nDRNGMm0qnPXJlwEFMMLXDnxW9lOSfWHsVHPqKHBSMTp6JzpKDJ4B80/8yWpNgl7
         HPn3bNDGkQ45EstjV4GIlfrA9PCo0YNOGHAEashM/XWbePHtxUuCCIlR1pVH4lLEY5lG
         o+TsfLDoRVrIf9X7uxZTwXFHQvXkctW0EN5oA7m4Nfq4ocl3xPiylI00EZ9BPKDFCdSq
         IjTwQ2O7oI6UnMgSq0tAZqzIHmHkyZPdU5yHeFuQI1NNyvciS7gD6B+z/nFpuD7aDoR1
         jc9HxCZudJD7Tnj541Cn72PZEQZzt2Mmt6bdmDqSftTnmoaE/w9zJENcdtGm0rr69ob4
         WaOA==
X-Gm-Message-State: AOAM533uBabdxTA3wgk6JY8cMwtiJljIL6milZh/QUjWb1NTU4IXHJKr
        cIcogcEWEkoSspfxsnSgFnF4l09fsL2Hcg==
X-Google-Smtp-Source: ABdhPJzN31a8fb3hArFNzP0zK4gXJkh4yXbULm107s+BMWZSrv4Tlus6Q1F6cUhoA54qewVUya/IyA==
X-Received: by 2002:a1c:4e0f:: with SMTP id g15mr9142233wmh.74.1633518496285;
        Wed, 06 Oct 2021 04:08:16 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:278:1f59:2992:87fe? ([2a01:e34:ed2f:f020:278:1f59:2992:87fe])
        by smtp.googlemail.com with ESMTPSA id r9sm20587793wru.2.2021.10.06.04.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:08:15 -0700 (PDT)
Subject: Re: [PATCH v2] thermal: Fix a NULL pointer dereference
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Ram Chandrasekar <rkumbako@codeaurora.org>,
        stable@vger.kernel.org
References: <1631041289-11804-1-git-send-email-quic_subbaram@quicinc.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <003252f2-510f-e9ea-0032-6034f26aad11@linaro.org>
Date:   Wed, 6 Oct 2021 13:08:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1631041289-11804-1-git-send-email-quic_subbaram@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/09/2021 21:01, Subbaraman Narayanamurthy wrote:
> of_parse_thermal_zones() parses the thermal-zones node and registers a
> thermal_zone device for each subnode. However, if a thermal zone is
> consuming a thermal sensor and that thermal sensor device hasn't probed
> yet, an attempt to set trip_point_*_temp for that thermal zone device
> can cause a NULL pointer dereference. Fix it.
> 
>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>  ...
>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020

I'm still not convinced by the changes.

Could please tell the commit-id where this is happening and give the
procedure to reproduce the bug ?


>  ...
>  Call trace:
>   of_thermal_set_trip_temp+0x40/0xc4
>   trip_point_temp_store+0xc0/0x1dc
>   dev_attr_store+0x38/0x88
>   sysfs_kf_write+0x64/0xc0
>   kernfs_fop_write_iter+0x108/0x1d0
>   vfs_write+0x2f4/0x368
>   ksys_write+0x7c/0xec
>   __arm64_sys_write+0x20/0x30
>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>   do_el0_svc+0x28/0xa0
>   el0_svc+0x14/0x24
>   el0_sync_handler+0x88/0xec
>   el0_sync+0x1c0/0x200
> 
> While at it, fix the possible NULL pointer dereference in other
> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
> of_thermal_get_trend().
> 
> Cc: stable@vger.kernel.org
> Suggested-by: David Collins <quic_collinsd@quicinc.com>
> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> ---
> Changes for v2:
> - Added checks in of_thermal_get_temp(), of_thermal_set_emul_temp(), of_thermal_get_trend().
> 
>  drivers/thermal/thermal_of.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index 6379f26..9233f7e 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
>  {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	if (!data->ops->get_temp)
> +	if (!data->ops || !data->ops->get_temp)
>  		return -EINVAL;
>  
>  	return data->ops->get_temp(data->sensor_data, temp);
> @@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
>  {
>  	struct __thermal_zone *data = tz->devdata;
>  
> +	if (!data->ops || !data->ops->set_emul_temp)
> +		return -EINVAL;
> +
>  	return data->ops->set_emul_temp(data->sensor_data, temp);
>  }
>  
> @@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>  {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	if (!data->ops->get_trend)
> +	if (!data->ops || !data->ops->get_trend)
>  		return -EINVAL;
>  
>  	return data->ops->get_trend(data->sensor_data, trip, trend);
> @@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>  	if (trip >= data->ntrips || trip < 0)
>  		return -EDOM;
>  
> -	if (data->ops->set_trip_temp) {
> +	if (data->ops && data->ops->set_trip_temp) {
>  		int ret;
>  
>  		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
