Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1CB2E9371
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbhADKgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:36:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:42320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbhADKgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:36:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A1FAACAF;
        Mon,  4 Jan 2021 10:35:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5A2FC1E07F9; Mon,  4 Jan 2021 11:35:26 +0100 (CET)
Date:   Mon, 4 Jan 2021 11:35:26 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jinoh Kang <jinoh.kang.kr@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 bp v2] ext4: don't remount read-only with
 errors=continue on reboot
Message-ID: <20210104103526.GB4018@quack2.suse.cz>
References: <16091470451704@kroah.com>
 <2c1466be-7b5d-1e50-bcc2-3bcb9478fba2@gmail.com>
 <7ac5f2f0-e545-e0b7-4f71-1cb1c383e472@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac5f2f0-e545-e0b7-4f71-1cb1c383e472@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 01-01-21 16:40:58, Jinoh Kang wrote:
> From: Jan Kara <jack@suse.cz>
> 
> commit b08070eca9e247f60ab39d79b2c25d274750441f upstream.
> 
> ext4_handle_error() with errors=continue mount option can accidentally
> remount the filesystem read-only when the system is rebooting. Fix that.
> 
> Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Cc: stable@kernel.org
> Link: https://lore.kernel.org/r/20201127113405.26867-2-jack@suse.cz
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> [jinoh: backport accounting for missing
>   commit 9b5f6c9b83d9 ("ext4: make s_mount_flags modifications atomic")]
> Signed-off-by: Jinoh Kang <jinoh.kang.kr@gmail.com>
> ---
> v1 --> v2: added missing comment and signoff
> Apologies for wasted traffic...

The backport looks good to me.

								Honza

> ---
>  fs/ext4/super.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ee96f504ed78..e9e9f09f5370 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -454,19 +454,17 @@ static bool system_going_down(void)
>  
>  static void ext4_handle_error(struct super_block *sb)
>  {
> +	journal_t *journal = EXT4_SB(sb)->s_journal;
> +
>  	if (test_opt(sb, WARN_ON_ERROR))
>  		WARN_ON_ONCE(1);
>  
> -	if (sb_rdonly(sb))
> +	if (sb_rdonly(sb) || test_opt(sb, ERRORS_CONT))
>  		return;
>  
> -	if (!test_opt(sb, ERRORS_CONT)) {
> -		journal_t *journal = EXT4_SB(sb)->s_journal;
> -
> -		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
> -		if (journal)
> -			jbd2_journal_abort(journal, -EIO);
> -	}
> +	EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
> +	if (journal)
> +		jbd2_journal_abort(journal, -EIO);
>  	/*
>  	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
>  	 * could panic during 'reboot -f' as the underlying device got already
> -- 
> 2.26.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
