Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5113C1923
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhGHS0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHS0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F8C761629;
        Thu,  8 Jul 2021 18:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768605;
        bh=F+pkmPFwzpvSHwGf0uB7PeziFTcjlyKk7winzMjkIyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDrPQxcWe+zqA7gtc9KL0y4o+kw0utZ0+34jIcwesHzu3Snmx9KcFDeOxa4aP9wsz
         vAws4msbF7H3SShHaB8RmYLaoCE8RBWSON5/eQz1NjLzGKUb1NeFgxKtwnTIC2mpmC
         3AlAMODGP0N4uvrNUXT6W3YF4sQpJJDgJYUXUGL0=
Date:   Thu, 8 Jul 2021 20:23:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] kthread_worker: Fix race between
 kthread_mod_delayed_work()
Message-ID: <YOdCmjX5Gm3IgP1H@kroah.com>
References: <162480383515619@kroah.com>
 <20210630110149.25086-1-pmladek@suse.com>
 <YNxQPzcr7FaMERZd@kroah.com>
 <YNxWIb1GBU0hOE8B@alley>
 <YOKwgmjdIF0Eunaq@kroah.com>
 <YOWIIok+uvE+/xt6@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOWIIok+uvE+/xt6@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 12:55:30PM +0200, Petr Mladek wrote:
> On Mon 2021-07-05 09:10:58, Greg KH wrote:
> > On Wed, Jun 30, 2021 at 01:31:45PM +0200, Petr Mladek wrote:
> > > On Wed 2021-06-30 13:06:39, Greg KH wrote:
> > > > On Wed, Jun 30, 2021 at 01:01:47PM +0200, Petr Mladek wrote:
> > > > > This is backport of the series for the following stable trees:
> > > > > 
> > > > >    + 4.9
> > > > >    + 4.14
> > > > >    + 4.19
> > > > > 
> > > > > The orignal series did not apply because of a conflict with the commit
> > > > > ("kthread: Convert worker lock to raw spinlock").
> > > > > 
> > > > > Petr Mladek (2):
> > > > >   kthread_worker: split code for canceling the delayed work timer
> > > > >   kthread: prevent deadlock when kthread_mod_delayed_work() races with
> > > > >     kthread_cancel_delayed_work_sync()
> > > > > 
> > > > >  kernel/kthread.c | 77 ++++++++++++++++++++++++++++++++----------------
> > > > >  1 file changed, 51 insertions(+), 26 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.26.2
> > > > > 
> > > > 
> > > > What is the original git commit ids of these patches in Linus's tree?
> > > 
> > > commit 34b3d5344719d14fd2185b2d9459b3abcb8cf9d8 ("kthread_worker: split code for canceling the delayed work timer")
> > > commit 5fa54346caf67b4b1b10b1f390316ae466da4d53 ("kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync())"
> > > 
> > > The original commits have already been taken for the newer stable trees.
> > > 
> > > I am sorry for the inconvenience.
> > 
> > What about backports for 5.4, 5.10, and 5.12?  We can not take patches
> > only for older kernels, otherwise people upgrading to newer ones would
> > have a regression.  Please can you submit these patches for those trees
> > too?  Until that, I can not take these.
> 
> The patches for 5.4, 5.10, and 5.12 did not need any changes. My
> understanding is that the original commits have already been queued
> for these never code trees. See the mail in stable-commits:
> 
> for 5.4:
> 
> https://www.spinics.net/lists/stable-commits/msg203482.html
> https://www.spinics.net/lists/stable-commits/msg203481.html
> 
> for 5.10:
> 
> https://www.spinics.net/lists/stable-commits/msg203486.html
> https://www.spinics.net/lists/stable-commits/msg203485.html
> 
> for 5.12:
> 
> https://www.spinics.net/lists/stable-commits/msg203494.html
> https://www.spinics.net/lists/stable-commits/msg203493.html
> 
> I am sorry, I should have mentioned this in the cover letter.

No worries, all now queued up, thanks.

greg k-h
