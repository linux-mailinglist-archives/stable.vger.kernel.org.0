Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5D40F4D1
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbhIQJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 05:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbhIQJcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 05:32:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09CAC061764
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 02:31:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t8so14106174wrq.4
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 02:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QTIEOKxWLANQY5Sj91t8yOn88f8yDa6LMFP2RHaNCbU=;
        b=GKjKa7mQ/CCe6yL2G2vt6fueccCqqIcdpTBpt403pgw36KTYxx/xRwKNVVCvnjlxnN
         hFuNy8EHYO68vINTCh2lakvwsgY0MQRjluMi9brGpT4tkZe3xVdHrFuPgSUgicqF06Cg
         FHuzn8TTmjiTEncwmE+0iZoOPizXLfGAAi9KDuSUQUSD5OrEORjMMNrIXy6A4HSRuUbZ
         2RRQzQZzwdSLvUIpG78ztrfBQSlI2iZeojPpmfLp2QrcaZIxIgHk2P3rOTEvCybDQ+Qr
         rqHgtpW5W3565sOjX0x0+W6l0LHBS/WFSMvchC5L31J7kVXq/W0k/EMOZOj+SnwOjqrQ
         8jHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QTIEOKxWLANQY5Sj91t8yOn88f8yDa6LMFP2RHaNCbU=;
        b=K1KNBzN3De3hv6VsYNBETFvwW6s4pl8afT/47P+muWVfmCRxp/ru+pGlYYrGZ3PNP7
         qsMCzDbDcEzpAk5TacbpGyWYQZX7lF/ws3D+qYf5x4yOdj/czloj7TQdNpWdaEHQSb5Z
         yxacLEsZb2ktlZiy2XTYgcJkpC7JtJ/TDX/AxO6018DthS5DmeFv2KJc5OAGdzoxXiYx
         jibc/WQB9kNzxlW0yRSh8N/vfYwhfYXQB4YYZoUtgOB9q1tAilE8SeImEErsVsrLH7g+
         rptkVf7cm48u7vsFXLz3wb976kxiM3EnFH12DyqPpwA/bNGu1SlFnSs8fdIIlALvTLSL
         KEuw==
X-Gm-Message-State: AOAM530rInNLPb1NycXPytPZjkQ4xLqoathoVPqQnTFoBseOSwa+LxTO
        xP9Rj0Fp/TxZzXin70ycCNctQOLayuqfoQ==
X-Google-Smtp-Source: ABdhPJwbOrjqjTlETXUGsgOiKGwf3FZ90pR2q9c3P3vpwSuX6hrzPFMg526xOQKJqu0xjArPDmTesQ==
X-Received: by 2002:a5d:444a:: with SMTP id x10mr10915654wrr.360.1631871062127;
        Fri, 17 Sep 2021 02:31:02 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:cf95:6508:8470:7171? ([2a01:e34:ed2f:f020:cf95:6508:8470:7171])
        by smtp.googlemail.com with ESMTPSA id q19sm10215879wmq.29.2021.09.17.02.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 02:31:01 -0700 (PDT)
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
Message-ID: <55999619-22c7-63fd-7006-f91f144e4a60@linaro.org>
Date:   Fri, 17 Sep 2021 11:31:00 +0200
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

comment (1)

AFAICT, if data->ops != NULL then data->ops->get_temp is also != NULL
because of the code allocating/freeing the ops structure.

The tests can be replaced by (!data->ops), no ?

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

comment (2)

The test looks pointless here (I mean both of them).

If of_thermal_set_emul_temp() is called it is because the callback was
set in thermal_zone_of_add_sensor().

This one does:

	tz->ops = ops;

and
	if (ops->set_emul_temp)
                tzd->ops->set_emul_temp = of_thermal_set_emul_temp;

If I'm not wrong if we are called, then data->ops &&
data->ops->set_emul_temp is always true, right ?


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

Same comment as (1)

>  	return data->ops->get_trend(data->sensor_data, trip, trend);
> @@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>  	if (trip >= data->ntrips || trip < 0)
>  		return -EDOM;
>  
> -	if (data->ops->set_trip_temp) {
> +	if (data->ops && data->ops->set_trip_temp) {

Same comment as (2)

>  		int ret;
>  
>  		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
