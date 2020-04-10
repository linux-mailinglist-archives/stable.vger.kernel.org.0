Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1730B1A47C3
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDJPMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 11:12:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:58340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgDJPMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 11:12:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3876AE70;
        Fri, 10 Apr 2020 15:12:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 447C01E1246; Fri, 10 Apr 2020 17:12:42 +0200 (CEST)
Date:   Fri, 10 Apr 2020 17:12:42 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Do not zeroout extents beyond i_disksize
Message-ID: <20200410151242.GA3922@quack2.suse.cz>
References: <20200331105016.8674-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331105016.8674-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 31-03-20 12:50:16, Jan Kara wrote:
> We do not want to create initialized extents beyond end of file because
> for e2fsck it is impossible to distinguish them from a case of corrupted
> file size / extent tree and so it complains like:
> 
> Inode 12, i_size is 147456, should be 163840.  Fix? no
> 
> Code in ext4_ext_convert_to_initialized() and
> ext4_split_convert_extents() try to make sure it does not create
> initialized extents beyond inode size however they check against
> inode->i_size which is wrong. They should instead check against
> EXT4_I(inode)->i_disksize which is the current inode size on disk.
> That's what e2fsck is going to see in case of crash before all dirty
> data is written. This bug manifests as generic/456 test failure (with
> recent enough fstests where fsx got fixed to properly pass
> FALLOC_KEEP_SIZE_FL flags to the kernel) when run with dioread_lock
> mount option.
> 
> CC: stable@vger.kernel.org
> Fixes: 21ca087a3891 ("ext4: Do not zero out uninitialized extents beyond i_size")
> Signed-off-by: Jan Kara <jack@suse.cz>

Ping Ted? Did this patch get lost?

								Honza

> ---
>  fs/ext4/extents.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 954013d6076b..c5e190fd4589 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3532,8 +3532,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		(unsigned long long)map->m_lblk, map_len);
>  
>  	sbi = EXT4_SB(inode->i_sb);
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> +	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
> +			>> inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map_len)
>  		eof_block = map->m_lblk + map_len;
>  
> @@ -3785,8 +3785,8 @@ static int ext4_split_convert_extents(handle_t *handle,
>  		  __func__, inode->i_ino,
>  		  (unsigned long long)map->m_lblk, map->m_len);
>  
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> +	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
> +			>> inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map->m_len)
>  		eof_block = map->m_lblk + map->m_len;
>  	/*
> -- 
> 2.16.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
