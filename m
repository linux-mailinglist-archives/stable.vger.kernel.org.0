Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11A43935D6
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhE0TDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhE0TC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 15:02:59 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD419C061574;
        Thu, 27 May 2021 12:01:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w33so1610188lfu.7;
        Thu, 27 May 2021 12:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qroXKVOtlEtTL1eRbXzTTCtc5l+ESuO3YaVgDW84Xms=;
        b=j6au+t1K24fPuBAsmGG+P8gq6TbiMMBFk8PKRJAS5R2vw02U7BafJ5rK0k+3zF/PbG
         g1dWmyE00/o/0m8FCpcZPrhezGDL+m2qr7cIqrXiZi4Xbs8aZv9y1Bmn+qcOL1D9myP3
         KGqLp/XlYFRY5irzCrcV13WC3Y9U3WMHjE4Z2X8ll1Ovfl0Cj4v7gwnSYXTtJx1HrxS8
         0zC9r7xuGeLAApje3YuSYpJpwyyJmgul/H4yY2B0djB1luEsv66QWjmPtpTS3jCY+GPC
         vng15KCqzzUn0iEvljkfrgIRvsheewu9SRSwbh8e3wm4gF/G4nDImgAwTsODQBP0F7w4
         w/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qroXKVOtlEtTL1eRbXzTTCtc5l+ESuO3YaVgDW84Xms=;
        b=CX8cqvhBoi3LPKtXqkiA4li2+S2B1WtstXUKAKiH4Ui4SAWswrWXxFCtLFIhKr3lwi
         pO50HK1nAqqT5duuqtEkcKmfBLHifOzpPFjjJp5II5FG3uQWPNgMT7dkDVdbnYuJ2ZqI
         hnpjElCV5v/WG/y/DVZDbIe+BqtSe2NelsSw0COjnQX+T50sQ/DpPmwrnqnIVe/y4UC3
         2tJaO64KYPQWbj6GFcNh0WAJDP8pT/YjZK0+lakMadLirQLMfvt5J7ZwdJocWf23lm0L
         GJP1mrrPi9WhabXGYUf/W9F6sD070YPjvAt4qjKEtU5469ixGa8ZG2Lsyy2dPhd0oel3
         PTMg==
X-Gm-Message-State: AOAM531uMO8mZSU7tDxrqZtV8JBGqzwwXord5o15OUTQe25W/Yc7Y9QB
        cdhDmwJVyCntmizvlYTxhnX1NSxFmfY=
X-Google-Smtp-Source: ABdhPJy1wvmHaLITf81EXOctomKmjEvz9T4XX0vbtq3CLOxa061TNc1A15dwPHoG78b1SYWDEYkfZA==
X-Received: by 2002:a19:6e0d:: with SMTP id j13mr3243425lfc.81.1622142083040;
        Thu, 27 May 2021 12:01:23 -0700 (PDT)
Received: from [192.168.2.145] (46-138-12-55.dynamic.spd-mgts.ru. [46.138.12.55])
        by smtp.googlemail.com with ESMTPSA id w16sm265281lfn.183.2021.05.27.12.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 12:01:22 -0700 (PDT)
Subject: Re: [PATCH] Input: elants_i2c - Fix NULL dereference at probing
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210526194301.28780-1-tiwai@suse.de>
 <YK6tZy3E/XZpOAbh@google.com>
 <b7fc167b-23c6-fd64-cfbf-dd16a90fbf63@gmail.com>
 <s5hmtsg8zmn.wl-tiwai@suse.de>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <85932641-4b41-1505-4bb6-077220f2835b@gmail.com>
Date:   Thu, 27 May 2021 22:01:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <s5hmtsg8zmn.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

27.05.2021 09:22, Takashi Iwai пишет:
> On Wed, 26 May 2021 22:44:59 +0200,
> Dmitry Osipenko wrote:
>>
>> Hello all,
>>
>> 26.05.2021 23:19, Dmitry Torokhov пишет:
>>> Hi Takashi,
>>>
>>> On Wed, May 26, 2021 at 09:43:01PM +0200, Takashi Iwai wrote:
>>>> The recent change in elants_i2c driver to support more chips
>>>> introduced a regression leading to Oops at probing.  The driver reads
>>>> id->driver_data, but the id may be NULL depending on the device type
>>>> the driver gets bound.
>>>>
>>>> Add a NULL check and falls back to the default EKTH3500.
>>>
>>> Thank you for the patch. I think my preference would be to switch to
>>> device_get_match_data() and annotate the rest of the match tables with
>>> proper controller types.
>>
>> Doesn't a NULL mean that elants_i2c_id[] table fails to match the ACPI
>> device name? What is the name then?
> 
> I don't own the device, so we need to ask on (open)SUSE Bugzilla.

If we will know the name, then alternative fix could be to add the name
to the elants_i2c_id[]. To be honest, I thought that the ID should be
borrowed from elants_acpi_id[] for the ACPI devices, but this was a mistake.

>> This could be two patches:
>>   1 - trivial fix that can be backported easily
>>   2 - switch to device_get_match_data()
> 
> I guess 2 is easy enough to backport to 5.12.x.  Let's see.

Okay
