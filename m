Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3A4B04B7
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiBJE7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:59:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiBJE7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382101FD;
        Wed,  9 Feb 2022 20:59:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8D0261BC2;
        Thu, 10 Feb 2022 04:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32187C004E1;
        Thu, 10 Feb 2022 04:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644469152;
        bh=xpSvsZo9uIV0gv5kg5afu2dn4W4prSq2494jXFlLryk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LGAaT2n8o/rRfG0ba+hSPaCFMYinhEO78KexL2r1ZHN7vSdXzms4x++Lx/P6wtxBL
         wyFLiDCkCbwyoOeFY1uD8QPOrfQOPd7m0g6bi71JspfBODLOv9vizoz104odfTXcAB
         MIZ0FblxbGnpmoig7yPFQjto1AUJX8RAOxyvzrSubxIFKdQdqt5j566bnOXIRqhB6Q
         eWk4odKOgFJ3uUXizEipo8c1I6j1Y8pBL5GRMSFrkzmMjj5kuIckd4igTOwRz/qE9G
         Jgm4Jac8haD9fzqT3BS2/jAMHdpM58RQnhNopOhBnd5XNxAW5E1gRG155e3Rnm9IPr
         gkH3M1Tlruyxw==
Date:   Wed, 9 Feb 2022 20:59:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <20220210045911.GF8338@magnolia>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209085243.3136536-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> 
> Reverting since this commit opens a potential avenue for abuse.

What kind of abuse?  Did you conclude there's an avenue solely because
some combination of userspace rigging produced a BUG warning?  Or is
this a real problem that someone found?

> The C-reproducer and more information can be found at the link below.

No.  Post the information and your analysis here.  I'm not going to dig
into some Google site to find out what happened, and I'm not going to
assume that future developers will be able to access that URL to learn
why this patch was created.

I am not convinced that this revert is a proper fix for ... whatever is
the problem, because you never explained what happened.

> With this patch applied, I can no longer get the repro to trigger.

With ext4 completely reverted, I can no longer get the repro to trigger
either.

>   kernel BUG at fs/ext4/inode.c:2647!
>   invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>   CPU: 0 PID: 459 Comm: syz-executor359 Tainted: G        W         5.10.93-syzkaller-01028-g0347b1658399 #0

What BUG on fs/ext4/inode.c:2647?

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/ext4/inode.c?h=v5.10.93#n2647

All I see is a call to pagevec_release()?  There's a BUG_ON further up
if we wait for page writeback but then it still has Writeback set.  But
I don't see anything in pagevec_release that would actually result in a
BUG warning.

Oh, right, this is one of those inscrutable syzkaller things, where a
person can spend hours figuring out what the hell it set up.

Yeah...no, you don't get to submit patches to core kernel code, claim
it's not your responsibility to know anything about a subsystem that you
want to patch, and then expect us to do the work for you.  If you pick
up a syzkaller report, you get to figure out what broke, why, and how to
fix it in a reasonable manner.

You're a maintainer, would you accept a patch like this?

NAK.

--D

OH WAIT, you're running this on the Android 5.10 kernel, aren't you?
The BUG report came from page_buffers failing to find any buffer heads
attached to the page.
https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10-2022-02/fs/ext4/inode.c#2647

Yeah, don't care.

>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:mpage_prepare_extent_to_map+0xbe9/0xc00 fs/ext4/inode.c:2647
>   Code: e8 fc bd c3 ff e9 80 f6 ff ff 44 89 e9 80 e1 07 38 c1 0f 8c a6 fe ff ff 4c 89 ef e8 e1 bd c3 ff e9 99 fe ff ff e8 87 c9 89 ff <0f> 0b e8 80 c9 89 ff 0f 0b e8 79 1e b8 02 66 0f 1f 84 00 00 00 00
>   RSP: 0018:ffffc90000e2e9c0 EFLAGS: 00010293
>   RAX: ffffffff81e321f9 RBX: 0000000000000000 RCX: ffff88810c12cf00
>   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>   RBP: ffffc90000e2eb90 R08: ffffffff81e31e71 R09: fffff940008d68b1
>   R10: fffff940008d68b1 R11: 0000000000000000 R12: ffffea00046b4580
>   R13: ffffc90000e2ea80 R14: 000000000000011e R15: dffffc0000000000
>   FS:  00007fcfd0717700(0000) GS:ffff8881f7000000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007fcfd07d5520 CR3: 000000010a142000 CR4: 00000000003506b0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    ext4_writepages+0xcbb/0x3950 fs/ext4/inode.c:2776
>    do_writepages+0x13a/0x280 mm/page-writeback.c:2358
>    __filemap_fdatawrite_range+0x356/0x420 mm/filemap.c:427
>    filemap_write_and_wait_range+0x64/0xe0 mm/filemap.c:660
>    __iomap_dio_rw+0x621/0x10c0 fs/iomap/direct-io.c:495
>    iomap_dio_rw+0x35/0x80 fs/iomap/direct-io.c:611
>    ext4_dio_write_iter fs/ext4/file.c:571 [inline]
>    ext4_file_write_iter+0xfc5/0x1b70 fs/ext4/file.c:681
>    do_iter_readv_writev+0x548/0x740 include/linux/fs.h:1941
>    do_iter_write+0x182/0x660 fs/read_write.c:866
>    vfs_iter_write+0x7c/0xa0 fs/read_write.c:907
>    iter_file_splice_write+0x7fb/0xf70 fs/splice.c:686
>    do_splice_from fs/splice.c:764 [inline]
>    direct_splice_actor+0xfe/0x130 fs/splice.c:933
>    splice_direct_to_actor+0x4f4/0xbc0 fs/splice.c:888
>    do_splice_direct+0x28b/0x3e0 fs/splice.c:976
>    do_sendfile+0x914/0x1390 fs/read_write.c:1257
> 
> Link: https://syzkaller.appspot.com/bug?extid=41c966bf0729a530bd8d
> 
> From the patch:
> Cc: Stable <stable@vger.kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Theodore Ts'o <tytso@mit.edu> # for ext4
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> Others:
> Cc: Johannes Thumshirn <jth@kernel.org>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-ext4@vger.kernel.org
> Cc: cluster-devel@redhat.com
> 
> Fixes: 60263d5889e6d ("iomap: fall back to buffered writes for invalidation failures")
> Reported-by: syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  fs/ext4/file.c       |  2 --
>  fs/gfs2/file.c       |  3 +--
>  fs/iomap/direct-io.c | 16 +++++-----------
>  fs/iomap/trace.h     |  1 -
>  fs/xfs/xfs_file.c    |  4 ++--
>  fs/zonefs/super.c    |  7 ++-----
>  6 files changed, 10 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 3ed8c048fb12c..cb347c3b35535 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -551,8 +551,6 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		iomap_ops = &ext4_iomap_overwrite_ops;
>  	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
>  			   is_sync_kiocb(iocb) || unaligned_io || extend);
> -	if (ret == -ENOTBLK)
> -		ret = 0;
>  
>  	if (extend)
>  		ret = ext4_handle_inode_extension(inode, offset, ret, count);
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index b39b339feddc9..847adb97380d3 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -835,8 +835,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
>  
>  	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
>  			   is_sync_kiocb(iocb));
> -	if (ret == -ENOTBLK)
> -		ret = 0;
> +
>  out:
>  	gfs2_glock_dq(gh);
>  out_uninit:
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 933f234d5becd..ddcd06c0c452d 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -10,7 +10,6 @@
>  #include <linux/backing-dev.h>
>  #include <linux/uio.h>
>  #include <linux/task_io_accounting_ops.h>
> -#include "trace.h"
>  
>  #include "../internal.h"
>  
> @@ -413,9 +412,6 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>   * can be mapped into multiple disjoint IOs and only a subset of the IOs issued
>   * may be pure data writes. In that case, we still need to do a full data sync
>   * completion.
> - *
> - * Returns -ENOTBLK In case of a page invalidation invalidation failure for
> - * writes.  The callers needs to fall back to buffered I/O in this case.
>   */
>  struct iomap_dio *
>  __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> @@ -493,15 +489,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (iov_iter_rw(iter) == WRITE) {
>  		/*
>  		 * Try to invalidate cache pages for the range we are writing.
> -		 * If this invalidation fails, let the caller fall back to
> -		 * buffered I/O.
> +		 * If this invalidation fails, tough, the write will still work,
> +		 * but racing two incompatible write paths is a pretty crazy
> +		 * thing to do, so we don't support it 100%.
>  		 */
>  		if (invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
> -				end >> PAGE_SHIFT)) {
> -			trace_iomap_dio_invalidate_fail(inode, pos, count);
> -			ret = -ENOTBLK;
> -			goto out_free_dio;
> -		}
> +				end >> PAGE_SHIFT))
> +			dio_warn_stale_pagecache(iocb->ki_filp);
>  
>  		if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
>  			ret = sb_init_dio_done_wq(inode->i_sb);
> diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
> index fdc7ae388476f..5693a39d52fb6 100644
> --- a/fs/iomap/trace.h
> +++ b/fs/iomap/trace.h
> @@ -74,7 +74,6 @@ DEFINE_EVENT(iomap_range_class, name,	\
>  DEFINE_RANGE_EVENT(iomap_writepage);
>  DEFINE_RANGE_EVENT(iomap_releasepage);
>  DEFINE_RANGE_EVENT(iomap_invalidatepage);
> -DEFINE_RANGE_EVENT(iomap_dio_invalidate_fail);
>  
>  #define IOMAP_TYPE_STRINGS \
>  	{ IOMAP_HOLE,		"HOLE" }, \
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b0f93f738372..43e2c057214d9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -589,8 +589,8 @@ xfs_file_dio_aio_write(
>  	xfs_iunlock(ip, iolock);
>  
>  	/*
> -	 * No fallback to buffered IO after short writes for XFS, direct I/O
> -	 * will either complete fully or return an error.
> +	 * No fallback to buffered IO on errors for XFS, direct IO will either
> +	 * complete fully or fail.
>  	 */
>  	ASSERT(ret < 0 || ret == count);
>  	return ret;
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bec47f2d074be..d54fbef3db4df 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -851,11 +851,8 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if (iocb->ki_pos >= ZONEFS_I(inode)->i_max_size)
>  		return -EFBIG;
>  
> -	if (iocb->ki_flags & IOCB_DIRECT) {
> -		ssize_t ret = zonefs_file_dio_write(iocb, from);
> -		if (ret != -ENOTBLK)
> -			return ret;
> -	}
> +	if (iocb->ki_flags & IOCB_DIRECT)
> +		return zonefs_file_dio_write(iocb, from);
>  
>  	return zonefs_file_buffered_write(iocb, from);
>  }
> -- 
> 2.35.0.263.gb82422642f-goog
> 
