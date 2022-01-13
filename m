Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED96048D127
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 04:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiAMD5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 22:57:51 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30272 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiAMD5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 22:57:50 -0500
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JZ9c32W1lzbjvj;
        Thu, 13 Jan 2022 11:57:07 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 11:57:47 +0800
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 11:57:46 +0800
Subject: Re: [PATCH 3/4] bfq: Split shared queues on move between cgroups
To:     Jan Kara <jack@suse.cz>, <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <stable@vger.kernel.org>
References: <20220112113529.6355-1-jack@suse.cz>
 <20220112113928.32349-3-jack@suse.cz>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <3d831e07-61d5-b28b-9886-05f01ede7745@huawei.com>
Date:   Thu, 13 Jan 2022 11:57:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220112113928.32349-3-jack@suse.cz>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2022/01/12 19:39, Jan Kara Ð´µÀ:
> When bfqq is shared by multiple processes it can happen that one of the
> processes gets moved to a different cgroup (or just starts submitting IO
> for different cgroup). In case that happens we need to split the merged
> bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
> we will just account IO time to wrong entities etc.
> 
> Similarly if the bfqq is scheduled to merge with another bfqq but the
> merge didn't happen yet, cancel the merge as it need not be valid
> anymore.
> 
> CC: stable@vger.kernel.org
> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   block/bfq-cgroup.c  | 25 ++++++++++++++++++++++++-
>   block/bfq-iosched.c |  2 +-
>   block/bfq-iosched.h |  1 +
>   3 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 24a5c5329bcd..dbc117e00783 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -730,8 +730,31 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
>   
>   	if (sync_bfqq) {
>   		entity = &sync_bfqq->entity;
> -		if (entity->sched_data != &bfqg->sched_data)
> +		if (entity->sched_data != &bfqg->sched_data) {
> +			/*
> +			 * Was the queue we use merged to a different queue?
> +			 * Detach process from the queue as merge need not be
> +			 * valid anymore. We cannot easily cancel the merge as
> +			 * there may be other processes scheduled to this
> +			 * queue.
> +			 */
> +			if (sync_bfqq->new_bfqq) {
> +				bfq_put_cooperator(sync_bfqq);
Hi,

The patch " bfq: Simplify bfq_put_cooperator()" in last version is not
in this patch set, thus bfq_put_cooperator() won't set
sync_bfqq->new_bfqq to NULL. So I guess the problem still exist?

Thanks,
Kuai
> +				bfq_release_process_ref(bfqd, sync_bfqq);
> +				bic_set_bfqq(bic, NULL, 1);
> +				return bfqg;
> +			}
> +			/*
> +			 * Moving bfqq that is shared with another process?
> +			 * Split the queues at the nearest occasion as the
> +			 * processes can be in different cgroups now.
> +			 */
> +			if (bfq_bfqq_coop(sync_bfqq)) {
> +				bic->stably_merged = false;
> +				bfq_mark_bfqq_split_coop(sync_bfqq);
> +			}
>   			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +		}
>   	}
>   
>   	return bfqg;
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0da47f2ca781..361d321b012a 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -5184,7 +5184,7 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq)
>   	bfq_put_queue(bfqq);
>   }
>   
> -static void bfq_put_cooperator(struct bfq_queue *bfqq)
> +void bfq_put_cooperator(struct bfq_queue *bfqq)
>   {
>   	struct bfq_queue *__bfqq, *next;
>   
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index a73488eec8a4..6e250db2138e 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -976,6 +976,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
>   void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>   		     bool compensate, enum bfqq_expiration reason);
>   void bfq_put_queue(struct bfq_queue *bfqq);
> +void bfq_put_cooperator(struct bfq_queue *bfqq);
>   void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
>   void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
>   void bfq_schedule_dispatch(struct bfq_data *bfqd);
> 
