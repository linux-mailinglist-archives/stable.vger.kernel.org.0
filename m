Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081412B58CE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 05:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgKQE2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 23:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgKQE2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 23:28:35 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265382463D;
        Tue, 17 Nov 2020 04:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605587314;
        bh=9y0exohYjyxk5jiJ93JicBe//G14qZJKLu96RNf8udc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5xJI1ZFG6t/NOXZAOAJ2NvidPqX9aLMxtmiiv5K5A4dLKCncWhATDIFCQTEE43Cr
         qq9uouK7HlGbqzAUCo2eYF65fAG2KPt4xmDUTEtOTfy5sZIp6x9zddPt3RwtieD97q
         mpj3xzC4hzTf5vIklPjkITGA8jCY7513Xe5rgJKc=
Date:   Mon, 16 Nov 2020 20:28:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checksum errors with indexed dirs
Message-ID: <X7NRcBMnsR3w1K7X@sol.localdomain>
References: <20200205173025.12221-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205173025.12221-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

On Wed, Feb 05, 2020 at 06:30:25PM +0100, Jan Kara wrote:
> DIR_INDEX has been introduced as a compat ext4 feature. That means that
> even kernels / tools that don't understand the feature may modify the
> filesystem. This works because for kernels not understanding indexed dir
> format, internal htree nodes appear just as empty directory entries.
> Index dir aware kernels then check the htree structure is still
> consistent before using the data. This all worked reasonably well until
> metadata checksums were introduced. The problem is that these
> effectively made DIR_INDEX only ro-compatible because internal htree
> nodes store checksums in a different place than normal directory blocks.
> Thus any modification ignorant to DIR_INDEX (or just clearing
> EXT4_INDEX_FL from the inode) will effectively cause checksum mismatch
> and trigger kernel errors. So we have to be more careful when dealing
> with indexed directories on filesystems with checksumming enabled.
> 
> 1) We just disallow loading and directory inodes with EXT4_INDEX_FL when
> DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> means someone disabled DIR_INDEX on existing filesystem and didn't run
> e2fsck), e2fsck can fix the problem, and we don't want to answer the
> difficult question: "Should we rather corrupt the directory more or
> should we ignore that DIR_INDEX feature is not set?"
> 
> 2) When we find out htree structure is corrupted (but the filesystem and
> the directory should in support htrees), we continue just ignoring htree
> information for reading but we refuse to add new entries to the
> directory to avoid corrupting it more.
> 
> CC: stable@vger.kernel.org
> Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/dir.c   | 14 ++++++++------
>  fs/ext4/ext4.h  |  5 ++++-
>  fs/ext4/inode.c | 13 +++++++++++++
>  fs/ext4/namei.c |  7 +++++++
>  4 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 9f00fc0bf21d..cb9ea593b544 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -129,12 +129,14 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  		if (err != ERR_BAD_DX_DIR) {
>  			return err;
>  		}
> -		/*
> -		 * We don't set the inode dirty flag since it's not
> -		 * critical that it get flushed back to the disk.
> -		 */
> -		ext4_clear_inode_flag(file_inode(file),
> -				      EXT4_INODE_INDEX);
> +		/* Can we just clear INDEX flag to ignore htree information? */
> +		if (!ext4_has_metadata_csum(sb)) {
> +			/*
> +			 * We don't set the inode dirty flag since it's not
> +			 * critical that it gets flushed back to the disk.
> +			 */
> +			ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
> +		}
>  	}
>  
>  	if (ext4_has_inline_data(inode)) {
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f8578caba40d..1fd6c1e2ce2a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2482,8 +2482,11 @@ void ext4_insert_dentry(struct inode *inode,
>  			struct ext4_filename *fname);
>  static inline void ext4_update_dx_flag(struct inode *inode)
>  {
> -	if (!ext4_has_feature_dir_index(inode->i_sb))
> +	if (!ext4_has_feature_dir_index(inode->i_sb)) {
> +		/* ext4_iget() should have caught this... */
> +		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
>  		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
> +	}
>  }

This new WARN_ON_ONCE() gets triggered by the following commands:

	mkfs.ext4 -O ^dir_index /dev/vdc
	mount /dev/vdc /vdc
	mkdir /vdc/dir

WARNING: CPU: 1 PID: 305 at fs/ext4/ext4.h:2700 add_dirent_to_buf+0x1d0/0x1e0 fs/ext4/namei.c:2039
CPU: 1 PID: 305 Comm: mkdir Not tainted 5.10.0-rc4 #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
RIP: 0010:ext4_update_dx_flag fs/ext4/ext4.h:2700 [inline]
RIP: 0010:add_dirent_to_buf+0x1d0/0x1e0 fs/ext4/namei.c:2038
[...]
Call Trace:
 ext4_add_entry+0x179/0x4d0 fs/ext4/namei.c:2248
 ext4_mkdir+0x1c0/0x320 fs/ext4/namei.c:2814
 vfs_mkdir+0xcc/0x130 fs/namei.c:3650
 do_mkdirat+0x81/0x120 fs/namei.c:3673
 __do_sys_mkdir fs/namei.c:3689 [inline]


What is intended here?  metadata_csum && ^dir_index is a weird combination,
but it's technically valid, right?

- Eric
