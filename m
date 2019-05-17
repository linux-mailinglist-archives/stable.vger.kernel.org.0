Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4234022004
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfEQWEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 18:04:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53856 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfEQWEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 18:04:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id 198so8195420wme.3;
        Fri, 17 May 2019 15:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8zrpRD4WQSC0bql+5SNwotLtSqhpQ2N+iyeA6G7890=;
        b=HDB4UjrnDkFOLde1idgGEA15LrxWSQOLEFVapsFCSGkZHfaTIO+ePjpK1Dyai31w2t
         OhweGJ+Fz620r7eOkdMQ5Ba4dd9UHwvIJuvKL7wTlTVzt4F8Ax452WIUiC4YxffMn9bp
         qwg+EuVf8hQN+4v608beAmrvjH2++A5Lsa+ZCJCj/dV43E2YJUWTni0a0jb5HpLB4khp
         mB/Fv/y+6Hur+nY1SBYJb6PUc5r6Ylyj2eDEo5mt3VHl0/m2Fop/jJ1QyuT95S2Q8nXU
         6PZFHDY5q6SHmjImQfzkuNLGhLEn7866OFh6+/nu9crUxN98aYGEyONuYfEznX6N+KNG
         9uqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8zrpRD4WQSC0bql+5SNwotLtSqhpQ2N+iyeA6G7890=;
        b=lg0AOl+y5tUvNwr2+JYZweAIMRwyv68bydcXiy87EpchQb9uLp75HFACPZBWuuRkPY
         Z7bmJxu6AlpCy6Kz2ZD2vNf7f120fiKS6KS/T8YOpKPMq8QLOCe/1BVwxwGXdpt9cj//
         1tunVbx9bVPN1ChYxB/kkV+91WoGCajOVjzcRmm2MWujOK7AnTS8SZsjCZB7nPadaT4X
         +1BC9QD4kgLlBq/qfzWLdIK8+JXTVQD7udYZU5nu78zZmE1cjQ4GWe3K9pU7lgJvU5oA
         +wC6UtvKPrrSlpW/P+lL192QIBVN95jG/NsQGqrWybQBPVlgi/PKeXD2hi+/xc2Kf5k0
         QE2Q==
X-Gm-Message-State: APjAAAVg690UFFOdLNEdtyGOYDon+R8mQAv+tSWRto2zcgyxj8Q1tb3Z
        puQzqVWOpuiHQd2ay9EFWHFOHljVhF8/8NMXHko=
X-Google-Smtp-Source: APXvYqzMrlVr79ILYiRFlMzmeGQnHyZo1wggiaGD9IG6AjeSL/odbeC8KCwqd1p9PccWL5zlVpiCHCfy++wHhd8kj7I=
X-Received: by 2002:a1c:760f:: with SMTP id r15mr20146659wmc.134.1558130684743;
 Fri, 17 May 2019 15:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
In-Reply-To: <20190430223722.20845-1-gpiccoli@canonical.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Sat, 18 May 2019 06:04:32 +0800
Message-ID: <CACVXFVNsOoJqipwivoCbH1jNs_5b0g9E6HWhh6kXYTzetALzQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block <linux-block@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net,
        Bart Van Assche <bvanassche@acm.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 1, 2019 at 6:38 AM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
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
> a) Build kernel v5.1-rc7 with CONFIG_BLK_CGROUP=n.
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
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: stable@vger.kernel.org # v4.17
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")

BTW, the legacy IO request path is removed since 5.0, the above fault
commit can be
removed as done by the following patches:

https://lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com/T/#t

> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>  block/blk-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a55389ba8779..e21856a7f3fa 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1076,7 +1076,6 @@ blk_qc_t generic_make_request(struct bio *bio)
>                                 flags = BLK_MQ_REQ_NOWAIT;
>                         if (blk_queue_enter(q, flags) < 0) {
>                                 enter_succeeded = false;
> -                               q = NULL;
>                         }

Please remove '{}'.

>                 }
>
> @@ -1108,6 +1107,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>                                 bio_wouldblock_error(bio);
>                         else
>                                 bio_io_error(bio);
> +                       q = NULL;
>                 }
>                 bio = bio_list_pop(&bio_list_on_stack[0]);
>         } while (bio);
> --
> 2.21.0
>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming Lei
