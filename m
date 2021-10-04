Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927F2421435
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbhJDQib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbhJDQia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 12:38:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53329C061745;
        Mon,  4 Oct 2021 09:36:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so367106pjb.1;
        Mon, 04 Oct 2021 09:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i9HvJ/dIvE1zjUyRbgyJl7m3OXfgPk4pqRTJ8vTrtPw=;
        b=TxNJ9ZvM1xTe9kSas+0NiFK82B0UIST6TWU4VrIJSw+9pYOuny9PHlYaKICzPE0L7o
         guKNRlxyIEuE1L/ndG8pxr8dvtqQmrn5XT+cP7RcMHXHoDmkBJ+PX8GJBEd+65yQrvwx
         D69DBWMeDLH//ej8jT4MRQm+e5NxD0eniF8jS/SBkL2sa3vpUoMMu3+p3JYO7B0ggxZ7
         +EuMFs5R61o70sb+LLOCa6AYkicRsW2br49LFS0d8moA/yshzkt2CRPW72LemBiNQf4j
         GLoQCeD8PPC9JpLwyRyOFMvtriRWzA70bc9K/Ec9o/NzxQx6u5gLwprgTtd06bpt4HEn
         MnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i9HvJ/dIvE1zjUyRbgyJl7m3OXfgPk4pqRTJ8vTrtPw=;
        b=JpGUdFMMNLlPy2TqYHHgywpCPWB9d6fP0W0GQf9Pvi0UpLHMWhHTomupYFiITVzcbP
         aHdHh6EJ7q06U3s47ZRiXScj2KHvCNkyzjSKmdHddxNn2cMy86OjoeTs3hvBCOyzyXdZ
         9UazWf9E1UzZh9GFJE0Pp9fJuzAACDRVmbyQoGttOjMtN2QFRn5ZnQB09b+S7j1IlZcZ
         nSOQ/+4a/mupXBRtD50OXb8UDJ2VQt9xvNqJ5sYJ7nti2MQdtKRafJTwIHCGPX7Yk2uJ
         uMPAa0ZnBzzeWYpEZpJbSzOXfLgJzVyiUR16SEoKMi56h7pHu1l6gY7jw80pSr5G8udw
         Hrkg==
X-Gm-Message-State: AOAM530kC/5shosYl0mVsSxGEBFytI6bJfj9bRYf54faj/jI/jxeAcQS
        NBdQjKvXL+SWFa+VoRpxWFDl5jHbT7Y=
X-Google-Smtp-Source: ABdhPJxW0sQGL51R/ehPcpgaTdHEc0UgSWs+QBXTyuowk9w9sxdZC1BnVFV3eyskjLVmX4avfaF2Qw==
X-Received: by 2002:a17:902:db01:b0:13e:d9ac:b8ff with SMTP id m1-20020a170902db0100b0013ed9acb8ffmr608448plx.46.1633365400297;
        Mon, 04 Oct 2021 09:36:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z24sm15796562pgu.54.2021.10.04.09.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:36:39 -0700 (PDT)
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Mark Brown <broonie@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk> <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk> <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
Date:   Mon, 4 Oct 2021 09:36:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YVssWYaxuQDi8jI5@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 9:31 AM, Mark Brown wrote:
> On Mon, Oct 04, 2021 at 12:44:36PM -0300, Jason Gunthorpe wrote:
>> On Mon, Oct 04, 2021 at 03:12:20PM +0100, Mark Brown wrote:
>>> On Mon, Oct 04, 2021 at 10:17:56AM -0300, Jason Gunthorpe wrote:
> 
>>>> When something like kexec happens we need the machine to be in a state
>>>> where random DMA's are not corrupting memory.
> 
>>> That's all well and good but there's no point in implementing something
>>> half baked that's opening up a whole bunch of opportunities to crash the
>>> system if more work comes in after it's half broken the device setup.  
> 
>> Well, that is up to the driver implementing this. It looks like device
>> shutdown is called before the userspace is all nuked so yes,
>> concurrency with userspace is a possible concern here.
> 
> It's not just userspace that can initiate things - interrupts are also
> an issue, someone could press a button or whatever.  Frankly for SPI the
> quiescing part doesn't seem like logic that should be implemented in
> drivers, it's a subsystem level thing since there's nothing driver
> specific about it.

Surely the SPI subsystem can help avoid queuing new transfers towards
the SPI controller while the controller can shut down the resources that
only it knows about.

> 
>>>> Due to the emergency sort of nature it is not appropriate to do
>>>> locking complicated sorts of things like struct device unregistrations
>>>> here.
> 
>>> That's just not what's actually implemented in a bunch of places, nor
>>> something one would infer from the documentation ("Called at shut-down
>>> to quiesce the device", no mention of emergency cases which I'd guess
>>> would just be kdump) - 
> 
>> Drivers mis understanding stuff is not new..
> 
> Not just drivers, entire subsystems.  And like I say given the
> documentation I'd be hard pressed to say that it's a misunderstanding.
> 
>>> that's a different thing and definitely abusing the API.  I would guess
>>> that a good proportion of people implementing it are more worried about
>>> clean system shutdown than they are about kdump.
> 
>> The other important case is to get the device cleaned up enough to
>> pass back to firmware for platforms that use a firmware
>> shutdown/reboot path.
> 
> Right, so the other cases I'm aware of are doing pretty much that -
> bringing things down to a state where the system can reboot cleanly.
> That can definitely include things like blocking for some hardware, and
> you're going to need some concurrency handling which means a combination
> of locking and infrequently tested lockless code paths.
> 
> In the case of this specific driver I'm still not clear that the best
> thing isn't just to delete the shutdown callback and let any ongoing
> transfers complete, though I guess there'd be issues in kexec cases with
> long enough tansfers.

No please don't, I should have arguably justified the reasons why
better, but the main reason is that one of the platforms on which this
driver is used has received extensive power management analysis and
changes, and shutting down every bit of hardware, including something as
small as a SPI controller, and its clock (and its PLL) helped meet
stringent power targets.

TBH, I still wonder why we have .shutdown() and we simply don't use
.remove() which would reduce the amount of work that people have to do
validate that the hardware is put in a low power state and would also
reduce the amount of burden on the various subsystems.
-- 
Florian
