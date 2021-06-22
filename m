Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273403B0111
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFVKQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhFVKQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 06:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 190266109E;
        Tue, 22 Jun 2021 10:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624356874;
        bh=cMy6BBj1ibQ2XrT7h06HDmFSBOdtVkwQnDCm39eQh2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cfXGRgJ7YCVRmoA5dMcNPixzJVbFk61JDKbEVwwzcZz2CyhjCAUD9xtEn8Rt4LjyL
         R6s9tSxAqW+mCo/eoBDpsc43MfgErstbtFc1j51eXSv+CVf4SLUMFuB+MayqgHeJiC
         b/p/+oCuAmxBTlhC5PlFXNr1sBpHHiy5Z/9hcsDo=
Date:   Tue, 22 Jun 2021 12:14:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 095/146] sched/fair: Correctly insert cfs_rqs to
 list on unthrottle
Message-ID: <YNG4B2wlcqMVMx6C@kroah.com>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154917.185551238@linuxfoundation.org>
 <YNDFFkh2Dn0hMqS8@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNDFFkh2Dn0hMqS8@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:57:58PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 21, 2021 at 06:15:25PM +0200, Greg Kroah-Hartman wrote:
> > From: Odin Ugedal <odin@uged.al>
> > 
> > [ Upstream commit a7b359fc6a37faaf472125867c8dc5a068c90982 ]
> > 
> > Fix an issue where fairness is decreased since cfs_rq's can end up not
> > being decayed properly. For two sibling control groups with the same
> > priority, this can often lead to a load ratio of 99/1 (!!).
> > 
> > This happens because when a cfs_rq is throttled, all the descendant
> > cfs_rq's will be removed from the leaf list. When they initial cfs_rq
> > is unthrottled, it will currently only re add descendant cfs_rq's if
> > they have one or more entities enqueued. This is not a perfect
> > heuristic.
> > 
> > Instead, we insert all cfs_rq's that contain one or more enqueued
> > entities, or it its load is not completely decayed.
> > 
> > Can often lead to situations like this for equally weighted control
> > groups:
> > 
> >   $ ps u -C stress
> >   USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> >   root       10009 88.8  0.0   3676   100 pts/1    R+   11:04   0:13 stress --cpu 1
> >   root       10023  3.0  0.0   3676   104 pts/1    R+   11:04   0:00 stress --cpu 1
> > 
> > Fixes: 31bc6aeaab1d ("sched/fair: Optimize update_blocked_averages()")
> > [vingo: !SMP build fix]
> > Signed-off-by: Odin Ugedal <odin@uged.al>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> > Link: https://lore.kernel.org/r/20210612112815.61678-1-odin@uged.al
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This one is currently known to cause some LTP fail, fixes are being
> discussed, please hold off for now.

Now dropped from all queues, thanks.

greg k-h
