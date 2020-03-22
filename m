Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E755E18E5E0
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgCVBzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgCVBzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:55:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7FD20753;
        Sun, 22 Mar 2020 01:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584842107;
        bh=y3EnSon9cHSyFeKk+MXsTsrqN7tBu+/NvqQ0fsNxXMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=odWTk07iZnPjyJTf8Zt9SPHmShEdhbr2Kaz49KSfdgNJy3osLvzpzmrGGoI4/UoSQ
         TLaPsYC95wVPTJNLKMLZoQK9FYofexYDtt3NFFrHQHvvcBgsbWNqo974bfL9DttjmG
         rMmNz8y2mXoxzJmNRxTguRw+jkds1cRZ8+YYHQoQ=
Date:   Sat, 21 Mar 2020 21:55:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] locks: fix a potential use-after-free problem when
 wakeup a waiter
Message-ID: <20200322015500.GM4189@sasha-vm>
References: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
 <20200318222906.GJ4189@sasha-vm>
 <20200319063742.GB3274814@kroah.com>
 <500c8174c171378e8b6802ad70b4bf5563b3fab0.camel@codethink.co.uk>
 <20200320054130.GA9611@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200320054130.GA9611@ubuntu-m2-xlarge-x86>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 10:41:30PM -0700, Nathan Chancellor wrote:
>On Thu, Mar 19, 2020 at 07:27:56PM +0000, Ben Hutchings wrote:
>> On Thu, 2020-03-19 at 07:37 +0100, Greg Kroah-Hartman wrote:
>> > On Wed, Mar 18, 2020 at 06:29:06PM -0400, Sasha Levin wrote:
>> > > On Wed, Mar 18, 2020 at 10:09:20PM +0000, Ben Hutchings wrote:
>> > > > This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
>> > > > branches:
>> > > >
>> > > > commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
>> > > > Author: yangerkun <yangerkun@huawei.com>
>> > > > Date:   Wed Mar 4 15:25:56 2020 +0800
>> > > >
>> > > >    locks: fix a potential use-after-free problem when wakeup a waiter
>> > >
>> > > I've queued it up for 5.5 and 5.4, thanks!
>> > >
>> > > > I'm a bit surprised that it hasn't yet been applied, while some fixes
>> > > > from 5.6-rc6 have.
>> > >
>> > > Greg, I wonder if it makes sense to have you push a "Greg is here
>> > > --->" "bookmark" in the form of a tag/branch on linux-stable-rc.git? at
>> > > the very least it'll make it easy to see if something was missed or
>> > > still waiting in the queue.
>> >
>> > To quote Jeff Layton:
>> >
>> > 	Hi Greg, there is a performance regression with this patch. We're
>> > 	sorting through potential ways to address it at the moment, but you may
>> > 	want to hold off until we have a fix for that merged.
>> > 	
>> > 	Sorry for the hassle!
>> >
>> > Which is why I dropped it for now.
>> >
>> > I'll go drop it again :)
>>
>> I didn't see any mention of this on the stable list though.
>> I also don't think that a performance regression outweighs the
>> seriousness of the bug being fixed.
>>
>> Ben.
>>
>
>Looks like a fix for the performance regression was committed yesterday
>to mainline.
>
>dcf23ac3e846c ("locks: reinstate locks_delete_block optimization")

I've queued both 6d390e4b5d48 and dcf23ac3e846c to 5.5 and 5.4.

-- 
Thanks,
Sasha
