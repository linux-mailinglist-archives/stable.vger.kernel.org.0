Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A7E2EA9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407521AbfJXKTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 06:19:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:34332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407344AbfJXKTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 06:19:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E22A5B507;
        Thu, 24 Oct 2019 10:19:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 768411E4AA6; Thu, 24 Oct 2019 12:19:06 +0200 (CEST)
Date:   Thu, 24 Oct 2019 12:19:06 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/22] ext4: Do not iput inode under running transaction
 in ext4_mkdir()
Message-ID: <20191024101906.GM31271@quack2.suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-3-jack@suse.cz>
 <20191021012105.GE6799@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021012105.GE6799@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 20-10-19 21:21:05, Theodore Y. Ts'o wrote:
> On Fri, Oct 04, 2019 at 12:05:49AM +0200, Jan Kara wrote:
> > When ext4_mkdir() fails to add entry into directory, it ends up dropping
> > freshly created inode under the running transaction and thus inode
> > truncation happens under that transaction. That breaks assumptions that
> > ext4_evict_inode() does not get called from a transaction context
> > (although I'm not aware of any real issue) and is completely
> > unnecessary. Just stop the transaction before dropping inode reference.
> > 
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> If we call ext4_journal_stop(handle) before calling iput(inode),
> there's a chance that we could crash with the inode with i_link_counts
> == 0, but we won't have yet call ext4_evict_inode() to mark the inode
> as free in the inode bitmap.  This would result in a inode leak.
> 
> Also, this isn't the only place where we can enter ext4_evict_inode()
> with an active handle; the same situation arise in ext4_add_nondir(),
> and for the same reason.
> 
> So I think the code is right as is.  Do you agree?

Correct on both points. Thanks for spotting this! Now I still don't think
that calling iput() with running transaction is good. It complicates
matters with revoke record reservation but it is also fragile for other
reasons - e.g. flush worker could find the allocated inode just before we
will call iput() on it, try to write it out, block on starting transaction
and we get a deadlock with inode_wait_for_writeback() inside evict(). Now
inode *probably* won't be dirty yet by the time we get to ext4_add_nondir()
or similar, that's why I say above it's just fragile, not an outright bug.

So I'd still prefer to do the iput() outside of transaction and we can
protect from leaking the inode in case of crash by adding it to orphan
list. I'll update the patch. Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
