Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AC2AAE80
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 01:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgKIAT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 19:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgKIAT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 19:19:57 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65315206F4;
        Mon,  9 Nov 2020 00:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604881196;
        bh=JmOVQ0lS9L03RxDhQ4u0jFFiObXIqtoCL7R6icSgmQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xWor+i7V0cc2L2vOV0EqE1j+Z09u96MjYKh2++r1SfW3y1BJy0VAObcrc0b1HT/v2
         GIQvj8ntMYJa+atULbm1HlGeaWP8Fo1IiNeuypCLhlQvzH6D3LfB+vcV3CtwZDW7G5
         202UtpuFmDzvPBgGlOkme0DZHkvVYeZNns2JG6Bg=
Date:   Sun, 8 Nov 2020 19:19:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: build failures in v4.4.y stable queue
Message-ID: <20201109001955.GS2092@sasha-vm>
References: <20201104141230.GC4312@roeck-us.net>
 <20201104143709.GC2202359@kroah.com>
 <20201104161817.GG2092@sasha-vm>
 <1fc37180-ad6f-d2b7-7921-77e9c271ebb0@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fc37180-ad6f-d2b7-7921-77e9c271ebb0@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 06:34:50PM -0800, Guenter Roeck wrote:
>On 11/4/20 8:18 AM, Sasha Levin wrote:
>> On Wed, Nov 04, 2020 at 03:37:09PM +0100, Greg KH wrote:
>>> On Wed, Nov 04, 2020 at 06:12:30AM -0800, Guenter Roeck wrote:
>>>> Building ia64:defconfig ... failed
>>>> --------------
>>>> Error log:
>>>> drivers/acpi/numa.c: In function 'pxm_to_node':
>>>> drivers/acpi/numa.c:49:43: error: 'numa_off' undeclared
>>>
>>> Caused by 8a3decac087a ("ACPI: Add out of bounds and numa_off
>>> protections to pxm_to_node()"), I'll go drop it.
>>>
>>> Sasha, you didn't queue this up to 4.9, but you did to 4.4?
>>>
>>>>
>>>> Building powerpc:defconfig ... failed
>>>> --------------
>>>> Error log:
>>>> arch/powerpc/kvm/book3s_hv.c: In function ‘kvm_arch_vm_ioctl_hv’:
>>>> arch/powerpc/kvm/book3s_hv.c:3161:7: error: implicit declaration of function ‘kvmhv_on_pseries’
>>>
>>> Caused by 05e6295dc7de ("KVM: PPC: Book3S HV: Do not allocate HPT for a
>>> nested guest"), I'll go drop this.
>>>
>>> Sasha, why did you only queue this up to 4.4 and 5.4 and 5.9 and not the
>>> middle queues as well?
>>
>> Originally it got queued everywhere, but then it looks like I dropped it
>> from 4.9-4.19 because of build failures, but it seems that the 4.4
>> failure wasn't detected.
>>
>> Looking into why, it seems that my baseline for that build also fails
>> for some reason:
>>
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1603: Warning: invalid register expression
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:1644: Warning: invalid register expression
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
>> ../../../../linux/arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
>> make[2]: *** [/home/sasha/data/linux/scripts/Makefile.build:375: arch/powerpc/kernel/head_64.o] Error 1
>> make[1]: *** [/home/sasha/data/linux/Makefile:1006: arch/powerpc/kernel] Error 2
>>
>> I think that I'll rebuild my toolchain for powerpc and redo the baseline
>> builds, sorry about that.
>>
>
>Is that an allmodconfig build ? That simply won't build in 4.4.y because
>exceptions-64s.S is too large there.

But only on 4.4, and not on 4.9+? sheesh...

-- 
Thanks,
Sasha
