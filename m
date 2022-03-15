Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD44D9B29
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbiCOM2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348251AbiCOM2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:28:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F2DE532E4;
        Tue, 15 Mar 2022 05:27:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CED4B1474;
        Tue, 15 Mar 2022 05:27:39 -0700 (PDT)
Received: from [10.57.90.210] (unknown [10.57.90.210])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E7D603F66F;
        Tue, 15 Mar 2022 05:27:38 -0700 (PDT)
Subject: Re: [PATCH 5.10 38/58] KVM: arm64: Allow indirect vectors to be used
 without SPECTRE_V3A
From:   James Morse <james.morse@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20220310140812.869208747@linuxfoundation.org>
 <20220310140813.956533242@linuxfoundation.org> <20220310234858.GB16308@amd>
 <YirvObKn0ADrEOk+@kroah.com> <ef538a31-5f73-dfc5-12a9-f5222514035c@arm.com>
Message-ID: <dcce2353-d20b-eed3-fac1-420b4cad7152@arm.com>
Date:   Tue, 15 Mar 2022 12:27:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ef538a31-5f73-dfc5-12a9-f5222514035c@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/22 12:20 PM, James Morse wrote:
> On 3/11/22 6:42 AM, Greg Kroah-Hartman wrote:
>> On Fri, Mar 11, 2022 at 12:48:59AM +0100, Pavel Machek wrote:
>>> What is going on here?
>>>
>>>> commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.
>>>
>>> Upstream commit 5bdf is very different from this. In particular,
>>>
>>>>   arch/arm64/kvm/hyp/smccc_wa.S    |   66 +++++++++++++++++++++++++++++++++++++++
>>>
>>> I can't find smccc_wa.S, neither in mainline, nor in -next. And it
>>> looks buggy. I suspect loop_k24 should loop 24 times, but it does 8
>>> loops AFAICT. Same problem with loop_k32.
> 
> Yup, that's a bug. Thanks for spotting it!
> I'll post a replacement for this patch.

Looking more closely at this: when I originally did this the 'new' code for stable was
in a separate patch to make it clear it was new code. Here it looks like Greg has merged
it into this patch.
I'm not sure what the 'rules' are for this sort of thing, obviously Greg gets the last say.

I'll try and restructure the other backports to look like this, it is certainly simpler
than trrying to pull all the prerequisites for all the upstream patches in.


Thanks,

James
