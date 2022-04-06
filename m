Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DE14F5C00
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiDFLP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiDFLOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:14:45 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5900848782A;
        Wed,  6 Apr 2022 00:38:03 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id yy13so2486872ejb.2;
        Wed, 06 Apr 2022 00:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=s1nBGBz3envOphEIB9NlZFClpPpalzOLCkN7cvxbdrs=;
        b=YSEOX0uY42lpShDH+d3nXCFVWu0w0x8Xkdpy4XdtJWt625k+bDF+1ScY1bYbY1n71W
         /KaAacna3onn/Hj4p9QLF7wOYiKNHsOn+S6nT6TBghOUTpWe73tuolrTmS8SD2esUzKQ
         LXwnDkhfJ50gS7lIcumlwaVaHMGqxJoiHIJiZepMPiJe2ASpfnA9tkkivtC8gtZcxEV/
         snNjrzLvNLz2bHe2ZghuRJrDNBgy9gwVowbT3qd/LD/Jb61lWSbcRq7xQFv0QLpJmL9U
         6EnTj4MH/KUZ0WoB4ZzsbUBIg1SsTvoPJYsvN+lw44QMdotEHzgVkblnVwjCeesiSLGt
         8ozQ==
X-Gm-Message-State: AOAM533XzMyblg0AejytcvxcMCkqbaZBn9Dyo/XBiMVkwCIqtBmNfNrC
        Bpm7lhIhUigMPmFn0gWKCJk=
X-Google-Smtp-Source: ABdhPJzpr5MkoR0Rxn2HYPDwG6+GVTIe8DS26W0rSADV+iJa9Sr6qu0qIdvW+Ng8TsAMZlsFOTBvRQ==
X-Received: by 2002:a17:907:3d01:b0:6e0:c63b:1992 with SMTP id gm1-20020a1709073d0100b006e0c63b1992mr7423430ejc.422.1649230681805;
        Wed, 06 Apr 2022 00:38:01 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id d7-20020a170906370700b006e7f864d7a0sm2613961ejc.131.2022.04.06.00.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 00:38:01 -0700 (PDT)
Message-ID: <06b5cc53-8de6-b238-70eb-9c1d5f245f78@kernel.org>
Date:   Wed, 6 Apr 2022 09:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: sof_es8336 build failure [was: [PATCH 5.17 0000/1126] 5.17.2-rc1
 review]
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        pierre-louis.bossart@linux.intel.com,
        Mark Brown <broonie@kernel.org>,
        yung-chuan.liao@linux.intel.com, peter.ujfalusi@linux.intel.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
References: <20220405070407.513532867@linuxfoundation.org>
 <8ea245ed-eac9-1cd5-31bd-150a06378872@kernel.org>
In-Reply-To: <8ea245ed-eac9-1cd5-31bd-150a06378872@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc some folks and change subject

On 06. 04. 22, 9:29, Jiri Slaby wrote:
> On 05. 04. 22, 9:12, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.17.2 release.
>> There are 1126 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> ...
>> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>      ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP
> 
> Fails to build w/ suse x86_64 default config [1] (and x86_32 too):
>  > sound/soc/intel/boards/sof_es8336.c: In function ‘sof_es8336_probe’:
>  > sound/soc/intel/boards/sof_es8336.c:482:32: error: ‘struct 
> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
> mean ‘link_mask’?
>  >   482 |         if (!mach->mach_params.i2s_link_mask) {
>  >       |                                ^~~~~~~~~~~~~
>  >       |                                link_mask
>  > sound/soc/intel/boards/sof_es8336.c:494:39: error: ‘struct 
> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
> mean ‘link_mask’?
>  >   494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
>  >       |                                       ^~~~~~~~~~~~~
>  >       |                                       link_mask
>  > sound/soc/intel/boards/sof_es8336.c:496:44: error: ‘struct 
> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
> mean ‘link_mask’?
>  >   496 |                 else if (mach->mach_params.i2s_link_mask & 
> BIT(1))
>  >       |                                            ^~~~~~~~~~~~~
>  >       |                                            link_mask
>  > sound/soc/intel/boards/sof_es8336.c:498:45: error: ‘struct 
> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
> mean ‘link_mask’?
>  >   498 |                 else  if (mach->mach_params.i2s_link_mask & 
> BIT(0))
>  >       |                                             ^~~~~~~~~~~~~
>  >       |                                             link_mask
> 
> So 679aa83a0fb70dcbf9e97c is missing -- but likely more is needed.
> 
> [1] 
> https://raw.githubusercontent.com/SUSE/kernel-source/stable/config/x86_64/default 
> 
> 
> regards,


-- 
js
suse labs
