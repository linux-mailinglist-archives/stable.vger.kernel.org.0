Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8FF47EA62
	for <lists+stable@lfdr.de>; Fri, 24 Dec 2021 02:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350736AbhLXBpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 20:45:06 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33908 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350732AbhLXBpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 20:45:06 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JKqcR4kfTzcc4r;
        Fri, 24 Dec 2021 09:44:39 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 09:45:03 +0800
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 09:45:03 +0800
Subject: Re: [PATCH 2/3] bfq: Avoid merging queues with different parents
To:     Jan Kara <jack@suse.cz>, <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <stable@vger.kernel.org>
References: <20211223171425.3551-1-jack@suse.cz>
 <20211223173207.15388-2-jack@suse.cz>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <fec7558a-1559-dae0-fe21-d11876dc7473@huawei.com>
Date:   Fri, 24 Dec 2021 09:45:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20211223173207.15388-2-jack@suse.cz>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2021/12/24 1:31, Jan Kara Ð´µÀ:
> It can happen that the parent of a bfqq changes between the moment we
> decide two queues are worth to merge (and set bic->stable_merge_bfqq)
> and the moment bfq_setup_merge() is called. This can happen e.g. because
> the process submitted IO for a different cgroup and thus bfqq got
> reparented. It can even happen that the bfqq we are merging with has
> parent cgroup that is already offline and going to be destroyed in which
> case the merge can lead to use-after-free issues such as:
> 
> BUG: KASAN: use-after-free in __bfq_deactivate_entity+0x9cb/0xa50
> Read of size 8 at addr ffff88800693c0c0 by task runc:[2:INIT]/10544
> 
> CPU: 0 PID: 10544 Comm: runc:[2:INIT] Tainted: G            E     5.15.2-0.g5fb85fd-default #1 openSUSE Tumbleweed (unreleased) f1f3b891c72369aebecd2e43e4641a6358867c70
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
> Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x46/0x5a
>   print_address_description.constprop.0+0x1f/0x140
>   ? __bfq_deactivate_entity+0x9cb/0xa50
>   kasan_report.cold+0x7f/0x11b
>   ? __bfq_deactivate_entity+0x9cb/0xa50
>   __bfq_deactivate_entity+0x9cb/0xa50
>   ? update_curr+0x32f/0x5d0
>   bfq_deactivate_entity+0xa0/0x1d0
>   bfq_del_bfqq_busy+0x28a/0x420
>   ? resched_curr+0x116/0x1d0
>   ? bfq_requeue_bfqq+0x70/0x70
>   ? check_preempt_wakeup+0x52b/0xbc0
>   __bfq_bfqq_expire+0x1a2/0x270
>   bfq_bfqq_expire+0xd16/0x2160
>   ? try_to_wake_up+0x4ee/0x1260
>   ? bfq_end_wr_async_queues+0xe0/0xe0
>   ? _raw_write_unlock_bh+0x60/0x60
>   ? _raw_spin_lock_irq+0x81/0xe0
>   bfq_idle_slice_timer+0x109/0x280
>   ? bfq_dispatch_request+0x4870/0x4870
>   __hrtimer_run_queues+0x37d/0x700
>   ? enqueue_hrtimer+0x1b0/0x1b0
>   ? kvm_clock_get_cycles+0xd/0x10
>   ? ktime_get_update_offsets_now+0x6f/0x280
>   hrtimer_interrupt+0x2c8/0x740
> 
> Fix the problem by checking that the parent of the two bfqqs we are
> merging in bfq_setup_merge() is the same.
> 
> Link: https://lore.kernel.org/linux-block/20211125172809.GC19572@quack2.suse.cz/
> CC: stable@vger.kernel.org
> Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   block/bfq-iosched.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 056399185c2f..0da47f2ca781 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -2638,6 +2638,14 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
>   	if (process_refs == 0 || new_process_refs == 0)
>   		return NULL;
>   
> +	/*
> +	 * Make sure merged queues belong to the same parent. Parents could
> +	 * have changed since the time we decided the two queues are suitable
> +	 * for merging.
> +	 */
> +	if (new_bfqq->entity.parent != bfqq->entity.parent)
> +		return NULL;
> +
Hi,

This seems unnecessary, the caller of bfq_setup_merge() aready make sure
bfqq and new_bfqq are under the same bfqg. Am I missing something?

Thanks,
Kuai
>   	bfq_log_bfqq(bfqq->bfqd, bfqq, "scheduling merge with queue %d",
>   		new_bfqq->pid);
>   
> 
