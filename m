Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E323E53F1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhHJGyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJGyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 02:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D4A761019;
        Tue, 10 Aug 2021 06:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628578455;
        bh=WSwF9Soxod+R7alLk1M9QZ5n1BJ7jILJ2EnisQdX4Eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFLGkpfi/7fwcSizS0TAxFT6FjovJCW1hcPSuT0tE7RuBbosk8RCs9cxCxa4DR20J
         2Nj3uZx3ggSLgHb7Q9cydTBTrHMhWVwy4Y6woYwy2MALarG0poz+LS1BmoplrQTv/l
         l/A+rzRNMeXGErf6cRoEc3Gp1TGtrJuGCksWz8Vs=
Date:   Tue, 10 Aug 2021 08:54:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <YRIilQUgbcejSREr@kroah.com>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
 <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
 <CAHk-=whoV+SNzvOLSOOfM=Gj3m7A81Y4TYd2qtSO3soStiWxFQ@mail.gmail.com>
 <YRFomYOJvuJx8VTT@kroah.com>
 <20210809190406.GA23706@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809190406.GA23706@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 09:04:06PM +0200, Willy Tarreau wrote:
> On Mon, Aug 09, 2021 at 07:40:41PM +0200, Greg Kroah-Hartman wrote:
> > >  fs/pipe.c | 17 ++++++++++++++++-
> > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > This looks good to me, I'll queue it up in a bit as it's more
> > descriptive than Alex's backport.
> 
> Greg, do you *really* want to backport it to 4.4 ? I mean, if nobody
> faces this issue in 4.4 I can see more risks with the fix that without
> for systems with low memory (or manually tuned memory usage).

I always prefer to merge "known fixes" to the stable kernel trees as
somehow once one person hits a bug, everyone hits it, no matter how long
it was in hiding :)

The additional memory usage here seems low to me, and we backported the
needed accounting changes there a long time ago, and we know that 4.4.y
is being used for build servers as well as other huge hosting providers.
The "tiny" systems that might be on 4.4 are not really updating
themselves to newer kernels from what I can tell.

So I would prefer to take this patch, but am always willing to revert it
if someone reports problems with it, as it keeps us in sync with the
other stable branches, and with upstream, as close as possible.

thanks,

greg k-h
