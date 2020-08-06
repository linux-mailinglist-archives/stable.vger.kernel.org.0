Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC323E34B
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgHFUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 16:40:20 -0400
Received: from foss.arm.com ([217.140.110.172]:48080 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgHFUkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 16:40:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D93E30E;
        Thu,  6 Aug 2020 13:40:19 -0700 (PDT)
Received: from [10.57.35.143] (unknown [10.57.35.143])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 414D43F7D7;
        Thu,  6 Aug 2020 13:40:18 -0700 (PDT)
Subject: Re: [tip: perf/core] perf/core: Fix endless multiplex timer
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        x86 <x86@kernel.org>
References: <20200305123851.GX2596@hirez.programming.kicks-ass.net>
 <158470908175.28353.4859180707604949658.tip-bot2@tip-bot2>
 <abd1dde6-2761-ae91-195c-cd7c4e4515c6@arm.com>
 <20200806185353.GA2942033@kroah.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <3a89fe47-e143-885a-d116-d3805e0712a0@arm.com>
Date:   Thu, 6 Aug 2020 21:40:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200806185353.GA2942033@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-06 19:53, Greg KH wrote:
> On Thu, Aug 06, 2020 at 07:11:24PM +0100, Robin Murphy wrote:
>> On 2020-03-20 12:58, tip-bot2 for Peter Zijlstra wrote:
>>> The following commit has been merged into the perf/core branch of tip:
>>>
>>> Commit-ID:     90c91dfb86d0ff545bd329d3ddd72c147e2ae198
>>> Gitweb:        https://git.kernel.org/tip/90c91dfb86d0ff545bd329d3ddd72c147e2ae198
>>> Author:        Peter Zijlstra <peterz@infradead.org>
>>> AuthorDate:    Thu, 05 Mar 2020 13:38:51 +01:00
>>> Committer:     Peter Zijlstra <peterz@infradead.org>
>>> CommitterDate: Fri, 20 Mar 2020 13:06:22 +01:00
>>>
>>> perf/core: Fix endless multiplex timer
>>>
>>> Kan and Andi reported that we fail to kill rotation when the flexible
>>> events go empty, but the context does not. XXX moar
>>>
>>> Fixes: fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")
>>
>> Can this patch (commit 90c91dfb86d0 ("perf/core: Fix endless multiplex
>> timer") upstream) be applied to stable please? For PMU drivers built as
>> modules, the bug can actually kill the system, since the runaway hrtimer
>> loop keeps calling pmu->{enable,disable} after all the events have been
>> closed and dropped their references to pmu->module. Thus legitimately
>> unloading the module once things have got into this state quickly results in
>> a crash when those callbacks disappear.
>>
>> (FWIW I spent about two days fighting with this while testing a new driver
>> as a module against the 5.3 kernel installed on someone else's machine,
>> assuming it was a bug in my code...)
> 
> What exactly kernel(s) do you wish for it to be applied to?  It's
> already in the latest stable releases of 5.7.y.

Sorry, I implicitly meant 5.4.y there - the buggy commit was merged in 
5.3, the fix in 5.7, so I think that's the only "stable" branch in 
between that warrants explicit action. Apologies if I'm getting the 
terminology wrong.

Cheers,
Robin.
