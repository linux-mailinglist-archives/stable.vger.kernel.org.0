Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1975B46B8C4
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhLGK0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhLGK0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:26:02 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8656C061574;
        Tue,  7 Dec 2021 02:22:31 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id k2so26533453lji.4;
        Tue, 07 Dec 2021 02:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zn4bh7aDtipPvIQajdqUH0g7HydWjfXn6rvGe1BMNUA=;
        b=QX0Oq1SAxkO6tVEodTmKdzTn3o3oXRNoD1cv2vYJCr+21mmrHt3JLRdQZRSiTE2jX8
         REup2kvzdfpFTnvbfjSuQjq+qNCgxuaIJohZHc/yJYd520QTmIZQXfGQ2MpYCM7AYjBD
         0IFrCLqGfJkCFLPIyJKbyisgH4vsavf7WKBq5V+LA8w9LAMZvg+SDAf4Y6NFGTv98KOB
         5AdN1q9YmwkDlLQcj32OBvTAD1soULHez9BkU7GXJhOK8dA4MFNxgO298FDJsGueYRUM
         z0IvpCD3p/Adh1xCzlNGwArIrZEMsL2NJJQNIJj5HqdACjbu9MqMGms70PR+63oaUfmC
         a3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zn4bh7aDtipPvIQajdqUH0g7HydWjfXn6rvGe1BMNUA=;
        b=31of1G0RKriLRxBanm+6ALoeYmu3lclcBFXujmMRn+4hoxdn359+i7RQrzEpty2Qn/
         oOAyB6X1J04igczFCgGygykAR0ZkVF5eAzOLJWX9Js7Pr5ZrRbD6iUffZbuFY/BMm6Wm
         Nq+y1fxi2/A5ivWr0CbYGti8OpbnibWkSUgprs23HofPsW2BhXftSgTTD51FiGwTF4Vs
         kGe1HD04CtYPzzpKZMr6D0/AX1j+Zjrme7c3nOnLLHYBKOzXqkYz8yvvQ9HVTOR5S4oq
         aA9D8rh/haQHM7bqqe2aD5/YROL04RrNYcLPnsIsMwE3gTuUzLoYwlww1GzSNYvMbrIh
         N6sg==
X-Gm-Message-State: AOAM533i7rhf8aY3f43yAdpqYpG3sC/48+vxFux3vwpXmwfcuzL0qs/d
        Lvfz4BO1awr++HUVm3blfd5T8nE8gDQ=
X-Google-Smtp-Source: ABdhPJwa9mQuwpzBTlt1YakBtu9w7COZcAvYbJk3NFERAIkQSUu9HoZB4XdVRfP08MqzECPAi0qGOQ==
X-Received: by 2002:a05:651c:1687:: with SMTP id bd7mr42558183ljb.305.1638872550008;
        Tue, 07 Dec 2021 02:22:30 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id l5sm1568500ljh.66.2021.12.07.02.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:22:29 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
Date:   Tue, 7 Dec 2021 13:22:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1638858770-22594-2-git-send-email-spujar@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 09:32, Sameer Pujar пишет:
> HDA regression is recently reported on Tegra194 based platforms.
> This happens because "hda2codec_2x" reset does not really exist
> in Tegra194 and it causes probe failure. All the HDA based audio
> tests fail at the moment. This underlying issue is exposed by
> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
> response") which now checks return code of BPMP command response.
> 
> The failure can be fixed by avoiding above reset in the driver,
> but the explicit reset is not necessary for Tegra devices which
> depend on BPMP. On such devices, BPMP ensures reset application
> during unpowergate calls. Hence skip reset on these devices
> which is applicable for Tegra186 and later.

The power domain is shared with the display, AFAICS. The point of reset
is to bring h/w into predictable state. It doesn't make sense to me to
skip the reset.

If T194+ doesn't have hda2codec_2x reset, then don't request that reset
for T194+.
