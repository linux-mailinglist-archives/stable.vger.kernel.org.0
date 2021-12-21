Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB947C59B
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 18:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhLUR6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 12:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbhLUR6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 12:58:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD95C061574;
        Tue, 21 Dec 2021 09:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B22161560;
        Tue, 21 Dec 2021 17:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843AFC36AE8;
        Tue, 21 Dec 2021 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640109481;
        bh=3qgi7m2U5AM2AOiPN4zIxugcdCksddJqx+Ux44PyM1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qAo8OY8u5TEnvSJXZTiZPWyAFXoQ498I07KyY1TYKZm7G6Q8/kCLLQ7dhohQ3ANj2
         4iL+bFix8HrBp5vSbuDu6qaN7g3Q+7TVrHR+0HMN6xYmwYmgzytDnN6u2ttbRB3bT6
         GZVH0aIXC7jY4Z4U7miqtQgUscHNZQa1urs8sQBEzpLyIAKDiIx5AAYn2ztZ7SqO4L
         rL8i0riLSvD54/OWExGZg0jvHJAXhyVPf3KYe3STaWLh16pAczqyW7Obw+Dyr+fLuO
         VocalQNktwbs6YMxyTE4njNwdbNToIenMfRfR6ia1m7qhFKRaWz4bt7Ew6DkwMNwgw
         IDxVE7i7sqW+w==
Date:   Tue, 21 Dec 2021 12:58:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.15 20/29] block: reduce
 kblockd_mod_delayed_work_on() CPU consumption
Message-ID: <YcIVqFOrxbG8sqXK@sashalap>
References: <20211221015751.116328-1-sashal@kernel.org>
 <20211221015751.116328-20-sashal@kernel.org>
 <MWHPR21MB1593141494C76CF5A0BDDB11D77C9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <ad76826e-73b2-b2f0-3cd4-8481645a6568@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ad76826e-73b2-b2f0-3cd4-8481645a6568@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 08:36:33AM -0700, Jens Axboe wrote:
>On 12/21/21 8:35 AM, Michael Kelley (LINUX) wrote:
>> From: Sasha Levin <sashal@kernel.org> Sent: Monday, December 20, 2021 5:58 PM
>>>
>>> From: Jens Axboe <axboe@kernel.dk>
>>>
>>> [ Upstream commit cb2ac2912a9ca7d3d26291c511939a41361d2d83 ]
>>>
>>> Dexuan reports that he's seeing spikes of very heavy CPU utilization when
>>> running 24 disks and using the 'none' scheduler. This happens off the
>>> sched restart path, because SCSI requires the queue to be restarted async,
>>> and hence we're hammering on mod_delayed_work_on() to ensure that the work
>>> item gets run appropriately.
>>>
>>> Avoid hammering on the timer and just use queue_work_on() if no delay
>>> has been specified.
>>>
>>> Reported-and-tested-by: Dexuan Cui <decui@microsoft.com>
>>> Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
>>> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  block/blk-core.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index c2d912d0c976c..a728434fcff87 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -1625,6 +1625,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>>>  int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>>>  				unsigned long delay)
>>>  {
>>> +	if (!delay)
>>> +		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
>>>  	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
>>>  }
>>>  EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
>>> --
>>> 2.34.1
>>
>> Sasha -- there are reports of this patch causing performance problems.
>> See
>> https://lore.kernel.org/lkml/1639853092.524jxfaem2.none@localhost/. I
>> would suggest *not* backporting it to any of the stable branches until
>> the issues are fully sorted out.
>
>Both this and the revert were backported. Which arguably doesn't make a
>lot of sense, but at least it's consistent and won't cause any issues...

The logic behind it is that it makes it easy for both us as well as
everyone else to annotate why a certain patch might be "missing" from
the trees - in this case because it was reverted.

It looks dumb now, but it saves a lot of time as well as mitigates the
risk of it being picked up again at some point in the future.

-- 
Thanks,
Sasha
