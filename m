Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4662E936C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbhADKfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:35:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:42254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhADKfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:35:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0EEEACBA;
        Mon,  4 Jan 2021 10:35:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8BB881E07F9; Mon,  4 Jan 2021 11:35:04 +0100 (CET)
Date:   Mon, 4 Jan 2021 11:35:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jinoh Kang <jinoh.kang.kr@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 bp v2] ext4: don't remount read-only with
 errors=continue on reboot
Message-ID: <20210104103504.GA4018@quack2.suse.cz>
References: <16091470451704@kroah.com>
 <5611c936-5913-d570-36a4-2b2ed209cd88@gmail.com>
 <1609147045182133@kroah.com>
 <9efcb977-b6a6-b5b4-04a7-59b376b890e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9efcb977-b6a6-b5b4-04a7-59b376b890e5@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 01-01-21 17:03:21, Jinoh Kang wrote:
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
> 
> Please disregard the previous mail, which was in a wrong thread:
> - <5611c936-5913-d570-36a4-2b2ed209cd88@gmail.com> [PATCH 5.4 bp]
> That said, the patches for 4.19 and 5.4 have the same patch ID.

The backport looks good to me. Thanks!

								Honza

> ---
>  fs/ext4/super.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 920658ca8777..06568467b0c2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -455,19 +455,17 @@ static bool system_going_down(void)
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
