Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD05404274
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349033AbhIIA5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 20:57:40 -0400
Received: from x127130.tudelft.net ([131.180.127.130]:54186 "EHLO
        djo.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1348847AbhIIA5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 20:57:40 -0400
Received: by djo.tudelft.nl (Postfix, from userid 2001)
        id EC4DD1C42C2; Thu,  9 Sep 2021 02:57:48 +0200 (CEST)
Date:   Thu, 9 Sep 2021 02:57:48 +0200
From:   wim <wim@djo.tudelft.nl>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        wim <wim@djo.tudelft.nl>
Subject: Re: kernel-4.9.270 crash
Message-ID: <20210909005748.GA8236@djo.tudelft.nl>
Reply-To: wim@djo.tudelft.nl
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
 <20210906093611.GA20123@djo.tudelft.nl>
 <YTXy5BmzQpY0SprA@kroah.com>
 <20210908015139.GA26272@djo.tudelft.nl>
 <YThKidnH3d1fb18g@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YThKidnH3d1fb18g@kroah.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 07:30:49AM +0200, Greg KH wrote:
> > > > ...
> > > > Aug  1 20:51:24 djo kernel:  [<f8bc4ef7>] ? 0xf8bc4ef7
> > > 
> > > <snip>
> > > 
> > > These aren't going to help us much, can you turn on debugging symbols
> > > for these crashes for us to see the symbol names?
> > 
> > ERROR: not enough memory to load nouveau.ko
> 
> That's the only error?  Maybe you don't have enough memory?

Nouveau.ko with symbols is really huge. I see only 2GB RAM in that machine,
so I'm not amazed.

> > i915.ko is smaller and my laptop is bigger. Identical crash, no symbols.
> 
> Odd.

I've had that before, some years ago. The devs were very reluctant to start
investigating. After a while the bug just vanished. Bugs come and go was
their remark.
This time the bug doesn't vanish spontaneously.

> > > > > Can you use 'git bisect' to track down the offending commit?

> > and that brought me reasonably fast to this:
> > 
> >   3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01 is the first bad commit
> >   commit 3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01
> >   Author: Maciej W. Rozycki <macro@orcam.me.uk>
> >   Date:   Thu May 13 11:51:50 2021 +0200
> >   ...
> 
> That is a vt change that handles an issue with a console driver, so this
> feels like a false failure.
> 
> If you revert this change on a newer kernel release, does it work?

No false failure.

git checkout v4.9.282
git revert <the above patch>

Lo and behold, no crash on modprobe i915 !!!


> And what about showing us the symbols of that traceback?

What symbols of what traceback? It does not crash!

And when it crashes (the previous case) there are no symbols, despite
debugging set to on. Just the same log. Apparently it ran invalid code.
What does the 'Divide Error: 0000' mean? A divide by zero error?

Regards, Wim.

