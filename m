Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4769A302931
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 18:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbhAYRm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbhAYRlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 12:41:05 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1F9C06174A;
        Mon, 25 Jan 2021 09:40:21 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w14so8811508pfi.2;
        Mon, 25 Jan 2021 09:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ll5CPSA8oXAVF+ATpu54RVy1Dmm80vxtyP/rheTo5bY=;
        b=TrPHo+IIlhYXEIUGZnvVvy0gZqdTpRW2zdvLckAXnziMr3wC+urBR+OmQS8W73nnb0
         N0vxhZJ8/8h99P+aZTdkqPzGQoVGVnDTGGoAs2tnSGyPtQOQ6naUqLpCyfOQLDQ3U7/S
         Afcy9kRlkwOaVGteCaBQ7XKmTp5sTPwkXkzaFu62CivM4nKEJN0l6aBwf+zzA3ZNkUxX
         Wj6Gpi0KSHnPDgqDGdITrbPhONGqTLpaZO8ilrZnPxTaabHzp8ivl6w9laSqsNPyOLPz
         1I5D0O+xlBEOlorR1+7UfVaAxC6ZZcvj2q+KhRGt5e1gU1O3zpdmsCceM7ob5Rn7rEub
         0Zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ll5CPSA8oXAVF+ATpu54RVy1Dmm80vxtyP/rheTo5bY=;
        b=lbw1AaCaB/A9IYv0HjLbXlDhBq4fcuOSqpUQbxNxTfa31RvZs5GtrpDraKMbvLCVIk
         8BfVh6CgmvyIct0YTlV4/DfzEN5E3/NR+U8vugICNyQzk6HzI4e2myS+/bdr1xDvdv1n
         ns5ybhchvwM0Kty0YNLKbChtf6AnbNHovUK12G7rZ8UNByY1EN9Rx3Nno6gGv1reig8f
         kK9bU2hs+CNG+iT2GTZH49/U2DMPX0pevNvIQhRr5wknxt/lo0Y62C5qqk4TUsvDJgWI
         ywbw8ECHrTiRoLfaonCQ80DQpGe26oCNIrSZZ4gaf/yRdxs35KMBfrCyHAAnJI++4HYt
         hORg==
X-Gm-Message-State: AOAM533HAEtlTU4YCRponjugJqfNSxsoB1g0ymvIx0dmMBGPaEkWkDwy
        RXr1YBU/9lMmuKxwnRw3jWz9woEPJ60=
X-Google-Smtp-Source: ABdhPJx/x1gICR2eqXW4n+pOoamjEIIYYGojiydYeWPyZhXE0r9WcMnr2TwUrRP7Nat2R+vlDUpYzg==
X-Received: by 2002:a63:6d2:: with SMTP id 201mr1614834pgg.270.1611596420007;
        Mon, 25 Jan 2021 09:40:20 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c5sm17764227pgt.73.2021.01.25.09.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:40:19 -0800 (PST)
Subject: Re: [PATCH] mmc: brcmstb: Fix sdhci_pltfm_suspend link error
To:     Arnd Bergmann <arnd@kernel.org>, Al Cooper <alcooperx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Schichan <nschichan@freebox.fr>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20210125125050.102605-1-arnd@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f671f5d2-36c4-ded5-c4b9-93c5c57cc9f2@gmail.com>
Date:   Mon, 25 Jan 2021 09:40:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125125050.102605-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Nicolas,

On 1/25/2021 4:50 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> sdhci_pltfm_suspend() is only available when CONFIG_PM_SLEEP
> support is built into the kernel, which caused a regression
> in a recent bugfix:
> 
> ld.lld: error: undefined symbol: sdhci_pltfm_suspend
>>>> referenced by sdhci-brcmstb.c
>>>>               mmc/host/sdhci-brcmstb.o:(sdhci_brcmstb_shutdown) in archive drivers/built-in.a
> 
> Making the call conditional on the symbol fixes the link
> error.
> 
> Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
> Fixes: e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> It would be helpful if someone could test this to ensure that the
> driver works correctly even when CONFIG_PM_SLEEP is disabled

Why not create stubs for sdhci_pltfm_suspend() when CONFIG_PM_SLEEP=n? I
don't think this is going to be a functional issue given that the
purpose of having the .shutdown() function is to save power if we cannot
that is fine, too.
-- 
Florian
