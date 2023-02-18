Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB89269BA6F
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 15:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBRO2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 09:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRO2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 09:28:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC121816E
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 06:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802F4B82BC9
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 14:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58FEC433D2;
        Sat, 18 Feb 2023 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676730524;
        bh=LE5Ztuds8aT2g/VX6MUjeUWWtbxBLKG40FASGE5Rv14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W8dTkM8xKo/Y7NL1CbIHOo3EK7CVTnMDjQ6w4uevYvD6teBhiEGOwmiez79HrfVuA
         kLu3MB43TyqQ7y5JDIZS+vzIjASDoVMmBSIN0Z4tasp0V2Aqd74mux2hbzzq7eEGvd
         MH+p24vvj5iznUk0acogJN300uJBRBDy2HWsdABo=
Date:   Sat, 18 Feb 2023 15:28:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 5.15] nilfs2: fix underflow in second superblock
 position calculations
Message-ID: <Y/DgkdiD9UsvUvMf@kroah.com>
References: <16767073279675@kroah.com>
 <20230218142350.2548-1-konishi.ryusuke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218142350.2548-1-konishi.ryusuke@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 18, 2023 at 11:23:49PM +0900, Ryusuke Konishi wrote:
> commit 99b9402a36f0799f25feee4465bfa4b8dfa74b4d upstream.
> 
> Macro NILFS_SB2_OFFSET_BYTES, which computes the position of the second
> superblock, underflows when the argument device size is less than 4096
> bytes.  Therefore, when using this macro, it is necessary to check in
> advance that the device size is not less than a lower limit, or at least
> that underflow does not occur.
> 
> The current nilfs2 implementation lacks this check, causing out-of-bound
> block access when mounting devices smaller than 4096 bytes:
> 
>  I/O error, dev loop0, sector 36028797018963960 op 0x0:(READ) flags 0x0
>  phys_seg 1 prio class 2
>  NILFS (loop0): unable to read secondary superblock (blocksize = 1024)
> 
> In addition, when trying to resize the filesystem to a size below 4096
> bytes, this underflow occurs in nilfs_resize_fs(), passing a huge number
> of segments to nilfs_sufile_resize(), corrupting parameters such as the
> number of segments in superblocks.  This causes excessive loop iterations
> in nilfs_sufile_resize() during a subsequent resize ioctl, causing
> semaphore ns_segctor_sem to block for a long time and hang the writer
> thread:
> 
>  INFO: task segctord:5067 blocked for more than 143 seconds.
>       Not tainted 6.2.0-rc8-syzkaller-00015-gf6feea56f66d #0
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  task:segctord        state:D stack:23456 pid:5067  ppid:2
>  flags:0x00004000
>  Call Trace:
>   <TASK>
>   context_switch kernel/sched/core.c:5293 [inline]
>   __schedule+0x1409/0x43f0 kernel/sched/core.c:6606
>   schedule+0xc3/0x190 kernel/sched/core.c:6682
>   rwsem_down_write_slowpath+0xfcf/0x14a0 kernel/locking/rwsem.c:1190
>   nilfs_transaction_lock+0x25c/0x4f0 fs/nilfs2/segment.c:357
>   nilfs_segctor_thread_construct fs/nilfs2/segment.c:2486 [inline]
>   nilfs_segctor_thread+0x52f/0x1140 fs/nilfs2/segment.c:2570
>   kthread+0x270/0x300 kernel/kthread.c:376
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>   </TASK>
>  ...
>  Call Trace:
>   <TASK>
>   folio_mark_accessed+0x51c/0xf00 mm/swap.c:515
>   __nilfs_get_page_block fs/nilfs2/page.c:42 [inline]
>   nilfs_grab_buffer+0x3d3/0x540 fs/nilfs2/page.c:61
>   nilfs_mdt_submit_block+0xd7/0x8f0 fs/nilfs2/mdt.c:121
>   nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:176
>   nilfs_mdt_get_block+0x12d/0xbb0 fs/nilfs2/mdt.c:251
>   nilfs_sufile_get_segment_usage_block fs/nilfs2/sufile.c:92 [inline]
>   nilfs_sufile_truncate_range fs/nilfs2/sufile.c:679 [inline]
>   nilfs_sufile_resize+0x7a3/0x12b0 fs/nilfs2/sufile.c:777
>   nilfs_resize_fs+0x20c/0xed0 fs/nilfs2/super.c:422
>   nilfs_ioctl_resize fs/nilfs2/ioctl.c:1033 [inline]
>   nilfs_ioctl+0x137c/0x2440 fs/nilfs2/ioctl.c:1301
>   ...
> 
> This fixes these issues by inserting appropriate minimum device size
> checks or anti-underflow checks, depending on where the macro is used.
> 
> Link: https://lkml.kernel.org/r/0000000000004e1dfa05f4a48e6b@google.com
> Link: https://lkml.kernel.org/r/20230214224043.24141-1-konishi.ryusuke@gmail.com
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Reported-by: <syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com>
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> Please apply this patch to the above stable trees instead of the patch
> that could not be applied to them last time.
> 
> This replaces bdev_nr_bytes() with its equivalent reference since it
> does not yet exist in these kernels.  With this tweak, this patch is
> applicable from v5.9 to v5.15.  Also, this patch has been tested against
> the title stable trees.
> 

Now queued up, thanks!

greg k-h
