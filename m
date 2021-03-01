Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9495D32808E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhCAOT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232807AbhCAOTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC28C64E07;
        Mon,  1 Mar 2021 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614608354;
        bh=k1UvY5aGECSBschfIZbptzWuvhL5cuyW0lixGCaxFHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IBVrvHn70IusfxbNTfaUa4EiDWHh5ycOe9o0R9NXJzWU2yc0dFLuSDmH85Xb0+mHm
         KV6VtIHyxBhjug7yQ738Qs4J81vnM3F9ADrUYza04xV/A0NV/2riOyKL69LsFi2rcs
         QQ96bdbJ4YVP+e/xYB+SuZhyWbzjGVr5ZoVib92I=
Date:   Mon, 1 Mar 2021 15:19:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Xiaoming Ni <nixiaoming@huawei.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org, tglx@linutronix.de,
        wangle6@huawei.com, zhengyejian1@huawei.com
Subject: Re: [PATCH 4.9.258] futex: fix dead code in attach_to_pi_owner()
Message-ID: <YDz338EbaQHUP070@kroah.com>
References: <20210224100923.51315-1-nixiaoming@huawei.com>
 <20210225091738.GC641347@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225091738.GC641347@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 09:17:38AM +0000, Lee Jones wrote:
> On Wed, 24 Feb 2021, Xiaoming Ni wrote:
> 
> > The handle_exit_race() function is defined in commit 9c3f39860367
> >  ("futex: Cure exit race"), which never returns -EBUSY. This results
> > in a small piece of dead code in the attach_to_pi_owner() function:
> > 
> > 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> > 	...
> > 	if (ret == -EBUSY)
> > 		*exiting = p; /* dead code */
> > 
> > The return value -EBUSY is added to handle_exit_race() in upsteam
> > commit ac31c7ff8624409 ("futex: Provide distinct return value when
> > owner is exiting"). This commit was incorporated into v4.9.255, before
> > the function handle_exit_race() was introduced, whitout Modify
> > handle_exit_race().
> > 
> > To fix dead code, extract the change of handle_exit_race() from
> > commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
> >  is exiting"), re-incorporated.
> > 
> > Fixes: 9c3f39860367 ("futex: Cure exit race")
> > Cc: stable@vger.kernel.org # v4.9.258
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > ---
> >  kernel/futex.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> To clarify, this is not a wholesale back-port from Mainline.
> 
> It takes the remaining functional snippet of:
> 
>  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> 
> ... and is the correct fix for this issue.
> 
> Reviewed-by: Lee Jones <lee.jones@linaro.org>

Thanks, now queued up.

greg k-h
