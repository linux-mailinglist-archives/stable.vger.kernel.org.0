Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF220993B
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 06:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgFYE5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 00:57:18 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:46777 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFYE5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 00:57:18 -0400
Received: by mail-ej1-f65.google.com with SMTP id p20so4575922ejd.13;
        Wed, 24 Jun 2020 21:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDQOaa5HH/zr8eVIcjkrYiG3AZ14kTxtIgkPZZdVMpc=;
        b=QBki+8UhP3NaYfdlxlzA3KzSb3f/lVdYFygFwcrg0IvLAb1TB19fa34+dwEHBT6cxp
         z2mEX7l0iZdv9JaqSrB7ndnHLvJThs3OG8fdlEi4Pk37Kr2n1Q7orwWJeaNbt3RIJiJS
         oq1aLOWy3dSrNC+Xd3bqo81ZQKFIW7tUUJifZ0KYTwVvCpTytEubFUgjUWJzdU6EFXt+
         8vyOJ8pMxQcM8ClJvRUdE8C7EFjs3MJqVyKYrFD1qLX1rDzeAJb+wnmn0De+3l7FkLAw
         ufAZDbmKZOg8ETrKqn+ga2Bc4+0ovHCR2ow1d2SeH1ptW6PxLx/rbgyPMjajmIy0VSFI
         BeFw==
X-Gm-Message-State: AOAM5310RYUGQyPlj2NRIe9a6R5iPT+fdB6wiZtyLSwKnbQTKNGVXiSd
        00vT587SVU9INozhjISak3JggkN4BQ8=
X-Google-Smtp-Source: ABdhPJyW7oW77/uxdprLrtBZGhiqru+4GXD0IlYicbu4DlhrOTY/ErhsIJMw1leAKmJGzocjCSLoTw==
X-Received: by 2002:a17:906:e298:: with SMTP id gg24mr27562253ejb.120.1593061035256;
        Wed, 24 Jun 2020 21:57:15 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id by20sm2857025ejc.119.2020.06.24.21.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 21:57:14 -0700 (PDT)
Subject: ath9k broken [was: Linux 5.7.3]
To:     Gabriel C <nix.or.die@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel@qca.qualcomm.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1592410366125160@kroah.com>
 <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
Date:   Thu, 25 Jun 2020 06:57:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25. 06. 20, 0:05, Gabriel C wrote:
> Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>:
>>
>> I'm announcing the release of the 5.7.3 kernel.
>>
> 
> Hello Greg,
> 
>> Qiujun Huang (5):
>>       ath9k: Fix use-after-free Read in htc_connect_service
>>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
>>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
>>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
>>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>
> 
> We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> while working fine on <5.7.3.
> 
> I don't have myself such HW, and the reported doesn't have any experience
> in bisecting the kernel, so we build kernels, each with one of the
> above commits reverted,
> to find the bad commit.
> 
> The winner is:
> 
> commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> Author: Qiujun Huang <hqjagain@gmail.com>
> Date:   Sat Apr 4 12:18:38 2020 +0800
> 
>     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> 
>     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> ...
> 
> Reverting this one fixed his problem.

Obvious question: is 5.8-rc1 (containing the commit) broken too?

I fail to see how the commit could cause an issue like this. Is this
really reproducibly broken with the commit and irreproducible without
it? As it looks like a USB/wiring problem:
usb 1-2: USB disconnect, device number 2
ath: phy0: Reading Magic # failed
ath: phy0: Unable to initialize hardware; initialization status: -5
...
usb 1-2: device descriptor read/64, error -110
usb 1-2: device descriptor read/64, error -71

Ccing ath9k maintainers too.

> I don't have so much info about the HW, besides a dmesg showing the
> phy breaking.
> I also added the reporter to CC too.
> 
> https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea
> 
> If you need more info, please let me know and I'll try my best to get
> it as fast as possible for you.

thanks,
-- 
js
