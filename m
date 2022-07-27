Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2613958329C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 21:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiG0TBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 15:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiG0TBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 15:01:06 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BB589AAC;
        Wed, 27 Jul 2022 11:12:20 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id f65so16529807pgc.12;
        Wed, 27 Jul 2022 11:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RNVMJ4oZ8yHzMS/5F5vQFWD6tQYWHNz7yT3+sY7HxXA=;
        b=nRkfNNrYt2ZK4DUimkI7vzomXYnIKfQkIWhgYp8MuyFsieNr3q9mU9OfuE5e3Pjoth
         3fCR9Tfp+f9vPEMshygga+rp/9H45P+onm8Dbmm95ji+4TmzoO2hGmMPEti5BZYe2GCS
         u3F91Rzf4J6ifJqNKvnxtfPYeO7qfJ1xPfPp4uQRooqJhVmmtpWeWRGHQNEaCoqSrq0q
         Je7RkjTfjvPdTELu9dr/FcSQMr29FYRJfKsC37/qZVk6J5uzEZ99wmnuhu8TcrL2Km0/
         senzB/A0MCFTymWwPfs+JU/svyaIooyPpylxO0Ouru517XmxKrbhIAvry0+ej1/62VIU
         GKBQ==
X-Gm-Message-State: AJIora8oNOt9fyUPhrXjuKJOOmCLdYKz2OG87WMWk9HyeQ61aGud6uMa
        GWMnfBGYwBN7x8Rfe3QRvIw=
X-Google-Smtp-Source: AGRyM1usI0Gt657atV+HPb4lgLIOIMc5MiSpXSfWbHnB7XKqfY5gstwVxG7jNUFV+C3r+yvf7zuFPQ==
X-Received: by 2002:a05:6a00:1946:b0:52a:e551:2241 with SMTP id s6-20020a056a00194600b0052ae5512241mr22626795pfk.29.1658945539275;
        Wed, 27 Jul 2022 11:12:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a84e:2ec1:1b57:b033? ([2620:15c:211:201:a84e:2ec1:1b57:b033])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902680d00b0016ce31cfea6sm14180388plk.159.2022.07.27.11.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 11:12:18 -0700 (PDT)
Message-ID: <5fab3d4f-914e-63f8-a3e8-7dd92ecdb04a@acm.org>
Date:   Wed, 27 Jul 2022 11:12:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] ufs: core: fix lockdep warning of clk_scaling_lock
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        stable@vger.kernel.org
References: <20220727032110.31168-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220727032110.31168-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/22 20:21, peter.wang@mediatek.com wrote:
> -	/* Enable Write Booster if we have scaled up else disable it */
> -	downgrade_write(&hba->clk_scaling_lock);
> -	is_writelock = false;
> -	ufshcd_wb_toggle(hba, scale_up);
> +	/* Disable clk_scaling until ufshcd_wb_toggle finish */
> +	hba->clk_scaling.is_allowed = false;
> +	wb_toggle = true;
>   
>   out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +	ufshcd_clock_scaling_unprepare(hba);
> +
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (wb_toggle) {
> +		ufshcd_wb_toggle(hba, scale_up);
> +		ufshcd_clk_scaling_allow(hba, true);
> +	}

I'm concerned that briefly disabling clock scaling may cause the clock 
to remain at a high frequency even if it shouldn't. Has the following 
approach been considered? Instead of moving the 
ufshcd_clk_scaling_allow() call, convert dev_cmd.lock into a semaphore, 
lock it near the start of ufshcd_devfreq_scale() and unlock it near the 
end of the same function.

Thanks,

Bart.
