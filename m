Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C1403264
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346957AbhIHBve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:51:34 -0400
Received: from x127130.tudelft.net ([131.180.127.130]:53048 "EHLO
        djo.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1347068AbhIHBvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:51:33 -0400
Received: by djo.tudelft.nl (Postfix, from userid 2001)
        id C71311C42C2; Wed,  8 Sep 2021 03:51:39 +0200 (CEST)
Date:   Wed, 8 Sep 2021 03:51:39 +0200
From:   wim <wim@djo.tudelft.nl>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        wim <wim@djo.tudelft.nl>
Subject: Re: kernel-4.9.270 crash
Message-ID: <20210908015139.GA26272@djo.tudelft.nl>
Reply-To: wim@djo.tudelft.nl
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
 <20210906093611.GA20123@djo.tudelft.nl>
 <YTXy5BmzQpY0SprA@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTXy5BmzQpY0SprA@kroah.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 12:52:20PM +0200, Greg KH wrote:
> > > > > 
> > > > > from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> > > > > loading a GPU module.
> > > > > ...
> > > 
> > > Do you have any kernel log messages when these crashes happen?
> > ...
> > Aug  1 20:51:24 djo kernel:  [<f8bc4ef7>] ? 0xf8bc4ef7
> 
> <snip>
> 
> These aren't going to help us much, can you turn on debugging symbols
> for these crashes for us to see the symbol names?

ERROR: not enough memory to load nouveau.ko

i915.ko is smaller and my laptop is bigger. Identical crash, no symbols.


> > > Can you use 'git bisect' to track down the offending commit?
> > 
> > If I would know how to do that
> 
> 'man git bisect' should provide a tutorial on how to do this.

No, it does not.
It would have taken an enormous amount of time and GBs less if I'd found
earlier the only pointer on internet that stated:

  cd linux
  git remote add stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 
and that brought me reasonably fast to this:

  3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01 is the first bad commit
  commit 3bd3a8ca5a7b1530f463b6e1cc811c085e6ffa01
  Author: Maciej W. Rozycki <macro@orcam.me.uk>
  Date:   Thu May 13 11:51:50 2021 +0200
  ...
 
> > > And why are you stuck on 4.9.y for these machines?  Why not use 5.10 or
> > > newer?
> > 
> > Because in 4.10 they dropped lirc-serial and I need that. The new ir-serial
> > is no replacement. (The last working version of LIRC is 0.9.6. After that
> > they destroyed transmitter support.)

Correction: lirc-0.9.0-rc6 it is.

> > 
> If the new functionality is not working properly, please work with those
> developers to fix that up. 

I can't.  I can hardly write and compile 'Hello world', let alone fix some
complex fossil and abandoned software.  To make a long LIRC story short:
LIRC got orphaned long ago. A dozen patches from Gentoo kept it alive (until
kernel-3.x where f_dentry got dropped, which gentoo never fixed).  I managed
to get around that problem. By then there was a new maintainer that was not
interested in bug reports and clearly stated that he was against a transmitter
(over the serial port). The new LIRC-0.10 is not popular, to say the least.
The only route for IR blasting nowadays seems to be a RaspberryPi, where
Rasbian seems to have something like 'ir-ctl' outside of LIRC.

Regards, Wim.

