Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC18E42147E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhJDQ50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhJDQ5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 12:57:25 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C2C061745;
        Mon,  4 Oct 2021 09:55:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j15so317379plh.7;
        Mon, 04 Oct 2021 09:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U+IYaXIi0kevdp5VDl9CH/x102yc2TdcKtkx6wZCCI8=;
        b=fAmWcBughkCFp8PjZC1ANlvrxWbWHcbidKFu5qpnkTfk0RQeOQsIsa0/6aF/WhaP8u
         bfVWFsrGTObyWnDhiIinn8LE2+IyrAIf8g7tpJsV7BtsdRnGbhsVrrAoyLUpFbw/ICy9
         PFpeG7RbYwRVtcAJaS2JLImKex1hmpA0Fp7YFHJBXzVBmHrzF2wnLeZh4c+YhJzoEQnw
         6eouDhm1+g7JVn41R33DoWQh9lLw1/MVvVXX5UnaAtUtpMWhiFMyay8c3yWz0Vp+sVse
         2kw+TdCW0ln0ncRYC/4S8q170M2CqMkc6ihq56DelJVOWEuoMl8lWvftzF8ZF6Hi6jQX
         lA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U+IYaXIi0kevdp5VDl9CH/x102yc2TdcKtkx6wZCCI8=;
        b=hl11oCKTMCguxuh2YL6xe/Dfaw9HhOk/HvbB6GguAucrxS3PBrpt+KtqTvx3qd2Qwv
         nEGW3KRCd/LJCiqCYXXgw4SmA022ALrPrakvL1bQzjMZe1xqJMqXo/yqw3/kQ7B7YrDz
         Sn5p6n0mMxlLBfwJ/OO92mBpgzd+TaD8NuVeTu6mtVJIBTAqxVB1fxOPTCJFAbDoNoUU
         +f2N+UhcsrEV3F91O00+DvOTW4iDC/6s6SSjxYwlVIHhnmiP8qWdfhRYzrAp4fPJ2Tdk
         LSX5VAWvzmjDxFbWncK+bJs4evbpXVvq9sNvHRW6XsimzTFXmx9XWwUQPeFv9KBexSHg
         AXMA==
X-Gm-Message-State: AOAM532PXjCDEEksS2lkjeRD/2zrjA9leZCp/icFEcnZPVbcTznp4ulG
        1EsFlS6BRqVINyPklYjVAQsxRThvfok=
X-Google-Smtp-Source: ABdhPJz3jre+tCrbqpCLHc4fMU0v5RCM+YxSKIXkMlyTRYbyN0I6ZL/TOyE/x7UiHXAUi1zU8m+mhQ==
X-Received: by 2002:a17:902:c204:b0:13e:6361:839 with SMTP id 4-20020a170902c20400b0013e63610839mr634508pll.57.1633366534945;
        Mon, 04 Oct 2021 09:55:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g3sm14592770pgj.66.2021.10.04.09.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:55:34 -0700 (PDT)
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Mark Brown <broonie@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk> <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk> <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <20211004165127.GZ3544071@ziepe.ca>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f481f7cc-6734-59b3-6432-5c2049cd87ea@gmail.com>
Date:   Mon, 4 Oct 2021 09:55:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004165127.GZ3544071@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 9:51 AM, Jason Gunthorpe wrote:
> On Mon, Oct 04, 2021 at 09:36:37AM -0700, Florian Fainelli wrote:
> 
>> No please don't, I should have arguably justified the reasons why
>> better, but the main reason is that one of the platforms on which this
>> driver is used has received extensive power management analysis and
>> changes, and shutting down every bit of hardware, including something as
>> small as a SPI controller, and its clock (and its PLL) helped meet
>> stringent power targets.
> 
> Huh? for device shutdown? What would this matter if the next step is
> reboot or power off?

Power off, the device is put into a low power state (equivalent to ACPI
S5) and then a remote control key press, or a GPIO could wake-up the
device again. While it is in that mode, it consumes less than 0.5W(AC).
Imagine your stick/cast/broom behind your TV falling in that category.

> 
>> TBH, I still wonder why we have .shutdown() and we simply don't use
>> .remove() which would reduce the amount of work that people have to do
>> validate that the hardware is put in a low power state and would also
>> reduce the amount of burden on the various subsystems.
> 
> The difference between remove and shutdown really is that 'emergency'
> sense that shutdown is something that must complete in bounded time
> and thus only has to concern itself with quieting hardware to a safe
> state for the next step in the shutdown/reboot/kexec/kdump sequence.

I am fairly sure that no driver write knows about the being bound in
time aspect.

> 
> Many remove handlers happily block until, eg all user files are closed
> or something to allow a graceful module unload.

Fair point.
-- 
Florian
