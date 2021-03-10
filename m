Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61482333BE4
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCJMBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhCJMAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD19D64FC8;
        Wed, 10 Mar 2021 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615377651;
        bh=AGuMI85YbWqj55al8PdjTh6DWfYDTr6uOIwqaWAcErE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WLHZmWrARw0ecwJuGJACvT0jW5JWKhyg0d+Mb4BFVbHqpDrpSmaIIivF55LGMF/jb
         sjpQZeqvlZQu3JtQCn0BgyM5GeVIZCHVGduh2AFdWV2TH8CpPklD95PDwwUj3wFXQW
         Pcoia6UEGFZHjRIR2IEX8H1IMdHuFZwaadpki6UY=
Date:   Wed, 10 Mar 2021 13:00:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
Message-ID: <YEi08Dr3cgNp0KlP@kroah.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-4-zhengyejian1@huawei.com>
 <YEdQoy6j7eOne+8h@kroah.com>
 <20210309181437.GV4931@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309181437.GV4931@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 06:14:37PM +0000, Lee Jones wrote:
> On Tue, 09 Mar 2021, Greg KH wrote:
> 
> > On Tue, Mar 09, 2021 at 11:06:05AM +0800, Zheng Yejian wrote:
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > > 
> > > The handle_exit_race() function is defined in commit 9c3f39860367
> > >  ("futex: Cure exit race"), which never returns -EBUSY. This results
> > > in a small piece of dead code in the attach_to_pi_owner() function:
> > > 
> > > 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> > > 	...
> > > 	if (ret == -EBUSY)
> > > 		*exiting = p; /* dead code */
> > > 
> > > The return value -EBUSY is added to handle_exit_race() in upsteam
> > > commit ac31c7ff8624409 ("futex: Provide distinct return value when
> > > owner is exiting"). This commit was incorporated into v4.9.255, before
> > > the function handle_exit_race() was introduced, whitout Modify
> > > handle_exit_race().
> > > 
> > > To fix dead code, extract the change of handle_exit_race() from
> > > commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
> > >  is exiting"), re-incorporated.
> > > 
> > > Lee writes:
> > > 
> > > This commit takes the remaining functional snippet of:
> > > 
> > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> > > 
> > > ... and is the correct fix for this issue.
> > > 
> > > Fixes: 9c3f39860367 ("futex: Cure exit race")
> > > Cc: stable@vger.kernel.org # v4.9.258
> > > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > > Reviewed-by: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > > ---
> > >  kernel/futex.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > Same here, what is the upstream git id?
> 
> It doesn't have one as such - it's a part-patch:
> 
> > > This commit takes the remaining functional snippet of:
> > > 
> > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")

That wasn't obvious :(

Is this a backport of another patch in the stable tree somewhere?

confused,

greg k-h
