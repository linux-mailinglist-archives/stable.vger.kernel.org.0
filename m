Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A9153281
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgBEOIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:08:32 -0500
Received: from foss.arm.com ([217.140.110.172]:47682 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbgBEOIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 09:08:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B51E31B;
        Wed,  5 Feb 2020 06:08:31 -0800 (PST)
Received: from [10.1.195.32] (e112269-lin.cambridge.arm.com [10.1.195.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 841903F68E;
        Wed,  5 Feb 2020 06:08:30 -0800 (PST)
Subject: Re: [PATCH 1/2] drm/panfrost: Make sure MMU context lifetime is not
 bound to panfrost_priv
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Icecream95 <ixn@keemail.me>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20200204143504.135388-1-boris.brezillon@collabora.com>
 <b798bc8f-e8a9-01e9-e234-a8fdef290259@arm.com>
 <20200205150134.340a72c8@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f80c8f6d-6099-5052-a2f3-6453d50b4571@arm.com>
Date:   Wed, 5 Feb 2020 14:08:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205150134.340a72c8@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/02/2020 14:01, Boris Brezillon wrote:
> On Wed, 5 Feb 2020 13:39:21 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 04/02/2020 14:35, Boris Brezillon wrote:
>>> Jobs can be in-flight when the file descriptor is closed (either because
>>> the process did not terminate properly, or because it didn't wait for
>>> all GPU jobs to be finished), and apparently panfrost_job_close() does
>>> not cancel already running jobs. Let's refcount the MMU context object
>>> so it's lifetime is no longer bound to the FD lifetime and running jobs
>>> can finish properly without generating spurious page faults.  
>>
>> Is there any good reason not to just make panfrost_job_close() kill off
>> any running jobs?
> 
> Nope, I just didn't know how to do that without stopping all other jobs
> (should have looked at how mali_kbase is doing that before posting this
> patch :)).

Yeah - this is an area Panfrost might need some improvement, you need to
target the HARD_STOP carefully to ensure you kill of the correct jobs
(and only the correct ones). It's not too difficult at the moment
because we still don't have the _NEXT registers actively in use (I must
get round to reposting that having fixed up the devfreq integration).

>> I'm not sure what the benefit is of allowing the jobs
>> to still run after the file descriptor has closed.
> 
> None that I can think of.
> 
>>
>> In particular this could cause problems when(/if) Panfrost starts trying
>> to deal with "compute" work loads that might have long runtimes. It's
>> quite possible to produce a job which never (naturally) exits, currently
>> we have a simplistic timeout which kills anything which doesn't complete
>> promptly. However there is nothing conceptually wrong with a job which
>> takes seconds (or even minutes) to complete.
> 
> Absolutely. That was also one of my concerns.
> 
>> The hardware has support
>> for task switching ('soft stopping') between jobs so this can be done to
>> prevent blocking other applications.
> 
> Okay. I guess it's implemented in mali_kbase. I'll have a look.
> 
>>
>> If panfrost_job_close() doesn't kill the jobs then removing the timeouts
>> could lead to the situation where there is an 'infinite' job with no
>> owner and no way of killing it off. Which doesn't seem like a great
>> feature ;)
> 
> Didn't know you were planning to remove the timeouts.

Well I don't have any immediate plans, but when(/if) there's interest in
compute the relatively short timeouts for graphics tend to get in the
way. I'm not in a hurry to do it because it will make the scheduling
more complex :)

>>
>> Another approach could be simply to silence the page fault output in
>> this case - switching the address space to UNMAPPED is actually an
>> effective way of killing jobs - at some point I think this was a
>> workaround to a hardware bug, but IIRC that was unreleased hardware :)
> 
> Okay. I'll check how it's done in mali_kbase.
> 
> Thanks for the feedback.

Let me know if you need any pointers about how mali_kbase does it - the
code is not exactly the prettiest ;)

Steve
