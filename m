Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793E4D09C3
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJII1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:27:08 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36681 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJII1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 04:27:08 -0400
Received: by mail-lj1-f195.google.com with SMTP id v24so1579068ljj.3;
        Wed, 09 Oct 2019 01:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yfhq1E9yXZ/dYz+RVAVCb0hvNZMSRLRp5FqR0oMniw8=;
        b=UhQ+YyCtUNwtGdm86BvN4GFLTsXupQwGs/C6jW6LXsoowPk1p8iIIACRu+tEqNtSRD
         WoLS0J2tkE60S2ddmz7wzzvAIxfBD2dW5zVjSoB1EyLOxhVNB8ZIySMqXpouEig+qNNc
         pWNqEIRZszJ0bsrs9dEpWgBhWFZGnJMwObIu7GArxEaU9rWh+PCv5IV+eClF4j2stKxT
         TpK5dpsY4zF/HzBbtkCYW3IAXvrq7eWLxKjc6rR5A6e7VkvIDRDAzt4imyM9Ee+bqr7r
         oY2+uA66UrIWklo45IZ7Xbd6dxrTBQJqO8NaBloyc4JWasUOm4xyC7cC5Iakfnh0ZQ1w
         nvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yfhq1E9yXZ/dYz+RVAVCb0hvNZMSRLRp5FqR0oMniw8=;
        b=aIO5uwRgEKEtiCSxxJQJZsVE2g6YxCKk7Q95dzP4XPkOUHGv+YBx52VP6wp2hx8G7O
         WH8qx9o0QzZh5VXCBlbswsOSd+N+suar87/W5wKJVIeNHrBh3WB3Y1aNxxehQE5q0Qyq
         JxvQiZhCIXj6AKKX/lT1eSLhvxCnZB8Pg8Hydo4/ea8IVJCHHAEUyu7bSypVmmy5ecBS
         SS5p7nKZDToMFVmIgA8ZJ1FVTLCxr9GbYr//l7qR6JYFwt1PAPhAJo6S3DfkmqDswMRZ
         380x100ZFMy3zzILfFGB5aZSfS5RK7O1bUVOCx1Fe3cVH8gzDwRUK1PMfYp6eVkJ5UJU
         TqiA==
X-Gm-Message-State: APjAAAVdx3XBYcdsA/q9nAoeqFU+dPfAL95wd9XpCVfxP5J4fn9q9tSn
        ERcPL0p1hhSpvveeqjfbPe7JWhgEZdvAlTaB2hk=
X-Google-Smtp-Source: APXvYqw8+QxjriCPr/LEMjTWfI6k5EvDIBoouA2L8BRkiFGC2hQfpKg8xOBM3vUWML19Rl1TqHnCykr2vjuihcEkBLg=
X-Received: by 2002:a2e:9b8a:: with SMTP id z10mr1511882lji.66.1570609626427;
 Wed, 09 Oct 2019 01:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190925122025.31246-1-yuyufen@huawei.com>
In-Reply-To: <20190925122025.31246-1-yuyufen@huawei.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 9 Oct 2019 10:26:55 +0200
Message-ID: <CA+res+QQtXD6phz=Ko-_n7eWVySrJA1kqgmMW3h3YUX+5RQ_7w@mail.gmail.com>
Subject: Re: [PATCH v4] block: fix null pointer dereference in blk_mq_rq_timed_out()
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        stable <stable@vger.kernel.org>, guoqing.jiang@cloud.ionos.com,
        jinpu.wang@cloud.ionos.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yufen Yu <yuyufen@huawei.com> =E4=BA=8E2019=E5=B9=B49=E6=9C=8826=E6=97=A5=
=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=8811:30=E5=86=99=E9=81=93=EF=BC=9A
>
> We got a null pointer deference BUG_ON in blk_mq_rq_timed_out()
> as following:
>
> [  108.825472] BUG: kernel NULL pointer dereference, address: 00000000000=
00040
> [  108.827059] PGD 0 P4D 0
> [  108.827313] Oops: 0000 [#1] SMP PTI
> [  108.827657] CPU: 6 PID: 198 Comm: kworker/6:1H Not tainted 5.3.0-rc8+ =
#431
> [  108.829503] Workqueue: kblockd blk_mq_timeout_work
> [  108.829913] RIP: 0010:blk_mq_check_expired+0x258/0x330
> [  108.838191] Call Trace:
> [  108.838406]  bt_iter+0x74/0x80
> [  108.838665]  blk_mq_queue_tag_busy_iter+0x204/0x450
> [  108.839074]  ? __switch_to_asm+0x34/0x70
> [  108.839405]  ? blk_mq_stop_hw_queue+0x40/0x40
> [  108.839823]  ? blk_mq_stop_hw_queue+0x40/0x40
> [  108.840273]  ? syscall_return_via_sysret+0xf/0x7f
> [  108.840732]  blk_mq_timeout_work+0x74/0x200
> [  108.841151]  process_one_work+0x297/0x680
> [  108.841550]  worker_thread+0x29c/0x6f0
> [  108.841926]  ? rescuer_thread+0x580/0x580
> [  108.842344]  kthread+0x16a/0x1a0
> [  108.842666]  ? kthread_flush_work+0x170/0x170
> [  108.843100]  ret_from_fork+0x35/0x40
>
> The bug is caused by the race between timeout handle and completion for
> flush request.
>
> When timeout handle function blk_mq_rq_timed_out() try to read
> 'req->q->mq_ops', the 'req' have completed and reinitiated by next
> flush request, which would call blk_rq_init() to clear 'req' as 0.
>
> After commit 12f5b93145 ("blk-mq: Remove generation seqeunce"),
> normal requests lifetime are protected by refcount. Until 'rq->ref'
> drop to zero, the request can really be free. Thus, these requests
> cannot been reused before timeout handle finish.
>
> However, flush request has defined .end_io and rq->end_io() is still
> called even if 'rq->ref' doesn't drop to zero. After that, the 'flush_rq'
> can be reused by the next flush request handle, resulting in null
> pointer deference BUG ON.
>
> We fix this problem by covering flush request with 'rq->ref'.
> If the refcount is not zero, flush_end_io() return and wait the
> last holder recall it. To record the request status, we add a new
> entry 'rq_status', which will be used in flush_end_io().
>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: stable@vger.kernel.org # v4.18+
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>
Hi Yufen,

Can you share your reproducer, I think the bug was there for long
time, we hit it in kernel 4.4.
We also need to fix it for older LTS kernel.

Do you have an idea, how should we fix it for older LTS kernel?

Regards,
Jack Wang
