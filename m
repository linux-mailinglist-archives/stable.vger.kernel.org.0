Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A426C66FB
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 12:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjCWLoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 07:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCWLoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 07:44:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C9615881;
        Thu, 23 Mar 2023 04:44:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 76AD3339C9;
        Thu, 23 Mar 2023 11:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679571848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02wHikqJQjlQXDxF4J81KE4SFli5AhbVDrvqB/d55To=;
        b=eCCG0uhqFbuznYxi3bOPXwK2H6eAior6LfRZbZLZA4znSHPJcoC6dqHyM/jarktXKPLiHV
        8N7WMf+yZ/Kq7VSryJQlMsi+pFET/6RBWdGiIQwJaPy4F/1uWG4fqfWi1JAZVp+s5xrKta
        YBXwzQekR8I2Ca1tLbfiUZePMMXUjz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679571848;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02wHikqJQjlQXDxF4J81KE4SFli5AhbVDrvqB/d55To=;
        b=PKlN7ad4ktsCSEoI6PlUkec6xcQY5gHH1Pb45eT5ZsO2Y081n1thQtThO0PGEwe3W6ZIwa
        uDoQY+iuZhyVrvDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 674A5132C2;
        Thu, 23 Mar 2023 11:44:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xN0mGYg7HGRjGwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 23 Mar 2023 11:44:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DC7BFA071C; Thu, 23 Mar 2023 12:44:07 +0100 (CET)
Date:   Thu, 23 Mar 2023 12:44:07 +0100
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, ritesh.list@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ext4: fix race between writepages and remount
Message-ID: <20230323114407.xenntblzv4ewfqkk@quack3>
References: <20230316112832.2711783-1-libaokun1@huawei.com>
 <20230316112832.2711783-4-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316112832.2711783-4-libaokun1@huawei.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 16-03-23 19:28:32, Baokun Li wrote:
> We got a WARNING in ext4_add_complete_io:
> ==================================================================
>  WARNING: at fs/ext4/page-io.c:231 ext4_put_io_end_defer+0x182/0x250
>  CPU: 10 PID: 77 Comm: ksoftirqd/10 Tainted: 6.3.0-rc2 #85
>  RIP: 0010:ext4_put_io_end_defer+0x182/0x250 [ext4]
>  [...]
>  Call Trace:
>   <TASK>
>   ext4_end_bio+0xa8/0x240 [ext4]
>   bio_endio+0x195/0x310
>   blk_update_request+0x184/0x770
>   scsi_end_request+0x2f/0x240
>   scsi_io_completion+0x75/0x450
>   scsi_finish_command+0xef/0x160
>   scsi_complete+0xa3/0x180
>   blk_complete_reqs+0x60/0x80
>   blk_done_softirq+0x25/0x40
>   __do_softirq+0x119/0x4c8
>   run_ksoftirqd+0x42/0x70
>   smpboot_thread_fn+0x136/0x3c0
>   kthread+0x140/0x1a0
>   ret_from_fork+0x2c/0x50
> ==================================================================
> 
> Above issue may happen as follows:
>            cpu1                           cpu2
> ______________________________|_____________________________
> mount -o dioread_lock
> ext4_writepages
>  ext4_do_writepages
>   *if (ext4_should_dioread_nolock(inode))*
>     // rsv_blocks is not assigned here
>                                  mount -o remount,dioread_nolock
>   ext4_journal_start_with_reserve
>    __ext4_journal_start
>     __ext4_journal_start_sb
>      jbd2__journal_start
>       *if (rsv_blocks)*
>         // h_rsv_handle is not initialized here
>   mpage_map_and_submit_extent
>     mpage_map_one_extent
>       dioread_nolock = ext4_should_dioread_nolock(inode)
>       if (dioread_nolock && (map->m_flags & EXT4_MAP_UNWRITTEN))
>         mpd->io_submit.io_end->handle = handle->h_rsv_handle
>         ext4_set_io_unwritten_flag
>           io_end->flag |= EXT4_IO_END_UNWRITTEN
>       // now io_end->handle is NULL but has EXT4_IO_END_UNWRITTEN flag
> 
> scsi_finish_command
>  scsi_io_completion
>   scsi_io_completion_action
>    scsi_end_request
>     blk_update_request
>      req_bio_endio
>       bio_endio
>        bio->bi_end_io  > ext4_end_bio
>         ext4_put_io_end_defer
> 	 ext4_add_complete_io
> 	  // trigger WARN_ON(!io_end->handle && sbi->s_journal);
> 
> The immediate cause of this problem is that ext4_should_dioread_nolock()
> function returns inconsistent values in the ext4_do_writepages() and
> mpage_map_one_extent(). There are four conditions in this function that
> can be changed at mount time to cause this problem. These four conditions
> can be divided into two categories:
>     (1) journal_data and EXT4_EXTENTS_FL, which can be changed by ioctl
>     (2) DELALLOC and DIOREAD_NOLOCK, which can be changed by remount
> The two in the first category have been fixed by commit c8585c6fcaf2
> ("ext4: fix races between changing inode journal mode and ext4_writepages")
> and commit cb85f4d23f79 ("ext4: fix race between writepages and enabling
> EXT4_EXTENTS_FL") respectively.
> Two cases in the other category have not yet been fixed, and the above
> issue is caused by this situation. We refer to the fix for the first
> category, When DELALLOC or DIOREAD_NOLOCK is detected to be changed
> during remount, we hold the s_writepages_rwsem lock to avoid racing with
> ext4_writepages to trigger the problem.
> Moreover, we add an EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK macro to ensure that
> the mount options used by ext4_should_dioread_nolock() and __ext4_remount()
> are always consistent.
> 
> Fixes: 6b523df4fb5a ("ext4: use transaction reservation for extent conversion in ext4_end_io")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Nice catch! One comment below:

> ---
>  fs/ext4/ext4.h      |  3 ++-
>  fs/ext4/ext4_jbd2.h |  9 +++++----
>  fs/ext4/super.c     | 14 ++++++++++++++
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 08b29c289da4..f60967fa648f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1703,7 +1703,8 @@ struct ext4_sb_info {
>  
>  	/*
>  	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
> -	 * or EXTENTS flag.
> +	 * or EXTENTS flag or between changing SHOULD_DIOREAD_NOLOCK flag on
> +	 * remount and writepages ops.
>  	 */
>  	struct percpu_rw_semaphore s_writepages_rwsem;
>  	struct dax_device *s_daxdev;
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 0c77697d5e90..d82bfcdd56e5 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -488,6 +488,9 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>  	return blocks + 2*(EXT4_SB(inode->i_sb)->s_cluster_ratio - 1);
>  }
>  
> +/* delalloc is a temporary fix to prevent generic/422 test failures*/
> +#define EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK (EXT4_MOUNT_DIOREAD_NOLOCK | \
> +					  EXT4_MOUNT_DELALLOC)
>  /*
>   * This function controls whether or not we should try to go down the
>   * dioread_nolock code paths, which makes it safe to avoid taking
> @@ -499,7 +502,8 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>   */
>  static inline int ext4_should_dioread_nolock(struct inode *inode)
>  {
> -	if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
> +	if (test_opt(inode->i_sb, SHOULD_DIOREAD_NOLOCK) !=
> +	    EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK)
>  		return 0;
>  	if (!S_ISREG(inode->i_mode))
>  		return 0;
> @@ -507,9 +511,6 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
>  		return 0;
>  	if (ext4_should_journal_data(inode))
>  		return 0;
> -	/* temporary fix to prevent generic/422 test failures */
> -	if (!test_opt(inode->i_sb, DELALLOC))
> -		return 0;
>  	return 1;
>  }

Is there a need for this SHOULD_DIOREAD_NOLOCK? When called from writeback
we will be protected by s_writepages_rwsem anyway. When called from other
places, we either decide to do dioread_nolock or don't but the situation
can change at any instant so I don't see how unifying this check would
help. And the new SHOULD_DIOREAD_NOLOCK somewhat obfuscates what's going
on.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index fefcd42f34ea..bdf6b288aeff 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -6403,8 +6403,22 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  
>  	}
>  
> +	/* Get the flag we really need to set/clear. */
> +	ctx->mask_s_mount_opt &= sbi->s_mount_opt;
> +	ctx->vals_s_mount_opt &= ~sbi->s_mount_opt;
> +
> +	/*
> +	 * If EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK change on remount, we need
> +	 * to hold s_writepages_rwsem to avoid racing with writepages ops.
> +	 */
> +	if (ctx_changed_mount_opt(ctx, EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK))
> +		percpu_down_write(&sbi->s_writepages_rwsem);
> +

Honestly, I'd be inclined to grab s_writepages_rwsem unconditionally during
remount. Remount is not a fast path operation and waiting for writepages
isn't too bad. Also it's easier for testing :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
