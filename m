Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561D4247B6
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 07:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfEUF7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 01:59:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45709 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfEUF7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 01:59:31 -0400
Received: by mail-qt1-f194.google.com with SMTP id t1so19102105qtc.12;
        Mon, 20 May 2019 22:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22drku89J88mMyk6FMdT8bzeRBn3S8WUY620gLaEtr0=;
        b=ITJ/Lu15dmi11f6pK2aUseX67g1Vex7ZyIgg5HWjqUhM88G0F+0/sM4Ts9Td887rJC
         7iIQSCsRX1oVBU9YcwrQPtesZDxjbldr2hdSEW7dm4ulZhHuDInAIYEv+UgrC41IFeSX
         /Mqpi7M6b94MbO4q7zMCj5R8gH7XdqvQ1/9XoBSzU1U4hkgz7OeoGuSmJhHZjpL3+Fml
         XLR43AXAdf1joMfGrKm255miCExk5Ak4FEzGhw4WSYt2Oo0t63lwAmFneNVqLQocQrJ0
         zibxEne5yRHr5rF/4kbWMgE97Kk2215ftfuR+po7kD9SFDWVVYGwVvBjI7zt7vYDZmSZ
         8nKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22drku89J88mMyk6FMdT8bzeRBn3S8WUY620gLaEtr0=;
        b=Sa1Sw6BiJTLVXB06vQg1g5QCpLOIqn66rxiZiaURQbhxGr8zXkK3augeHu3VTu1t7R
         LrY8qYY+L9KbqGgJ7Uw0Q2v7eI3AgKmpRChkGJVJbrY3En80xH2Zzhem4scnrTsBkg12
         J4J+i9Ijfp/sAuHPn9AdclwrxfdwrF1fAaKVKS5hB8J3DurpjnRurP54HU17tkg11UdH
         fOasrQJKdy6ZUfepPrwzFK5Rig7wieZ3UGNl+MMBl1HdFHKxL+Yiz5UmVE7FVJe9hS0P
         7AO6fxffOFvneSmkoiw/jTJL/nFN340DEv/mQ+TA+NWGfCvUnBXFcuCa8QZIwhajpx/L
         HMbw==
X-Gm-Message-State: APjAAAVCH92gSWfgzB59xDOZeszqzinVVxTc9y2fATjQmZTxNuwKy8CH
        sXCcstiA+1bVzYslh2THa/rCMUHPsl5w+ICuEY/T9Q==
X-Google-Smtp-Source: APXvYqyYI5VgBMX/SIFyqX22jP2q43cXBY5auvp1OVfJSJLQSLA9BXFpYQ++917U535uUUrqIjl4T1FZPHucXh6ofN8=
X-Received: by 2002:ac8:30bb:: with SMTP id v56mr53609323qta.183.1558418369776;
 Mon, 20 May 2019 22:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com>
In-Reply-To: <20190520220911.25192-1-gpiccoli@canonical.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 20 May 2019 22:59:16 -0700
Message-ID: <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 3:10 PM Guilherme G. Piccoli
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
> Tested-by: Eric Ren <renzhengeek@gmail.com>
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Applied both patches! Thanks for the fix!

> ---
>
> Changes V1->V2:
> * Implemented Ming's suggestion (drop {} from if) - thanks Ming!
> * Rebased to v5.2-rc1
> * Added Reviewed-by/Tested-by tags
>
> Also, Ming mentioned a new patch series[0] that will refactor legacy IO
> path so probably the bug won't happen anymore. Even in this case,
> I consider this patch important specially aiming the stable releases,
> in which backporting small bugfixes is much simpler than more complex
> patch sets.
>
> [0] https://lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com/T/#t
>
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 419d600e6637..e887915c7804 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1054,10 +1054,8 @@ blk_qc_t generic_make_request(struct bio *bio)
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
> @@ -1088,6 +1086,7 @@ blk_qc_t generic_make_request(struct bio *bio)
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
