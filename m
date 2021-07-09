Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34A13C2AED
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhGIVlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhGIVlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:41:00 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC44C0613DD;
        Fri,  9 Jul 2021 14:38:16 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s18so10226595ljg.7;
        Fri, 09 Jul 2021 14:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZVPWYqSyixkxkDSr12zp1Gb/EBiJF8//ADhPZjQHkNY=;
        b=coLNTHP2JDZCDbh9rSFwBNNgy4/PiQ/h9A/b2My9drw7hVjw4e/I1PIv8KKuORE6Hk
         jWcWEXi+PDqWxto9Glc1TIpdlXlKr8wWvNu2Vjvo9N9KpAHG1jnE2HGGPMU+epgHq2t5
         U+Locdqonh9XT90mb49h3q075H6dSI42y77G3HhagnYPyY1WN52zV+g3DFkqDlHeVY1a
         43N1EYAefr9OWNvkklsjyf+PsFX93qJk5j00thze8kzNFnc0H5XX8hzxBvdNgpHMAV9S
         EFdvYQBBJP8iA38ln3xJreH/QEH9IfuBghoqell+XhAoCV1FV/5YGgHdg9NxTfw8oYq7
         3ujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVPWYqSyixkxkDSr12zp1Gb/EBiJF8//ADhPZjQHkNY=;
        b=qDm13BZUi7v647q+jSy55Yt6UwCpPtcrVf/q0ckRTcCFiyuwe+y22btZk7VSbibsst
         bJRM209xfNZj44kG5py6NbZKJV4/rxfKDruk4KongDYwUQEkED7Jea+L3jAKLAT3tIGO
         +AF1Yi14yh+CvBcmGc34yLVEUcYjv4MaxiXYEhkNeU+/V1f/48mEsXX5MezEbEVEnVFe
         y/kqL8XpufU29dR0ajzQaHHazNTqHLWzS614BKgJA+2tDQSroeLs7ABpTgjRuFMgvAKM
         n6qYRpJSyf5qBkaexaQnS+T5MV+HeVx/R3/ymLLXZ2HkbEXIo6sO/Rtd8C+fu0tcAB/b
         a6tw==
X-Gm-Message-State: AOAM5305/IKKH/6xyN6DIsJKI0HUlxGuenzKdDXHwcDSzziFyylkigHQ
        7X0z2NDiEKY8pncgk0fKNO39eM3sumc=
X-Google-Smtp-Source: ABdhPJy8w4nB0SwfVg9e0pH/UJAZ+6wCIk2dWvx5t8aq1ddzP6Wwk2dKZXg4s8nCC0uwx+l+sxxvkQ==
X-Received: by 2002:a2e:a16d:: with SMTP id u13mr23697171ljl.222.1625866694503;
        Fri, 09 Jul 2021 14:38:14 -0700 (PDT)
Received: from [192.168.2.145] (94-29-37-113.dynamic.spd-mgts.ru. [94.29.37.113])
        by smtp.googlemail.com with ESMTPSA id y7sm667113lji.64.2021.07.09.14.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:38:14 -0700 (PDT)
Subject: Re: [PATCH V2] serial: tegra: Only print FIFO error message when an
 error occurs
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
References: <20210630125643.264264-1-jonathanh@nvidia.com>
 <YOd7ZTJf0WoQ8oKo@qmqm.qmqm.pl>
 <aad402e7-a2b7-1faf-bc22-eb90bee39d3b@nvidia.com>
 <30057ea5-5699-9335-f4dd-a9e8ed847ee4@nvidia.com>
 <YOiNh2ue6YnN6Zr/@qmqm.qmqm.pl>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <0e5678f2-96d3-9970-b2e4-f1efb395c919@gmail.com>
Date:   Sat, 10 Jul 2021 00:38:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOiNh2ue6YnN6Zr/@qmqm.qmqm.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

09.07.2021 20:55, Michał Mirosław пишет:
> On Fri, Jul 09, 2021 at 12:38:07PM +0100, Jon Hunter wrote:
>>
>> On 09/07/2021 09:34, Jon Hunter wrote:
>>>
>>>
>>> On 08/07/2021 23:25, Michał Mirosław wrote:
>>>> On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
>>>>> The Tegra serial driver always prints an error message when enabling the
>>>>> FIFO for devices that have support for checking the FIFO enable status.
>>>>> Fix this by displaying the error message, only when an error occurs.
>>>>>
>>>>> Finally, update the error message to make it clear that enabling the
>>>>> FIFO failed and display the error code.
>>>> [...]
>>>>> @@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
>>>>>  
>>>>>  	if (tup->cdata->fifo_mode_enable_status) {
>>>>>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
>>>>> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
>>>>> -		if (ret < 0)
>>>>> +		if (ret < 0) {
>>>>> +			dev_err(tup->uport.dev,
>>>>> +				"Failed to enable FIFO mode: %d\n", ret);
>>>>
>>>> Could you change this to use %pe and ERR_PTR(ret)?
>>>
>>> Sorry, but it is not clear to me why this would be necessary in this case.
>>
>> I see so '%pe' prints the symbolic name of the error code. While that is
>> nice, it also looks a bit odd. Given that we simply print the error code
>> values in this driver, from looking at other prints, I prefer to keep it
>> as is for consistency.
> 
> It is a quite new facility of printk(), so I woudn't expect it to be
> present in older code. It saves a bit of time when you occasionally
> hit an error, so even incremental conversion seems beneficial for me.

It doesn't feel like a good approach to use ERR_PTR where it's not very
appropriate. I suppose printk could get a new specifier, like '%de' for
example, for the verbose integer error codes, couldn't it?
