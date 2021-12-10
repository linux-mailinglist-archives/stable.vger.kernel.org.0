Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CED46F99D
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 04:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhLJDd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 22:33:26 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33697 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231314AbhLJDd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 22:33:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-7861r_1639106989;
Received: from 30.226.12.31(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-7861r_1639106989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 11:29:50 +0800
Subject: Re: [PATCH v2 2/2] io_uring: ensure task_work gets run as part of
 cancelations
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-3-axboe@kernel.dk>
 <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <227847a6-a76c-3942-a563-7d492b0d2ced@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 11:29:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/12/10 上午12:16, Jens Axboe 写道:
> If we successfully cancel a work item but that work item needs to be
> processed through task_work, then we can be sleeping uninterruptibly
> in io_uring_cancel_generic() and never process it. Hence we don't
> make forward progress and we end up with an uninterruptible sleep
> warning.
>
> Add the waitqueue earlier to ensure that any wakeups from cancelations
> are seen, and switch to using uninterruptible sleep so that postponed
^ typo
> task_work additions get seen and processed.
>
> While in there, correct a comment that should be IFF, not IIF.
>
> Reported-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> v2 - don't move prepare_to_wait(), it'll run into issues with locking
>       etc, and we don't need to as the inflight tracking guards against
>       missing a wakeup for a completion.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b4d5b8d168bf..111db33b940e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9826,7 +9826,7 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
>   
>   /*
>    * Find any io_uring ctx that this task has registered or done IO on, and cancel
> - * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
> + * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
>    */
>   static __cold void io_uring_cancel_generic(bool cancel_all,
>   					   struct io_sq_data *sqd)
> @@ -9868,8 +9868,10 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
>   							     cancel_all);
>   		}
>   
> -		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
> +		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
> +		io_run_task_work();
>   		io_uring_drop_tctx_refs(current);
> +
>   		/*
>   		 * If we've seen completions, retry without waiting. This
>   		 * avoids a race where a completion comes in before we did
>
