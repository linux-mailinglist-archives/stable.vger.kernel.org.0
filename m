Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC78E40FC17
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhIQPWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 11:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242637AbhIQPVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 11:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E2E61152;
        Fri, 17 Sep 2021 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631892012;
        bh=7g4dy2Nq0EV0oj3TXqa1BUVZxfDuijCer+oQ4nJxntk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAgHfQtHTF+NnAmsYFuWhfU0vFbxiec982s7kOtdu27/4w+tHuAuiygQtOZsrWTQi
         apj+QwU5Ghjk9p5dCTP4T47Aut6OHeC4wrzasWYMVpdgZhg4hFsOXDM3z84grTtCfb
         VloaLY7mMzj9uno58JgsRzbt22lIH4ybS0kPAsO8=
Date:   Fri, 17 Sep 2021 17:20:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YUSyKQwdpfSTbQ4H@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
 <YURQ4ZFDJ8E9MJZM@kroah.com>
 <87sfy38p1o.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfy38p1o.ffs@tglx>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 12:38:43PM +0200, Thomas Gleixner wrote:
> On Fri, Sep 17 2021 at 10:25, Greg Kroah-Hartman wrote:
> > On Fri, Sep 17, 2021 at 12:32:17AM +0200, Thomas Gleixner wrote:
> >> I already got a private bug report vs. that on 5.10.65. Annoyingly
> >> 5.10.5 does not have the issue despite the fact that the resulting diff
> >> between those two versions in hrtimer.c is just in comments.
> 
> The bug report turned out to be a red hering. Probably caused by a
> bisect gone wrong. The real culprit was the posix-cpu-timer change which
> got reverted already.
> 
> > Looks like Sasha picked it up with the AUTOSEL process, and emailed you
> > about this on Sep 5:
> > 	https://lore.kernel.org/r/20210906012153.929962-12-sashal@kernel.org
> 
> which I obviously missed.
> 
> > I will revert it if you don't think it should be in the stable trees.
> 
> It's a pure performance improvement, so according to stable rules it
> should not be there.
> 
> > Also, if you want AUTOSEL to not look at any hrtimer.c patches, just let
> > us know and Sasha will add it to the ignore-list.
> 
> Nah. I try to pay more attention. I'm not against AUTOSEL per se, but
> could we change the rules slightly?
> 
> Any change which is selected by AUTOSEL and lacks a Cc: stable@... is
> put on hold until acked by the maintainer unless it is a prerequisite
> for applying a stable tagged fix?
> 
> This can be default off and made effective on maintainer request.
> 
> Hmm?

The whole point of the AUTOSEL patches are for the huge numbers of
subsystems where maintainers and developers do not care about the stable
trees at all, and so they do not mark patches to be backported.  So
requireing an opt-in like this would defeat the purpose.

We do allow the ability to take files/subsystems out of the AUTOSEL
process as there are many maintainers that do do this right and get
annoyed when patches are picked that they feel shouldn't have.  That's
the best thing we can do for stuff like this.

thanks,

greg k-h
