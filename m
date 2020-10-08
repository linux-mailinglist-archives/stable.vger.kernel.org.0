Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46C02870FC
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 10:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJHI5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 04:57:10 -0400
Received: from aibo.runbox.com ([91.220.196.211]:59062 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJHI5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 04:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=kGvypXZxgrBG+SxPG/SXrLtg1UusSCoR3ZqdUgL/SB4=; b=ZWyLlF5fIptTZDdVlgXLctjhyy
        qY+tu/PVTpd99VdwKi5xIKHEJNVi7TF0gEkUaWb92ynSgM0e/CwDu9/wcaFHkiufLBkWjhE4ZcCbe
        35byIeuHimruzjjJUkwgwni4533AuGXG6twt/MTl+l0s31JlXX+qQtnsWWTE1dlxlwW+cWGtcmnCF
        wG4yReT9z1HjRyEk9x+YM1GSzxyi+cROagR7XvEkHSk0CC3uvwFVCbKPFxnsppCvX+/pSqO0TtVYT
        ZD23iDc78WZuF6o/siiWHZoT3XrwqdEcML3f4Nkkq9JoOzbVfhAF0BnL9/5e1i7dfUAWYv4mtWanW
        ppy1VSHA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kQRjT-0004hv-70; Thu, 08 Oct 2020 10:57:03 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kQRjQ-0007JW-MS; Thu, 08 Oct 2020 10:57:00 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH 5.8 05/85] Revert "usbip: Implement a match function to
 fix usbip"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
 <20201005142115.000911358@linuxfoundation.org>
 <ad55b590-da4a-4aa8-7a04-302a8d55d723@runbox.com>
 <20201007091324.GF614379@kroah.com>
Message-ID: <bb5f0904-af0e-e9a3-3d72-2d2d198ff6fa@runbox.com>
Date:   Thu, 8 Oct 2020 04:56:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201007091324.GF614379@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/10/2020 12.13, Greg Kroah-Hartman wrote:
> On Tue, Oct 06, 2020 at 04:26:27PM +0300, M. Vefa Bicakci wrote:
>> On 05/10/2020 18.26, Greg Kroah-Hartman wrote:
>>> From: M. Vefa Bicakci <m.v.b@runbox.com>
>>>
>>> commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.
>>>
>>> This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
>>> function to fix usbip").
>>>
>>> In summary, commit d5643d2249b2 ("USB: Fix device driver race")
>>> inadvertently broke usbip functionality, which I resolved in an incorrect
>>> manner by introducing a match function to usbip, usbip_match(), that
>>> unconditionally returns true.
>>>
>>> However, the usbip_match function, as is, causes usbip to take over
>>> virtual devices used by syzkaller for USB fuzzing, which is a regression
>>> reported by Andrey Konovalov.
>>>
>>> Furthermore, in conjunction with the fix of another bug, handled by another
>>> patch titled "usbcore/driver: Fix specific driver selection" in this patch
>>> set, the usbip_match function causes unexpected USB subsystem behaviour
>>> when the usbip_host driver is loaded. The unexpected behaviour can be
>>> qualified as follows:
>>> - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
>>>     in the kernel, then all USB devices are bound to the usbip_host
>>>     driver, which appears to the user as if all USB devices were
>>>     disconnected.
>>> - If the same commit (41160802ab8e) is not in the kernel (as is the case
>>>     with v5.8.10) then all USB devices are re-probed and re-bound to their
>>>     original device drivers, which appears to the user as a disconnection
>>>     and re-connection of USB devices.
>>>
>>> Please note that this commit will make usbip non-operational again,
>>> until yet another patch in this patch set is merged, titled
>>> "usbcore/driver: Accommodate usbip".
>>>
>>> Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
>>> Cc: <stable@vger.kernel.org> # 5.8
>>
>> Hello Greg,
>>
>> Sorry for the lateness of this e-mail.
>>
>> I had noted commit 41160802ab8e ("USB: Simplify USB ID table match") as a
>> prerequisite in the commit message, but I just realized that the commit
>> identifier refers to a commit in my local git tree, and not to the actual
>> commit in Linus Torvalds' git tree! I apologize for this mistake.
>>
>> Here is the correct commit identifier:
>>    0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944 ("USB: Simplify USB ID table match")
>>
>> Perhaps this is why the prerequisite commit was not cherry-picked to the 5.8.y
>> branch.
>>
>> As a justification for the cherry-pick, commit 0ed9498f9ecf actually resolves
>> a bug. In summary, this commit works together with commit adb6e6ac20ee ("USB:
>> Also match device drivers using the ->match vfunc", which has been cherry-picked
>> as part of v5.8.6) and ensures that a USB driver's ->match function is also
>> called during the search for a more specialized/appropriate USB driver, in case
>> the driver in question does not have an id_table.
>>
>> If I am to be the devil's advocate, however, then given that there is only one
>> specialized USB device driver ("apple-mfi-fastcharge"), which conveniently has
>> an id_table, and also given that usbip no longer has a match function, I also
>> realize that it may not be crucial to cherry-pick 0ed9498f9ecf as a prerequisite
>> commit.
> 
> I'm sorry, but I don't really understand.  Does 5.8.y need an additional
> patch here, or is all ok because I missed the above patch?

No worries; sorry for not communicating clearly and for the delay.

I meant to state that it would be good to have commit 0ed9498f9ecf ("USB: Simplify
USB ID table match") cherry picked to 5.8.y, as it fixes a bug, albeit a minor one.

Thank you,

Vefa
