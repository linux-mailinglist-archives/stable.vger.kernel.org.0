Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FCE5D9CB
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGCAxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:53:39 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38256 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfGCAxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:53:39 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so448666qkk.5;
        Tue, 02 Jul 2019 17:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTgua9G58q50LFVixMsdybnWckR256ux0PIIDP1wQ5Y=;
        b=eNnvNTFXUtK2ZmwHM5eqnMuzDgJPwkqHrI+PkZhmUjI//R1v14BzZDCU5xRUnbQYp8
         Ys7Z4llzJPYIq260gYIW+o9qlLnHJ+O9uOVD1zyeBW+7ZZtGIti58RWbqvaiXD6Jq1HV
         IiHX54MaIDkl3JDO31+FKWsp4hOeE6VspxxOMH/w2WazIhRAD08Iw9KPTwpRM4L6ohkU
         Sxqk8lfvxoTpGJdqwRZc6t50tDDwgUDLJ372Lp6rAVRtD37xaQJw8ztLhM39zvLY1YRv
         lGgchql7l2XVg1ulSTuWeb2JfGqqlFenKDasfdxLDALl3noeXRJS7RMyClKqiXo7xKCB
         hFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTgua9G58q50LFVixMsdybnWckR256ux0PIIDP1wQ5Y=;
        b=RxuIW2Ad2mluHPSFQ0njm6wofPlIH/kRQcs/K1c9YuZU48bFghBSqnnVbFu3L54T9c
         yKvDd8+78Cs/prKoI2OC8YBX7u4mP+60qTTrrveEq5OyhrN254R5G+5Xe+dImHyB2+iv
         P4XOp7aKhIqANs3naWzV6CItAK4I63WJEV4Vg/vNuve4LRKArle8y+hHkOceVqh5Z1S7
         L1l1y6ZimqMXsZ3VFU0aEig/t3ELTEGhZZny0wD9yfN6mbPuTucEevX5UFZSQLjDN8dm
         oUHboSRt2PmzKJ88zrKDUR5zsVMTDUbgksYdyF7SciO6dFWKncqAtyAGAiLr10x0AsDQ
         zGIQ==
X-Gm-Message-State: APjAAAWDwEAO0uwACQj92mnzqH6DmN6YKswPP++Pq9qdcp1M8TE0aVJC
        NysdaF1WwS9hadNaPzKgtK9QnhLOJmQOkHGFop5sx+EcOw8=
X-Google-Smtp-Source: APXvYqwXZMt+P2u8xEdlyca/T+BvLbvy+lm3kwU603/Ditp8soNe+beEqZROzQ8SEe4b0yK/AWH15xcSeRFtprWNMT0=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr25697889qkc.241.1562111637578;
 Tue, 02 Jul 2019 16:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221759.18274-1-gpiccoli@canonical.com> <20190628221759.18274-2-gpiccoli@canonical.com>
In-Reply-To: <20190628221759.18274-2-gpiccoli@canonical.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 2 Jul 2019 16:53:46 -0700
Message-ID: <CAPhsuW6NpgM5HXHcuqt4oL3kORrTrMWvdTNANuBr=9Px5H4vEQ@mail.gmail.com>
Subject: Re: [4.19.y PATCH 2/2] md/raid0: Do not bypass blocking queue entered
 for raid0 bios
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <songliubraving@fb.com>,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 3:18 PM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> -----------------------------------------------------------------
> This patch is not on mainline and is meant to 4.19 stable *only*.
> After the patch description there's a reasoning about that.
> -----------------------------------------------------------------
>
> Commit cd4a4ae4683d ("block: don't use blocking queue entered for
> recursive bio submits") introduced the flag BIO_QUEUE_ENTERED in order
> split bios bypass the blocking queue entering routine and use the live
> non-blocking version. It was a result of an extensive discussion in
> a linux-block thread[0], and the purpose of this change was to prevent
> a hung task waiting on a reference to drop.
>
> Happens that md raid0 split bios all the time, and more important,
> it changes their underlying device to the raid member. After the change
> introduced by this flag's usage, we experience various crashes if a raid0
> member is removed during a large write. This happens because the bio
> reaches the live queue entering function when the queue of the raid0
> member is dying.
>
> A simple reproducer of this behavior is presented below:
> a) Build kernel v4.19.56-stable with CONFIG_BLK_DEV_THROTTLING=y.
>
> b) Create a raid0 md array with 2 NVMe devices as members, and mount
> it with an ext4 filesystem.
>
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme1n1/device/device/remove
> (whereas nvme1n1 is the 2nd array member)
>
> This will trigger the following warning/oops:
>
> ------------[ cut here ]------------
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000155
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:blk_throtl_bio+0x45/0x970
> [...]
> Call Trace:
>  generic_make_request_checks+0x1bf/0x690
>  generic_make_request+0x64/0x3f0
>  raid0_make_request+0x184/0x620 [raid0]
>  ? raid0_make_request+0x184/0x620 [raid0]
>  md_handle_request+0x126/0x1a0
>  md_make_request+0x7b/0x180
>  generic_make_request+0x19e/0x3f0
>  submit_bio+0x73/0x140
> [...]
>
> This patch changes raid0 driver to fallback to the "old" blocking queue
> entering procedure, by clearing the BIO_QUEUE_ENTERED from raid0 bios.
> This prevents the crashes and restores the regular behavior of raid0
> arrays when a member is removed during a large write.
>
> [0] lore.kernel.org/linux-block/343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp
>
> ----------------------------
> Why this is not on mainline?
> ----------------------------
>
> The patch was originally submitted upstream in linux-raid and
> linux-block mailing-lists - it was initially accepted by Song Liu,
> but Christoph Hellwig[1] observed that there was a clean-up series
> ready to be accepted from Ming Lei[2] that fixed the same issue.
>
> The accepted patches from Ming's series in upstream are: commit
> 47cdee29ef9d ("block: move blk_exit_queue into __blk_release_queue") and
> commit fe2008640ae3 ("block: don't protect generic_make_request_checks
> with blk_queue_enter"). Those patches basically do a clean-up in the
> block layer involving:
>
> 1) Putting back blk_exit_queue() logic into __blk_release_queue(); that
> path was changed in the past and the logic from blk_exit_queue() was
> added to blk_cleanup_queue().
>
> 2) Removing the guard/protection in generic_make_request_checks() with
> blk_queue_enter().
>
> The problem with Ming's series for -stable is that it relies in the
> legacy request IO path removal. So it's "backport-able" to v5.0+,
> but doing that for early versions (like 4.19) would incur in complex
> code changes. Hence, it was suggested by Christoph and Song Liu that
> this patch was submitted to stable only; otherwise merging it upstream
> would add code to fix a path removed in a subsequent commit.
>
> [1] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
> [2] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: cd4a4ae4683d ("block: don't use blocking queue entered for recursive bio submits")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
>  drivers/md/raid0.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index ac1cffd2a09b..f4daa56d204d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -547,6 +547,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>                         trace_block_bio_remap(bdev_get_queue(rdev->bdev),
>                                 discard_bio, disk_devt(mddev->gendisk),
>                                 bio->bi_iter.bi_sector);
> +               bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>                 generic_make_request(discard_bio);
>         }
>         bio_endio(bio);
> @@ -602,6 +603,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>                                 disk_devt(mddev->gendisk), bio_sector);
>         mddev_check_writesame(mddev, bio);
>         mddev_check_write_zeroes(mddev, bio);
> +       bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>         generic_make_request(bio);
>         return true;
>  }
> --
> 2.22.0
>
