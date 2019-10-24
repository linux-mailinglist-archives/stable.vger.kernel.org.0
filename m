Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205E5E3464
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388595AbfJXNhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:37:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:46338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733296AbfJXNhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 09:37:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF447BCF6;
        Thu, 24 Oct 2019 13:37:01 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4AB1A1E155F; Thu, 24 Oct 2019 15:37:01 +0200 (CEST)
Date:   Thu, 24 Oct 2019 15:37:01 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/22] ext4: Do not iput inode under running transaction
 in ext4_mkdir()
Message-ID: <20191024133701.GP31271@quack2.suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-3-jack@suse.cz>
 <20191021012105.GE6799@mit.edu>
 <20191024101906.GM31271@quack2.suse.cz>
 <20191024120958.GC1124@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024120958.GC1124@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 24-10-19 08:09:58, Theodore Y. Ts'o wrote:
> On Thu, Oct 24, 2019 at 12:19:06PM +0200, Jan Kara wrote:
> > Correct on both points. Thanks for spotting this! Now I still don't think
> > that calling iput() with running transaction is good. It complicates
> > matters with revoke record reservation but it is also fragile for other
> > reasons - e.g. flush worker could find the allocated inode just before we
> > will call iput() on it, try to write it out, block on starting transaction
> > and we get a deadlock with inode_wait_for_writeback() inside evict(). Now
> > inode *probably* won't be dirty yet by the time we get to ext4_add_nondir()
> > or similar, that's why I say above it's just fragile, not an outright bug.
> 
> But we don't ever write the inode itself via
> inode_wait_for_writeback(), because how ext4 journalling works.  (See
> the comments before ext4_mark_inode_dirty()).  And for the special
> inodes (directories, device nodes, etc.) there's no data dirtyness to
> worry about.  For regular files, we hit this code path when have just
> created the inode, but were not able to add a link to the parent
> directory; the fd wasn't been released to userspace yet, so it can't
> be data dirty either.
> 
> So unless I'm missing something, I don't think the deadlock described
> above is possible?

Actually, now that I look at it, large symlinks may be prone to this
deadlock. There we create unlinked inode, add it to orphan list, stop
transaction, call __page_symlink() which will dirty the inode through
mark_inode_dirty(), then we start transaction and call ext4_add_nondir()
which may call iput() while the transaction is started.

Granted we can fix just ext4_symlink() but it kind of demonstrates my point
that calling iput() under transaction is fragile - some of the stuff done
on last iput generaly ranks above transaction start, just in cases we clean
up failed create none of them happens to block currently (except for the
symlink case mentioned above). And also lockdep does not track dependencies
like inode_wait_for_writeback() as otherwise it would complain as well.

> We can certainly add it to the orphan list if it's necessary, but it's
> extra overhead and adds a global contention point.  So if it's not
> necessary, I'd rather avoid it if possible, and I think it's safe to
> do so in this case.

As this is error cleanup path (only EIO and ENOSPC are realistic failure
cases AFAICT) I don't think performance really matters here. I certainly
don't want to add inode to orphan list in the fast path. I agree that would
be non-starter. I'll try to write a patch and we'll see how bad it will be.
If you still hate it, I can have a look into how bad it would be to fix
ext4_symlink() and somehow deal with revoke reservation issues.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
