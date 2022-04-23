Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2250C777
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 07:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiDWFGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 01:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiDWFGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 01:06:21 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D331F8EF4;
        Fri, 22 Apr 2022 22:03:25 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id p8so9835237pfh.8;
        Fri, 22 Apr 2022 22:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vD0W6bI9inxY1IqwYpYGCs5VOO5jHMZ9Ui2cOWh/okI=;
        b=RWffJnpR0EMAvWQ4n2uAQXH5VLGnAAh/w4N9lv+SQOf4g6YmvoL9PFiFykGtYKhk7x
         grsCxY+NknzeRoR12SmHnJqHcKY4pph25sgJqAY+Lbo4ra8rU3GvcdqBL9omc9twkdIC
         oMe4adn6AwuBdfuawmRqT2v+eUIUz2ZAE2gImJ47Ghl/aAHiZenZWWsuoj1yXb+3BCwM
         ifpS6TbmsfKApb7HnQ1X1/8TlrJcfac5lag46NuEtw/KoyFvtSMDtGpPB69LlgNpuUqE
         dygL8IfQTH7uYgC6SkiuixzzRQqaHsw0YbMvobXXlFxm6FSFKeE6oCBU2hVR0o10lo2c
         WARw==
X-Gm-Message-State: AOAM533xQsTJGJDcfOqdykMC6p5QsJzIA5Si0h39Toq3ANa13WPhDcNZ
        Vlz2Q70kuV4X2LXvJV66t9c=
X-Google-Smtp-Source: ABdhPJx6rWeo45nxheFodGYu+usoypVGBw0VrjbV/QATcx3S17+KMoJacGaZFY6u3PPv2KOdDQPdXw==
X-Received: by 2002:a05:6a00:164c:b0:50a:472a:6b0a with SMTP id m12-20020a056a00164c00b0050a472a6b0amr8424873pfc.77.1650690204550;
        Fri, 22 Apr 2022 22:03:24 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id r19-20020a17090b051300b001cd4989ff5esm7630037pjz.37.2022.04.22.22.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 22:03:23 -0700 (PDT)
Message-ID: <5ee685f5-152c-aca0-cc14-646cfae93000@acm.org>
Date:   Fri, 22 Apr 2022 22:03:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 3/5] scsi: ufs: qcom: Add a readl() to make sure ref_clk
 gets enabled
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
 <20220422132140.313390-4-manivannan.sadhasivam@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220422132140.313390-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/22 06:21, Manivannan Sadhasivam wrote:
> In ufs_qcom_dev_ref_clk_ctrl(), it was noted that the ref_clk needs to be
> stable for atleast 1us. Eventhough there is wmb() to make sure the write
                ^              ^
Some spaces are missing.

> gets "completed", there is no guarantee that the write actually reached
> the UFS device. There is a good chance that the write could be stored in
> a Write Buffer (WB). In that case, eventhough the CPU waits for 1us, the
                                          ^
missing space----------------------------

> ref_clk might not be stable for that period.
> 
> So lets do a readl() to make sure that the previous write has reached the
> UFS device before udelay().
> 
> Cc: stable@vger.kernel.org
> Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/scsi/ufs/ufs-qcom.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 5f0a8f646eb5..5b9986c63eed 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -690,6 +690,12 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>   		/* ensure that ref_clk is enabled/disabled before we return */
>   		wmb();
>   
> +		/*
> +		 * Make sure the write to ref_clk reaches the destination and
> +		 * not stored in a Write Buffer (WB).
> +		 */
> +		readl(host->dev_ref_clk_ctrl_mmio);
> +
>   		/*
>   		 * If we call hibern8 exit after this, we need to make sure that
>   		 * device ref_clk is stable for at least 1us before the hibern8

The comment above the wmb() call looks wrong to me. How about removing 
that wmb() call?

Thanks,

Bart.
