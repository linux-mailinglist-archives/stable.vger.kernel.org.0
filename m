Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295B061708
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfGGToq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57234 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727544AbfGGTiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:07 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006gr-7D; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005ad-Qc; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Daniel Axtens" <dja@axtens.net>, "Jens Axboe" <axboe@kernel.dk>,
        "Kent Overstreet" <koverstreet@google.com>,
        "Coly Li" <colyli@suse.de>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.963232624@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 054/129] bcache: never writeback a discard operation
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Axtens <dja@axtens.net>

commit 9951379b0ca88c95876ad9778b9099e19a95d566 upstream.

Some users see panics like the following when performing fstrim on a
bcached volume:

[  529.803060] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  530.183928] #PF error: [normal kernel read fault]
[  530.412392] PGD 8000001f42163067 P4D 8000001f42163067 PUD 1f42168067 PMD 0
[  530.750887] Oops: 0000 [#1] SMP PTI
[  530.920869] CPU: 10 PID: 4167 Comm: fstrim Kdump: loaded Not tainted 5.0.0-rc1+ #3
[  531.290204] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360 Gen9, BIOS P89 12/27/2015
[  531.693137] RIP: 0010:blk_queue_split+0x148/0x620
[  531.922205] Code: 60 38 89 55 a0 45 31 db 45 31 f6 45 31 c9 31 ff 89 4d 98 85 db 0f 84 7f 04 00 00 44 8b 6d 98 4c 89 ee 48 c1 e6 04 49 03 70 78 <8b> 46 08 44 8b 56 0c 48
8b 16 44 29 e0 39 d8 48 89 55 a8 0f 47 c3
[  532.838634] RSP: 0018:ffffb9b708df39b0 EFLAGS: 00010246
[  533.093571] RAX: 00000000ffffffff RBX: 0000000000046000 RCX: 0000000000000000
[  533.441865] RDX: 0000000000000200 RSI: 0000000000000000 RDI: 0000000000000000
[  533.789922] RBP: ffffb9b708df3a48 R08: ffff940d3b3fdd20 R09: 0000000000000000
[  534.137512] R10: ffffb9b708df3958 R11: 0000000000000000 R12: 0000000000000000
[  534.485329] R13: 0000000000000000 R14: 0000000000000000 R15: ffff940d39212020
[  534.833319] FS:  00007efec26e3840(0000) GS:ffff940d1f480000(0000) knlGS:0000000000000000
[  535.224098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  535.504318] CR2: 0000000000000008 CR3: 0000001f4e256004 CR4: 00000000001606e0
[  535.851759] Call Trace:
[  535.970308]  ? mempool_alloc_slab+0x15/0x20
[  536.174152]  ? bch_data_insert+0x42/0xd0 [bcache]
[  536.403399]  blk_mq_make_request+0x97/0x4f0
[  536.607036]  generic_make_request+0x1e2/0x410
[  536.819164]  submit_bio+0x73/0x150
[  536.980168]  ? submit_bio+0x73/0x150
[  537.149731]  ? bio_associate_blkg_from_css+0x3b/0x60
[  537.391595]  ? _cond_resched+0x1a/0x50
[  537.573774]  submit_bio_wait+0x59/0x90
[  537.756105]  blkdev_issue_discard+0x80/0xd0
[  537.959590]  ext4_trim_fs+0x4a9/0x9e0
[  538.137636]  ? ext4_trim_fs+0x4a9/0x9e0
[  538.324087]  ext4_ioctl+0xea4/0x1530
[  538.497712]  ? _copy_to_user+0x2a/0x40
[  538.679632]  do_vfs_ioctl+0xa6/0x600
[  538.853127]  ? __do_sys_newfstat+0x44/0x70
[  539.051951]  ksys_ioctl+0x6d/0x80
[  539.212785]  __x64_sys_ioctl+0x1a/0x20
[  539.394918]  do_syscall_64+0x5a/0x110
[  539.568674]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

We have observed it where both:
1) LVM/devmapper is involved (bcache backing device is LVM volume) and
2) writeback cache is involved (bcache cache_mode is writeback)

On one machine, we can reliably reproduce it with:

 # echo writeback > /sys/block/bcache0/bcache/cache_mode
   (not sure whether above line is required)
 # mount /dev/bcache0 /test
 # for i in {0..10}; do
	file="$(mktemp /test/zero.XXX)"
	dd if=/dev/zero of="$file" bs=1M count=256
	sync
	rm $file
    done
  # fstrim -v /test

Observing this with tracepoints on, we see the following writes:

fstrim-18019 [022] .... 91107.302026: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4260112 + 196352 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302050: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4456464 + 262144 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302075: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4718608 + 81920 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302094: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5324816 + 180224 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302121: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5505040 + 262144 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302145: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5767184 + 81920 hit 0 bypass 1
fstrim-18019 [022] .... 91107.308777: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 6373392 + 180224 hit 1 bypass 0
<crash>

Note the final one has different hit/bypass flags.

This is because in should_writeback(), we were hitting a case where
the partial stripe condition was returning true and so
should_writeback() was returning true early.

If that hadn't been the case, it would have hit the would_skip test, and
as would_skip == s->iop.bypass == true, should_writeback() would have
returned false.

Looking at the git history from 'commit 72c270612bd3 ("bcache: Write out
full stripes")', it looks like the idea was to optimise for raid5/6:

       * If a stripe is already dirty, force writes to that stripe to
	 writeback mode - to help build up full stripes of dirty data

To fix this issue, make sure that should_writeback() on a discard op
never returns true.

More details of debugging:
https://www.spinics.net/lists/linux-bcache/msg06996.html

Previous reports:
 - https://bugzilla.kernel.org/show_bug.cgi?id=201051
 - https://bugzilla.kernel.org/show_bug.cgi?id=196103
 - https://www.spinics.net/lists/linux-bcache/msg06885.html

(Coly Li: minor modification to follow maximum 75 chars per line rule)

Cc: Kent Overstreet <koverstreet@google.com>
Fixes: 72c270612bd3 ("bcache: Write out full stripes")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.16: check REQ_DISCARD flag instead of calling bio_op()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/writeback.h | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -68,6 +68,9 @@ static inline bool should_writeback(stru
 	    in_use > CUTOFF_WRITEBACK_SYNC)
 		return false;
 
+	if (bio->bi_rw & REQ_DISCARD)
+		return false;
+
 	if (dc->partial_stripes_expensive &&
 	    bcache_dev_stripe_dirty(dc, bio->bi_iter.bi_sector,
 				    bio_sectors(bio)))

