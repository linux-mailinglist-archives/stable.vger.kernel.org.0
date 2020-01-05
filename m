Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E041308EA
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAEQCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 11:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgAEQCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 11:02:08 -0500
Received: from localhost (unknown [73.61.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C402077B;
        Sun,  5 Jan 2020 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578240126;
        bh=SQuaTM/11clie5KRfL19/pPLweekYMQGSmVekjV1jv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=agqbGEu9Yz47PMHx9c7YzLSPbf3LkTRoPouSU28YnODKrTZkEiWWUSCqjb4pCrFLG
         8b7ym4Yxn1YjVcHxqwEhKP01QKHWG8lTqKwzmJ2Od2nFlfisS5XDd1lhmQ6x8K9fya
         y7ZczmWMEh7bBZL2ahEHYZgYEVeffHsEBpeEbniY=
Date:   Sun, 5 Jan 2020 11:02:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200105160204.GR16372@sasha-vm>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com>
 <20200102212837.GA9400@roeck-us.net>
 <20200103004024.GM16372@sasha-vm>
 <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 06:50:45AM -0800, Guenter Roeck wrote:
>On 1/2/20 4:40 PM, Sasha Levin wrote:
>>On Thu, Jan 02, 2020 at 01:28:37PM -0800, Guenter Roeck wrote:
>>>On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
>>>>On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
>>>>> Hi,
>>>>>
>>>>> I see a number of crashes in the latest v5.4.y-queue; please see below
>>>>> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>>>> leak in clk_unregister()").
>>>>>
>>>>> The context suggests recovery from a failed driver probe, and it appears
>>>>> that the memory is released twice. Interestingly, I don't see the problem
>>>>> in mainline.
>>>>>
>>>>> I would suggest to drop that patch from the stable queue.
>>>>
>>>>That does not look right, as you point out, so I will go drop it now.
>>>>
>>>>The logic of the clk structure lifetimes seems crazy, messing with krefs
>>>>and just "knowing" the lifecycle of the other structures seems like a
>>>>problem just waiting to happen...
>>>>
>>>
>>>I agree. While the patch itself seems to be ok per Stephen's feedback,
>>>we have to assume that there will be more secondary failures in addition
>>>to the one I have discovered. Given that clocks are not normally
>>>unregistered, I don't think fixing the memory leak is important enough
>>>to risk the stability of stable releases.
>>>
>>>With all that in mind, I'd rather have this in mainline for a prolonged
>>>period of time before considering it for stable release (if at all).
>>
>>I would very much like to circle back and add both this patch and it's
>>fix to the stable trees at some point in the future.
>>
>>If the code is good enough for mainline it should be good enough for
>>stable as well. If it's broken - let's fix it now instead of deferring
>>this to when people try to upgrade their major kernel versions.
>>
>
>This is where we differ strongly, and where I think the Linux community will
>have to make a decision sometime soon. If "good enough for mainline" is a
>relevant criteria for inclusion of a patch into stable releases, we don't
>need stable releases anymore (we are backporting all bugs into those anyway).
>Just use mainline.
>
>Really, stable releases should be limited to fixing severe bugs. This is not
>a fix for a severe bug, and on top of that it has side effects. True, those
>side effects are that it uncovers other bugs, but that just makes it worse.
>If we assume that my marginal testing covers, optimistically, 1% of the kernel,
>and it discovers one bug, we have the potential of many more bugs littered
>throughout the kernel which are now exposed. I really don't want to export
>that risk into stable releases.

The assumption here is that fixes introduce less bugs than newly
introduced features, so I'd like to think that we're not backporting
*all* bugs :)

It's hard to define "severe" given how widely the kernel is used and all
the weird usecases it has. Something that doesn't look severe might be
very critical in a specific usecase. I fear that if we have a strict
definition of "severe", our users will end up carrying more patches
out-of-tree to fix their "less severe" issue, causing fragmantation
which we really want to avoid.

I actually belive very much in the suggestion you've made in your first
paragraph: I'd love to see LTS and later on -stable kernels go away and
users just use mainline releases. Yes, it's unrealistic now, but I'd
like to think that we're working towards it, thus I want to keep picking
up more patches and develop our (as well as our user's) testing muscle
to be able to catch regressions.

-- 
Thanks,
Sasha
