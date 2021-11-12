Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E0B44EB02
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 17:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhKLQHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 11:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhKLQHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 11:07:37 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BCCC061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 08:04:46 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mlZ2i-0006EO-9d; Fri, 12 Nov 2021 17:04:44 +0100
Message-ID: <e0f6f173-95a6-3868-5cc1-44092acd9267@leemhuis.info>
Date:   Fri, 12 Nov 2021 17:04:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-BS
To:     Mark Boddington <lkml@badpenguin.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <dbadfe41-24bf-5811-cf38-74973df45214@badpenguin.co.uk>
 <YYwDnbpES0rrnWBw@kroah.com>
 <b266047e-5674-d1e6-de4b-59a90299f022@badpenguin.co.uk>
 <797107e1-6595-f3ef-e7b2-5784667f73e7@badpenguin.co.uk>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: kernel 5.15.1: AMD RX 6700 XT - Fails to resume after screen
 blank
In-Reply-To: <797107e1-6595-f3ef-e7b2-5784667f73e7@badpenguin.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1636733086;5112ffe1;
X-HE-SMSGID: 1mlZ2i-0006EO-9d
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark. Replying inline
(https://en.wikipedia.org/wiki/Posting_style#Interleaved_style ), as
that's the norm and kinda expected on Linux kernel mailing lists:

On 11.11.21 00:11, Mark Boddington wrote:
> And also
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=f02abeb0779700c308e661a412451b38962b8a0b
> 
> Maybe if the function is called during resume() without being called
> during init(), bad things happen???

Have you tried to revert any of the patches you suspect to cause this
and see if things improve? And BTW: did 5.15 (aka 5.15.0) work? Or was
some process to resolve this made already somewhere else and I just
missed it?

Ciao, Thorsten (with his Linux kernel regression tracker hat on)

#regzbot poke

> On 10/11/2021 23:02, Mark Boddington wrote:
>> I think I've found the problem.
>>
>> The amdgpu_amdkfd_resume_iommu(adev) call has been moved around a few
>> times recently, but in 5.15.1 it's been removed completely.
>>
>> I think reverting this patch fixes the issue:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=f17dca0ab3f38b19c0f1b935f417f62d4a528723
>>
>>
>> See also:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=714d9e4574d54596973ee3b0624ee4a16264d700
>>
>>
>> Cheers,
>>
>> Mark
>>
>> On 10/11/2021 17:38, Greg KH wrote:
>>> On Wed, Nov 10, 2021 at 04:27:39PM +0000, Mark Boddington wrote:
>>>> Hi all,
>>>>
>>>> I run the mainline Linux kernel on Ubuntu 20.04, built from
>>>> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1/
>>>>
>>>> There appears to be a regression in 5.15.1 which causes the GPU to
>>>> fail to
>>>> resume after power saving.
>>>>
>>>> Could it be this change??:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c?h=v5.15.1&id=8af3a335b5531ca3df0920b1cca43e456cd110ad
>>>>
>>> If you revert it, does it solve the problem for you?
>>>
>>> If not, what kernel version did work for you with this hardware?
>>>
>>> thanks,
>>>
>>> greg k-h
> 
> 
