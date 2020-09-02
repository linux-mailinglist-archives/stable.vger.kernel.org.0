Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB34625AB6E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBMvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:51:06 -0400
Received: from gofer.mess.org ([88.97.38.141]:45889 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgIBMvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 08:51:03 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id AB606C649E; Wed,  2 Sep 2020 13:51:01 +0100 (BST)
Date:   Wed, 2 Sep 2020 13:51:01 +0100
From:   Sean Young <sean@mess.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 053/125] media: gpio-ir-tx: improve precision of
 transmitted signal due to scheduling
Message-ID: <20200902125101.GA12378@gofer.mess.org>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150937.150292200@linuxfoundation.org>
 <20200902102521.GC3765@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902102521.GC3765@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Wed, Sep 02, 2020 at 12:25:21PM +0200, Pavel Machek wrote:
> Hi!
> > 
> > [ Upstream commit ea8912b788f8144e7d32ee61e5ccba45424bef83 ]
> > 
> > usleep_range() may take longer than the max argument due to scheduling,
> > especially under load. This is causing random errors in the transmitted
> > IR. Remove the usleep_range() in favour of busy-looping with udelay().
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> 
> I don't believe this should be in stable.
> 
> Yes, it probably fixes someone's remote control.
> 
> It also introduces > half a second (!) with interrupts disabled
> (according to the code comments), which will break other devices on
> the system.

Yes, I've always been uncormfortable with this code, but nothing else I
tried worked.

BTW the delay has a maximum of half a second, but the point stands of
course.

> Less intrusive solutions should be explored, first. Like.. if that
> part is time-critical, perhaps it should set itself at realtime
> priority, so that scheduler has motivation to schedule it at the right
> times?

That is an interesting idea, I'll explore that.

> Perhaps usleep_range should be delta, delta+1?

I'm pretty sure I tried that and it didn't work. I'll give it another go.

> Perhaps udelay makes sense to use for more than 10usec?

I don't follow -- what are you suggesting here?

So any other ideas here would be very welcome. I'm happy to explore options,
so far under load the output is can be total garbage if you're unlucky.


Thanks,

Sean


> 
> Best regards,
> 										Pavel
> 
> > @@ -87,13 +87,8 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
> >  			// space
> >  			edge = ktime_add_us(edge, txbuf[i]);
> >  			delta = ktime_us_delta(edge, ktime_get());
> > -			if (delta > 10) {
> > -				spin_unlock_irqrestore(&gpio_ir->lock, flags);
> > -				usleep_range(delta, delta + 10);
> > -				spin_lock_irqsave(&gpio_ir->lock, flags);
> > -			} else if (delta > 0) {
> > +			if (delta > 0)
> >  				udelay(delta);
> > -			}
> >  		} else {
> >  			// pulse
> >  			ktime_t last = ktime_add_us(edge, txbuf[i]);
> > -- 
> > 2.25.1
> > 
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


