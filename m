Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C6784B12
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 13:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfHGLxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 07:53:41 -0400
Received: from foss.arm.com ([217.140.110.172]:47138 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfHGLxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 07:53:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CF6B28;
        Wed,  7 Aug 2019 04:53:40 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B3393F575;
        Wed,  7 Aug 2019 04:53:39 -0700 (PDT)
Subject: Re: [PATCH 4.19] Revert "initramfs: free initrd memory if opening
 /initrd.image fails"
To:     Stephen Boyd <swboyd@chromium.org>, Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Christoph Hellwig <hch@lst.de>
References: <20190806175940.156412-1-swboyd@chromium.org>
 <20190806204752.GG17747@sasha-vm>
 <5d49f2ee.1c69fb81.881ec.1cf7@mx.google.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <7d6ad3a2-8b73-a8f8-a9f7-7ffe72e7eb97@arm.com>
Date:   Wed, 7 Aug 2019 12:53:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d49f2ee.1c69fb81.881ec.1cf7@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/08/2019 22:36, Stephen Boyd wrote:
> Quoting Sasha Levin (2019-08-06 13:47:52)
>> On Tue, Aug 06, 2019 at 10:59:40AM -0700, Stephen Boyd wrote:
>>> This reverts commit 25511676362d8f7d4b8805730a3d29484ceab1ec in the 4.19
>>> stable trees. From what I can tell this commit doesn't do anything to
>>> improve the situation, mostly just reordering code to call free_initrd()
>> >from one place instead of many. In doing that, it causes free_initrd()
>>> to be called even in the case when there isn't an initrd present. That
>>> leads to virtual memory bugs that manifest on arm64 devices.
>>>
>>> The fix has been merged upstream in commit 5d59aa8f9ce9 ("initramfs:
>>> don't free a non-existent initrd"), but backporting that here is more
>>> complicated because the patch is stacked upon this patch being reverted
>>> along with more patches that rewrites the logic in this area.
>>>
>>> Let's just revert the patch from the stable tree instead of trying to
>>> backport a collection of fixes to get the final fix from upstream.
>>
>> The only dependency for taking the fix, 5d59aa8f9ce9, into 4.19 is
>> 23091e28735 ("initramfs: cleanup initrd freeing") which is not too
>> scary.
>>
>> Is it the case that 25511676362d8 shouldn't have been backported to 4.19
>> for some reason? If it fixes something on 4.19, I think it's better to
>> take the dependency and the fix instead of reverting.
>>
> 
> Ah thanks for taking a second look. I missed that we call free_initrd()
> in one more case when unpack_to_rootfs() fails and goes into the else
> statement. I suppose bringing in 23091e28735 ("initramfs: cleanup initrd
> freeing") in addition to 5d59aa8f9ce9 works just as well, but I'll defer
> to the persons working in this area.
> 

25511676362d 'fixes' a (one-off) memory leak if the initrd setup is
misconfigured. So not something that is likely to affect many systems,
and a reasonably minor bug. But obviously that commit introduced a more
serious regression which my later patch fixed.

As Sasha has pointed out there is only one extra dependency if you want
to backport my fix.

So I'm happy either way, the original patch was really more of a cleanup
- I'm sorry I missed it when this was being picked up for stable!

Steve
