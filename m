Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83C53BE6B7
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhGGK6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 06:58:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51884 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhGGK6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 06:58:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 28E1C2203E;
        Wed,  7 Jul 2021 10:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625655331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dFk9WWUY0k/N1hD9DATQGxyyNt/P111NDg4+WjkF+9k=;
        b=XtyWZykU0Ogynlim5SWd1Py4ae5NBYtRVZ4RscyUlMYlUJ/jog2wt1JqOSqExgdQ26ILw/
        b5QGmznHxi3tFRMQjzXqSg21r0AVGnK7EprdC38vhXtxSF5BGH3YfDM7BphdkHTkipEUx8
        gYzyaPJs/kG19pOHegLeJmuAJD+vo2M=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 04DF3A3BA9;
        Wed,  7 Jul 2021 10:55:30 +0000 (UTC)
Date:   Wed, 7 Jul 2021 12:55:30 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] kthread_worker: Fix race between
 kthread_mod_delayed_work()
Message-ID: <YOWIIok+uvE+/xt6@alley>
References: <162480383515619@kroah.com>
 <20210630110149.25086-1-pmladek@suse.com>
 <YNxQPzcr7FaMERZd@kroah.com>
 <YNxWIb1GBU0hOE8B@alley>
 <YOKwgmjdIF0Eunaq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOKwgmjdIF0Eunaq@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 2021-07-05 09:10:58, Greg KH wrote:
> On Wed, Jun 30, 2021 at 01:31:45PM +0200, Petr Mladek wrote:
> > On Wed 2021-06-30 13:06:39, Greg KH wrote:
> > > On Wed, Jun 30, 2021 at 01:01:47PM +0200, Petr Mladek wrote:
> > > > This is backport of the series for the following stable trees:
> > > > 
> > > >    + 4.9
> > > >    + 4.14
> > > >    + 4.19
> > > > 
> > > > The orignal series did not apply because of a conflict with the commit
> > > > ("kthread: Convert worker lock to raw spinlock").
> > > > 
> > > > Petr Mladek (2):
> > > >   kthread_worker: split code for canceling the delayed work timer
> > > >   kthread: prevent deadlock when kthread_mod_delayed_work() races with
> > > >     kthread_cancel_delayed_work_sync()
> > > > 
> > > >  kernel/kthread.c | 77 ++++++++++++++++++++++++++++++++----------------
> > > >  1 file changed, 51 insertions(+), 26 deletions(-)
> > > > 
> > > > -- 
> > > > 2.26.2
> > > > 
> > > 
> > > What is the original git commit ids of these patches in Linus's tree?
> > 
> > commit 34b3d5344719d14fd2185b2d9459b3abcb8cf9d8 ("kthread_worker: split code for canceling the delayed work timer")
> > commit 5fa54346caf67b4b1b10b1f390316ae466da4d53 ("kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync())"
> > 
> > The original commits have already been taken for the newer stable trees.
> > 
> > I am sorry for the inconvenience.
> 
> What about backports for 5.4, 5.10, and 5.12?  We can not take patches
> only for older kernels, otherwise people upgrading to newer ones would
> have a regression.  Please can you submit these patches for those trees
> too?  Until that, I can not take these.

The patches for 5.4, 5.10, and 5.12 did not need any changes. My
understanding is that the original commits have already been queued
for these never code trees. See the mail in stable-commits:

for 5.4:

https://www.spinics.net/lists/stable-commits/msg203482.html
https://www.spinics.net/lists/stable-commits/msg203481.html

for 5.10:

https://www.spinics.net/lists/stable-commits/msg203486.html
https://www.spinics.net/lists/stable-commits/msg203485.html

for 5.12:

https://www.spinics.net/lists/stable-commits/msg203494.html
https://www.spinics.net/lists/stable-commits/msg203493.html

I am sorry, I should have mentioned this in the cover letter.

Best Regards,
Petr
