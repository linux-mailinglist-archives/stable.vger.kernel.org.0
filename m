Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFDC44CDAB
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhKJXOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:14:04 -0500
Received: from smarthost01b.ixn.mail.zen.net.uk ([212.23.1.21]:55332 "EHLO
        smarthost01b.ixn.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhKJXOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:14:04 -0500
Received: from [217.155.148.18] (helo=swift)
        by smarthost01b.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <lkml@badpenguin.co.uk>)
        id 1mkwkM-00052a-Jq; Wed, 10 Nov 2021 23:11:14 +0000
Received: from localhost (localhost [127.0.0.1])
        by swift (Postfix) with ESMTP id 5B2662C9AAC;
        Wed, 10 Nov 2021 23:11:14 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at badpenguin.co.uk
Received: from swift ([127.0.0.1])
        by localhost (swift.badpenguin.co.uk [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fUhCnCa-A1Od; Wed, 10 Nov 2021 23:11:12 +0000 (GMT)
Received: from [192.168.42.11] (katana [192.168.42.11])
        by swift (Postfix) with ESMTPS id 26D4E2C9A31;
        Wed, 10 Nov 2021 23:11:12 +0000 (GMT)
Subject: Re: kernel 5.15.1: AMD RX 6700 XT - Fails to resume after screen
 blank
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <dbadfe41-24bf-5811-cf38-74973df45214@badpenguin.co.uk>
 <YYwDnbpES0rrnWBw@kroah.com>
 <b266047e-5674-d1e6-de4b-59a90299f022@badpenguin.co.uk>
From:   Mark Boddington <lkml@badpenguin.co.uk>
Message-ID: <797107e1-6595-f3ef-e7b2-5784667f73e7@badpenguin.co.uk>
Date:   Wed, 10 Nov 2021 23:11:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b266047e-5674-d1e6-de4b-59a90299f022@badpenguin.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-smarthost01b-IP: [217.155.148.18]
Feedback-ID: 217.155.148.18
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

And also 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=f02abeb0779700c308e661a412451b38962b8a0b

Maybe if the function is called during resume() without being called 
during init(), bad things happen???

Cheers

On 10/11/2021 23:02, Mark Boddington wrote:
> I think I've found the problem.
>
> The amdgpu_amdkfd_resume_iommu(adev) call has been moved around a few 
> times recently, but in 5.15.1 it's been removed completely.
>
> I think reverting this patch fixes the issue: 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=f17dca0ab3f38b19c0f1b935f417f62d4a528723
>
> See also: 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=714d9e4574d54596973ee3b0624ee4a16264d700
>
> Cheers,
>
> Mark
>
> On 10/11/2021 17:38, Greg KH wrote:
>> On Wed, Nov 10, 2021 at 04:27:39PM +0000, Mark Boddington wrote:
>>> Hi all,
>>>
>>> I run the mainline Linux kernel on Ubuntu 20.04, built from
>>> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1/
>>>
>>> There appears to be a regression in 5.15.1 which causes the GPU to 
>>> fail to
>>> resume after power saving.
>>>
>>> Could it be this change??:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c?h=v5.15.1&id=8af3a335b5531ca3df0920b1cca43e456cd110ad 
>>>
>> If you revert it, does it solve the problem for you?
>>
>> If not, what kernel version did work for you with this hardware?
>>
>> thanks,
>>
>> greg k-h
