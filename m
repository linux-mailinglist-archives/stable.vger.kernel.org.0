Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A17284DF
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbfEWRZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:25:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44347 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWRZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 13:25:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id w25so4275588qkj.11;
        Thu, 23 May 2019 10:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJjCNrzpdOy2l1ZRnxp5Zju+1qm4InPBw3rALhmp2wE=;
        b=I+ArrbouMwviOeqikqtIY4LwfQW5BzQKpawINI5YM9MibAzceL9zbWOOy/FqoHa+mZ
         vfYGNEDCnVfnXGITC0QWv4ypadR1GtrNaHZOWgg6xu+PvgY/U/Lf2eLSZ7H/aJdOrxV6
         2DtGxVWfDbr2KJlprdLB3bT5tnhrXh1iLqr+TH8e6tOLwUwKXrdwFxeYIYJx0NC8Hvg+
         InTauCuLovrQSQWXUS7lkRaIBe2xSFHaToHzflyzIK32gXMA/b9E0/8GuveymNyEWXEM
         y3+GrLuwC9DG58N+RPZ6VWHCV1yBNj6le7a0023+BooxjSLHMc1EtwggV2E1h3fX4r+b
         t+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJjCNrzpdOy2l1ZRnxp5Zju+1qm4InPBw3rALhmp2wE=;
        b=UWdXilRRhI8+DC19sPL1DQcYD2dKrs9vz8v6VnwxNjELpwYFQ3dSJt1ELV35pl58f+
         d2D9UXh7BpCQAk1SDY4EUU9jLfIJnRDRUtrUuGptHT4GSvRwl5H1q3/d1e1iFYDH/RLH
         wi150jBISCU3Js5IvkCbrzPIKBkWmtKi16p+r7U3EzzBTmd3/7FSVXuL5/IgsuqUo288
         qrtMYcg7RsHuTjL1AGRlCj4B1m2jJO7PsIZuZNSpsrVeIYPWGVjb8Wh4R8Y1Ys/1YZ8W
         c5elBYV7uXXzQ5Xk8Ep3Vo39bwuAqYANhJ8Od/2D1UEHKA9250wKbYvlibE/xwya3Y1/
         TUvg==
X-Gm-Message-State: APjAAAWwubJv4d4pq1NWK74/fb/YxbN9uOApiAcuq434ND1gZ0iD6ppn
        0lHZ79cS77rn36fMh1XLxGIAsHlJOM81rDflJoQ=
X-Google-Smtp-Source: APXvYqx1xpcC6eCRsOTU8awQq81G7bpo2fPzWcTU7zNqwJnm2to3nxz2E5a+GkueerIHWCH91vk2qplj3DBDYpbolac=
X-Received: by 2002:a37:680c:: with SMTP id d12mr75395903qkc.202.1558632349824;
 Thu, 23 May 2019 10:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190523172345.1861077-1-songliubraving@fb.com>
In-Reply-To: <20190523172345.1861077-1-songliubraving@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 23 May 2019 10:25:38 -0700
Message-ID: <CAPhsuW5GghbT5XOJgNx0AM+HCD0kLcDdFV1YRRg3rHo+iU4gyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 10:24 AM Song Liu <songliubraving@fb.com> wrote:
>
> From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
>
> Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
> with device removal triggers a crash") introduced a NULL pointer
> dereference in generic_make_request(). The patch sets q to NULL and
> enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
> which is not taken, and then the 'else' will dereference q in
> blk_queue_dying(q).
>
> This patch just moves the 'q = NULL' to a point in which it won't trigger
> the oops, although the semantics of this NULLification remains untouched.
>
> A simple test case/reproducer is as follows:
> a) Build kernel v5.2-rc1 with CONFIG_BLK_CGROUP=n.
>
> b) Create a raid0 md array with 2 NVMe devices as members, and mount it
> with an ext4 filesystem.
>
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme0n1/device/device/remove
> (whereas nvme0n1 is the 2nd array member)
>
> This will trigger the following oops:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:generic_make_request+0x32b/0x400
> Call Trace:
>  submit_bio+0x73/0x140
>  ext4_io_submit+0x4d/0x60
>  ext4_writepages+0x626/0xe90
>  do_writepages+0x4b/0xe0
> [...]
>
> This patch has no functional changes and preserves the md/raid0 behavior
> when a member is removed before kernel v4.17.
>
> Cc: stable@vger.kernel.org # v4.17
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Eric Ren <renzhengeek@gmail.com>
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Please note this patchset is only for stable.

Thanks,
Song

> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a55389ba8779..d24a29244cb8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1074,10 +1074,8 @@ blk_qc_t generic_make_request(struct bio *bio)
>                         flags = 0;
>                         if (bio->bi_opf & REQ_NOWAIT)
>                                 flags = BLK_MQ_REQ_NOWAIT;
> -                       if (blk_queue_enter(q, flags) < 0) {
> +                       if (blk_queue_enter(q, flags) < 0)
>                                 enter_succeeded = false;
> -                               q = NULL;
> -                       }
>                 }
>
>                 if (enter_succeeded) {
> @@ -1108,6 +1106,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>                                 bio_wouldblock_error(bio);
>                         else
>                                 bio_io_error(bio);
> +                       q = NULL;
>                 }
>                 bio = bio_list_pop(&bio_list_on_stack[0]);
>         } while (bio);
> --
> 2.17.1
>
