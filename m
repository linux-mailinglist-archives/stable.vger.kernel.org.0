Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0114CBEAB
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 17:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389378AbfJDPLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 11:11:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46942 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389086AbfJDPLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 11:11:01 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGPEQ-0004dA-83; Fri, 04 Oct 2019 15:10:58 +0000
Date:   Fri, 4 Oct 2019 16:10:58 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable@vger.kernel.org,
        Jan Glauber <jglauber@marvell.com>
Subject: Re: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
Message-ID: <20191004151058.GH26530@ZenIV.linux.org.uk>
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk>
 <20191004143301.kfzcut6a6z5owfee@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004143301.kfzcut6a6z5owfee@wittgenstein>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 04:33:02PM +0200, Christian Brauner wrote:
> On Fri, Oct 04, 2019 at 03:27:48PM +0100, Al Viro wrote:
> > On Fri, Oct 04, 2019 at 04:05:03PM +0200, Christian Brauner wrote:
> > > From: Will Deacon <will@kernel.org>
> > > 
> > > Closing /dev/pts/ptmx removes the corresponding pty under /dev/pts/
> > > without synchronizing against concurrent path walkers. This can lead to
> > > 'dcache_readdir()' tripping over a 'struct dentry' with a NULL 'd_inode'
> > > field:
> > 
> > FWIW, vfs.git#fixes (or #next.dcache) ought to deal with that one.
> 
> Is it feasible to backport your changes? Or do we want to merge the one
> here first and backport?

I'm not sure.  The whole pile is backportable, all right (and the first commit
alone should take care of devpts problem).  However, there's a performance
regression on some loads; it *is* possible to get the thing reasonably lockless
without fucking it up (as the original conversion had been).  Still not
in the series, since cifs (ab)use of dcache_readdir() needs to be clarified
to figure out the right way to do it.  Asked CIFS folks, got no reaction
whatsoever, will ask again...

	Al, mostly back after flu, digging through the piles of mail
