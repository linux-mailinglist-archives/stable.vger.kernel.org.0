Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7A65E00B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbjADWeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbjADWeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:34:16 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5815642E06;
        Wed,  4 Jan 2023 14:34:14 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id v23so37797573pju.3;
        Wed, 04 Jan 2023 14:34:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFcGgrlnInq+98rpZdTRIXveI0p5krEuOABzJSNz1vE=;
        b=JUVYZzP4yyyRRW3q7H7+iD+H7LOg/LZY3YrcKnZBSFf1D9lzjmy5tvu/2ykyyjWKwy
         WM/25S81Rk4wiXB4Ktv+9ToXWLo2cHy9xZl8amx0CntM6Y3xFp0C7UNDW6EPG3ir63Su
         Vjq7N7RhFS6++GNkxqS6+gVsRdzml8XR0TnedMCTG0RsrtbxpQH1YVKD5FBlfsbfeuD5
         vHEh5zPjgTjFWsRy2aLoyQhL6uw/ysB81zep+Hhsdv3sTzq6giTnMPsO7S0XTDE/Rohe
         LizkibOL1bGYsmFM2MXzKQgbha9NQ69lw3IXWmAf+aGNs1U00+/cTHFr5+u+lAnzaYeb
         C5yA==
X-Gm-Message-State: AFqh2krREZFfmTUxEt7S9usyXu9efNezi3MBQc746fLxe9N3OjlbpQpC
        SWXDkDZ89ZKpGVewRWQ5hzw=
X-Google-Smtp-Source: AMrXdXvvk5tMtlkFlL4QSprV6QfqR2bYRvQpuF4tJgaecnG8lmz0yz44H7JTvnKqjINdoXDG2s81hQ==
X-Received: by 2002:a17:902:ab11:b0:191:33e2:452d with SMTP id ik17-20020a170902ab1100b0019133e2452dmr46100755plb.24.1672871653665;
        Wed, 04 Jan 2023 14:34:13 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902c60a00b001869b988d93sm24621987plr.187.2023.01.04.14.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 14:34:12 -0800 (PST)
Message-ID: <32c122e6-d87d-307b-72c8-a0ac74c42602@acm.org>
Date:   Wed, 4 Jan 2023 14:34:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Can Guo <quic_cang@quicinc.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
 <DM6PR04MB657555DBC49DF54716A98B6DFCF59@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657555DBC49DF54716A98B6DFCF59@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/23 00:24, Avri Altman wrote:
>   
>> On 12/22/22 02:21, Johan Hovold wrote:
>>> +     /* Enable Write Booster if we have scaled up else disable it */
>>> +     if (ufshcd_enable_wb_if_scaling_up(hba))
>>> +             ufshcd_wb_toggle(hba, scale_up);
>>
>> Hi Asutosh,
>>
>> This patch is the second complaint about the mechanism that toggles the
>> WriteBooster during clock scaling. Can this mechanism be removed entirely?
> commit 87bd05016a64 that introduced UFSHCD_CAP_WB_WITH_CLK_SCALING enables
> the platform vendors and OEMs to maintain wb toggling - should they choose so.
> Why remove it in its entirety?

Hi Avri,

I'm in favor of keeping kernel code simple :-)

UFSHCD_CAP_WB_WITH_CLK_SCALING controls whether or not clock scaling 
affects the WriteBooster depending on which host controller is in use. 
Shouldn't this depend on which UFS device is present instead of on the 
type of host controller?

Thanks,

Bart.

