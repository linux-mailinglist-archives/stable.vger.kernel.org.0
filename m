Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C5AA8211
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 14:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfIDMI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 08:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbfIDMI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 08:08:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E189922CED;
        Wed,  4 Sep 2019 12:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567598905;
        bh=QbYO5xJQGT1Uu94hWScBCp6qWdp8GydhSptk7yOPeHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HLOwcXn29+BdSWFL3qKDpEDbLdF51Ww2YAF6klsvOok5k1oQ1Lee8fRjgoP40Z3hD
         XXrM2fR7PuHQwR72a2MJS+DqWYtl7VMLoDnalEiQgicy4dE8KYwGP7ehYl2uyJ/Dva
         xKoaEHfjepJkgmsXpJhskZPwPDGL0hrKIhAaKrZY=
Date:   Wed, 4 Sep 2019 08:08:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        Yu Zhao <yuzhao@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 044/167] drm/amdgpu: validate user pitch
 alignment
Message-ID: <20190904120823.GW5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-44-sashal@kernel.org>
 <7957107d-634f-4771-327e-99fdd5e6474e@daenzer.net>
 <20190903170347.GA24357@kroah.com>
 <20190903200139.GJ5281@sasha-vm>
 <CAKMK7uFpBnkF4xABdkDMZ8TYhL4jg6ZuGyHGyVeBxc9rkyUtXQ@mail.gmail.com>
 <829c5912-cf80-81d0-7400-d01d286861fc@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829c5912-cf80-81d0-7400-d01d286861fc@daenzer.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 10:55:10AM +0200, Michel Dänzer wrote:
>On 2019-09-03 10:16 p.m., Daniel Vetter wrote:
>> On Tue, Sep 3, 2019 at 10:01 PM Sasha Levin <sashal@kernel.org> wrote:
>>> On Tue, Sep 03, 2019 at 07:03:47PM +0200, Greg KH wrote:
>>>> On Tue, Sep 03, 2019 at 06:40:43PM +0200, Michel Dänzer wrote:
>>>>> On 2019-09-03 6:23 p.m., Sasha Levin wrote:
>>>>>> From: Yu Zhao <yuzhao@google.com>
>>>>>>
>>>>>> [ Upstream commit 89f23b6efef554766177bf51aa754bce14c3e7da ]
>>>>>
>>>>> Hold your horses!
>>>>>
>>>>> This commit and c4a32b266da7bb702e60381ca0c35eaddbc89a6c had to be
>>>>> reverted, as they caused regressions. See commits
>>>>> 25ec429e86bb790e40387a550f0501d0ac55a47c &
>>>>> 92b0730eaf2d549fdfb10ecc8b71f34b9f472c12 .
>>>>>
>>>>>
>>>>> This isn't bolstering confidence in how these patches are selected...
>>>>
>>>> The patch _itself_ said to be backported to the stable trees from 4.2
>>>> and newer.  Why wouldn't we be confident in doing this?
>>>>
>>>> If the patch doesn't want to be backported, then do not add the cc:
>>>> stable line to it...
>>>
>>> This patch was picked because it has a stable tag, which you presumably
>>> saw as your Reviewed-by tag is in the patch. This is why it was
>>> backported; it doesn't take AI to backport patches tagged for stable...
>
>The patches did point to gaps in validation of ioctl parameters passed
>in by userspace. Unfortunately, they turned out to be too strict,
>causing valid parameters to spuriously fail. If that wasn't the case,
>and the patches didn't have stable tags, maybe we'd be having a
>discussion about why they didn't have the tags now...

That's fair, and we're definitely not complaining that these patches had
a stable tag, my comment was directed more towards the "This isn't
bolstering confidence in how these patches are selected" comment you've
made - we basically did what we were told to do and for some reason you
got upset :)

>>> The revert of this patch, however:
>>>
>>>  1. Didn't have a stable tag.
>
>I guess it didn't occur to me that was necessary, as the patches got
>reverted within days.

Since the original stable tagged patch made it upstream, we're bound to
try and select it for stable branches even if there are more changes or
reverts later on. We'll try to detect further fixes and reverts, but
we're limited by the metadata in the commit message.

>>>  2. Didn't have a "Fixes:" tag.
>>>  3. Didn't have the usual "the reverts commit ..." string added by git
>>>  when one does a revert.
>
>I suspect that's because there were no stable commit hashes to
>reference, see below.
>
>
>>> Which is why we still kick patches for review, even though they had a
>>> stable tag, just so people could take a look and confirm we're not
>>> missing anything - like we did here.
>>>
>>> I'm not sure what you expected me to do differently here.
>
>Yeah, sorry, I didn't realize it's tricky for scripts to recognize that
>the patches have been reverted in this case.

FWIW, I've added another test to my scripts to try and catch these cases
(Revert "%s"). It'll slow down the scripts a bit but it's better to get
it right rather than to be done quickly :)

--
Thanks,
Sasha
