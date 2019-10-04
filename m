Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD02CBF17
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbfJDPZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 11:25:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51775 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389210AbfJDPZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 11:25:31 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iGPSS-0001UA-OK; Fri, 04 Oct 2019 15:25:28 +0000
Date:   Fri, 4 Oct 2019 17:25:28 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable@vger.kernel.org,
        Jan Glauber <jglauber@marvell.com>
Subject: Re: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
Message-ID: <20191004152526.adgg3a7u7jylfk4a@wittgenstein>
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk>
 <20191004143301.kfzcut6a6z5owfee@wittgenstein>
 <20191004151058.GH26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191004151058.GH26530@ZenIV.linux.org.uk>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 04:10:58PM +0100, Al Viro wrote:
> On Fri, Oct 04, 2019 at 04:33:02PM +0200, Christian Brauner wrote:
> > On Fri, Oct 04, 2019 at 03:27:48PM +0100, Al Viro wrote:
> > > On Fri, Oct 04, 2019 at 04:05:03PM +0200, Christian Brauner wrote:
> > > > From: Will Deacon <will@kernel.org>
> > > > 
> > > > Closing /dev/pts/ptmx removes the corresponding pty under /dev/pts/
> > > > without synchronizing against concurrent path walkers. This can lead to
> > > > 'dcache_readdir()' tripping over a 'struct dentry' with a NULL 'd_inode'
> > > > field:
> > > 
> > > FWIW, vfs.git#fixes (or #next.dcache) ought to deal with that one.
> > 
> > Is it feasible to backport your changes? Or do we want to merge the one
> > here first and backport?
> 
> I'm not sure.  The whole pile is backportable, all right (and the first commit

Ok. So here's what I propose: we'll merge this one as it seems an
obvious fix to the problem and can easily be backported to stable
kernels.
Then you'll land your generic workaround alleviating callers from
holding inode_lock(). Then I'll send a patch to remove the inode_lock()
from devpts for master.
If we see that your fix is fine to backport and has no performance
impacts that you find unacceptable we backport it.

> alone should take care of devpts problem).  However, there's a performance
> regression on some loads; it *is* possible to get the thing reasonably lockless
> without fucking it up (as the original conversion had been).  Still not
> in the series, since cifs (ab)use of dcache_readdir() needs to be clarified
> to figure out the right way to do it.  Asked CIFS folks, got no reaction
> whatsoever, will ask again...
> 
> 	Al, mostly back after flu, digging through the piles of mail

Ugh, flu season...

Christian
