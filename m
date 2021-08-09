Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F163E4A61
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhHIQ5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:57:46 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34775 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhHIQ5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 12:57:44 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 179GvKP0022980;
        Mon, 9 Aug 2021 18:57:20 +0200
Date:   Mon, 9 Aug 2021 18:57:20 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
Message-ID: <20210809165720.GA22893@1wt.eu>
References: <162850274511123@kroah.com>
 <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
 <1628527244.3ckns4zvnz.none@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628527244.3ckns4zvnz.none@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 12:51:48PM -0400, Alex Xu (Hello71) wrote:
> Excerpts from Greg Kroah-Hartman's message of August 9, 2021 12:27 pm:
> > On Mon, Aug 09, 2021 at 09:23:00AM -0700, Linus Torvalds wrote:
> >> On Mon, Aug 9, 2021 at 2:52 AM <gregkh@linuxfoundation.org> wrote:
> >> >
> >> > The patch below does not apply to the 4.4-stable tree.
> >> 
> >> It shouldn't.
> >> 
> >> The pipe buffer accounting and soft limits that introduced the whole
> >> "limp along with limited pipe buffers" behavior that this fixes was
> >> introduced by
> >> 
> >> > Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated in pipes")
> >> 
> >> ..which made it into 4.5.
> >> 
> >> So 4.4 is unaffected and doesn't want this patch.
> > 
> > But that commit showed up in 4.4.13 as fa6d0ba12a8e ("pipe: limit the
> > per-user amount of pages allocated in pipes") which is why I asked about
> > this.  The code didn't look similar at all, so I couldn't easily figure
> > out the backport myself :(
> > 
> > Willy, any ideas?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> alloc_pipe_info was heavily modified in 09b4d19900 ("pipe: simplify 
> logic in alloc_pipe_info()") and a005ca0e68 ("pipe: fix limit checking 
> in alloc_pipe_info()"), which I think landed in 4.9 and weren't 
> backported. The backported patch should look similar to this:
> 
> @@ -621,7 +621,7 @@
> 
>                 if (!too_many_pipe_buffers_hard(user)) {
>                         if (too_many_pipe_buffers_soft(user))
> -                               pipe_bufs = 1;
> +                               pipe_bufs = 2;
>                         pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * pipe_bufs, GFP_KERNEL);
>                 }
> 
> I can send a rebased patch, but I think we can also leave it the way it 
> is. It's a bit of an edge case; if nobody's hit it so far on 4.4, maybe 
> it can just stay this way until February. There's SLTS, but I don't 
> think they're interested in this kind of patch. Thoughts?

I tend to think that if the patch spent 5 years in 4.4 without anyone
hitting the problem it's likely that most of the applications found on
these distros are not affected either. Doubling the number of pages
could however increase the amount of memory used on some small machines
heavily using pipes (e.g. for splicing), reducing their stability, which
is probably not desirable if nobody complained about the current behavior
on that version.

Thus while I think that this fix should do the job I think it's better
to leave it out of 4.4 until someone *really* wants it.

Just my two cents,
Willy
