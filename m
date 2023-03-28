Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320FC6CBA0F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 11:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjC1JGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 05:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjC1JF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 05:05:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49E75FFD;
        Tue, 28 Mar 2023 02:05:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7D062219C2;
        Tue, 28 Mar 2023 09:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679994335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W19ZNXTUmBCwNQocRmCqq2y9UHESHO1aWNxN/I1GB78=;
        b=MlNlKlZYLM6ewuuC9uBNJIkHk1M+5gQngFAbugPMPRTm9QCRWtc4OVM0SMHAK7GNwu0a6C
        zkpp+RPGpiC3ITaAkd3F3SdgdTVVGPMJWrLN0FYyAiWy1ZszjOuyLHoTekqc/B+Gjvlucd
        Oqg+8+LhV9fO6Y6WtQqh3YmG2bsvnBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679994335;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W19ZNXTUmBCwNQocRmCqq2y9UHESHO1aWNxN/I1GB78=;
        b=AAEjZZRXNTN9hk42r0YqoUFTEyGQtUPPHAT3DCF8uz4X12KivRjzE19ULV0g2/BYkvIlf8
        KglenEAJcPJWsUDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 688311390B;
        Tue, 28 Mar 2023 09:05:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uNR2Gd+tImT7OgAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 28 Mar 2023 09:05:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id D556BA071C; Tue, 28 Mar 2023 11:05:34 +0200 (CEST)
Date:   Tue, 28 Mar 2023 11:05:34 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, ritesh.list@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix race between writepages and remount
Message-ID: <20230328090534.662l7yxj2e425j7w@quack3>
References: <20230328034853.2900007-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328034853.2900007-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 28-03-23 11:48:53, Baokun Li wrote:
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

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> V1->V2:
> 	Grab s_writepages_rwsem unconditionally during remount.
> 	Remove patches 1,2 that are no longer needed.
> 
>  fs/ext4/ext4.h  | 3 ++-
>  fs/ext4/super.c | 9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
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
> index e6d84c1e34a4..607ebf2a008b 100644
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
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
