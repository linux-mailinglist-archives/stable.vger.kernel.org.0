Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0266A115C1D
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 12:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfLGL55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 06:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfLGL54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Dec 2019 06:57:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D08B22176D;
        Sat,  7 Dec 2019 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575719876;
        bh=p6O/lHVRTH6YtTXiGilVdF0uKmFy7+Lt+hifmmAiDrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4gqtBWcr5BQxB59w9uIvnsDmR1EPhzQlwr3yc06Wlw1KYBroJL+VepvCS/e6tXdR
         mKfCzIR9KgSPRqV21h60adSiZY1XbCfq6PbdtaW9DLg/3X9qb8Z3BRhSavte115h3m
         vydbMQ+ZQRuuyOYAIHIdVBnbTSuoIqehEQ0YGutQ=
Date:   Sat, 7 Dec 2019 12:57:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
Message-ID: <20191207115754.GB325082@kroah.com>
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com>
 <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
 <20191206141129.GA9376@kroah.com>
 <CAPtwhKrZwkp_wmW38ks23ssqn3GShto_tfAL=jTU_Tiy97c-ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtwhKrZwkp_wmW38ks23ssqn3GShto_tfAL=jTU_Tiy97c-ZQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 05:47:10PM -0800, Xuewei Zhang wrote:
> On Fri, Dec 6, 2019 at 6:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Dec 03, 2019 at 03:30:05PM -0800, Xuewei Zhang wrote:
> > > Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:
> >
> > Did you send this twice?
> 
> Yes, sorry it's by accident.
> 
> >
> > And the patch is totally corrupted:
> >
> > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > index f77fcd37b226..f0abb8fe0ae9 100644
> > > --- a/kernel/sched/fair.c
> > > +++ b/kernel/sched/fair.c
> > > @@ -4868,20 +4868,28 @@ static enum hrtimer_restart
> > > sched_cfs_period_timer(struct hrtimer *timer)
> > >   if (++count > 3) {
> > >   u64 new, old = ktime_to_ns(cfs_b->period);
> > >
> > > - new = (old * 147) / 128; /* ~115% */
> > > - new = min(new, max_cfs_quota_period);
> > > -
> > > - cfs_b->period = ns_to_ktime(new);
> > > -
> >
> > All of your leading whitespace is gone.
> >
> > You can't use the web client of gmail to send patches inline, sorry.
> >
> > Can you fix this up and resend all of the backports, none of these
> > worked :(
> 
> Sorry for the formatting problem Greg.
> 
> I just used `git send-email` to sent out the backports. They are at:
> v4.19: https://www.spinics.net/lists/stable/msg347573.html
> v4.14: https://www.spinics.net/lists/stable/msg347576.html
> v4.9: https://www.spinics.net/lists/stable/msg347577.html
> v4.4: https://www.spinics.net/lists/stable/msg347578.html
> v3.16: https://www.spinics.net/lists/stable/msg347579.html
> 
> Hopefully that could work for you. But if they are still broken somehow
> (for which I'd be very sorry), you could consider cherry-picking the patch
> from my Github repository (forked from yours):

Those worked just fine from the emails you just sent (note, try using
lore.kernel.org instead of other mail archives, as I could not pull a
patch out of spinics.net).

I'll let Ben take the 3.16 version, as he handles that tree.

thanks,

greg k-h
