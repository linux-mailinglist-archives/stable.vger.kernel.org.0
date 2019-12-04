Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D668D112A60
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 12:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfLDLl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 06:41:58 -0500
Received: from foss.arm.com ([217.140.110.172]:54768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfLDLl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 06:41:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C36D31B;
        Wed,  4 Dec 2019 03:41:57 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F1B43F68E;
        Wed,  4 Dec 2019 03:41:56 -0800 (PST)
Subject: Re: [PATCH 7/8] drm/panfrost: Add the panfrost_gem_mapping concept
To:     Daniel Vetter <daniel@ffwll.ch>,
        Boris Brezillon <boris.brezillon@collabora.com>
Cc:     stable <stable@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-8-boris.brezillon@collabora.com>
 <20191129201459.GS624164@phenom.ffwll.local>
 <20191129223629.3aaab761@collabora.com>
 <20191202085532.GY624164@phenom.ffwll.local>
 <20191202101321.5a053f32@collabora.com>
 <CAKMK7uG2Zwm5zCud1CZHvAgxgtpg+LopSFM4uB1KO4=yJhYq+Q@mail.gmail.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <cfdfb3f8-75dc-2e01-bc6f-4c7508412137@arm.com>
Date:   Wed, 4 Dec 2019 11:41:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAKMK7uG2Zwm5zCud1CZHvAgxgtpg+LopSFM4uB1KO4=yJhYq+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/12/2019 09:44, Daniel Vetter wrote:
> On Mon, Dec 2, 2019 at 10:13 AM Boris Brezillon
> <boris.brezillon@collabora.com> wrote:
>>
>> On Mon, 2 Dec 2019 09:55:32 +0100
>> Daniel Vetter <daniel@ffwll.ch> wrote:
>>
>>> On Fri, Nov 29, 2019 at 10:36:29PM +0100, Boris Brezillon wrote:
>>>> On Fri, 29 Nov 2019 21:14:59 +0100
>>>> Daniel Vetter <daniel@ffwll.ch> wrote:
>>>>
>>>>> On Fri, Nov 29, 2019 at 02:59:07PM +0100, Boris Brezillon wrote:
>>>>>> With the introduction of per-FD address space, the same BO can be mapped
>>>>>> in different address space if the BO is globally visible (GEM_FLINK)
>>>>>
>>>>> Also dma-buf self-imports for wayland/dri3 ...
>>>>
>>>> Indeed, I'll extend the commit message to mention that case.
>>>>
>>>>>
>>>>>> and opened in different context. The current implementation does not
>>>>>> take case into account, and attaches the mapping directly to the
>>>>>> panfrost_gem_object.
>>>>>>
>>>>>> Let's create a panfrost_gem_mapping struct and allow multiple mappings
>>>>>> per BO.
>>>>>>
>>>>>> The mappings are refcounted, which helps solve another problem where
>>>>>> mappings were teared down (GEM handle closed by userspace) while GPU
>>>>>> jobs accessing those BOs were still in-flight. Jobs now keep a
>>>>>> reference on the mappings they use.
>>>>>
>>>>> uh what.
>>>>>
>>>>> tbh this sounds bad enough (as in how did a desktop on panfrost ever work)
>>>>
>>>> Well, we didn't discover this problem until recently because:
>>>>
>>>> 1/ We have a BO cache in mesa, and until recently, this cache could
>>>> only grow (no entry eviction and no MADVISE support), meaning that BOs
>>>> were staying around forever until the app was killed.
>>>
>>> Uh, so where was the userspace when we merged this?
>>
>> Well, userspace was there, it's just that we probably didn't stress
>> the implementation as it should have been when doing the changes
>> described in #1, #2 and 3.
>>
>>>
>>>> 2/ Mappings were teared down at BO destruction time before commit
>>>> a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation"), and
>>>> jobs are retaining references to all the BO they access.
>>>>
>>>> 3/ The mesa driver was serializing GPU jobs, and only releasing the BO
>>>> reference when the job was done (wait on the completion fence). This
>>>> has recently been changed, and now BOs are returned to the cache as
>>>> soon as the job has been submitted to the kernel. When that
>>>> happens,those BOs are marked purgeable which means the kernel can
>>>> reclaim them when it's under memory pressure.
>>>>
>>>> So yes, kernel 5.4 with a recent mesa version is currently subject to
>>>> GPU page-fault storms when the system starts reclaiming memory.
>>>>
>>>>> that I think you really want a few igts to test this stuff.
>>>>
>>>> I'll see what I can come up with (not sure how to easily detect
>>>> pagefaults from userspace).
>>>
>>> The dumb approach we do is just thrash memory and check nothing has blown
>>> up (which the runner does by looking at the dmesg and a few proc files).
>>> If you run that on a kernel with all debugging enabled, it's pretty good
>>> at catching issues.
>>
>> We could also check the fence state (assuming it's signaled with an
>> error, which I'm not sure is the case right now).
>>
>>>
>>> For added nastiness lots of interrupts to check error paths/syscall
>>> restarting, and at the end of the testcase, some sanity check that all the
>>> bo still contain what you think they should contain.
>>
>> Okay, but that requires a GPU job (vertex or fragment shader) touching
>> a BO. Apparently we haven't done that for panfrost IGT tests yet, and
>> I'm not sure how to approach that. Should we manually forge a cmdstream
>> and submit it?
> 
> Yeah that's what we do all the time in i915 igts. Usually a simple
> commandstream dword write (if you have that somewhere) is good enough
> for tests. We also have a 2d blitter engine, plus a library for
> issuing copies using the rendercopy.

Midgard has a "write value" job (or "set value" as Panfrost calls it).
See the "infinite job" test I submitted for IGT [1] for an example where
the job descriptor (of another job) is being modified. Although I don't
think that has actually been merged into IGT yet?

[1]
https://lists.freedesktop.org/archives/igt-dev/2019-September/016251.html

Steve
