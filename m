Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B539412E11A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 00:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgAAXxb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 Jan 2020 18:53:31 -0500
Received: from ozlabs.org ([203.11.71.1]:54965 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbgAAXxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 18:53:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47p7KM28hJz9sPK;
        Thu,  2 Jan 2020 10:53:27 +1100 (AEDT)
Date:   Thu, 02 Jan 2020 10:53:24 +1100
User-Agent: K-9 Mail for Android
In-Reply-To: <5454eee6-a94b-9254-512e-e8e685778b26@roeck-us.net>
References: <20191229162508.458551679@linuxfoundation.org> <20191230171959.GC12958@roeck-us.net> <20191230173506.GB1350143@kroah.com> <7c5b2866-39d9-5c5f-0282-eef2f34c7fe8@roeck-us.net> <20200101162413.GA2682113@kroah.com> <5454eee6-a94b-9254-512e-e8e685778b26@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, mpe@ellerman.id.au,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
From:   Michael Ellerman <michael@ellerman.id.au>
Message-ID: <EF9945BD-7923-45B0-A10F-0C6CA289E00D@ellerman.id.au>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2 January 2020 4:28:29 am AEDT, Guenter Roeck <linux@roeck-us.net> wrote:
>On 1/1/20 8:24 AM, Greg Kroah-Hartman wrote:
>> On Tue, Dec 31, 2019 at 06:01:12PM -0800, Guenter Roeck wrote:
>>> On 12/30/19 9:35 AM, Greg Kroah-Hartman wrote:
>>>> On Mon, Dec 30, 2019 at 09:19:59AM -0800, Guenter Roeck wrote:
>>>>> On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman
>wrote:
>>>>>> This is the start of the stable review cycle for the 4.19.92
>release.
>>>>>> There are 219 patches in this series, all will be posted as a
>response
>>>>>> to this one.  If anyone has any issues with these being applied,
>please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>> Build results:
>>>>> 	total: 156 pass: 141 fail: 15
>>>>> Failed builds:
>>>>> 	i386:tools/perf
>>>>> 	<all mips>
>>>>> 	x86_64:tools/perf
>>>>> Qemu test results:
>>>>> 	total: 381 pass: 316 fail: 65
>>>>> Failed tests:
>>>>> 	<all mips>
>>>>> 	<all ppc64_book3s_defconfig>
>>>>>
>>>>> perf as with v4.14.y.
>>>>>
>>>>> arch/mips/kernel/syscall.c:40:10: fatal error: asm/sync.h: No such
>file or directory
>>>>
>>>> Ah, will go drop the offending patch and push out a -rc2 with both
>of
>>>> these issues fixed.
>>>>
>>>>> arch/powerpc/include/asm/spinlock.h:56:1: error: type defaults to
>‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’
>>>>> and similar errors.
>>>>>
>>>>> The powerpc build problem is inherited from mainline and has not
>been fixed
>>>>> there as far as I can see. I guess that makes 4.19.y bug-for-bug
>"compatible"
>>>>> with mainline in that regard.
>>>>
>>>> bug compatible is fun :(
>>>>
>>>
>>> Not really. It is a terrible idea and results in the opposite of
>what I would
>>> call a "stable" release.
>>>
>>> Anyway, turns out the offending commit is 14c73bd344d
>("powerpc/vcpu: Assume
>>> dedicated processors as non-preempt"), which uses
>static_branch_unlikely().
>> 
>> It does?  I see:
>> 
>> +               if (lppaca_shared_proc(get_lppaca()))
>> +                       static_branch_enable(&shared_processor);
>> 
>>> This function does not exist for ppc in v4.19.y and v5.4.y. Thus,
>the _impact_
>>> of the error in v4.19.y and v5.4.y is the same as in mainline, but
>the _cause_
>>> is different. Upstream commit 14c73bd344d should not have been
>applied to
>>> v4.19.y and v5.4.y and needs to be reverted from those branches.
>> 
>> I'll go revert this patch, but as it was marked for stable by the
>> authors of the patch, as relevant back to 4.18, I would have hoped
>that
>> they knew what they were doing :)
>> 
>
>I probably didn't have enough champagne last night when I wrote my
>previous e-mail.
>No, the problem is the same as with the upstream kernel, so feel free
>to drop
>the revert if you prefer "bug-for-bug compatibility". Given where we
>are, that
>is probably better than dropping the patch and re-applying it after its
>fix
>is available.
>
>The underlying problem is that the offending patch introduces the use
>of
>jump label code into arch/powerpc/include/asm/spinlock.h without
>including
>linux/jump_label.h. Depending on the configuration, this results in the
>observed
>build errors.
>
>Patches were submitted upstream to fix the problem, but the fix has not
>been
>applied to mainline, and I don't see a maintainer reaction. Maybe
>everyone
>is off for the holidays.

I am off for the "holidays". But I put the patch in my fixes branch a few days ago, I'll send a pull to Linus tomorrow.

cheers

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
