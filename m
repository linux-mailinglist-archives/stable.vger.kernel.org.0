Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6E9678463
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 19:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjAWSUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 13:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjAWSUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 13:20:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DF130B22
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 10:19:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 629FEB80E6C
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 18:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B36C433D2;
        Mon, 23 Jan 2023 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674497962;
        bh=BiY+94W/UA2ynCZttnaitmIe+1NUuICPK8erHklsvrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SS7mH2m+jFdYT29f+ugatIp0s4o2xES95QYx4dULaqt5ngD2AEAiPMPWfxeLrIg00
         0P53p1KTrkVlW61dom7c6Tzq/stVlZ7FAZbd03PpEJw8Tx77ZIfE/SrL9sxl5JUX4Y
         IRnFZ7boJRA2LZ8Cmf4tbtoZJY4IK+1fPOq3ndY/ku94GYns4yHyz662AFS9IYigR9
         vUiZTjvFJy1MvGUsNFd410L4OGuBo9uGffEevrWZITeQcgE848HZerPMfN3VImjg3O
         3H1VmFhTtY5ENmXujibtZFjzojFhWQjVKvNBtBLahRLETIGH6czKzo5UYdMveHpLs/
         3SWE4cIyNbxUA==
Date:   Mon, 23 Jan 2023 18:19:20 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: fix information leak in f2fs_move_inline_dirents()
Message-ID: <Y87PqGgw1uJVlnrP@gmail.com>
References: <20230123070414.138052-1-ebiggers@kernel.org>
 <CAG_fn=VNjkRMozdcQUSMTHvMQ26SG45oisxamJbEVrg2m41ngg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=VNjkRMozdcQUSMTHvMQ26SG45oisxamJbEVrg2m41ngg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 09:58:22AM +0100, Alexander Potapenko wrote:
> On Mon, Jan 23, 2023 at 8:05 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > When converting an inline directory to a regular one, f2fs is leaking
> > uninitialized memory to disk because it doesn't initialize the entire
> > directory block.  Fix this by zero-initializing the block.
> >
> > This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
> > initializing when converting inline dentry"), which didn't consider the
> > security implications of leaking uninitialized memory to disk.
> >
> > This was found by running xfstest generic/435 on a KMSAN-enabled kernel.
> 
> Out of curiosity, did you add any extra annotations to detect uninit
> writes to the disk?

No.  This is the report I got:

[  145.280969] =====================================================
[  145.285368] BUG: KMSAN: uninit-value in virtqueue_add+0x1ba5/0x6ac0
[  145.289123]  virtqueue_add+0x1ba5/0x6ac0
[  145.291539]  virtqueue_add_sgs+0x2ae/0x2c0
[  145.294036]  virtio_queue_rqs+0xa59/0x1270
[  145.296566]  blk_mq_flush_plug_list+0x34a/0x9e0
[  145.299389]  __blk_flush_plug+0x6b5/0x760
[  145.301801]  blk_finish_plug+0x92/0xd0
[  145.304084]  __f2fs_write_data_pages+0x3953/0x4140
[  145.307011]  f2fs_write_data_pages+0xf1/0x120
[  145.309665]  do_writepages+0x45c/0x980
[  145.312017]  filemap_fdatawrite+0x1d2/0x260
[  145.314533]  f2fs_sync_dirty_inodes+0x3a3/0xa40
[  145.317272]  f2fs_write_checkpoint+0xecc/0x2890
[  145.320013]  __checkpoint_and_complete_reqs+0x12e/0x660
[  145.323126]  issue_checkpoint_thread+0x10a/0x420
[  145.325900]  kthread+0x35c/0x490
[  145.327995]  ret_from_fork+0x1f/0x30
[  145.330208]
[  145.331242] Uninit was created at:
[  145.333399]  __alloc_pages+0x6f9/0xc90
[  145.335716]  alloc_pages+0x8aa/0xa20
[  145.337921]  folio_alloc+0x34/0x40
[  145.340069]  __filemap_get_folio+0xa9f/0x11a0
[  145.342719]  pagecache_get_page+0x5b/0x1b0
[  145.345209]  grab_cache_page_write_begin+0xa5/0xc0
[  145.348096]  do_convert_inline_dir+0x8dc/0x3680
[  145.350812]  f2fs_add_inline_entry+0x76a/0x11a0
[  145.353532]  f2fs_do_add_link+0x59b/0x970
[  145.356009]  f2fs_create+0x5b6/0x8c0
[  145.358213]  path_openat+0x25a5/0x46e0
[  145.360547]  do_filp_open+0x2ab/0x700
[  145.362785]  do_sys_openat2+0x20e/0x780
[  145.365138]  __x64_sys_openat+0x259/0x360
[  145.367562]  do_syscall_64+0x41/0x90
[  145.369819]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  145.372895]
[  145.373900] Bytes 2043-2050 of 4096 are uninitialized
[  145.376857] Memory access of size 4096 starts at ffff888076818000
[  145.380391]
[  145.381429] CPU: 1 PID: 1907 Comm: f2fs_ckpt-254:3 Not tainted 6.2.0-rc5-next-20230123 #1
[  145.386152] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
[  145.392541] =====================================================
[  145.396096] Disabling lock debugging due to kernel taint
[  145.399241] =====================================================
