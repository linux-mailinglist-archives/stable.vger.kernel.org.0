Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6B130996
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 20:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgAETKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 14:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAETKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 14:10:47 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE2D206F0;
        Sun,  5 Jan 2020 19:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578251445;
        bh=gFovR1Xk0gnO2h2ewTkbBmXCUDYQOOKLBmb7lW5MOVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GO4uUIuGa50JCPBItbEgev/R7K93zQBz1f2iLidvGSJnpgrIzcbmsCRaoshK88d3t
         QNTumFUSABBU88jNjEtYZTA74UyQ+m6oVvUuf2tZpS8Q1aDlqCSCSCtxpTKLgVNqcx
         y222myNGJM3fRtPLqanlw8YeyNxw7ViNqDUfbskw=
Date:   Sun, 5 Jan 2020 14:10:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200105191042.GB2530@sasha-vm>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com>
 <20200102212837.GA9400@roeck-us.net>
 <20200103004024.GM16372@sasha-vm>
 <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
 <20200105160204.GR16372@sasha-vm>
 <9c295487-5e28-0fa7-7892-59e61cd7d07e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9c295487-5e28-0fa7-7892-59e61cd7d07e@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 05, 2020 at 08:34:59AM -0800, Guenter Roeck wrote:
>On 1/5/20 8:02 AM, Sasha Levin wrote:
>>On Fri, Jan 03, 2020 at 06:50:45AM -0800, Guenter Roeck wrote:
>>>On 1/2/20 4:40 PM, Sasha Levin wrote:
>>>>On Thu, Jan 02, 2020 at 01:28:37PM -0800, Guenter Roeck wrote:
>>>>>On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
>>>>>>On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
>>>>>>>Hi,
>>>>>>>
>>>>>>>I see a number of crashes in the latest v5.4.y-queue; please see below
>>>>>>>for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>>>>>>leak in clk_unregister()").
>>>>>>>
>>>>>>>The context suggests recovery from a failed driver probe, and it appears
>>>>>>>that the memory is released twice. Interestingly, I don't see the problem
>>>>>>>in mainline.
>>>>>>>
>>>>>>>I would suggest to drop that patch from the stable queue.
>>>>>>
>>>>>>That does not look right, as you point out, so I will go drop it now.
>>>>>>
>>>>>>The logic of the clk structure lifetimes seems crazy, messing with krefs
>>>>>>and just "knowing" the lifecycle of the other structures seems like a
>>>>>>problem just waiting to happen...
>>>>>>
>>>>>
>>>>>I agree. While the patch itself seems to be ok per Stephen's feedback,
>>>>>we have to assume that there will be more secondary failures in addition
>>>>>to the one I have discovered. Given that clocks are not normally
>>>>>unregistered, I don't think fixing the memory leak is important enough
>>>>>to risk the stability of stable releases.
>>>>>
>>>>>With all that in mind, I'd rather have this in mainline for a prolonged
>>>>>period of time before considering it for stable release (if at all).
>>>>
>>>>I would very much like to circle back and add both this patch and it's
>>>>fix to the stable trees at some point in the future.
>>>>
>>>>If the code is good enough for mainline it should be good enough for
>>>>stable as well. If it's broken - let's fix it now instead of deferring
>>>>this to when people try to upgrade their major kernel versions.
>>>>
>>>
>>>This is where we differ strongly, and where I think the Linux community will
>>>have to make a decision sometime soon. If "good enough for mainline" is a
>>>relevant criteria for inclusion of a patch into stable releases, we don't
>>>need stable releases anymore (we are backporting all bugs into those anyway).
>>>Just use mainline.
>>>
>>>Really, stable releases should be limited to fixing severe bugs. This is not
>>>a fix for a severe bug, and on top of that it has side effects. True, those
>>>side effects are that it uncovers other bugs, but that just makes it worse.
>>>If we assume that my marginal testing covers, optimistically, 1% of the kernel,
>>>and it discovers one bug, we have the potential of many more bugs littered
>>>throughout the kernel which are now exposed. I really don't want to export
>>>that risk into stable releases.
>>
>>The assumption here is that fixes introduce less bugs than newly
>>introduced features, so I'd like to think that we're not backporting
>>*all* bugs :)
>>
>>It's hard to define "severe" given how widely the kernel is used and all
>>the weird usecases it has. Something that doesn't look severe might be
>>very critical in a specific usecase. I fear that if we have a strict
>>definition of "severe", our users will end up carrying more patches
>>out-of-tree to fix their "less severe" issue, causing fragmantation
>>which we really want to avoid.
>>
>>I actually belive very much in the suggestion you've made in your first
>>paragraph: I'd love to see LTS and later on -stable kernels go away and
>>users just use mainline releases. Yes, it's unrealistic now, but I'd
>>like to think that we're working towards it, thus I want to keep picking
>>up more patches and develop our (as well as our user's) testing muscle
>>to be able to catch regressions.
>>
>
>The result will be that more users will abandon upstream stable releases.
>I already have trouble explaining why that many patches are being backported;
>there is quite some internal grumbling about it (along the line of "this
>patch should not have been backported").
>
>I think we are going into the absolutely wrong direction. Expecting that
>everyone would use mainline is absolutely unrealistic, and backporting
>more and more patches to stable branches can only result in destabilizing
>stable branches, which in turn will drive people away from it (and _not_
>to use mainline). The only reason it wasn't a disaster yet is that we have
>better testing now. But we offset that better testing with backporting
>more patches, which has the opposite effect. One stabilizes, the other
>destabilizes. The end result is the same. Actually, it is worse - the
>indiscriminate backporting not only causes unnecessary regressions,
>it (again) gives people an argument against merging stable releases.
>And, this time I have to admit they are right.

I'd like to think that there are more patches that fix bugs than ones
that introduce them, so backporting more patches should reduce the bug
count rather than increase it. I very much agree with your point on
testing allowing us to pull more patches in, but I disagree that pulling
more patches destabilizes the tree - we don't add any new features here,
we only take more fixes which some view as less severe/critical.

Years ago I shared your view of this, and actually had a pet project
that attempted to pick only the "most important" patches out of a stable
tree (see https://lkml.org/lkml/2016/4/11/775). What I realized quickly
when we started using it is that almost every patch matters to someone
and almost every patch ends up having security impact. We could start
taking one what seems to be really important to us, but as humans we
suck at figuring this out.

-- 
Thanks,
Sasha
