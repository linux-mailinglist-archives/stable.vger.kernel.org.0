Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092527D806
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfHAIt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:49:58 -0400
Received: from foss.arm.com ([217.140.110.172]:60954 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfHAIt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 04:49:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19CAD337;
        Thu,  1 Aug 2019 01:49:57 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3938A3F694;
        Thu,  1 Aug 2019 01:49:55 -0700 (PDT)
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
To:     Greg KH <greg@kroah.com>, Will Deacon <will@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
 <20190801065700.GA17391@kroah.com>
 <20190801070541.hpmadulgp45txfem@vireshk-i7>
 <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
 <20190801084354.GA1085@kroah.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <bfa41364-6e98-2b1a-6584-6d956c99cfcc@arm.com>
Date:   Thu, 1 Aug 2019 09:49:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190801084354.GA1085@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01/08/2019 09:43, Greg KH wrote:
> On Thu, Aug 01, 2019 at 08:34:45AM +0100, Will Deacon wrote:
>> On Thu, Aug 01, 2019 at 12:35:41PM +0530, Viresh Kumar wrote:
>>> On 01-08-19, 08:57, Greg KH wrote:
>>>> On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
>>>>> On 01-08-19, 07:30, Julien Thierry wrote:
>>>>>> I must admit I am not familiar with backport/stable process enough. But
>>>>>> personally I think the your suggestion seems more sensible than
>>>>>> backporting 4 patches.
>>>>>>
>>>>>> Or you can maybe ignore patch 25 and say in patch 24 that among the
>>>>>> changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
>>>>>> was moved from post_ttbr_update_workaround as it doesn't exist and
>>>>>> placed in check_and_switch_context() as it is its final destination.
>>>>>
>>>>> Done that and dropped the other two patches.
>>>>>
>>>>>> However, I really don't know what's the best way to proceed according to
>>>>>> existing practices. So input from someone else would be welcome.
>>>>>
>>>>> Lets see if someone comes up and ask me to do something else :)
>>>>
>>>> Keeping the same patches that upstream has is almost always the better
>>>> thing to do in the long-run.
>>>
>>> That would require two additional patches to be backported, 22 and 23
>>> from this series. From your suggestion it seems that keeping them is
>>> better here ?
>>
>> Yes. Backporting individual patches as they appear upstream is definitely
>> the preferred method for -stable. It makes the relationship to mainline
>> crystal clear, as well as any dependencies between patches that have been
>> backported. Everytime we tweak something unecessarily in a stable backport,
>> it just creates the potential for confusion and additional conflicts in
>> future backports, so it's best to follow the shape of upstream as closely as
>> possible, even if it results in additional patches.
>>
>> So I wouldn't worry about total number of patches. I'd worry more about
>> things like conflicts, deviation from mainline and overall testing coverage.
> 
> That is exactly correct, thanks for saying it better than I could :)
> 

Thanks, I'll try to keep those guidelines in mind for my future comments
on backports.

Cheers,

-- 
Julien Thierry
