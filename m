Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8160413AA3
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 21:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhIUTWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 15:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230497AbhIUTWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 15:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A3A61166;
        Tue, 21 Sep 2021 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632252040;
        bh=q7cife23GK/op9HiZn/PW1l3DptbjfCu7Z7qN8lqqmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DlnU/SggKF1xUzGIMk7bj2Ha0jbqJKQwafZx7/EGhtrsqWJJkjJvhzx1O7LgIqWBM
         OeOxE7TkpO74osd09pC8Vn/Bv5AkMHIwIRN7g3NgZ/GCi2Ne/szw8elZVp4Al69Hqt
         3iMJjb3WgXxKEQ0KoKQl9i7ipeRQ0zpBLLt6Pmrh4DMFVsidrrt205rwyjCcPCTnvS
         pTbs9THHF2dtrTsLgprETdbQehtvkMTlXWpG6oVJBzzhXeO68Lpvm0kUECUSI+OXzl
         OqbuqEYPWZ65/HaZjq6o9tSVTU3y1tMGFE2YR+hWTTZlgkcO8eYk79Vy8R2T69nwIA
         QRrR8c5txiQSQ==
Date:   Tue, 21 Sep 2021 15:20:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YUowhlVfLiLWE8K/@sashalap>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
 <YURQ4ZFDJ8E9MJZM@kroah.com>
 <87sfy38p1o.ffs@tglx>
 <YUSyKQwdpfSTbQ4H@kroah.com>
 <87ee9n80gz.ffs@tglx>
 <YUYJ8WeOzPVwj16y@kroah.com>
 <YUibLGZAVgqiyCUq@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YUibLGZAVgqiyCUq@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 10:31:08AM -0400, Sasha Levin wrote:
>On Sat, Sep 18, 2021 at 05:46:57PM +0200, Greg Kroah-Hartman wrote:
>>On Fri, Sep 17, 2021 at 09:29:32PM +0200, Thomas Gleixner wrote:
>>>Greg,
>>>
>>>On Fri, Sep 17 2021 at 17:20, Greg Kroah-Hartman wrote:
>>>> On Fri, Sep 17, 2021 at 12:38:43PM +0200, Thomas Gleixner wrote:
>>>>> Nah. I try to pay more attention. I'm not against AUTOSEL per se, but
>>>>> could we change the rules slightly?
>>>>>
>>>>> Any change which is selected by AUTOSEL and lacks a Cc: stable@... is
>>>>> put on hold until acked by the maintainer unless it is a prerequisite
>>>>> for applying a stable tagged fix?
>>>>>
>>>>> This can be default off and made effective on maintainer request.
>>>>>
>>>>> Hmm?
>>>>
>>>> The whole point of the AUTOSEL patches are for the huge numbers of
>>>> subsystems where maintainers and developers do not care about the stable
>>>> trees at all, and so they do not mark patches to be backported.  So
>>>> requireing an opt-in like this would defeat the purpose.
>>>>
>>>> We do allow the ability to take files/subsystems out of the AUTOSEL
>>>> process as there are many maintainers that do do this right and get
>>>> annoyed when patches are picked that they feel shouldn't have.  That's
>>>> the best thing we can do for stuff like this.
>>>
>>>I guess I was not able to express myself correctly. What I wanted to say
>>>is:
>>>
>>>  1) Default is AUTOSEL
>>>
>>>  2) Maintainer can take files/subsystems out of AUTOSEL completely
>>>
>>>     Exists today
>>>
>>>  3) Maintainer allows AUTOSEL, but anything picked from files/subsystems
>>>     without a stable tag requires an explicit ACK from the maintainer
>>>     for the backport.
>>>
>>>     Is new and I would be the first to opt-in :)
>>>
>>>My rationale for #3 is that even when being careful about stable tags,
>>>it happens that one is missing. Occasionaly AUTOSEL finds one of those
>>>in my subsystems which I appreciate.
>>>
>>>Does that make more sense now?
>>
>>Ah, yes, that makes much more sense, sorry for the confusion.
>>
>>Sasha, what do you think?  You are the one that scripts all of this, not
>>me :)
>
>I could give it a go. It adds some complexity here but is probably worth
>it to avoid issues.
>
>Let me think about the best way to go about it.

So I'm thinking of yet another patch series that would go out, but
instead of AUTOSEL it'll be tagged with "MANUALSEL". It would work the
exact same way as AUTOSEL, without the final step of queueing up the
commits into the stable trees.

Thomas, do you want to give it a go? Want to describe how I filter for
commits you'd be taking care of? In the past I'd grep a combo of paths
and committers (i.e. net/ && davem@), but you have your hands in too
many things :)

-- 
Thanks,
Sasha
