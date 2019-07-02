Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5E55DA17
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfGCBBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:01:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35001 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfGCBBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:01:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so761218qto.2;
        Tue, 02 Jul 2019 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AF5wAEaSeOuu/dYORr2z7nahKEkMxFAhhFiFqhe66nc=;
        b=KBOctFt6fuFEqux0VV7CSWgommZB4FnyANMSEPt5JjEYuv6Jls8PBdd/PPpbHE3RcE
         /Dgl9dTtXzk0uqJPEFVIVM0BnlQFt1XupSF4Xxhu6C7pS+SCevNQfXVYnhN2ramXoA5t
         21AO32DyWtaC8GU4kuga8tmYxU5sFXiaKNFiGSgJmfx7yLfyJOwsCG8hS9h4nUFodWMl
         qstMTXjpmEBH/sTUzR14scYPgOyURXdmWhtHrfcMLhHB76oH0l3VFR/1w5oS+4RYxDIj
         FTQrLLKkaJ8G1Ghm9EFb2rAvto9VjUHFN3QCgyFNrpLffEs1e821F5eS+FCEAkMxfdTW
         oI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AF5wAEaSeOuu/dYORr2z7nahKEkMxFAhhFiFqhe66nc=;
        b=YJtmUthTZ+TVvQXZe9AQ8g1/lNDtPOV3NGPsC93UIdQgJSf4BSJJ9FExNG4CVP+GtR
         rrPbsElpxn8SzlRhwzzyz6pq4KiKJApaidFCBPizY6CTNLq8Y44UpixMTQLSFVS3kgBU
         j3hwCfFncyyCJuhJbBkwMQlTHoz20hjcpyugfmGul0BGut+a+ep3hdy6jUkDChbBQvhm
         HCLaeec9gaomfsomB9Y2uylk+3vxwsR/mnSVSla1Ig0hO4r0axAaGQXnq+5uglYvlmqz
         8rvtgt87IKk/dVAhZVqKlOO572KUX0W8QjpJd7HlX7Gvfnwxdc8q9laUM0fqHpLsjm9u
         fUPg==
X-Gm-Message-State: APjAAAWs2rAq4ufJShvTW8MfKL0txbrH7YiMRNYNIZHNkgTVPd/BIqiM
        pDLQuE10UMrndrxEKRiGvKW8bD66BZPN51tE/r9V4gy/XeI=
X-Google-Smtp-Source: APXvYqwipkyidadYl9pWmBe4w7DWi2+eePr3tvjA6SB8hN83jGerGUKJ3LpMmOersX7hx5FRh8mIkt6rAtaIlTQEmcM=
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr28737569qvj.145.1562111608377;
 Tue, 02 Jul 2019 16:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221759.18274-1-gpiccoli@canonical.com>
In-Reply-To: <20190628221759.18274-1-gpiccoli@canonical.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 2 Jul 2019 16:53:17 -0700
Message-ID: <CAPhsuW5arZgFy0iur0qdgO7a1g9qiB0V2OskQPXJkL0WWHG52A@mail.gmail.com>
Subject: Re: [4.19.y PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <songliubraving@fb.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 3:22 PM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> -----------------------------------------------------------------
> This patch is not on mainline and is meant to 4.19 stable *only*.
> After the patch description there's a reasoning about that.
> -----------------------------------------------------------------
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
> a) Build kernel v4.19.56-stable with CONFIG_BLK_CGROUP=n.
>
> b) Create a raid0 md array with 2 NVMe devices as members, and mount
> it with an ext4 filesystem.
>
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme1n1/device/device/remove
> (whereas nvme1n1 is the 2nd array member)
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
> ----------------------------
> Why this is not on mainline?
> ----------------------------
>
> The patch was originally submitted upstream in linux-raid and
> linux-block mailing-lists - it was initially accepted by Song Liu,
> but Christoph Hellwig[0] observed that there was a clean-up series
> ready to be accepted from Ming Lei[1] that fixed the same issue.
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
> [0] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
> [1] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Song Liu <songliubraving@fb.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Tested-by: Eric Ren <renzhengeek@gmail.com>
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6eed5d84c2ef..682bc561b77b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2445,10 +2445,8 @@ blk_qc_t generic_make_request(struct bio *bio)
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
> @@ -2479,6 +2477,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>                                 bio_wouldblock_error(bio);
>                         else
>                                 bio_io_error(bio);
> +                       q = NULL;
>                 }
>                 bio = bio_list_pop(&bio_list_on_stack[0]);
>         } while (bio);
> --
> 2.22.0
>
