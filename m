Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C79C54B337
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343800AbiFNOaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343777AbiFNOaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:30:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A539ADEFC;
        Tue, 14 Jun 2022 07:29:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4FEB01F9A9;
        Tue, 14 Jun 2022 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655216997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGoaGjGP6j/udP5ooaRRpjCZ4pfh/sVO4ewkgPS8RJ0=;
        b=FaGGYI2cAI6HiApREyD21snUqkJFheeNopmLSWacycbmwcmjsm2GsWL9/2W0oO39khzIS6
        6wMJcRuDJy0f+Nux70OX2DehF/oGD3uzpCFFHEf+1iPE86RmgaTO2tJx//27rzYnDbyTp7
        46vHe/bFhK2ZO4qonhGhLxEtPyLIkoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655216997;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGoaGjGP6j/udP5ooaRRpjCZ4pfh/sVO4ewkgPS8RJ0=;
        b=cwUGXG7IP061V1p/bwmD6vTjS9UnnD599g/2i+GRLU7cYZ9o56dt+WeaOTmfOKGPEEkqYd
        WmoWUhmqPtNrV+Aw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 11C3F2C141;
        Tue, 14 Jun 2022 14:29:56 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 03D76A062E; Tue, 14 Jun 2022 16:29:55 +0200 (CEST)
Date:   Tue, 14 Jun 2022 16:29:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Jchao Sun <sunjunchao2870@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] writeback: Avoid grabbing the wb if the we don't add it
 to dirty list
Message-ID: <20220614142955.7wvv5dfqdcwp5ftw@quack3.lan>
References: <20220614124618.2830569-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614124618.2830569-1-suzuki.poulose@arm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 14-06-22 13:46:18, Suzuki K Poulose wrote:
> Commit 10e14073107d moved grabbing the wb for an inode early enough,
> skipping the checks whether if this inode needs to be really added
> to the dirty list (backed by blockdev or unhashed inode). This causes
> a crash with kdevtmpfs as below, on an arm64 Juno board, as below:
> 
> [    1.446493] printk: console [ttyAMA0] printing thread started
> [    1.447195] printk: bootconsole [pl11] printing thread stopped
> [    1.467193] Unable to handle kernel paging request at virtual address ffff800871242000
> [    1.467793] Mem abort info:
> [    1.468093]   ESR = 0x0000000096000005
> [    1.468413]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    1.468741]   SET = 0, FnV = 0
> [    1.469093]   EA = 0, S1PTW = 0
> [    1.469396]   FSC = 0x05: level 1 translation fault
> [    1.470493] Data abort info:
> [    1.470793]   ISV = 0, ISS = 0x00000005
> [    1.471093]   CM = 0, WnR = 0
> [    1.471444] swapper pgtable: 4k pages, 48-bit VAs, 	pgdp=0000000081c10000
> [    1.471798] [ffff800871242000] pgd=10000008fffff003,
> p4d=10000008fffff003, pud=0000000000000000
> [    1.472836] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [    1.472918] Modules linked in:
> [    1.473085] CPU: 1 PID: 35 Comm: kdevtmpfs Tainted: G T 5.19.0-rc1+ #49
> [    1.473246] Hardware name: Foundation-v8A (DT)
> [    1.473345] pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT 	-SSBS BTYPE=--)
> [    1.473493] pc : locked_inode_to_wb_and_lock_list+0xbc/0x2a4
> [    1.473656] lr : locked_inode_to_wb_and_lock_list+0x8c/0x2a4
> [    1.473820] sp : ffff80000b77bc10
> [    1.473901] x29: ffff80000b77bc10 x28: 0000000000000001 x27: 0000000000000004
> [    1.474193] x26: 0000000000000000 x25: ffff000800888600 x24: ffff0008008885e8
> [    1.474393] x23: ffff80000848ddd4 x22: ffff80000a754f30 x21: ffff80000a7eaaf0
> [    1.474693] x20: ffff000800888150 x19: ffff80000b6a4150 x18: ffff80000ac3ac00
> [    1.474917] x17: 0000000070526bee x16: 000000003ac581ee x15: ffff80000ac42660
> [    1.475195] x14: 0000000000000000 x13: 0000000000007a60 x12: 0000000000000002
> [    1.475428] x11: ffff80000a7eaaf0 x10: 0000000000000004 x9 : 000000008845fe88
> [    1.475622] x8 : ffff000800868000 x7 : ffff80000ab98000 x6 : 00000000114514e2
> [    1.475893] x5 : 0000000000000000 x4 : 0000000000020019 x3 : 0000000000000001
> [    1.476113] x2 : ffff800871242000 x1 : ffff800871242000 x0 : ffff000800868000
> [    1.476393] Call trace:
> [    1.476493]  locked_inode_to_wb_and_lock_list+0xbc/0x2a4
> [    1.476605]  __mark_inode_dirty+0x3d8/0x6e0
> [    1.476793]  simple_setattr+0x5c/0x84
> [    1.476933]  notify_change+0x3ec/0x470
> [    1.477096]  handle_create+0x1b8/0x224
> [    1.477193]  devtmpfsd+0x98/0xf8
> [    1.477342]  kthread+0x124/0x130
> [    1.477512]  ret_from_fork+0x10/0x20
> [    1.477670] Code: b9000802 d2800023 d53cd042 8b020021 (f823003f)
> [    1.477793] ---[ end trace 0000000000000000 ]---
> [    1.478093] note: kdevtmpfs[35] exited with preempt_count 2
> 
> The problem was bisected to the above commit and moving the bail check
> early solves the problem for me.
> 
> Fixes: 10e14073107d ("writeback: Fix inode->i_io_list not be protected by inode->i_lock error")
> CC: stable@vger.kernel.org
> Cc: Jchao Sun <sunjunchao2870@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks for debugging this! The problem actually is not that we cannot call 
locked_inode_to_wb_and_lock_list() for devtmpfs inode. The problem is that
we get called so early during boot that noop_backing_dev_info is not
initialized yet and that breaks the code. But I agree the quick fix for
this breakage is to exclude unhashed inodes early in __mark_inode_dirty().
I'll update the changelog and code comment (and cleanup the condition when
moving it) and push the result to my tree.

								Honza

> ---
>  fs/fs-writeback.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 05221366a16d..cf68114af68b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2416,6 +2416,14 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  			inode->i_state &= ~I_DIRTY_TIME;
>  		inode->i_state |= flags;
>  
> +		/*
> +		 * Only add valid (hashed) inodes to the superblock's
> +		 * dirty list.  Add blockdev inodes as well.
> +		 */
> +		if (!S_ISBLK(inode->i_mode)) {
> +			if (inode_unhashed(inode))
> +				goto out_unlock_inode;
> +		}
>  		/*
>  		 * Grab inode's wb early because it requires dropping i_lock and we
>  		 * need to make sure following checks happen atomically with dirty
> @@ -2436,14 +2444,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		if (inode->i_state & I_SYNC_QUEUED)
>  			goto out_unlock;
>  
> -		/*
> -		 * Only add valid (hashed) inodes to the superblock's
> -		 * dirty list.  Add blockdev inodes as well.
> -		 */
> -		if (!S_ISBLK(inode->i_mode)) {
> -			if (inode_unhashed(inode))
> -				goto out_unlock;
> -		}
>  		if (inode->i_state & I_FREEING)
>  			goto out_unlock;
>  
> -- 
> 2.35.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
