Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A5C271F1D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 11:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIUJoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 05:44:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:51124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgIUJn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 05:43:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 791C9AB0E;
        Mon, 21 Sep 2020 09:44:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20095DA6E0; Mon, 21 Sep 2020 11:42:42 +0200 (CEST)
Date:   Mon, 21 Sep 2020 11:42:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix overflow when copying corrupt csums for a
 message
Message-ID: <20200921094241.GH6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20200921075714.33372-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921075714.33372-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 04:57:14PM +0900, Johannes Thumshirn wrote:
> Syzkaller reported a buffer overflow in btree_readpage_end_io_hook()
> when loop mounting a crafted image:
> 
>   detected buffer overflow in memcpy
>   ------------[ cut here ]------------
>   kernel BUG at lib/string.c:1129!
>   invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>   CPU: 1 PID: 26 Comm: kworker/u4:2 Not tainted 5.9.0-rc4-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Workqueue: btrfs-endio-meta btrfs_work_helper
>   RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
>   RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
>   RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
>   RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
>   RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
>   R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
>   R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
>   FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000557335f440d0 CR3: 000000009647d000 CR4: 00000000001506e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    memcpy include/linux/string.h:405 [inline]
>    btree_readpage_end_io_hook.cold+0x206/0x221 fs/btrfs/disk-io.c:642
>    end_bio_extent_readpage+0x4de/0x10c0 fs/btrfs/extent_io.c:2854
>    bio_endio+0x3cf/0x7f0 block/bio.c:1449
>    end_workqueue_fn+0x114/0x170 fs/btrfs/disk-io.c:1695
>    btrfs_work_helper+0x221/0xe20 fs/btrfs/async-thread.c:318
>    process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>    kthread+0x3b5/0x4a0 kernel/kthread.c:292
>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>   Modules linked in:
>   ---[ end trace b68924293169feef ]---
>   RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
>   RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
>   RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
>   RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
>   RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
>   R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
>   R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
>   FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f95b7c4d008 CR3: 000000009647d000 CR4: 00000000001506e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> The overflow happens, because in btree_readpage_end_io_hook() we assume
> that we have found a 4 byte checksum instead of the real possible 32
> bytes we have for the checksums.
> 
> With the fix applied:
> 
> [   35.726623] BTRFS: device fsid 815caf9a-dc43-4d2a-ac54-764b8333d765 devid 1 transid 5 /dev/loop0 scanned by syz-repro (215)
> [   35.738994] BTRFS info (device loop0): disk space caching is enabled
> [   35.738998] BTRFS info (device loop0): has skinny extents
> [   35.743337] BTRFS warning (device loop0): loop0 checksum verify failed on 1052672 wanted 0xf9c035fc8d239a54 found 0x67a25c14b7eabcf9 level 0
> [   35.743420] BTRFS error (device loop0): failed to read chunk root
> [   35.745899] BTRFS error (device loop0): open_ctree failed
> 
> Reported-by: syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com
> Fixes: d5178578bcd4 ("btrfs: directly call into crypto framework for checksumming")
> CC: stable@vger.kernel.org # 5.4+
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> ---
> Changes to v1:
> - Use CSUM_FMT (David)
> - Fix the 2nd possible overflow (David)
> - Remove some unnecessary local variables and memcpy (David)
> - Update commit log to have the now correct new log entries

Thanks, I'll take this as-is so it's the obvious minimal fix, there are
a few more cleanups possible.
