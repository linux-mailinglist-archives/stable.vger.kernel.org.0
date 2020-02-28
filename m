Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66768173A00
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgB1OiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 09:38:07 -0500
Received: from mail1.ugh.no ([178.79.162.34]:55216 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgB1OiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 09:38:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 833E024EBA8;
        Fri, 28 Feb 2020 15:38:05 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uRS-mdNYuDgz; Fri, 28 Feb 2020 15:38:05 +0100 (CET)
Received: from [10.255.64.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id C655A24EB4A;
        Fri, 28 Feb 2020 15:38:04 +0100 (CET)
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20200227132232.815448360@linuxfoundation.org>
 <d6212f9e-7e8d-95bd-18ca-8c44de224b28@tomt.net>
 <20200228122240.GA3012646@kroah.com>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <faad1735-e6b7-badb-3fcc-69c4c467bca2@tomt.net>
Date:   Fri, 28 Feb 2020 15:38:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228122240.GA3012646@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.02.2020 13:22, Greg Kroah-Hartman wrote:
> On Fri, Feb 28, 2020 at 01:06:00PM +0100, Andre Tomt wrote:
>> On 27.02.2020 14:35, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.5.7 release.
>>> There are 150 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
>>> Anything received after that time might be too late.
>>
>> There is something going on with USB in this release. My AMD X570 board is
>> constantly having ports stop working, while a older AMD X399 board seems
>> fine (maybe, there is an ATEN USB extender involved on the X570 system)
>>
>> I've only had time to do very rudimentary debugging, but reverting all usb
>> and xhci related patches seems to have solved it, eg:
>>
>>> <snip>
>>
>> I might be able to narrow it down in a day or two.
> 
> Narrowing it down would be good, try sticking with either the hub or
> xhci patches.  And, 'git bisect' might make it easier.

It seems to be caused by "USB: hub: Don't record a connect-change event 
during reset-resume". Running 5.5.7-rc1 with only that patch reverted 
works fine.

Also happens with the X399. And only when the ATEN UCE260 USB extender 
is involved. Connecting a device is the problem, if it is connected at 
boot, things seem fine, until you connect something new. Then the port 
dies completely, dead even if you disconnect the extender and plug 
something in directly - until system is rebooted (perhaps driver reload 
would work too - have not tested.)

Aw well, the problem does seem a little narrower than I expected at first :)

There's no errors in the kernel log at all. The last thing logged is 
that whatever device was on the other end got disconnected.

> Also, does Linus's current tree show the same problems for you?

Yes, it does

Unfortunately, email deliverability will be terrible for me for a few 
days (there was a mishap), so if you could loop in the 
author/maintainers for me that would be good.
