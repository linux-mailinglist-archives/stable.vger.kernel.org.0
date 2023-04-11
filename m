Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A3B6DD77B
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 12:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDKKIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 06:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKKIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 06:08:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3504B172C;
        Tue, 11 Apr 2023 03:08:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE20C1FE09;
        Tue, 11 Apr 2023 10:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681207714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lR71N1mYm36JOq5VF9CaSZ6QT7xQUnDPq3n8X/2hNUA=;
        b=OHtmcVW/1PLrds+bk1wJbaT0/VSElwTMtqL3RObpXG0Y3czGe55zl2TYdJboVgbebhSu//
        DRrWo/PFctezzue0a4fnn3wdAJTKlR6YysJy+7IjwkVgaxNunCDs1swxBKGysUO+KZQHbM
        wXyivsTEydWZQgHuRaerWWS8V5MXayE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681207714;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lR71N1mYm36JOq5VF9CaSZ6QT7xQUnDPq3n8X/2hNUA=;
        b=JaXpYwHfOL7K2A339hNzEy/0W47aGoheDtgbI9Vb9SVPLhHuMyr4jRLJ++t37r0Rdu1y/b
        uaoJfCypNgIkl3DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BEFBE13638;
        Tue, 11 Apr 2023 10:08:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OXZuLqIxNWRDQAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 11 Apr 2023 10:08:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 9B03CA0732; Tue, 11 Apr 2023 12:08:33 +0200 (CEST)
Date:   Tue, 11 Apr 2023 12:08:33 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, jack@suse.cz, tj@kernel.org, dennis@kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, houtao1@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] writeback, cgroup: fix null-ptr-deref write in
 bdi_split_work_to_wbs
Message-ID: <20230411100833.jlqyprce6qbphr6q@quack3>
References: <20230410130826.1492525-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410130826.1492525-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 10-04-23 21:08:26, Baokun Li wrote:
> KASAN report null-ptr-deref:
> ==================================================================
> BUG: KASAN: null-ptr-deref in bdi_split_work_to_wbs+0x5c5/0x7b0
> Write of size 8 at addr 0000000000000000 by task sync/943
> CPU: 5 PID: 943 Comm: sync Tainted: 6.3.0-rc5-next-20230406-dirty #461
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x7f/0xc0
>  print_report+0x2ba/0x340
>  kasan_report+0xc4/0x120
>  kasan_check_range+0x1b7/0x2e0
>  __kasan_check_write+0x24/0x40
>  bdi_split_work_to_wbs+0x5c5/0x7b0
>  sync_inodes_sb+0x195/0x630
>  sync_inodes_one_sb+0x3a/0x50
>  iterate_supers+0x106/0x1b0
>  ksys_sync+0x98/0x160
> [...]
> ==================================================================
> 
> The race that causes the above issue is as follows:
> 
>            cpu1                     cpu2
> -------------------------|-------------------------
> inode_switch_wbs
>  INIT_WORK(&isw->work, inode_switch_wbs_work_fn)
>  queue_rcu_work(isw_wq, &isw->work)
>  // queue_work async
>   inode_switch_wbs_work_fn
>    wb_put_many(old_wb, nr_switched)
>     percpu_ref_put_many
>      ref->data->release(ref)
>      cgwb_release
>       queue_work(cgwb_release_wq, &wb->release_work)
>       // queue_work async
>        &wb->release_work
>        cgwb_release_workfn
>                             ksys_sync
>                              iterate_supers
>                               sync_inodes_one_sb
>                                sync_inodes_sb
>                                 bdi_split_work_to_wbs
>                                  kmalloc(sizeof(*work), GFP_ATOMIC)
>                                  // alloc memory failed
>         percpu_ref_exit
>          ref->data = NULL
>          kfree(data)
>                                  wb_get(wb)
>                                   percpu_ref_get(&wb->refcnt)
>                                    percpu_ref_get_many(ref, 1)
>                                     atomic_long_add(nr, &ref->data->count)
>                                      atomic64_add(i, v)
>                                      // trigger null-ptr-deref
> 
> bdi_split_work_to_wbs() traverses &bdi->wb_list to split work into all wbs.
> If the allocation of new work fails, the on-stack fallback will be used and
> the reference count of the current wb is increased afterwards. If cgroup
> writeback membership switches occur before getting the reference count and
> the current wb is released as old_wd, then calling wb_get() or wb_put()
> will trigger the null pointer dereference above.
> 
> This issue was introduced in v4.3-rc7 (see fix tag1). Both sync_inodes_sb()
> and __writeback_inodes_sb_nr() calls to bdi_split_work_to_wbs() can trigger
> this issue. For scenarios called via sync_inodes_sb(), originally commit
> 7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback
> membership switches") reduced the possibility of the issue by adding
> wb_switch_rwsem, but in v5.14-rc1 (see fix tag2) removed the
> "inode_io_list_del_locked(inode, old_wb)" from inode_switch_wbs_work_fn()
> so that wb->state contains WB_has_dirty_io, thus old_wb is not skipped
> when traversing wbs in bdi_split_work_to_wbs(), and the issue becomes
> easily reproducible again.
> 
> To solve this problem, percpu_ref_exit() is called under RCU protection
> to avoid race between cgwb_release_workfn() and bdi_split_work_to_wbs().
> Moreover, replace wb_get() with wb_tryget() in bdi_split_work_to_wbs(),
> and skip the current wb if wb_tryget() fails because the wb has already
> been shutdown.
> 
> Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
> Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	Use RCU instead of wb_switch_rwsem to avoid race.

The cgwb shutdown code is really messy. But your change looks good to me
and I don't see an easier way around this race. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
>  fs/fs-writeback.c | 17 ++++++++++-------
>  mm/backing-dev.c  | 12 ++++++++++--
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 195dc23e0d83..1db3e3c24b43 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -978,6 +978,16 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  			continue;
>  		}
>  
> +		/*
> +		 * If wb_tryget fails, the wb has been shutdown, skip it.
> +		 *
> +		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
> +		 * continuing iteration from @wb after dropping and
> +		 * regrabbing rcu read lock.
> +		 */
> +		if (!wb_tryget(wb))
> +			continue;
> +
>  		/* alloc failed, execute synchronously using on-stack fallback */
>  		work = &fallback_work;
>  		*work = *base_work;
> @@ -986,13 +996,6 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  		work->done = &fallback_work_done;
>  
>  		wb_queue_work(wb, work);
> -
> -		/*
> -		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
> -		 * continuing iteration from @wb after dropping and
> -		 * regrabbing rcu read lock.
> -		 */
> -		wb_get(wb);
>  		last_wb = wb;
>  
>  		rcu_read_unlock();
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index ad011308cebe..43b48750b491 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -507,6 +507,15 @@ static LIST_HEAD(offline_cgwbs);
>  static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
>  static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_workfn);
>  
> +static void cgwb_free_rcu(struct rcu_head *rcu_head)
> +{
> +	struct bdi_writeback *wb = container_of(rcu_head,
> +			struct bdi_writeback, rcu);
> +
> +	percpu_ref_exit(&wb->refcnt);
> +	kfree(wb);
> +}
> +
>  static void cgwb_release_workfn(struct work_struct *work)
>  {
>  	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
> @@ -529,11 +538,10 @@ static void cgwb_release_workfn(struct work_struct *work)
>  	list_del(&wb->offline_node);
>  	spin_unlock_irq(&cgwb_lock);
>  
> -	percpu_ref_exit(&wb->refcnt);
>  	wb_exit(wb);
>  	bdi_put(bdi);
>  	WARN_ON_ONCE(!list_empty(&wb->b_attached));
> -	kfree_rcu(wb, rcu);
> +	call_rcu(&wb->rcu, cgwb_free_rcu);
>  }
>  
>  static void cgwb_release(struct percpu_ref *refcnt)
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
