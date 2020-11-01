Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7132A1D66
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgKAKoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgKAKoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:44:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4154B2072C;
        Sun,  1 Nov 2020 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604227443;
        bh=67tkhz7sy2VLerpPlvTKstXVL5NUfJRmG4tYNesA66Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qB/ksqpBxiXuLMJW1lqI3VM0RwzOgfYi3lir47FczaS+9bTIUQhUJZ5l5uWHCUXcv
         iMMn+7im9M1xki8T4lMQWFXvYRqRN7HfjSI7wL71mmvlBz7csxj1RQbd1gS8taq/IE
         c0j85WHjF3gqYr/R+vdBqiYP6OJraI/eeAJJer0M=
Date:   Sun, 1 Nov 2020 11:44:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Linux 4.19.154
Message-ID: <20201101104447.GC2689688@kroah.com>
References: <160405368022942@kroah.com>
 <160405368043128@kroah.com>
 <5F9D6341.71F2A54E@users.sourceforge.net>
 <9996e46f-e493-e3b3-c23a-31415668db7d@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9996e46f-e493-e3b3-c23a-31415668db7d@i-love.sakura.ne.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 11:02:56PM +0900, Tetsuo Handa wrote:
> On 2020/10/31 22:14, Jari Ruusu wrote:
> > Greg Kroah-Hartman wrote:
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -2127,11 +2127,10 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
> >>  {
> >>         char b[BDEVNAME_SIZE];
> >>
> >> -       printk(KERN_INFO "attempt to access beyond end of device\n");
> >> -       printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
> >> -                       bio_devname(bio, b), bio->bi_opf,
> >> -                       (unsigned long long)bio_end_sector(bio),
> >> -                       (long long)maxsector);
> >> +       pr_info_ratelimited("attempt to access beyond end of device\n"
> >> +                           "%s: rw=%d, want=%llu, limit=%llu\n",
> >> +                           bio_devname(bio, b), bio->bi_opf,
> >> +                           bio_end_sector(bio), maxsector);
> >>  }
> >>
> >>  #ifdef CONFIG_FAIL_MAKE_REQUEST
> > 
> > Above change "block: ratelimit handle_bad_sector() message"
> > upstream commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d
> > in 4.19.154 kernel is not completely OK.
> > 
> > Removing casts from arguments 4 and 5 produces these compile warnings:
> > 
> (...snipped...)
> > For 64 bit systems it is only compile time cosmetic warning. For 32 bit
> > system + CONFIG_LBDAF=n it introduces bugs: output formats are "%llu" and
> > passed parameters are 32 bits. That is not OK.
> > 
> > Upstream kernels have hardcoded 64 bit sector_t. In older stable trees
> > sector_t can be either 64 or 32 bit. In other words, backport of above patch
> > needs to keep those original casts.
> 
> Indeed, commit f4ac712e4fe00963 ("block: ratelimit handle_bad_sector() message")
> depends on commit 72deb455b5ec619f ("block: remove CONFIG_LBDAF") which was merged
> into 5.2 kernel.

Good catch, I'll go revert this now, sorry about it.

greg k-h
