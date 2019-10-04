Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74EB0CC11B
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfJDQyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:54:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48544 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDQyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:54:31 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGQqa-0007fz-6E; Fri, 04 Oct 2019 16:54:28 +0000
Date:   Fri, 4 Oct 2019 17:54:28 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable@vger.kernel.org,
        Jan Glauber <jglauber@marvell.com>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>
Subject: [cifs] semantics of IPC$ shares (was Re: [PATCH] devpts: Fix NULL
 pointer dereference in dcache_readdir())
Message-ID: <20191004165428.GA28597@ZenIV.linux.org.uk>
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk>
 <20191004143301.kfzcut6a6z5owfee@wittgenstein>
 <20191004151058.GH26530@ZenIV.linux.org.uk>
 <20191004152526.adgg3a7u7jylfk4a@wittgenstein>
 <20191004160219.GI26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004160219.GI26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 05:02:20PM +0100, Al Viro wrote:

> 	* (possibly) cifs hitting the same on eviction by memory pressure alone
> (no locked inodes anywhere in sight).  Possibly == if cifs IPC$ share happens to
> show up non-empty (e.g. due to server playing silly buggers).
> 	* (possibly) cifs hitting *another* lovely issue - lookup in one subdirectory
> of IPC$ root finding an alias for another subdirectory of said root, triggering
> d_move() of dentry of the latter.  IF the name happens to be long enough to be
> externally allocated and if dcache_readdir() on root is currently copying it to
> userland, Bad Things(tm) will happen.  That one almost certainly depends upon the
> server playing silly buggers and might or might not be possible.  I'm not familiar
> enough with CIFS to tell.

BTW, I would really appreciate somebody familiar with CIFS giving a braindump on
that.  Questions:

1) What's normally (== without malicious/broken server) seen when you mount
an IPC$ share?

2) Does it ever have subdirectories (i.e. can we fail a lookup in its root if it
looks like returning a subdirectory)?

3) If it can be non-empty, is there way to ask the server about its contents?
Short of "look every possible name up", that is...

As it is, the thing is abusing either cifs_lookup() (if it really shouldn't
have any files in it) or dcache_readdir().  Sure, dcache_readdir() can (and
should) pin a dentry while copying the name to userland, but WTF kind of
semantics it is?  "ls will return the things you'd guessed to look up, until
there's enough memory pressure to have them forgotten, which can happen at
any point with no activity on server"?
