Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5165E003
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbjADWbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbjADWbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:31:37 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4ECC778;
        Wed,  4 Jan 2023 14:31:35 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id a184so13173075pfa.9;
        Wed, 04 Jan 2023 14:31:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rE/XSL3eCp2mV2wORWtmG2PyI2xCMLuVm583jQV+GOw=;
        b=vm0irkdtNVTpJOWpYL1nMVsUuTflR/PEGO+nnFeKEhjOOOPrIwNQcjPlYbO3UZI9nz
         Pju1unUOgFy2CVTHBbLO4V1zG+y318PhQTV2ioJogGpoYZsK6HIUgWRrECGZnpcLkqTQ
         xKVcKskX+GwPE/v0NsNUdVEEGOFtGLWZL13ZKRDmopA3S94WWghF7L2id+2jUUU5fEnu
         jm4xIkx6fqygFKtPOXtufmxammFp6fnzxGGFXDRCoRX8KLyLJ6It19YJyM/pSg9Mfxw3
         Kbzi6lA8PUCD7IfrsCY/WQ1flU+OWhrakHp/vixyQY0uIXzJvq5byTEXK3n9OEUcAHVc
         DC0A==
X-Gm-Message-State: AFqh2ko5tl+NW0A5eeT4PC8/yb9ybhYdPLYv3OAzUKZir2AhfvMug+kz
        kkCPz2Sq+ZA9Y+69+2p2xu8=
X-Google-Smtp-Source: AMrXdXv8NcxogYPwXAxiLkK2N+rGKjTZjehxFMMTGR681zYPUVvThikpNmHpuoJhgExHnDWpuoq5Dg==
X-Received: by 2002:aa7:8b1a:0:b0:582:26bc:a75b with SMTP id f26-20020aa78b1a000000b0058226bca75bmr15743628pfd.9.1672871494911;
        Wed, 04 Jan 2023 14:31:34 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f3-20020aa79d83000000b0058193135f6bsm13978144pfq.84.2023.01.04.14.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 14:31:33 -0800 (PST)
Message-ID: <3db8c140-2e4e-0d75-4d81-b2c1f22f68d1@acm.org>
Date:   Wed, 4 Jan 2023 14:31:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Content-Language: en-US
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
 <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
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

On 1/4/23 06:10, Asutosh Das wrote:
> Load based toggling of WB seemed fine to me then.
> I haven't thought about another method to toggle WriteBooster yet.
> Let me see if I can come up with something.
> IMT if you have a mechanism in mind, please let me know.

Hi Asutosh,

Which UFS devices need this mechanism? All UFS devices I'm familiar with 
can achieve wire speed for large write requests without enabling the 
WriteBooster.

Thanks,

Bart.

