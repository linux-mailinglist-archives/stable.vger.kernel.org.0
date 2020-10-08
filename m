Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5222871B0
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgJHJhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:37:34 -0400
Received: from aibo.runbox.com ([91.220.196.211]:45178 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgJHJhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 05:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=ELjpSpTAH7ZIHCGvXzFMEwt8FTjC+X1MqxRx4RtC/l4=; b=XqZwAJX065ggfC7PUIHmyA6Dax
        ynQG+dCLHjSuLAKriTA6uoIp8oc/eEXtPTjkzizv0Gpb9scDEWJ/Ollpeu86ToSwqaVuTIr/8T1sk
        QUzMBfsBEJtTohr6PvzcrT/b0rfh4HCDSR1gALYwXP5H1dS6Ip8O5LneobIOFSYsa4iNILlGG2awO
        eVKv5hQR8vNscD2QfhTMwrtbx4GuY5D2CngtWPgEY9CGTS0cqSWUVEtzVsDtxeX2WpDgE/KYRIMr6
        DD7hBy2HiAMThDRGffXiHwNgv5l6ov4v5fMr5ulT27CwbfYndM9aODBIKuqrMi8qfkpcdTiUlrfNV
        LjiVqnxw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kQSMX-0001Zw-6c; Thu, 08 Oct 2020 11:37:25 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kQSME-0006iS-VQ; Thu, 08 Oct 2020 11:37:07 +0200
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
 <bb5f0904-af0e-e9a3-3d72-2d2d198ff6fa@runbox.com>
 <20201008092525.GA263468@kroah.com>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <aecd3780-1248-804d-2c74-550ccbaeb993@runbox.com>
Date:   Thu, 8 Oct 2020 05:37:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008092525.GA263468@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/10/2020 05.25, Greg Kroah-Hartman wrote:
> On Thu, Oct 08, 2020 at 04:56:56AM -0400, M. Vefa Bicakci wrote:
>> On 07/10/2020 12.13, Greg Kroah-Hartman wrote:
>>> On Tue, Oct 06, 2020 at 04:26:27PM +0300, M. Vefa Bicakci wrote:
>>>> On 05/10/2020 18.26, Greg Kroah-Hartman wrote:
>>>>> From: M. Vefa Bicakci <m.v.b@runbox.com>
>>>>>
>>>>> commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.
>>>>>
>>>>> This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
>>>>> function to fix usbip").
>>>>>
>>>>> In summary, commit d5643d2249b2 ("USB: Fix device driver race")
>>>>> inadvertently broke usbip functionality, which I resolved in an incorrect
>>>>> manner by introducing a match function to usbip, usbip_match(), that
>>>>> unconditionally returns true.
>>>>>
>>>>> However, the usbip_match function, as is, causes usbip to take over
>>>>> virtual devices used by syzkaller for USB fuzzing, which is a regression
>>>>> reported by Andrey Konovalov.
>>>>>
>>>>> Furthermore, in conjunction with the fix of another bug, handled by another
>>>>> patch titled "usbcore/driver: Fix specific driver selection" in this patch
>>>>> set, the usbip_match function causes unexpected USB subsystem behaviour
>>>>> when the usbip_host driver is loaded. The unexpected behaviour can be
>>>>> qualified as follows:
>>>>> - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
>>>>>      in the kernel, then all USB devices are bound to the usbip_host
>>>>>      driver, which appears to the user as if all USB devices were
>>>>>      disconnected.
>>>>> - If the same commit (41160802ab8e) is not in the kernel (as is the case
>>>>>      with v5.8.10) then all USB devices are re-probed and re-bound to their
>>>>>      original device drivers, which appears to the user as a disconnection
>>>>>      and re-connection of USB devices.
>>>>>
>>>>> Please note that this commit will make usbip non-operational again,
>>>>> until yet another patch in this patch set is merged, titled
>>>>> "usbcore/driver: Accommodate usbip".
>>>>>
>>>>> Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
>>>>> Cc: <stable@vger.kernel.org> # 5.8
>>>>
>>>> Hello Greg,
>>>>
>>>> Sorry for the lateness of this e-mail.
>>>>
>>>> I had noted commit 41160802ab8e ("USB: Simplify USB ID table match") as a
>>>> prerequisite in the commit message, but I just realized that the commit
>>>> identifier refers to a commit in my local git tree, and not to the actual
>>>> commit in Linus Torvalds' git tree! I apologize for this mistake.
>>>>
>>>> Here is the correct commit identifier:
>>>>     0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944 ("USB: Simplify USB ID table match")
>>>>
>>>> Perhaps this is why the prerequisite commit was not cherry-picked to the 5.8.y
>>>> branch.
>>>>
>>>> As a justification for the cherry-pick, commit 0ed9498f9ecf actually resolves
>>>> a bug. In summary, this commit works together with commit adb6e6ac20ee ("USB:
>>>> Also match device drivers using the ->match vfunc", which has been cherry-picked
>>>> as part of v5.8.6) and ensures that a USB driver's ->match function is also
>>>> called during the search for a more specialized/appropriate USB driver, in case
>>>> the driver in question does not have an id_table.
>>>>
>>>> If I am to be the devil's advocate, however, then given that there is only one
>>>> specialized USB device driver ("apple-mfi-fastcharge"), which conveniently has
>>>> an id_table, and also given that usbip no longer has a match function, I also
>>>> realize that it may not be crucial to cherry-pick 0ed9498f9ecf as a prerequisite
>>>> commit.
>>>
>>> I'm sorry, but I don't really understand.  Does 5.8.y need an additional
>>> patch here, or is all ok because I missed the above patch?
>>
>> No worries; sorry for not communicating clearly and for the delay.
>>
>> I meant to state that it would be good to have commit 0ed9498f9ecf ("USB: Simplify
>> USB ID table match") cherry picked to 5.8.y, as it fixes a bug, albeit a minor one.
> 
> What bug does it fix now?  Is usbip or the apple charger driver not
> working properly on 5.8.14?  If nothing is broken, no need to add this
> patch...

I had tried to describe the bug in my original e-mail; it involves not considering
the match functions of candidate USB drivers when determining whether a more
specialized driver exists for a USB device. The bug takes effect when a candidate
USB driver does not have an id_table, but has a match function.

To the best of my current understanding, however, the impact of the bug is
currently none/negligible, because the only specialized driver is currently
the Apple charger driver, and the Apple charger driver uses an id_table and
not a match function.

All this to say, given your last statement, and having thought about the whole
thing one more time, perhaps we do not need to cherry-pick the aforementioned
commit. Sorry for the noise!

Thank you,

Vefa
