Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599E148D29E
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 08:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiAMHIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 02:08:54 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30273 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiAMHIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 02:08:54 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JZFrW6XMkzbk1t;
        Thu, 13 Jan 2022 15:08:11 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 13 Jan 2022 15:08:51 +0800
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 15:08:50 +0800
Subject: Re: [PATCH 3/4] bfq: Split shared queues on move between cgroups
From:   "yukuai (C)" <yukuai3@huawei.com>
To:     Jan Kara <jack@suse.cz>, <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <stable@vger.kernel.org>
References: <20220112113529.6355-1-jack@suse.cz>
 <20220112113928.32349-3-jack@suse.cz>
 <3d831e07-61d5-b28b-9886-05f01ede7745@huawei.com>
Message-ID: <29ab0879-b0d3-f235-bd1e-a8af71e8974f@huawei.com>
Date:   Thu, 13 Jan 2022 15:08:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3d831e07-61d5-b28b-9886-05f01ede7745@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/01/13 11:57, yukuai (C) 写道:
> 在 2022/01/12 19:39, Jan Kara 写道:
>> When bfqq is shared by multiple processes it can happen that one of the
>> processes gets moved to a different cgroup (or just starts submitting IO
>> for different cgroup). In case that happens we need to split the merged
>> bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
>> we will just account IO time to wrong entities etc.
>>
>> Similarly if the bfqq is scheduled to merge with another bfqq but the
>> merge didn't happen yet, cancel the merge as it need not be valid
>> anymore.
>>
>> CC: stable@vger.kernel.org
>> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and 
>> cgroups support")
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>   block/bfq-cgroup.c  | 25 ++++++++++++++++++++++++-
>>   block/bfq-iosched.c |  2 +-
>>   block/bfq-iosched.h |  1 +
>>   3 files changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 24a5c5329bcd..dbc117e00783 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -730,8 +730,31 @@ static struct bfq_group 
>> *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
>>       if (sync_bfqq) {
>>           entity = &sync_bfqq->entity;
>> -        if (entity->sched_data != &bfqg->sched_data)
>> +        if (entity->sched_data != &bfqg->sched_data) {
>> +            /*
>> +             * Was the queue we use merged to a different queue?
>> +             * Detach process from the queue as merge need not be
>> +             * valid anymore. We cannot easily cancel the merge as
>> +             * there may be other processes scheduled to this
>> +             * queue.
>> +             */
>> +            if (sync_bfqq->new_bfqq) {
>> +                bfq_put_cooperator(sync_bfqq);
> Hi,
> 
> The patch " bfq: Simplify bfq_put_cooperator()" in last version is not
> in this patch set, thus bfq_put_cooperator() won't set
> sync_bfqq->new_bfqq to NULL. So I guess the problem still exist?
> 
> Thanks,
> Kuai
>> +                bfq_release_process_ref(bfqd, sync_bfqq);
>> +                bic_set_bfqq(bic, NULL, 1);
Hi,

I understand now that you set NULL here, however I still can repoduce
the problem with this patch set applied.

Here I add some debug message:

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index dbc117e00783..2d3da8e73ec0 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -754,6 +754,7 @@ static struct bfq_group 
*__bfq_bic_change_cgroup(struct bfq_data *bfqd,
                                 bfq_mark_bfqq_split_coop(sync_bfqq);
                         }
                         bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+                       printk("%s: bfqq %px move to %px\n", __func__, 
sync_bfqq, bfqg);
                 }
         }

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 07be51bc229b..74d5b575626f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2797,6 +2797,7 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct 
bfq_queue *new_bfqq)
          * are likely to increase the throughput.
          */
         bfqq->new_bfqq = new_bfqq;
+       printk("%s: bfqq %px new_bfqq %px bfqg %px\n", __func__, bfqq, 
new_bfqq, bfqq_group(bfqq));
         new_bfqq->ref += process_refs;
         return new_bfqq;
  }
@@ -2963,8 +2964,14 @@ bfq_setup_cooperator(struct bfq_data *bfqd, 
struct bfq_queue *bfqq,
         if (bfq_too_late_for_merging(bfqq))
                 return NULL;

-       if (bfqq->new_bfqq)
+       if (bfqq->new_bfqq) {
+               if (bfqq->entity.parent != bfqq->new_bfqq->entity.parent) {
+                       printk("%s: bfqq %px (%px), new_bfqq %px 
(%px)\n", __func__,
+                                       bfqq, bfqq_group(bfqq), 
bfqq->new_bfqq, bfqq_group(bfqq->new_bfqq));
+                       BUG_ON(1);
+               }
                 return bfqq->new_bfqq;
+       }

         if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
                 return NULL;

And here is the messages when BUG_ON is triggered（much easier than the
uaf problem):

[  157.237821] bfq_setup_merge: bfqq ffff888140654dc0 new_bfqq 
ffff888174122100 bfqg ffff88817abc6000
[  157.238739] __bfq_bic_change_cgroup: bfqq ffff888174122100 move to 
ffff888104b7c000
[  157.239675] bfq_setup_cooperator: bfqq ffff888140654dc0 
(ffff88817abc6000), new_bfqq ffff888174122100 (ffff888104b7c000)
[  157.240696] ------------[ cut here ]------------
[  157.241113] kernel BUG at block/bfq-iosched.c:2971!
[  157.241565] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[  157.242042] CPU: 4 PID: 3089 Comm: fio Tainted: G        W 
5.16.0-next-20220111+ #361
[  157.242810] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 
04/01/2014
[  157.243985] RIP: 0010:bfq_setup_cooperator+0x413/0x7e0
[  157.244470] Code: 8b 65 30 48 89 ef e8 9c ab 00 00 49 89 d9 48 89 ea 
48 c7 c6 00 d9 d9 82 48 89 c1 4d 89 e0 48 c7 c7 80 d4 d9 82 e8 88 3f 91 
00 <0f> 0b 48 8d bd f0 01 00 00 e8 0f 77 84 c
[  157.246132] RSP: 0018:ffff888171ecf1e0 EFLAGS: 00010082
[  157.246609] RAX: 000000000000006c RBX: ffff888104b7c000 RCX: 
0000000000000000
[  157.247243] RDX: 0000000000000002 RSI: ffffffff82da9fc0 RDI: 
ffffed102e3d9e2f
[  157.247889] RBP: ffff888140654dc0 R08: 000000000000006c R09: 
ffffed106cd06751
[  157.248529] R10: ffff888366833a87 R11: ffffed106cd06750 R12: 
ffff888174122100
[  157.249160] R13: 0000000000000000 R14: ffff88817abc5000 R15: 
ffff888174122100
[  157.249801] FS:  00007f21fe8d5700(0000) GS:ffff888366800000(0000) 
knlGS:0000000000000000
[  157.250524] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  157.251042] CR2: 000055f2bb593770 CR3: 0000000105045000 CR4: 
00000000000006e0
[  157.251688] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  157.252327] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  157.252970] Call Trace:
[  157.253207]  <TASK>
[  157.253418]  ? bic_set_bfqq+0x80/0x80
[  157.253757]  ? memcpy+0x39/0x60
[  157.254052]  ? blk_integrity_merge_bio+0x2e/0x150
[  157.254490]  bfq_allow_bio_merge+0x9a/0x130
[  157.254874]  elv_merge+0x76/0x1b0
[  157.255185]  blk_mq_sched_try_merge+0x7a/0x2c0
[  157.255603]  ? preempt_count_sub+0x14/0xc0
[  157.255985]  ? bio_attempt_front_merge+0x8b0/0x8b0
[  157.256427]  ? kernfs_path_from_node+0x4c/0x60
[  157.256839]  ? bfq_bic_update_cgroup+0x211/0x2c0
[  157.257269]  bfq_bio_merge+0x141/0x1d0
[  157.257629]  ? bfq_request_merge+0xe0/0xe0
[  157.258001]  ? blk_mq_sched_bio_merge+0x43/0x170
[  157.258426]  blk_mq_submit_bio+0x7a6/0xba0
[  157.258800]  ? submit_bio_checks+0x4ed/0x9f0
[  157.259191]  ? blk_mq_try_issue_list_directly+0x1d0/0x1d0
[  157.259685]  ? mempool_alloc+0x250/0x250
[  157.260040]  ? mempool_destroy+0x20/0x20
[  157.260401]  ? __submit_bio+0x61/0x290
[  157.260751]  submit_bio_noacct+0x441/0x480
[  157.261125]  ? __submit_bio+0x290/0x290
[  157.261486]  ? bio_add_page+0xbc/0x100
[  157.261831]  submit_bh_wbc+0x2e7/0x320
[  157.262179]  __block_write_full_page+0x3f3/0x870
[  157.262609]  ? blkdev_write_end+0x150/0x150
[  157.262994]  ? end_buffer_write_sync+0xa0/0xa0
[  157.263401]  __writepage+0x39/0xb0
[  157.263718]  write_cache_pages+0x27e/0x840
[  157.264091]  ? tag_pages_for_writeback+0x250/0x250
[  157.264538]  ? wb_writeout_inc+0x150/0x150
[  157.264919]  ? _raw_spin_lock_irqsave+0xe0/0xe0
[  157.265339]  ? xas_start+0x7b/0x170
[  157.265673]  generic_writepages+0xb9/0x110
[  157.266042]  ? write_cache_pages+0x840/0x840
[  157.266432]  ? xas_set_mark+0xd0/0xd0
[  157.266765]  do_writepages+0x104/0x320
[  157.267106]  ? __rcu_read_unlock+0x4e/0x250
[  157.267492]  ? page_writeback_cpu_online+0x10/0x10
[  157.267919]  ? _raw_spin_lock+0x87/0xe0
[  157.268264]  ? _raw_spin_lock_irqsave+0xe0/0xe0
[  157.268676]  ? inode_to_bdi+0x79/0x90
[  157.269012]  filemap_fdatawrite_wbc+0x91/0xc0
[  157.269412]  filemap_write_and_wait_range+0xbb/0x140
[  157.269851]  ? filemap_fdatawait_keep_errors+0x30/0x30
[  157.270309]  ? generic_file_direct_write+0xcb/0x250
[  157.270748]  __generic_file_write_iter+0x1fc/0x250
[  157.271175]  blkdev_write_iter+0x21a/0x300
[  157.271547]  ? blkdev_llseek+0x80/0x80
[  157.271884]  ? preempt_count_sub+0x14/0xc0
[  157.272247]  ? __update_load_avg_cfs_rq+0x51/0x530
[  157.272678]  ? __update_load_avg_cfs_rq+0x51/0x530
[  157.273111]  new_sync_write+0x24c/0x360
[  157.273464]  ? new_sync_read+0x360/0x360
[  157.273819]  ? set_next_entity+0xb1/0x280
[  157.274178]  ? preempt_count_sub+0x14/0xc0
[  157.274551]  ? __rcu_read_unlock+0x4e/0x250
[  157.274926]  vfs_write+0x291/0x3d0
[  157.275238]  ksys_pwrite64+0xe7/0x110
[  157.275580]  ? __ia32_sys_pread64+0x60/0x60
[  157.275954]  ? switch_fpu_return+0x9d/0x140
[  157.276329]  do_syscall_64+0x35/0x80
[  157.276659]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  157.277110] RIP: 0033:0x7f220f1f0b23

It seems that when q1 and q2 are merged(q1->new_bfqq = q2), and q2
is moved to another bfqg through __bfq_bic_change_cgroug(), the q2
is not split before the bfq_setup_cooperator() is called.

Thanks,
Kuai
