Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9381153F62
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBFHtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:49:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:52390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbgBFHtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 02:49:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 837C9AF93;
        Thu,  6 Feb 2020 07:49:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0985F1E0E31; Thu,  6 Feb 2020 08:49:44 +0100 (CET)
Date:   Thu, 6 Feb 2020 08:49:44 +0100
From:   Jan Kara <jack@suse.cz>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checksum errors with indexed dirs
Message-ID: <20200206074944.GA14001@quack2.suse.cz>
References: <20200205173025.12221-1-jack@suse.cz>
 <BC1AA070-8C16-4399-B4D8-1E9F24D05D8D@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC1AA070-8C16-4399-B4D8-1E9F24D05D8D@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 05-02-20 11:04:23, Andreas Dilger wrote:
> On Feb 5, 2020, at 10:30 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > DIR_INDEX has been introduced as a compat ext4 feature. That means that
> > even kernels / tools that don't understand the feature may modify the
> > filesystem. This works because for kernels not understanding indexed dir
> > format, internal htree nodes appear just as empty directory entries.
> > Index dir aware kernels then check the htree structure is still
> > consistent before using the data. This all worked reasonably well until
> > metadata checksums were introduced. The problem is that these
> > effectively made DIR_INDEX only ro-compatible because internal htree
> > nodes store checksums in a different place than normal directory blocks.
> > Thus any modification ignorant to DIR_INDEX (or just clearing
> > EXT4_INDEX_FL from the inode) will effectively cause checksum mismatch
> > and trigger kernel errors. So we have to be more careful when dealing
> > with indexed directories on filesystems with checksumming enabled.
> 
> > 1) We just disallow loading and directory inodes with EXT4_INDEX_FL when
> 
> s/and/any/ ?

Yes, will fix.

> > DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> > means someone disabled DIR_INDEX on existing filesystem and didn't run
> > e2fsck), e2fsck can fix the problem, and we don't want to answer the
> > difficult question: "Should we rather corrupt the directory more or
> > should we ignore that DIR_INDEX feature is not set?"
> 
> Wouldn't it be better to continue allowing the directory to be read, but
> not modified?  Otherwise, essentially, metadata_csum is making the
> filesystem _less_ robust rather than making it more robust.  We don't
> _need_ the htree index to do a lookup in the directory.

Hum, I was somewhat afraid it may be a bit fragile but thinking about it
now, there aren't that many places that need to check. OK, I will try to do
this and see how it looks.

> > 2) When we find out htree structure is corrupted (but the filesystem and
> > the directory should in support htrees), we continue just ignoring htree
> > information for reading but we refuse to add new entries to the
> > directory to avoid corrupting it more.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/ext4/dir.c   | 14 ++++++++------
> > fs/ext4/ext4.h  |  5 ++++-
> > fs/ext4/inode.c | 13 +++++++++++++
> > fs/ext4/namei.c |  7 +++++++
> > 4 files changed, 32 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 629a25d999f0..d33135308c1b 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4615,6 +4615,19 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
> > 		ret = -EFSCORRUPTED;
> > 		goto bad_inode;
> > 	}
> > +	/*
> > +	 * If dir_index is not enabled but there's dir with INDEX flag set,
> > +	 * we'd normally treat htree data as empty space. But with metadata
> > +	 * checksumming that corrupts checksums so forbid that.
> > +	 */
> > +	if (!ext4_has_feature_dir_index(sb) && ext4_has_metadata_csum(sb) &&
> > +	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
> > +		ext4_error_inode(inode, function, line, 0,
> > +				 "iget: Dir with htree data on filesystem "
> > +				 "without dir_index feature.");
> 
> Kernel style suggests error strings should not be line wrapped at 80 columns.

OK. Will change. Thanks for review!

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
