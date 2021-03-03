Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7674832BC35
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383260AbhCCNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1843033AbhCCKYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 05:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63150601FF;
        Wed,  3 Mar 2021 10:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614767038;
        bh=g13f1wNwycJzQzB482148MxXAKUri2zU2+znvRzH904=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mK8uAQYuWJevNgoGLCLA335nUMVwWOK/wmlcHdG6KcuJjhRwwYtZyZPQpuUNVltjO
         ZLMSqrkfncvAe3WcDuYZVgSbYNZ5r1iBViT9aMoiOEHGsPwiaTzNmWCABeaLmZZlzM
         /VGJFijW5wpXPzaPGsogAyGk1gxj1zlbihiSEh9Y=
Date:   Wed, 3 Mar 2021 11:23:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marco Elver <elver@google.com>
Cc:     rafael@kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] kcsan, debugfs: Move debugfs file creation out of early
 init
Message-ID: <YD9jujCYGnjwOMoP@kroah.com>
References: <20210303093845.2743309-1-elver@google.com>
 <YD9dld26cz0RWHg7@kroah.com>
 <CANpmjNMxuj23ryjDCr+ShcNy_oZ=t3MrxFa=pVBXjODBopEAnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNMxuj23ryjDCr+ShcNy_oZ=t3MrxFa=pVBXjODBopEAnw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 11:18:06AM +0100, Marco Elver wrote:
> On Wed, 3 Mar 2021 at 10:57, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 03, 2021 at 10:38:45AM +0100, Marco Elver wrote:
> > > Commit 56348560d495 ("debugfs: do not attempt to create a new file
> > > before the filesystem is initalized") forbids creating new debugfs files
> > > until debugfs is fully initialized. This breaks KCSAN's debugfs file
> > > creation, which happened at the end of __init().
> >
> > How did it "break" it?  The files shouldn't have actually been created,
> > right?
> 
> Right, with 56348560d495 the debugfs file isn't created anymore, which
> is the problem. Before 56348560d495 the file exists (syzbot wants the
> file to exist.)
> 
> > > There is no reason to create the debugfs file during early
> > > initialization. Therefore, move it into a late_initcall() callback.
> > >
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > Cc: stable <stable@vger.kernel.org>
> > > Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
> > > Signed-off-by: Marco Elver <elver@google.com>
> > > ---
> > > I've marked this for 'stable', since 56348560d495 is also intended for
> > > stable, and would subsequently break KCSAN in all stable kernels where
> > > KCSAN is available (since 5.8).
> >
> > No objection from me, just odd that this actually fixes anything :)
> 
> 56348560d495 causes the file to just not be created if we try to
> create at the end of __init(). Having it created as late as
> late_initcall() gets us the file back.
> 
> When you say "fixes anything", should the file be created even though
> it's at the end of __init()? Perhaps I misunderstood what 56348560d495
> changes, but I verified it to be the problem by reverting (upon which
> the file exists as expected).

All my change did is explicitly not allow you to create a file if
debugfs had not been initialized.  If you tried to do that before, you
should have gotten an error from the vfs layer that the file was not
created, as otherwise how would it have succeeded?

I just moved the check up higher in the "stack" to the debugfs code, and
not relied on the vfs layer to do a lot of work only to reject things
later on.

So there "should" not have been any functional change with this patch.
If there was, then something is really odd as how can the vfs layer
create a file for a filesystem _before_ that filesystem has been
registered with the vfs layer?

thanks,

greg k-h
