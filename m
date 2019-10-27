Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0129E64C7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 19:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfJ0SLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 14:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfJ0SLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 14:11:00 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5646F2064A;
        Sun, 27 Oct 2019 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572199859;
        bh=A/NfhAhlicS9UCtzeezjxfvNvjjgehcB22BsHQREl6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsXK/sK8i/sg9diEsQU/buc+DyHripQCLRHWen6RiQxBFuGsPANkaAAQKd+/YlAil
         i/pjCepEl3coxY39MRHmfjOhxs7vACGdTQRmKNUcfxX7KhZGEC1ooFHcSoM4yGzDF9
         B/l5hQGPezPGJnOlD1DDECHu4dz3Z+uopa01SGVo=
Date:   Sun, 27 Oct 2019 14:10:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable 5.3 backports
Message-ID: <20191027181057.GF1560@sasha-vm>
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
 <20191027134832.GD1560@sasha-vm>
 <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
 <20191027142415.GE1560@sasha-vm>
 <981a3436-e8a0-f13d-d33c-1aa53114fc64@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <981a3436-e8a0-f13d-d33c-1aa53114fc64@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 10:18:12AM -0600, Jens Axboe wrote:
>On 10/27/19 8:24 AM, Sasha Levin wrote:
>> On Sun, Oct 27, 2019 at 08:03:09AM -0600, Jens Axboe wrote:
>>> On 10/27/19 7:48 AM, Sasha Levin wrote:
>>>> On Sun, Oct 27, 2019 at 06:01:03AM -0600, Jens Axboe wrote:
>>>>> On 10/27/19 2:52 AM, Sasha Levin wrote:
>>>>>> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> For some reason I forgot to mark these stable, but they should go
>>>>>>> into stable. In order of applying them, they are:
>>>>>>>
>>>>>>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
>>>>>>
>>>>>> This commit says it fixes c576666863b78 ("io_uring: optimize
>>>>>> submit_and_wait API") which is not in the stable tree.
>>>>>>
>>>>>>> ef03681ae8df770745978148a7fb84796ae99cba
>>>>>>
>>>>>> This commit doesn't say so, but really it fixes 5262f567987d3
>>>>>> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
>>>>>>
>>>>>>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
>>>>>>
>>>>>> Same as the commit above.
>>>>>
>>>>> Oh man, sorry about that, I always forget to check if all of them are in
>>>>> 5.3. I blame the fact that I backport everything to our internal tree,
>>>>> which is 5.2 based. But yes, you are of course right, those three can be
>>>>> dropped.
>>>>
>>>> How much "secret sauce" does your internal tree have? Is it something
>>>> we can peek into to make sure we don't miss fixes?
>>>
>>> There's no secret sauce in the internal tree, it's just that I backport
>>> everything into the 5.2 version that is our newest. It's fully uptodate
>>> with 5.4-rc and in some cases what's queued up for 5.5 as well. Hence I
>>> sometimes forget to check what is applicable to 5.3-stable, since I have
>>> it in our 5.2 tree...
>>>
>>> The internal tree is just backports. That's how we do things.
>>
>> Could you push it somewhere public? I could automate grabbing fixes off
>> of it.
>
>There a few reasons why that hasn't been done, and none of them are
>related to the actual code/patches in there..
>
>But I don't think it would help you. The io_uring branch is a mix of
>things that have gone into the current window (and may or may not need
>to go to stable), and things that are queued up for the next kernel
>versions (and aren't going to stable). This will just continue to drift
>from stable, until we respin a new kernel version internally.

My thinking here was that:

1. I have a bunch of scripts that determine whether a given patch is
relevant to any stable kernel branch.
2. I have a machine learning toy that can help me kick patches for
review.

Running both on your tree means I can (let's say once a week) get a list
of probably fixes that are in your tree but are not in upstream stable
trees and might need to be there.

-- 
Thanks,
Sasha
