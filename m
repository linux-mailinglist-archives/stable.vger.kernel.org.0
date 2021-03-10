Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA96333FFD
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 15:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhCJOKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 09:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhCJOKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 09:10:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56C9664FE5;
        Wed, 10 Mar 2021 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615385429;
        bh=GYtxc/KBm2cPeRcQrsmKZtpPqvdeQbsvassH5zzBcDY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FqprEAQpNAeSL3uf1wXwOsfuMotV5siUk690EudW5RO1US9S6oATADtPT+evDbHlk
         PKECzLB0fPO8hBbIxCB9AHN5HfdynZUFgIb9ulFCjFl3sW+L0GcC+GQ08DZ+Uem29Y
         +Lkiut7/RZA06RukoKxA0E3uP4KxI1uMYwjram8U=
Date:   Wed, 10 Mar 2021 15:10:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>,
        Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
Message-ID: <YEjTUwOnAfoKyCpV@kroah.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-4-zhengyejian1@huawei.com>
 <YEdQoy6j7eOne+8h@kroah.com>
 <20210309181437.GV4931@dell>
 <YEi08Dr3cgNp0KlP@kroah.com>
 <20210310132802.GP701493@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132802.GP701493@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 01:28:02PM +0000, Lee Jones wrote:
> On Wed, 10 Mar 2021, Greg KH wrote:
> 
> > On Tue, Mar 09, 2021 at 06:14:37PM +0000, Lee Jones wrote:
> > > On Tue, 09 Mar 2021, Greg KH wrote:
> > > 
> > > > On Tue, Mar 09, 2021 at 11:06:05AM +0800, Zheng Yejian wrote:
> > > > > From: Thomas Gleixner <tglx@linutronix.de>
> > > > > 
> > > > > The handle_exit_race() function is defined in commit 9c3f39860367
> > > > >  ("futex: Cure exit race"), which never returns -EBUSY. This results
> > > > > in a small piece of dead code in the attach_to_pi_owner() function:
> > > > > 
> > > > > 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> > > > > 	...
> > > > > 	if (ret == -EBUSY)
> > > > > 		*exiting = p; /* dead code */
> > > > > 
> > > > > The return value -EBUSY is added to handle_exit_race() in upsteam
> > > > > commit ac31c7ff8624409 ("futex: Provide distinct return value when
> > > > > owner is exiting"). This commit was incorporated into v4.9.255, before
> > > > > the function handle_exit_race() was introduced, whitout Modify
> > > > > handle_exit_race().
> > > > > 
> > > > > To fix dead code, extract the change of handle_exit_race() from
> > > > > commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
> > > > >  is exiting"), re-incorporated.
> > > > > 
> > > > > Lee writes:
> > > > > 
> > > > > This commit takes the remaining functional snippet of:
> > > > > 
> > > > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> > > > > 
> > > > > ... and is the correct fix for this issue.
> > > > > 
> > > > > Fixes: 9c3f39860367 ("futex: Cure exit race")
> > > > > Cc: stable@vger.kernel.org # v4.9.258
> > > > > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > > > > Reviewed-by: Lee Jones <lee.jones@linaro.org>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > > > > ---
> > > > >  kernel/futex.c | 6 +++---
> > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > Same here, what is the upstream git id?
> > > 
> > > It doesn't have one as such - it's a part-patch:
> > > 
> > > > > This commit takes the remaining functional snippet of:
> > > > > 
> > > > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> > 
> > That wasn't obvious :(
> 
> This was also my thinking, which is why I replied to the original
> patch in an attempt to clarify what I thought was happening.
> 
> > Is this a backport of another patch in the stable tree somewhere?
> 
> Yes, it looks like it.
> 
> The full patch was back-ported to v4.14 as:
> 
>   e6e00df182908f34360c3c9f2d13cc719362e9c0

Ok, Zheng, can you put this information in the patch and resend the
whole series?

thanks,

greg k-h
