Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D216C2B86B6
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 22:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgKRVee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 16:34:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:52676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgKRVea (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 16:34:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7321BB01E;
        Wed, 18 Nov 2020 21:34:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D8FEB1E1334; Wed, 18 Nov 2020 15:58:38 +0100 (CET)
Date:   Wed, 18 Nov 2020 15:58:38 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checksum errors with indexed dirs
Message-ID: <20201118145838.GP1981@quack2.suse.cz>
References: <20200205173025.12221-1-jack@suse.cz>
 <X7NRcBMnsR3w1K7X@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7NRcBMnsR3w1K7X@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric!

On Mon 16-11-20 20:28:32, Eric Biggers wrote:
> On Wed, Feb 05, 2020 at 06:30:25PM +0100, Jan Kara wrote:
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
> > 
> > 1) We just disallow loading and directory inodes with EXT4_INDEX_FL when
> > DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> > means someone disabled DIR_INDEX on existing filesystem and didn't run
> > e2fsck), e2fsck can fix the problem, and we don't want to answer the
> > difficult question: "Should we rather corrupt the directory more or
> > should we ignore that DIR_INDEX feature is not set?"
> > 
> > 2) When we find out htree structure is corrupted (but the filesystem and
> > the directory should in support htrees), we continue just ignoring htree
> > information for reading but we refuse to add new entries to the
> > directory to avoid corrupting it more.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/dir.c   | 14 ++++++++------
> >  fs/ext4/ext4.h  |  5 ++++-
> >  fs/ext4/inode.c | 13 +++++++++++++
> >  fs/ext4/namei.c |  7 +++++++
> >  4 files changed, 32 insertions(+), 7 deletions(-)

...

> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index f8578caba40d..1fd6c1e2ce2a 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2482,8 +2482,11 @@ void ext4_insert_dentry(struct inode *inode,
> >  			struct ext4_filename *fname);
> >  static inline void ext4_update_dx_flag(struct inode *inode)
> >  {
> > -	if (!ext4_has_feature_dir_index(inode->i_sb))
> > +	if (!ext4_has_feature_dir_index(inode->i_sb)) {
> > +		/* ext4_iget() should have caught this... */
> > +		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
> >  		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
> > +	}
> >  }
> 
> This new WARN_ON_ONCE() gets triggered by the following commands:
> 
> 	mkfs.ext4 -O ^dir_index /dev/vdc
> 	mount /dev/vdc /vdc
> 	mkdir /vdc/dir
> 
> WARNING: CPU: 1 PID: 305 at fs/ext4/ext4.h:2700 add_dirent_to_buf+0x1d0/0x1e0 fs/ext4/namei.c:2039
> CPU: 1 PID: 305 Comm: mkdir Not tainted 5.10.0-rc4 #14
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
> RIP: 0010:ext4_update_dx_flag fs/ext4/ext4.h:2700 [inline]
> RIP: 0010:add_dirent_to_buf+0x1d0/0x1e0 fs/ext4/namei.c:2038
> [...]
> Call Trace:
>  ext4_add_entry+0x179/0x4d0 fs/ext4/namei.c:2248
>  ext4_mkdir+0x1c0/0x320 fs/ext4/namei.c:2814
>  vfs_mkdir+0xcc/0x130 fs/namei.c:3650
>  do_mkdirat+0x81/0x120 fs/namei.c:3673
>  __do_sys_mkdir fs/namei.c:3689 [inline]
> 
> What is intended here?  metadata_csum && ^dir_index is a weird combination,
> but it's technically valid, right?

Indeed the WARN_ON_ONCE() is wrong. It should also check that
EXT4_INODE_INDEX is set. The idea of the warning is that when we just clear
EXT4_INODE_INDEX flag, checksums will become invalid so generally that's
not desirable... I'll send a fix. Thanks for report!

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
