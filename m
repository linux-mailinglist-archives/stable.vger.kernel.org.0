Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25323EFFDD
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 11:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhHRJEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 05:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhHRJEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 05:04:53 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F94C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 02:04:18 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9B52182C6B;
        Wed, 18 Aug 2021 11:04:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1629277456;
        bh=ZiUDN42kRVhvAKHC5+XDv/6qoquCCdejElxFcedg+7Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Z0nhgmzQG3yIwThlOiWizRov5sDnpY4HSlgfar4PS4LWcQuKDEZfHFgpfZEC/B+rd
         /PJBs/bJGJUipOMU4L9I52pDUPa1I176G04ovLAv8Pv+e+hUEfgxCjy/tkCPRvMyru
         hE3YDqDgt5jcBw4hUJ1T7jpnhWJu8plusyOQ/NOTGnJCqXhF3MWfYe19dK/H7SuLep
         1UoP2tOjBlZqr/mfu2ylQDh2RdBsYCEqCfP4/FxL7bBGhomsXVRMOB7USfG1TyV5Oe
         vQKk4MM4xMCW7aNaux05HugylI1WCT8EVeDx98TSszwMERd3j6SRbR6UdPUBJcnSql
         OGgg4ov8pLHAA==
Subject: Re: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO)
 introduced driver crash in the 4.15 kernel
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hui Wang <hui.wang@canonical.com>
Cc:     Stable <stable@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        =?UTF-8?Q?Guido_G=c3=bcnther?= <agx@sigxcpu.org>
References: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
 <YRybjZdFngJr9R8i@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <6abb6c93-b9d6-c173-7fe1-fcf3b0abd615@denx.de>
Date:   Wed, 18 Aug 2021 11:04:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRybjZdFngJr9R8i@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/21 7:33 AM, Greg Kroah-Hartman wrote:
> On Wed, Aug 18, 2021 at 12:06:15PM +0800, Hui Wang wrote:
>> Hi Marex,
>>
>> We backported this patch to ubuntu 4.15.0-generic kernel, and found this
>> patch introduced the rsi driver crashing when running system resume on the
>> Dell 300x IoT platform (100% rate). Below is the log, After seeing this log,
>> the rsi wifi can't work anymore, need to run 'rmmod rsi_sdio;modprobe
>> rsi_sdio" to make it work again.
>>
>> So do you know what is missing apart from this patch or this patch is not
>> suitable for 4.15 kernel at all?
> 
> Does 4.19.191 work for this system?  Why not just use that or newer
> instead?

I haven't seen this on linux-stable 5.4.y or 5.10.y, if that information 
is of any use.

But I have to admit, I am tempted to mark the whole driver as BROKEN and 
submit that for stable backports.

Because that is what it is, it is buggy, broken, and the hardware lacks 
any documentation. I spent an insane amount of time talking to RedPine 
Signals / SiLabs trying to get help with basic things like association 
problems against various APs, no result there. I tried getting hardware 
docs from them so I can fix the driver myself, no result either. So far 
I tried to pick various fixes from their downstream driver and submit 
them, but that is massively time consuming and the changes there are not 
separated or documented, it is just one large chunk of code.

As far as I can tell, they also have no interest in fixing the driver or 
helping others with fixing it, so maybe we should just mark it as broken 
... :-(
