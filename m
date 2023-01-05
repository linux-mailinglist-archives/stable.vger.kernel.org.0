Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FCC65F3DD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbjAESjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 13:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjAESjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 13:39:07 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A47658822;
        Thu,  5 Jan 2023 10:39:01 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id q64so2304262pjq.4;
        Thu, 05 Jan 2023 10:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6z58OIH54ss9cN62GyLhaIjgexylm6sw14uIEBRIwWs=;
        b=zXpoZeXA3/ahCbiHHNwzsWN4kLqTYNGUbh3iJVxnEo18G7Ypy/IyyohsBEVIHiHmr9
         kekNVBTs1o8kmpYekuYm6mQ0QmeYyzC7iLk+UhuBlmSQSH4jOCHvn2W1+N1PqV0LxkJu
         fOszP2a2A3OyH7ojHBAvDrryiwZdm0NlcUwQb29XCpKkHeuJziXvV9GV5yG2drXN/vac
         PNIICWVNtAxMjrj+6nQk1UhRMpD40iA+e++zwFKq3bcx7A+CpPXwYoIjjCe4999mrWSL
         KEVv4l4IqKXewYFLw+Ge2G8iedL/QP2Zf/tN9I08odhYSBzG5LCgeWQ45MKZJSzwUj9N
         04TA==
X-Gm-Message-State: AFqh2kro7BoHxO8DSEQD+0wGHl8tstKzOhOtzC61H2Mc4wIPEStYe6U2
        5HtPrcT0rM2t/aSRibfZ8o0=
X-Google-Smtp-Source: AMrXdXuuDIwImr2AW4/8U7pEe9cDrH/4IUfr35rdJ/vKQ5tn+g3Eex2Pqs8cXFI/4iePpMvHBDAOsg==
X-Received: by 2002:a17:90a:4804:b0:220:bad8:b4e7 with SMTP id a4-20020a17090a480400b00220bad8b4e7mr57715911pjh.7.1672943940910;
        Thu, 05 Jan 2023 10:39:00 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f9eb:49b6:75b:111e? ([2620:15c:211:201:f9eb:49b6:75b:111e])
        by smtp.gmail.com with ESMTPSA id k60-20020a17090a14c200b00225bc0e5f19sm1668520pja.1.2023.01.05.10.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 10:39:00 -0800 (PST)
Message-ID: <349e3564-10d4-9429-93d2-7bb639253fc2@acm.org>
Date:   Thu, 5 Jan 2023 10:38:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221222102121.18682-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 02:21, Johan Hovold wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bda61be5f035..5c3821b2fcf8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1234,12 +1234,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>   	 * clock scaling is in progress
>   	 */
>   	ufshcd_scsi_block_requests(hba);
> +	mutex_lock(&hba->wb_mutex);
>   	down_write(&hba->clk_scaling_lock);
>   
>   	if (!hba->clk_scaling.is_allowed ||
>   	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
>   		ret = -EBUSY;
>   		up_write(&hba->clk_scaling_lock);
> +		mutex_unlock(&hba->wb_mutex);
>   		ufshcd_scsi_unblock_requests(hba);
>   		goto out;
>   	}
> @@ -1251,12 +1253,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>   	return ret;
>   }

Please add an __acquires(&hba->wb_mutex) annotation for sparse.

> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool scale_up)
>   {
> -	if (writelock)
> -		up_write(&hba->clk_scaling_lock);
> -	else
> -		up_read(&hba->clk_scaling_lock);
> +	up_write(&hba->clk_scaling_lock);
> +
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (ufshcd_enable_wb_if_scaling_up(hba))
> +		ufshcd_wb_toggle(hba, scale_up);
> +
> +	mutex_unlock(&hba->wb_mutex);
> +
>   	ufshcd_scsi_unblock_requests(hba);
>   	ufshcd_release(hba);
>   }

Please add a __releases(&hba->wb_mutex) annotation for sparse.

> @@ -1273,7 +1279,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>   static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>   {
>   	int ret = 0;
> -	bool is_writelock = true;
>   
>   	ret = ufshcd_clock_scaling_prepare(hba);
>   	if (ret)
> @@ -1302,15 +1307,8 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>   		}
>   	}
>   
> -	/* Enable Write Booster if we have scaled up else disable it */
> -	if (ufshcd_enable_wb_if_scaling_up(hba)) {
> -		downgrade_write(&hba->clk_scaling_lock);
> -		is_writelock = false;
> -		ufshcd_wb_toggle(hba, scale_up);
> -	}
> -
>   out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +	ufshcd_clock_scaling_unprepare(hba, scale_up);
>   	return ret;
>   }

This patch moves the ufshcd_wb_toggle() from before the out_unprepare 
label to after the out_unprepare label (into 
ufshcd_clock_scaling_unprepare()). Does this change perhaps introduce a 
new call to ufshcd_wb_toggle() in error paths?

Thanks,

Bart.

