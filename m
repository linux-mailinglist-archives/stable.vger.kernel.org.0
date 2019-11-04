Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540D4EDD7A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 12:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfKDLIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 06:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfKDLIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 06:08:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876C821D7F;
        Mon,  4 Nov 2019 11:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572865715;
        bh=4ou01qcj/utExbOdmWJdAYR/XY9D6wrh/HUTYqpAqEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PxwyU24DPL4fGeFSsstcLtesLgT5tful2lmFMj3PywuGNfn/wVk6yrp/EpFDxRxtm
         KH7NSvz/tmRiWJJ7e8wQ42dCGTvvkJwrRMHt4WlbGI2WcMKqTauBetIM/T3bGSIFpy
         7NuX51NpwrNBTAXc3L7FIQYDUgMBNorx53fZO+m8=
Date:   Mon, 4 Nov 2019 12:08:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20191104110832.GE1945210@kroah.com>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
 <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm>
 <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
 <20191003065135.GA1813585@kroah.com>
 <CAC=E7cWYpdA1Ufds6OoAu+5eP+kTXY1OzZ8O7nLYrfb_tCBEZg@mail.gmail.com>
 <20191018205326.GB1817@hirez.programming.kicks-ass.net>
 <CAC=E7cV2DzpLOz_RaFzBKCN3cEntB7BPLGL9PaGZ2LYb6dc0Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cV2DzpLOz_RaFzBKCN3cEntB7BPLGL9PaGZ2LYb6dc0Jw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 22, 2019 at 09:55:58AM -0500, Dave Chiluk wrote:
> On Fri, Oct 18, 2019 at 3:53 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Oct 18, 2019 at 03:23:02PM -0500, Dave Chiluk wrote:
> > > @Ben @Ingo @Peter
> > > Can you please please ack this backport request?
> > >
> > > Thank you,
> > > Dave Chiluk
> > >
> > > On Thu, Oct 3, 2019 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Oct 03, 2019 at 12:15:02AM -0500, Dave Chiluk wrote:
> > > > > @Greg KH, Qian Cai's compiler warning fix has now been integrated into
> > > > > Linus' tree as commit: 763a9ec06c409
> > > > >
> > > > > Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
> > > > > please queue up these fixes for backport to all stable kernels.
> > > >
> > > > I need an ack from the scheduler maintainers that this is ok to do so...
> >
> > Sure I suppose, but what makes this commit special? Don't you normally
> > take just about anything?
> 
> I think this is more a matter of me being a relatively unknown in the
> scheduler space, and Greg is just being responsible as this looks like
> a pretty scary fix.
> 
> In reality, I probably should have just added "Cc:
> stable@vger.kernel.org" to the sign-off area of the initial commit and
> this conversation wouldn't have been necessary.

That is very true :)

I just tried to apply this to 5.3, 4.19, and 4.14, and it only applies
cleanly to 5.3.y.  Can you please provide backports for 4.19.y and
4.14.y so that I can queue it up there?

thanks,

greg k-h
