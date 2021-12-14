Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35645473D0F
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 07:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhLNGPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 01:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLNGPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 01:15:49 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3941C061574;
        Mon, 13 Dec 2021 22:15:48 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id i63so26853723lji.3;
        Mon, 13 Dec 2021 22:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=725ChSobD1VD4Ep/VU60OT9W4QyTtvRCLihRfx/XJFI=;
        b=GmfHh5wtbAkMz0d5F80QG380DoERfkquzkQHI58BfCR6UCF/ppBX0QcILykcLGLCLR
         bLSyfzKtL6fIji52++qq+XvXsRJErPWGut7/jVxOntewKVynrWajhoLJNr8KkIKNx/n9
         UF5Pcg0fpFjUc0XUHuD3val8uMBCIl/jMoXVWkoYqZygHcN6wdc9WhgApBRH4Mn78tdP
         v3jmzinXx8xdnr/9pHN4yFWYprcewMc4IefBDH5EmKOMRoZ3d2RnAAaPb9234eEeddkG
         hs5lDo1Yl8e5E/2BD34LHsjsN/Bf0YOSqPWUHr3bFABdKJvvh6IOw5IZ4vpDCOAGa0RL
         qZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=725ChSobD1VD4Ep/VU60OT9W4QyTtvRCLihRfx/XJFI=;
        b=TWGlEDDH1FIKQIT6+YSz8fm1J+0Saf0x9ZY5IU9bo/zopWv1cdR8zwsITfGd1Dvgph
         +Knu1QRfYWes5nYUSEKcySHo9nE7PFI0Wjh/HWm2ckLoQ2rfxZbvt3xWTnPX2igLdCtI
         xZLAZMfPg6C2vx3E3m7MtsVae9N4vHYN03qnklYX6oa72d1Y43Co6Xo5SodxmCglwaSk
         sZ93j3yXfYnFFYU3t5YbWnLaxfp9qexFCAu6Z6kTS+HdvLLbsk3TU7N0U4UJJ0plUMK3
         S6vN5cbCKYUSBiWxYF+QEHaL0ayioyzvFutDRa10zyXB043ZZR+tK4IzHgUmujFbi3Nk
         Xb8g==
X-Gm-Message-State: AOAM533uFF0kY5NWYNV/+0kI20hqP+3HuIP/vXf/NixjkSeFB7691TC9
        xKcM1fjgRW9VkDepk6QO7Nzi2wHA+jo=
X-Google-Smtp-Source: ABdhPJyRbqZooRhCMtT9QRyO1YM7LLBWlPUm2wZXVvfxkW5q+x6LMK0P9+LRK86sL3exSHwBjzHi4w==
X-Received: by 2002:a05:651c:1791:: with SMTP id bn17mr3075419ljb.525.1639462546955;
        Mon, 13 Dec 2021 22:15:46 -0800 (PST)
Received: from [192.168.2.145] (94-29-63-156.dynamic.spd-mgts.ru. [94.29.63.156])
        by smtp.googlemail.com with ESMTPSA id v2sm1723169ljv.6.2021.12.13.22.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 22:15:46 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
 <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
 <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
Message-ID: <93276b40-9ff8-f401-2624-04c0ff02c755@gmail.com>
Date:   Tue, 14 Dec 2021 09:15:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

14.12.2021 09:09, Dmitry Osipenko пишет:
> 14.12.2021 09:02, Sameer Pujar пишет:
>>
>>
>> On 12/8/2021 5:35 PM, Dmitry Osipenko wrote:
>>> 08.12.2021 08:22, Sameer Pujar пишет:
>>>>
>>>> On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
>>>>> If display is already active, then shared power domain is already
>>>>> ungated.
>>>> If display is already active, then shared power domain is already
>>>> ungated. HDA reset is already applied during this ungate. In other
>>>> words, HDA would be reset as well when display ungates power-domain.
>>> Now, if you'll reload the HDA driver module while display is active,
>>> you'll get a different reset behaviour. HDA hardware will be reset on
>>> pre-T186, on T186+ it won't be reset.
>>
>> How the reset behavior is different? At this point when HDA driver is
>> loaded the HW is already reset during display ungate. What matters,
>> during HDA driver load, is whether the HW is in predictable state or not
>> and the answer is yes. So I am not sure what problem you are referring
>> to. Question is, if BPMP already ensures this, then why driver needs to
>> take care of it.
> 
> 1. Enable display
> 2. Play audio over HDMI
> 3. HDA hardware now is in dirty state
> 4. Reload HDA driver
> 5. In your case HDA is kept in dirty state, in my no
> 

The power domain is shared by display and HDA, is this correct?

If yes, then the shared power domain will be turned off only when all
its clients are turned off, i.e. both display and HDA simultaneously.
