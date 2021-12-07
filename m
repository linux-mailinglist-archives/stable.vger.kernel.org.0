Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1B46B9A7
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhLGLCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbhLGLCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 06:02:14 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1B4C061574;
        Tue,  7 Dec 2021 02:58:44 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z8so26642954ljz.9;
        Tue, 07 Dec 2021 02:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T7f2BYRkHt8MhUv7MJ0rG/eBUmUyHFQ+AN78efL2lEY=;
        b=Haspf0TMEDKoSi9DP6mb2vaEnZJkJR/At3xVyAhX8B0HuOL/FWo84rk7rwFSFNMskW
         BtN6hFtQeVzFlD/f2jqPv5wokOBH9DeEpBUq+v3PBrAfeXGlKGGz/93N2vPdii6P77xo
         rTBAIynwW9ikYbaJ5/JotS9OEaf7miKt0LyzVRwSaFWpR71dB7HV5GjNI+xXnjPGpytr
         PeggeKbwO7rLnn7w6ydwJdqfFmtLj4zzp+8KFqhq9oTkiVlEuVImBoi6J/KhX+lG+cyT
         LHUxwTvFnVsJIsBs1ZouPzv89E5Z2DYg1o9u4GjJNumnSSYRlqkRMMyp8B+U8LzeowcV
         6yYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T7f2BYRkHt8MhUv7MJ0rG/eBUmUyHFQ+AN78efL2lEY=;
        b=Kl8gYJF23Q5BTITCk1YhFryPYh/1P9LRGyOx4YQmpprWfWrGQDzqJk5l2yrtS65FlR
         6H1OJ9MPliyIwaDmgyArj5h/wsL8ecLaIseZ6VwO7S1KNkkfVu390TDIRjOLFYvSwvcU
         W6kJHb5Ab4yDVcYbdHvrKlPK1assxYDAlGfS34KHF9SP7scI7M0ODWt1K1LqJTJ1uRdJ
         /wXWfr3FQjDHbIdynsTFJqmKRtflzA3aU2ojFkx5x3fQPsdBIBsOBEr2eNbLP7QAs7MQ
         xNPkT3RAxKESZdS3HBryWYoU9tFvgA/Rv8wBxndm615uXZwA8DgGQVaoD7mfLeeoBtUs
         BkQQ==
X-Gm-Message-State: AOAM5333SIkcmbgmvs2IA8EeKRJkA+fWIh3HfDGiIgvYUytDriO8BTbI
        8syuYhe/mY66mz5bRZs3H4858OTOUcQ=
X-Google-Smtp-Source: ABdhPJxyHT3p1A/j7SwfN7khEiU4g35DC8t+JdXDzi7hqN4F4J16vGCeSKEiwTDcj+OP/UuISdkIWg==
X-Received: by 2002:a05:651c:1117:: with SMTP id d23mr39699896ljo.299.1638874722741;
        Tue, 07 Dec 2021 02:58:42 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id q13sm1648336lfm.13.2021.12.07.02.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:58:42 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
Message-ID: <9c21aa0d-b7e6-17b8-cd1a-f12a2b2a1a57@gmail.com>
Date:   Tue, 7 Dec 2021 13:58:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 13:44, Dmitry Osipenko пишет:
> 07.12.2021 13:22, Dmitry Osipenko пишет:
>> 07.12.2021 09:32, Sameer Pujar пишет:
>>> HDA regression is recently reported on Tegra194 based platforms.
>>> This happens because "hda2codec_2x" reset does not really exist
>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>> tests fail at the moment. This underlying issue is exposed by
>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>> response") which now checks return code of BPMP command response.

I see that this BPMP commit already has been reverted. There is no
problem in this hda_tegra driver at all.

>>> The failure can be fixed by avoiding above reset in the driver,
>>> but the explicit reset is not necessary for Tegra devices which
>>> depend on BPMP. On such devices, BPMP ensures reset application
>>> during unpowergate calls. Hence skip reset on these devices
>>> which is applicable for Tegra186 and later.
>>
>> The power domain is shared with the display, AFAICS. The point of reset
>> is to bring h/w into predictable state. It doesn't make sense to me to
>> skip the reset.
>>
>> If T194+ doesn't have hda2codec_2x reset, then don't request that reset
>> for T194+.
>>
> 
> I don't see the problem in the driver. It's only the device-tree that is
> wrong. This hda_tegra.c patch should be unneeded, please fix only the
> device-tree.
> 

