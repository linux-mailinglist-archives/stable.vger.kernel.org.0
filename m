Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E878053DC18
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 16:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiFEOCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351928AbiFEOBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 10:01:53 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FDA4DF5F;
        Sun,  5 Jun 2022 07:01:50 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id AAA7C27FCA;
        Sun,  5 Jun 2022 10:01:49 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 25789A7C60; Sun,  5 Jun 2022 10:01:49 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25244.46925.105411.511394@quad.stoffel.home>
Date:   Sun, 5 Jun 2022 10:01:49 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Heming Zhao <heming.zhao@suse.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 18/55] md/bitmap: don't set sb values if
 can't pass sanity check
In-Reply-To: <YpyvWOd0Tg2tn0wt@sashalap>
References: <20220530134701.1935933-1-sashal@kernel.org>
        <20220530134701.1935933-18-sashal@kernel.org>
        <25239.56271.848372.965726@quad.stoffel.home>
        <YpyvWOd0Tg2tn0wt@sashalap>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>>>> "Sasha" == Sasha Levin <sashal@kernel.org> writes:

My fault.  I was just pointing out that 'special' was spelled wrong in
the messages, you had:  speical.

John


Sasha> I'm sorry, I couldn't parse the mail below.

Sasha> On Wed, Jun 01, 2022 at 05:36:15PM -0400, John Stoffel wrote:
>>>>>>> "Sasha" == Sasha Levin <sashal@kernel.org> writes:
>> 
Sasha> From: Heming Zhao <heming.zhao@suse.com>
Sasha> [ Upstream commit e68cb83a57a458b01c9739e2ad9cb70b04d1e6d2 ]
>> 
Sasha> If bitmap area contains invalid data, kernel will crash then mdadm
Sasha> triggers "Segmentation fault".
Sasha> This is cluster-md speical bug. In non-clustered env, mdadm will
>> 
>> special
>> 
>> All the commit messages need to be fixed from what I see.
>> 
Sasha> handle broken metadata case. In clustered array, only kernel space
Sasha> handles bitmap slot info. But even this bug only happened in clustered
Sasha> env, current sanity check is wrong, the code should be changed.
>> 
Sasha> How to trigger: (faulty injection)
>> 
Sasha> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sda
Sasha> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdb
Sasha> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
Sasha> mdadm -Ss
Sasha> echo aaa > magic.txt
Sasha> == below modifying slot 2 bitmap data ==
Sasha> dd if=magic.txt of=/dev/sda seek=16384 bs=1 count=3 <== destroy magic
Sasha> dd if=/dev/zero of=/dev/sda seek=16436 bs=1 count=4 <== ZERO chunksize
Sasha> mdadm -A /dev/md0 /dev/sda /dev/sdb
Sasha> == kernel crashes. mdadm outputs "Segmentation fault" ==
>> 
Sasha> Reason of kernel crash:
>> 
Sasha> In md_bitmap_read_sb (called by md_bitmap_create), bad bitmap magic didn't
Sasha> block chunksize assignment, and zero value made DIV_ROUND_UP_SECTOR_T()
Sasha> trigger "divide error".
>> 
Sasha> Crash log:
>> 
Sasha> kernel: md: md0 stopped.
Sasha> kernel: md/raid1:md0: not clean -- starting background reconstruction
Sasha> kernel: md/raid1:md0: active with 2 out of 2 mirrors
Sasha> kernel: dlm: ... ...
Sasha> kernel: md-cluster: Joined cluster 44810aba-38bb-e6b8-daca-bc97a0b254aa slot 1
Sasha> kernel: md0: invalid bitmap file superblock: bad magic
Sasha> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
Sasha> kernel: md-cluster: Could not gather bitmaps from slot 2
Sasha> kernel: divide error: 0000 [#1] SMP NOPTI
Sasha> kernel: CPU: 0 PID: 1603 Comm: mdadm Not tainted 5.14.6-1-default
Sasha> kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Sasha> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
Sasha> kernel: RSP: 0018:ffffc22ac0843ba0 EFLAGS: 00010246
Sasha> kernel: ... ...
Sasha> kernel: Call Trace:
Sasha> kernel:  ? dlm_lock_sync+0xd0/0xd0 [md_cluster 77fe..7a0]
Sasha> kernel:  md_bitmap_copy_from_slot+0x2c/0x290 [md_mod 24ea..d3a]
Sasha> kernel:  load_bitmaps+0xec/0x210 [md_cluster 77fe..7a0]
Sasha> kernel:  md_bitmap_load+0x81/0x1e0 [md_mod 24ea..d3a]
Sasha> kernel:  do_md_run+0x30/0x100 [md_mod 24ea..d3a]
Sasha> kernel:  md_ioctl+0x1290/0x15a0 [md_mod 24ea....d3a]
Sasha> kernel:  ? mddev_unlock+0xaa/0x130 [md_mod 24ea..d3a]
Sasha> kernel:  ? blkdev_ioctl+0xb1/0x2b0
Sasha> kernel:  block_ioctl+0x3b/0x40
Sasha> kernel:  __x64_sys_ioctl+0x7f/0xb0
Sasha> kernel:  do_syscall_64+0x59/0x80
Sasha> kernel:  ? exit_to_user_mode_prepare+0x1ab/0x230
Sasha> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
Sasha> kernel:  ? do_syscall_64+0x69/0x80
Sasha> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
Sasha> kernel: RIP: 0033:0x7f4a15fa722b
Sasha> kernel: ... ...
Sasha> kernel: ---[ end trace 8afa7612f559c868 ]---
Sasha> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
>> 
Sasha> Reported-by: kernel test robot <lkp@intel.com>
Sasha> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Sasha> Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Sasha> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Sasha> Signed-off-by: Song Liu <song@kernel.org>
Sasha> Signed-off-by: Sasha Levin <sashal@kernel.org>
Sasha> ---
Sasha> drivers/md/md-bitmap.c | 44 ++++++++++++++++++++++--------------------
Sasha> 1 file changed, 23 insertions(+), 21 deletions(-)
>> 
Sasha> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
Sasha> index d7eef5292ae2..a95e20c3d0d4 100644
Sasha> --- a/drivers/md/md-bitmap.c
Sasha> +++ b/drivers/md/md-bitmap.c
Sasha> @@ -642,14 +642,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
Sasha> daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
Sasha> write_behind = le32_to_cpu(sb->write_behind);
Sasha> sectors_reserved = le32_to_cpu(sb->sectors_reserved);
Sasha> -	/* Setup nodes/clustername only if bitmap version is
Sasha> -	 * cluster-compatible
Sasha> -	 */
Sasha> -	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
Sasha> -		nodes = le32_to_cpu(sb->nodes);
Sasha> -		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
Sasha> -				sb->cluster_name, 64);
Sasha> -	}
>> 
Sasha> /* verify that the bitmap-specific fields are valid */
Sasha> if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
Sasha> @@ -671,6 +663,16 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
Sasha> goto out;
Sasha> }
>> 
Sasha> +	/*
Sasha> +	 * Setup nodes/clustername only if bitmap version is
Sasha> +	 * cluster-compatible
Sasha> +	 */
Sasha> +	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
Sasha> +		nodes = le32_to_cpu(sb->nodes);
Sasha> +		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
Sasha> +				sb->cluster_name, 64);
Sasha> +	}
Sasha> +
Sasha> /* keep the array size field of the bitmap superblock up to date */
sb-> sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
>> 
Sasha> @@ -703,9 +705,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> 
Sasha> out:
Sasha> kunmap_atomic(sb);
Sasha> -	/* Assigning chunksize is required for "re_read" */
Sasha> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
Sasha> if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
Sasha> +		/* Assigning chunksize is required for "re_read" */
Sasha> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
Sasha> err = md_setup_cluster(bitmap->mddev, nodes);
Sasha> if (err) {
Sasha> pr_warn("%s: Could not setup cluster service (%d)\n",
Sasha> @@ -716,18 +718,18 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
Sasha> goto re_read;
Sasha> }
>> 
Sasha> -
Sasha> out_no_sb:
Sasha> -	if (test_bit(BITMAP_STALE, &bitmap->flags))
Sasha> -		bitmap->events_cleared = bitmap->mddev->events;
Sasha> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
Sasha> -	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
Sasha> -	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
Sasha> -	bitmap->mddev->bitmap_info.nodes = nodes;
Sasha> -	if (bitmap->mddev->bitmap_info.space == 0 ||
Sasha> -	    bitmap->mddev->bitmap_info.space > sectors_reserved)
Sasha> -		bitmap->mddev->bitmap_info.space = sectors_reserved;
Sasha> -	if (err) {
Sasha> +	if (err == 0) {
Sasha> +		if (test_bit(BITMAP_STALE, &bitmap->flags))
Sasha> +			bitmap->events_cleared = bitmap->mddev->events;
Sasha> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
Sasha> +		bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
Sasha> +		bitmap->mddev->bitmap_info.max_write_behind = write_behind;
Sasha> +		bitmap->mddev->bitmap_info.nodes = nodes;
Sasha> +		if (bitmap->mddev->bitmap_info.space == 0 ||
Sasha> +			bitmap->mddev->bitmap_info.space > sectors_reserved)
Sasha> +			bitmap->mddev->bitmap_info.space = sectors_reserved;
Sasha> +	} else {
Sasha> md_bitmap_print_sb(bitmap);
Sasha> if (bitmap->cluster_slot < 0)
Sasha> md_cluster_stop(bitmap->mddev);
Sasha> --
Sasha> 2.35.1
>> 

Sasha> -- 
Sasha> Thanks,
Sasha> Sasha
