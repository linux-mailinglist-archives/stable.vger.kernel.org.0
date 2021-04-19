Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B2364B1C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbhDSUYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242068AbhDSUYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 16:24:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA5C06174A;
        Mon, 19 Apr 2021 13:24:10 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u17so54951247ejk.2;
        Mon, 19 Apr 2021 13:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PhHrHZTnHWl4dYuJ08rovKPiY+jAx1smovfxRkAUCIo=;
        b=kunzzXFh+tAz4F4bWKTcSqZ4FCfvWllWA/rB2UBSMLgVudZWveUJs3ws6wPtEbXMNl
         gNT285LySgx6UT2vF7ib2+2Z/bIt6TfR3U3jSmXlm42NH46AoM0j88Ap4+J/LiFn6vsQ
         33m95JYg3wRTSqe6LOaEe5Nhf7Cv7UZynm2dNMjWisfhaua5zn4EzCP+BuWBP1CdQJQW
         lStF6+4kAut24DEDGGD3xHtHBeV/3SCD7LI5mKH2Vq+NpJs+k9Yeuksnl2/jIRVh5sra
         wQZZBVHmllgyweVuel6HHE75lN8KLVtpoyBZ/V4eY1UBSeOsXsyEW8YAsflrO0KlFISf
         4HjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PhHrHZTnHWl4dYuJ08rovKPiY+jAx1smovfxRkAUCIo=;
        b=S8rOHi59tWAL9QgxsJ/tASGrzc6oKFhqbEX4iVbbvgIwSX7VT5RO6zJ9E/kBqFkCpk
         6L+VFlsDcWFm8pAn45rxJsUooGOyuIhsnUiYDjjS+HrkprZtY5Y7EargI3qrdmlkXNmz
         8VDb5X25fbFwtQM4BuLbEso3BemOxLKcqP0Ry6WQ4dctYLU1iNzRVNzKteMIuBU3a/4t
         xsA6Mqeld5BvHSFtWFOEBsQLDE8noQoWgFeGOKO6rX9Pf7TTuzGTiaW8NfQw2hOWXoSe
         bLhYIEKfzfSjcOdREPfIfNfGq6GBBPe8cjVgVxYpqQNVVmomnOLwI8cxeb6uOAR93zFg
         W3qA==
X-Gm-Message-State: AOAM532eiTCkHoqI+/E9Wy3LhT0A1MUv7hqQZGDoRE75YsxgJWfE/8de
        D8btMYSCHB/O86YbPZSS4HoXTyNR3bH04A==
X-Google-Smtp-Source: ABdhPJwFBpYurS2+zK/ROGCoBaIC5lcqQqAwDoeMNsd8rTLT7VwkjzUDtkwJNWzbJjEM0ykD+hESWw==
X-Received: by 2002:a17:906:6b81:: with SMTP id l1mr4635789ejr.494.1618863848847;
        Mon, 19 Apr 2021 13:24:08 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:c5ff:9fd6:3e2f:f252? ([2001:981:6fec:1:c5ff:9fd6:3e2f:f252])
        by smtp.gmail.com with ESMTPSA id x9sm13715366edv.22.2021.04.19.13.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 13:24:08 -0700 (PDT)
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
 <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
 <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
 <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
 <CAHp75Vfs559OL1_iwtmdvnLTELUFLHXaJfmW4_oqoC3NpyMhLw@mail.gmail.com>
From:   Ferry Toth <fntoth@gmail.com>
Message-ID: <a5d9837c-eb2d-dcd2-8082-952304443795@gmail.com>
Date:   Mon, 19 Apr 2021 22:24:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAHp75Vfs559OL1_iwtmdvnLTELUFLHXaJfmW4_oqoC3NpyMhLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Op 19-04-2021 om 10:43 schreef Andy Shevchenko:
> On Mon, Apr 19, 2021 at 2:03 AM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
>> Ferry Toth wrote:
>>> Op 17-04-2021 om 16:22 schreef Ferry Toth:
>>>> Op 17-04-2021 om 04:27 schreef Thinh Nguyen:
>>>>> Ferry Toth wrote:
>>>>>> Op 16-04-2021 om 00:23 schreef Thinh Nguyen:
>>>>>>> Thinh Nguyen wrote:
>>> On the PC side this resulted to:
>>>
>>> apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device
>>> number 12 using xhci_hcd
>>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found,
>>> idVendor=1d6b, idProduct=0104, bcdDevice= 1.00
>>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings: Mfr=1,
>>> Product=2, SerialNumber=3
>>> apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
>>> apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
>>> apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber: 0123456789abcdef
>>> apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error -110
>>>
>>> Thanks for all your help!
>> Looks like it's LPM related again. To confirm, try this:
>> Disable LPM with this property "snps,usb2-gadget-lpm-disable"
>> (Note that it's not the same as "snps,dis_enblslpm_quirk")
>> Make sure that your testing kernel has this patch [1]
>> 475e8be53d04 ("usb: dwc3: gadget: Check for disabled LPM quirk")
> Thinh, Ferry, I'm a bit lost in this thread. Can you summarize what
> patches I have to apply on top of v5.12-rc8 to mitigate issues,
> mentioned in this thread?
>
> (Sounds to me there are like ~5 patches floating around)

I have 3 on top usb-next (-rc7)

usb: dwc3: core: Do core softreset when switch mode

usb: dwc3: gadget: START_TRANSFER command needs to be executed while the 
device is on "ON" state

usb: gadget: increase BESL baseline to 6

See here: https://github.com/htot/linux/commits/eds-acpi-5.12-rc7

>
> I'll try to find time to test on my side.
>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=475e8be53d0496f9bc6159f4abb3ff5f9b90e8de
>
