Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB5CE31DD
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439602AbfJXMKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:10:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38749 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2439599AbfJXMKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:10:06 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9OC9xGd010052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 08:10:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3FDC9420456; Thu, 24 Oct 2019 08:09:58 -0400 (EDT)
Date:   Thu, 24 Oct 2019 08:09:58 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/22] ext4: Do not iput inode under running transaction
 in ext4_mkdir()
Message-ID: <20191024120958.GC1124@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-3-jack@suse.cz>
 <20191021012105.GE6799@mit.edu>
 <20191024101906.GM31271@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024101906.GM31271@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 12:19:06PM +0200, Jan Kara wrote:
> Correct on both points. Thanks for spotting this! Now I still don't think
> that calling iput() with running transaction is good. It complicates
> matters with revoke record reservation but it is also fragile for other
> reasons - e.g. flush worker could find the allocated inode just before we
> will call iput() on it, try to write it out, block on starting transaction
> and we get a deadlock with inode_wait_for_writeback() inside evict(). Now
> inode *probably* won't be dirty yet by the time we get to ext4_add_nondir()
> or similar, that's why I say above it's just fragile, not an outright bug.

But we don't ever write the inode itself via
inode_wait_for_writeback(), because how ext4 journalling works.  (See
the comments before ext4_mark_inode_dirty()).  And for the special
inodes (directories, device nodes, etc.) there's no data dirtyness to
worry about.  For regular files, we hit this code path when have just
created the inode, but were not able to add a link to the parent
directory; the fd wasn't been released to userspace yet, so it can't
be data dirty either.

So unless I'm missing something, I don't think the deadlock described
above is possible?

We can certainly add it to the orphan list if it's necessary, but it's
extra overhead and adds a global contention point.  So if it's not
necessary, I'd rather avoid it if possible, and I think it's safe to
do so in this case.

						- Ted
