Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6D168F5D
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 15:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgBVOgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 09:36:50 -0500
Received: from vps.xff.cz ([195.181.215.36]:59090 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgBVOgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 09:36:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1582382208; bh=HE3v7bOejO+dhgKXSB0UO2Jzk9/x8w6N83RUyOcVJ1Y=;
        h=Date:From:To:Subject:References:X-My-GPG-KeyId:From;
        b=W8XrVqWi4t9GcdWofDfixPF9vShRGY8uURWROGztauV2p7iqkhU+XV387cQi0ghTl
         +mOpRI10RCtXfr3BV6GJ1WE10G1GtfaZTzrTSyeBhVmuRTlvC/Vxadeq4yzrx+Ft6X
         uEdShmhqJ+CqYAsUjKxylkeCiUbarDgDtFq9p73U=
Date:   Sat, 22 Feb 2020 15:36:47 +0100
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 020/399] f2fs: call f2fs_balance_fs outside of locked
 page
Message-ID: <20200222143647.k7cfv6ryd53oejmp@core.my.home>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200221072402.315346745@linuxfoundation.org>
 <20200221072404.289499313@linuxfoundation.org>
 <20200222044151.odurt3xqyhgxqqve@core.my.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222044151.odurt3xqyhgxqqve@core.my.home>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 05:41:51AM +0100, megous hlavni wrote:
> Hello,
> 
> On Fri, Feb 21, 2020 at 08:35:45AM +0100, Greg Kroah-Hartman wrote:
> > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > 
> > [ Upstream commit bdf03299248916640a835a05d32841bb3d31912d ]
> 
> I have somes issues with this patch.
> 
> It causes panics due to hung tasks on 5.6. I guess it fixes one deadlock, but
> causes other one? Not sure backporting it to stable branches is a good idea.

False alarm. The issue is unrelated to this patch.

regards,
	o.

> regards,
> 	o.
> 
> 
> INFO: task kworker/u16:2:341 blocked for more than 122 seconds.
>       Not tainted 5.6.0-rc2-00254-g9a029a493dc16 #4
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/u16:2   D    0   341      2 0x00000000
> Workqueue: writeback wb_workfn (flush-179:0)
> Backtrace:
> [<c0912bd0>] (__schedule) from [<c0913274>] (schedule+0x78/0xf4)
>  r10:ede1a000 r9:00000000 r8:ede1ba60 r7:ec417290 r6:00000002 r5:ede1a000
>  r4:ee8e8000
> [<c09131fc>] (schedule) from [<c017ec74>] (rwsem_down_write_slowpath+0x24c/0x4c0)
>  r5:00000001 r4:ec417280
> [<c017ea28>] (rwsem_down_write_slowpath) from [<c0915f6c>] (down_write+0x6c/0x70)
>  r10:ec417280 r9:ede1bd80 r8:ee128000 r7:00000001 r6:00000000 r5:eff0afc4
>  r4:ec417280
> [<c0915f00>] (down_write) from [<c0435b68>] (f2fs_write_single_data_page+0x608/0x7ac)
>  r5:eff0afc4 r4:ec4170e0
> [<c0435560>] (f2fs_write_single_data_page) from [<c0435fc0>] (f2fs_write_cache_pages+0x2b4/0x7c4)
>  r10:ede1bc28 r9:ec4171e0 r8:ec4170e0 r7:00000001 r6:ede1bd80 r5:00000001
>  r4:eff0afc4
> [<c0435d0c>] (f2fs_write_cache_pages) from [<c0436814>] (f2fs_write_data_pages+0x344/0x35c)
>  r10:0000012c r9:ee12802c r8:ee128000 r7:00000004 r6:ec4171e0 r5:ec4170e0
>  r4:ede1bd80
> [<c04364d0>] (f2fs_write_data_pages) from [<c0267fa0>] (do_writepages+0x3c/0xd4)
>  r10:0000012c r9:c0e03d00 r8:00001400 r7:c0264e94 r6:ede1bd80 r5:ec4171e0
>  r4:ec4170e0
> [<c0267f64>] (do_writepages) from [<c0310d24>] (__writeback_single_inode+0x44/0x454)
>  r7:ec4171e0 r6:ede1beac r5:ede1bd80 r4:ec4170e0
> [<c0310ce0>] (__writeback_single_inode) from [<c0311338>] (writeback_sb_inodes+0x204/0x4b0)
>  r10:0000012c r9:c0e03d00 r8:ec417148 r7:ec4170e0 r6:ede1beac r5:ec417188
>  r4:eebed848
> [<c0311134>] (writeback_sb_inodes) from [<c0311634>] (__writeback_inodes_wb+0x50/0xe4)
>  r10:ee7128e8 r9:c0e03d00 r8:eebed85c r7:ede1beac r6:00000000 r5:eebed848
>  r4:ee120000
> [<c03115e4>] (__writeback_inodes_wb) from [<c031195c>] (wb_writeback+0x294/0x338)
>  r10:00020800 r9:ede1a000 r8:c0e04e64 r7:eebed848 r6:000192d0 r5:ede1beac
>  r4:eebed848
> [<c03116c8>] (wb_writeback) from [<c0312e98>] (wb_workfn+0x3e0/0x54c)
>  r10:ee894005 r9:eebed84c r8:eebed948 r7:eebed848 r6:00000000 r5:eebed954
>  r4:00002b6e
> [<c0312ab8>] (wb_workfn) from [<c014f2b8>] (process_one_work+0x214/0x544)
>  r10:ee894005 r9:00000200 r8:00000000 r7:ee894000 r6:ef044400 r5:edb1c700
>  r4:eebed954
> [<c014f0a4>] (process_one_work) from [<c014f634>] (worker_thread+0x4c/0x574)
>  r10:ef044400 r9:c0e03d00 r8:ef044418 r7:00000088 r6:ef044400 r5:edb1c714
>  r4:edb1c700
> [<c014f5e8>] (worker_thread) from [<c01564fc>] (kthread+0x144/0x170)
>  r10:ef125e90 r9:ec0f235c r8:edb1c700 r7:ede1a000 r6:00000000 r5:ec0f2300
>  r4:ec0f2340
> [<c01563b8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
> Exception stack(0xede1bfb0 to 0xede1bff8)
> bfa0:                                     00000000 00000000 00000000 00000000
> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c01563b8
>  r4:ec0f2300
> NMI backtrace for cpu 2
> CPU: 2 PID: 52 Comm: khungtaskd Not tainted 5.6.0-rc2-00254-g9a029a493dc16 #4
> Hardware name: Allwinner A83t board
> Backtrace:
> [<c010db5c>] (dump_backtrace) from [<c010dee0>] (show_stack+0x20/0x24)
>  r7:00000000 r6:60060013 r5:00000000 r4:c0e9ab10
> 
> > Otherwise, we can hit deadlock by waiting for the locked page in
> > move_data_block in GC.
> > 
> >  Thread A                     Thread B
> >  - do_page_mkwrite
> >   - f2fs_vm_page_mkwrite
> >    - lock_page
> >                               - f2fs_balance_fs
> >                                   - mutex_lock(gc_mutex)
> >                                - f2fs_gc
> >                                 - do_garbage_collect
> >                                  - ra_data_block
> >                                   - grab_cache_page
> >    - f2fs_balance_fs
> >     - mutex_lock(gc_mutex)
> > 
> > Fixes: 39a8695824510 ("f2fs: refactor ->page_mkwrite() flow")
> > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/f2fs/file.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 33c412d178f0f..6c4436a5ce797 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -50,7 +50,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
> >  	struct page *page = vmf->page;
> >  	struct inode *inode = file_inode(vmf->vma->vm_file);
> >  	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> > -	struct dnode_of_data dn = { .node_changed = false };
> > +	struct dnode_of_data dn;
> >  	int err;
> >  
> >  	if (unlikely(f2fs_cp_error(sbi))) {
> > @@ -63,6 +63,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
> >  		goto err;
> >  	}
> >  
> > +	/* should do out of any locked page */
> > +	f2fs_balance_fs(sbi, true);
> > +
> >  	sb_start_pagefault(inode->i_sb);
> >  
> >  	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
> > @@ -120,8 +123,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
> >  out_sem:
> >  	up_read(&F2FS_I(inode)->i_mmap_sem);
> >  
> > -	f2fs_balance_fs(sbi, dn.node_changed);
> > -
> >  	sb_end_pagefault(inode->i_sb);
> >  err:
> >  	return block_page_mkwrite_return(err);
> > -- 
> > 2.20.1
> > 
> > 
> > 
