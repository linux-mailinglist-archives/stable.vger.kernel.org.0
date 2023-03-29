Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022EC6CDA0F
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjC2NHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 09:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjC2NHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 09:07:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3611A4C28;
        Wed, 29 Mar 2023 06:06:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 11359219A6;
        Wed, 29 Mar 2023 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680095196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vuqiwL5WOHhi9vY4nLsSMA4hwqodR1/I22u11aU6o8o=;
        b=3XzsDcmRODNZh63PhpIc8D2uvzhHz2mBrGx8DYc1FZJSY45CKVPBtD5WcjVu6JgZ5D8An7
        9cVDmfWVkGW/sApFemF2uumxnK82oO+oQ2lMhYjzqX/i143P5CX/gB8xrLFGoHoKIIItwG
        2S/FvxFeO1IYFCeAzEV3jw1dlt2JwCU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680095196;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vuqiwL5WOHhi9vY4nLsSMA4hwqodR1/I22u11aU6o8o=;
        b=NhrqOAitaVTTwcKrGvNi5GrfzJdBMgw6wu/78KlHqBwG4N/S6gBAWv6WHGhu28z6ygpQaL
        ljG7HUQmlN0VS5DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3471139D3;
        Wed, 29 Mar 2023 13:06:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9vVWO9s3JGQEBwAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 29 Mar 2023 13:06:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 75A4DA071E; Wed, 29 Mar 2023 15:06:35 +0200 (CEST)
Date:   Wed, 29 Mar 2023 15:06:35 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, ritesh.list@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix race between writepages and remount
Message-ID: <20230329130635.utcb3mzekp5izu3q@quack3>
References: <20230329085036.2755843-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329085036.2755843-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 29-03-23 16:50:36, Baokun Li wrote:
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
> 
>             cpu1                        cpu2
> ----------------------------|----------------------------
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
> 
>     (1) journal_data and EXT4_EXTENTS_FL, which can be changed by ioctl
>     (2) DELALLOC and DIOREAD_NOLOCK, which can be changed by remount
> 
> The two in the first category have been fixed by commit c8585c6fcaf2
> ("ext4: fix races between changing inode journal mode and ext4_writepages")
> and commit cb85f4d23f79 ("ext4: fix race between writepages and enabling
> EXT4_EXTENTS_FL") respectively.
> 
> Two cases in the other category have not yet been fixed, and the above
> issue is caused by this situation. We refer to the fix for the first
> category, when applying options during remount, we grab s_writepages_rwsem
> to avoid racing with writepages ops to trigger this problem.
> 
> Fixes: 6b523df4fb5a ("ext4: use transaction reservation for extent conversion in ext4_end_io")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Looks good. Nice that you've spotted also the restore options case. Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> V1->V2:
> 	Grab s_writepages_rwsem unconditionally during remount.
> 	Remove patches 1,2 that are no longer needed.
> V2->V3:
> 	Also grab s_writepages_rwsem when restoring options.
> 
>  fs/ext4/ext4.h  |  3 ++-
>  fs/ext4/super.c | 12 ++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9b2cfc32cf78..5f5ee0c20673 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1703,7 +1703,8 @@ struct ext4_sb_info {
>  
>  	/*
>  	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
> -	 * or EXTENTS flag.
> +	 * or EXTENTS flag or between writepages ops and changing DELALLOC or
> +	 * DIOREAD_NOLOCK mount options on remount.
>  	 */
>  	struct percpu_rw_semaphore s_writepages_rwsem;
>  	struct dax_device *s_daxdev;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e6d84c1e34a4..8396da483c17 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -6403,7 +6403,16 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  
>  	}
>  
> +	/*
> +	 * Changing the DIOREAD_NOLOCK or DELALLOC mount options may cause
> +	 * two calls to ext4_should_dioread_nolock() to return inconsistent
> +	 * values, triggering WARN_ON in ext4_add_complete_io(). we grab
> +	 * here s_writepages_rwsem to avoid race between writepages ops and
> +	 * remount.
> +	 */
> +	percpu_down_write(&sbi->s_writepages_rwsem);
>  	ext4_apply_options(fc, sb);
> +	percpu_up_write(&sbi->s_writepages_rwsem);
>  
>  	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
>  	    test_opt(sb, JOURNAL_CHECKSUM)) {
> @@ -6614,6 +6623,7 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  	return 0;
>  
>  restore_opts:
> +	percpu_down_write(&sbi->s_writepages_rwsem);
>  	sb->s_flags = old_sb_flags;
>  	sbi->s_mount_opt = old_opts.s_mount_opt;
>  	sbi->s_mount_opt2 = old_opts.s_mount_opt2;
> @@ -6622,6 +6632,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  	sbi->s_commit_interval = old_opts.s_commit_interval;
>  	sbi->s_min_batch_time = old_opts.s_min_batch_time;
>  	sbi->s_max_batch_time = old_opts.s_max_batch_time;
> +	percpu_up_write(&sbi->s_writepages_rwsem);
> +
>  	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->s_system_blks)
>  		ext4_release_system_zone(sb);
>  #ifdef CONFIG_QUOTA
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
