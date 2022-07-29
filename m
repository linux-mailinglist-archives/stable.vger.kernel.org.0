Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201E7584BD8
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiG2GaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 02:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiG2G3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 02:29:52 -0400
X-Greylist: delayed 1050 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Jul 2022 23:29:25 PDT
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E792E7FE4E
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 23:29:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LvHFD3bLTz6R4t8;
        Fri, 29 Jul 2022 14:10:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S4;
        Fri, 29 Jul 2022 14:11:53 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        snitzer@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH stable 5.10 0/3] dm: fix nullptr crash
Date:   Fri, 29 Jul 2022 14:23:53 +0800
Message-Id: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4rCFyxJr45GrWrWF45KFg_yoW7Jr43pr
        43Kr45Cr48Kr17JF43AF1UJr1UJr47AF1UXryxGr18J3Wj93WUXryUJr4UAryUJr4UZry7
        tr1DJw48tr1UtaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This patchset backport three patches to fix a crash found by our test:

BUG: kernel NULL pointer dereference, address: 00000000000001a0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 1317 Comm: mount Not tainted 5.10.0-16691-gf6076432827d-dirty #169
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-4
RIP: 0010:__blk_mq_sched_bio_merge+0x9d/0x1a0
Code: 87 1e 9d 89 d0 25 00 00 00 01 0f 85 ad 00 00 00 48 83 05 25 a1 37 0c 01 3
RSP: 0018:ffffc90000473b50 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90000473b98
RDX: 0000000000001000 RSI: ffff8881080c7500 RDI: ffff888103a9cc18
RBP: ffff88813bc80000 R08: 0000000000000001 R09: 0000000000000000
R10: ffff88810710be30 R11: 0000000000000000 R12: ffff888103a9cc18
R13: ffff8881080c7500 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f51bcdbb040(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000001a0 CR3: 000000010d715000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Call Trace:
 blk_mq_submit_bio+0x115/0xd80
 submit_bio_noacct+0x4ff/0x610
 submit_bio+0xaa/0x1a0
 submit_bh_wbc+0x1cb/0x2f0
 submit_bh+0x17/0x20
 ext4_read_bh+0x63/0x170
 ext4_read_bh_lock+0x2c/0xd0
 __ext4_sb_bread_gfp.isra.0+0xa0/0xf0
 ext4_fill_super+0x21f/0x5610
 ? pointer+0x31b/0x5a0
 ? vsnprintf+0x131/0x7d0
 mount_bdev+0x233/0x280
 ? ext4_calculate_overhead+0x660/0x660
 ext4_mount+0x19/0x30
 legacy_get_tree+0x35/0x90
 vfs_get_tree+0x29/0x100
 ? capable+0x1d/0x30
 path_mount+0x8a7/0x1150
 do_mount+0x8d/0xc0
 __se_sys_mount+0x14a/0x220
 __x64_sys_mount+0x29/0x40
 do_syscall_64+0x45/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f51bbe1623a
Code: 48 8b 0d 51 dc 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 8
RSP: 002b:00007fff173ae898 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000056169a120030 RCX: 00007f51bbe1623a
RDX: 000056169a120210 RSI: 000056169a120250 RDI: 000056169a120230
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fff173ad798
R10: 00000000c0ed0000 R11: 0000000000000246 R12: 000056169a120230
R13: 000056169a120210 R14: 0000000000000000 R15: 00007f51bcbac184
Modules linked in: dm_service_time dm_multipath
CR2: 00000000000001a0
---[ end trace ac5d86e09fdc7c98 ]---
RIP: 0010:__blk_mq_sched_bio_merge+0x9d/0x1a0
Code: 87 1e 9d 89 d0 25 00 00 00 01 0f 85 ad 00 00 00 48 83 05 25 a1 37 0c 01 3
RSP: 0018:ffffc90000473b50 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90000473b98
RDX: 0000000000001000 RSI: ffff8881080c7500 RDI: ffff888103a9cc18
RBP: ffff88813bc80000 R08: 0000000000000001 R09: 0000000000000000
R10: ffff88810710be30 R11: 0000000000000000 R12: ffff888103a9cc18
R13: ffff8881080c7500 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f51bcdbb040(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f10e97a5000 CR3: 000000010d715000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception ]---

root cause:
t1 dm-mpath		t2 mount

alloc_dev
 md->queue = blk_alloc_queue
 add_disk_no_queue_reg

dm_setup_md_queue
 case DM_TYPE_REQUEST_BASED -> multipath
  md->disk->fops = &dm_rq_blk_dops;
			ext4_fill_super
                        ┊__ext4_sb_bread_gfp
                        ┊ ext4_read_bh
                        ┊  submit_bio -> queue is not initialized yet
                        ┊   __blk_mq_sched_bio_merge
                        ┊    ctx = blk_mq_get_ctx(q); -> ctx is NULL
  dm_mq_init_request_queue

Patch 3 is the fix patch, and patch 1,2 is needed to backport patch 3.

Please noted that there are lots of conficts between 5.10 and mainline,
and I made plenty adaptations in these patches.

I already tested this patchset with dmtest create/remove tests:

dmtest run --suite thin-provisioning -t /Creation\Deletion/

Christoph Hellwig (3):
  block: look up holders by bdev
  block: support delayed holder registration
  dm: delay registering the gendisk

 block/genhd.c             |  13 +++++
 drivers/md/dm.c           |  24 +++++----
 fs/block_dev.c            | 105 +++++++++++++++++++++++++++-----------
 include/linux/blk_types.h |   3 --
 include/linux/genhd.h     |   9 +++-
 5 files changed, 110 insertions(+), 44 deletions(-)

-- 
2.31.1

