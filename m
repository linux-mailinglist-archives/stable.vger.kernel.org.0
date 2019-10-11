Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07193D37C7
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 05:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfJKDQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 23:16:16 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48258 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726096AbfJKDQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 23:16:16 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1B18565B942655BC239C;
        Fri, 11 Oct 2019 11:16:14 +0800 (CST)
Received: from [127.0.0.1] (10.177.219.49) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 11:16:10 +0800
Subject: Re: [PATCH v4] block: fix null pointer dereference in
 blk_mq_rq_timed_out()
To:     Jack Wang <jack.wang.usish@gmail.com>
CC:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        stable <stable@vger.kernel.org>, <guoqing.jiang@cloud.ionos.com>,
        <jinpu.wang@cloud.ionos.com>
References: <20190925122025.31246-1-yuyufen@huawei.com>
 <CA+res+QQtXD6phz=Ko-_n7eWVySrJA1kqgmMW3h3YUX+5RQ_7w@mail.gmail.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <9f99de42-9edb-d7df-df8c-e994ada6613c@huawei.com>
Date:   Fri, 11 Oct 2019 11:16:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CA+res+QQtXD6phz=Ko-_n7eWVySrJA1kqgmMW3h3YUX+5RQ_7w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.219.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/10/9 16:26, Jack Wang wrote:
>
>> We got a null pointer deference BUG_ON in blk_mq_rq_timed_out()
>> as following:
>>
>> [  108.825472] BUG: kernel NULL pointer dereference, address: 0000000000000040
>> [  108.827059] PGD 0 P4D 0
>> [  108.827313] Oops: 0000 [#1] SMP PTI
>> [  108.827657] CPU: 6 PID: 198 Comm: kworker/6:1H Not tainted 5.3.0-rc8+ #431
>> [  108.829503] Workqueue: kblockd blk_mq_timeout_work
>> [  108.829913] RIP: 0010:blk_mq_check_expired+0x258/0x330
>> [  108.838191] Call Trace:
>> [  108.838406]  bt_iter+0x74/0x80
>> [  108.838665]  blk_mq_queue_tag_busy_iter+0x204/0x450
>> [  108.839074]  ? __switch_to_asm+0x34/0x70
>> [  108.839405]  ? blk_mq_stop_hw_queue+0x40/0x40
>> [  108.839823]  ? blk_mq_stop_hw_queue+0x40/0x40
>> [  108.840273]  ? syscall_return_via_sysret+0xf/0x7f
>> [  108.840732]  blk_mq_timeout_work+0x74/0x200
>> [  108.841151]  process_one_work+0x297/0x680
>> [  108.841550]  worker_thread+0x29c/0x6f0
>> [  108.841926]  ? rescuer_thread+0x580/0x580
>> [  108.842344]  kthread+0x16a/0x1a0
>> [  108.842666]  ? kthread_flush_work+0x170/0x170
>> [  108.843100]  ret_from_fork+0x35/0x40
>>
>> The bug is caused by the race between timeout handle and completion for
>> flush request.
>>
>> When timeout handle function blk_mq_rq_timed_out() try to read
>> 'req->q->mq_ops', the 'req' have completed and reinitiated by next
>> flush request, which would call blk_rq_init() to clear 'req' as 0.
>>
>> After commit 12f5b93145 ("blk-mq: Remove generation seqeunce"),
>> normal requests lifetime are protected by refcount. Until 'rq->ref'
>> drop to zero, the request can really be free. Thus, these requests
>> cannot been reused before timeout handle finish.
>>
>> However, flush request has defined .end_io and rq->end_io() is still
>> called even if 'rq->ref' doesn't drop to zero. After that, the 'flush_rq'
>> can be reused by the next flush request handle, resulting in null
>> pointer deference BUG ON.
>>
>> We fix this problem by covering flush request with 'rq->ref'.
>> If the refcount is not zero, flush_end_io() return and wait the
>> last holder recall it. To record the request status, we add a new
>> entry 'rq_status', which will be used in flush_end_io().
>>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Keith Busch <keith.busch@intel.com>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: stable@vger.kernel.org # v4.18+
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>>
> Hi Yufen,
>
> Can you share your reproducer, I think the bug was there for long
> time, we hit it in kernel 4.4.
> We also need to fix it for older LTS kernel.
>
> Do you have an idea, how should we fix it for older LTS kernel?
>

I have reproduced the bug by increasing delay after doing memset()
in blk_rq_init() and before calling blk_mq_rq_timed_out() in 
blk_mq_check_expired().

To make sure the request will be timeout, I have also increase delay
for flush request after blk_mq_start_request() in virtio_queue_rq() for
my virtio disk. Then, we just issue a flush request for the disk by fio.
The BUG_ON will be triggered.

For LTS 4.4 or older kernel, the race between timeout handle and completion
for normal request have not yet resolved.
So, IMO, we should fix the bug first by merging commit 12f5b93145
("blk-mq: Remove generation seqeunce") and its related patches.

After that, this patch can also be merged.

Thanks,
Yufen

