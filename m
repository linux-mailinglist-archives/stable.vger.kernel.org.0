Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3544F21F
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 09:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhKMISC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 03:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhKMISB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 03:18:01 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED9EC061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 00:15:09 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mloBn-0005T2-1b; Sat, 13 Nov 2021 09:15:07 +0100
Message-ID: <ec02e9bf-2c3b-c22b-ce94-d4a3e1fa102f@leemhuis.info>
Date:   Sat, 13 Nov 2021 09:15:06 +0100
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
 <e0f6f173-95a6-3868-5cc1-44092acd9267@leemhuis.info>
 <ab370b30-3d01-6f7e-4e56-dd7b61251e25@badpenguin.co.uk>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: kernel 5.15.1: AMD RX 6700 XT - Fails to resume after screen
 blank
In-Reply-To: <ab370b30-3d01-6f7e-4e56-dd7b61251e25@badpenguin.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1636791309;c1884b42;
X-HE-SMSGID: 1mloBn-0005T2-1b
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.11.21 18:24, Mark Boddington wrote:
> On 12/11/2021 16:04, Thorsten Leemhuis wrote:
> [...]
>> On 11.11.21 00:11, Mark Boddington wrote:
>>> And also
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c?h=linux-5.15.y&id=f02abeb0779700c308e661a412451b38962b8a0b
>>>
>>>
>>> Maybe if the function is called during resume() without being called
>>> during init(), bad things happen???
>> Have you tried to revert any of the patches you suspect to cause this
>> and see if things improve? And BTW: did 5.15 (aka 5.15.0) work? Or was
>> some process to resolve this made already somewhere else and I just
>> missed it?
>>
>> Ciao, Thorsten (with his Linux kernel regression tracker hat on)
>>
>> #regzbot poke
> 
> I tried reverting both, but they didn't improve the situation.
> 
> I also had the deadlock happen on 5.15 yesterday so the last stabl> kernel I have used is 5.14.15. I can try the latest 5.14.x if that will
> help?

You can give it a shot, maybe the problem shows up there now. But I
doubt it, as in situations like this the change that's causing the
problem likely was introduced in mainline (v5.14..v5.15) and not in
stable (v5.15..v5.15.1).

I'd suggest you do the following: install and run the latest 5.14.y
release, just to be sure (and to get something installed running properly).

In parallel check if someone reported such a problem already to the
developers of the driver in question. This document explains how to find
their mailing list or bug tracker archive to check:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
It also explains many other aspects around searching for existing
reports and reporting Linux kernel issues that might be of help.

If you don't find any existing reports, report your problem anew with
the regression mailing list in CC (no need to CC me or the stable list).
Maybe a developer then has a idea what might cause this and point you in
some direction to confirm. But in the end in situations like this you'll
likely need to bisect the problem using a git bisection (see reporting
issues). So consider to do that before reporting, it's not as hard and
time-consuming as many people think.

Note: As a Linux kernel regression tracker I'm getting a lot of reports
on my table and can only look briefly into them. Due to that I sometimes
will get things wrong and thus might give bad advice. I hope that's not
the case here. But if you think I got something wrong, don't hesitate to
tell me about that. That's in both other interest to prevent you from
going down the wrong rabbit hole.

Ciao, Thorsten (carrying his Linux kernel regression tracker hat)

P.S.: Feel free to ignore the following lines, they are for regzbot, my
Linux kernel regression tracking bot:

#regzbot introduced v5.14..v5.15
