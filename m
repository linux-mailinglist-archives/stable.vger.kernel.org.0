Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6F21284
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 05:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEQDd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 23:33:57 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55963 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQDd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 23:33:57 -0400
Received: by mail-it1-f194.google.com with SMTP id q132so9691840itc.5;
        Thu, 16 May 2019 20:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zlc1Z5RAkaS+PLi8IjlRp7vUkQUrPkJAKFClneQV0+4=;
        b=RL0qFDEMyN6iaevXm0sqvWWVZ7MEgondFX77P7G9i30niJ4a6ygBthzOQVm2COtdbm
         /lQ5bVfNdwMnO1oQHUR+msGw93+09086TMi9uvLI+WHB+njNlStrOh+N3bWjMoL/GKR+
         z2P+JD4HUeLrSBc3J5uYKc1bRqpW2lpa3iuYv7K6FKSMinPkVUCJqoGfKS5JvNB0aLKQ
         BoL/MlLGB9+2uC703qsVLYOgNDJMA5eopf2nTc3/ZPQlBQgA0pqsm6kejSYJ7Gast4f8
         FXk/k+1BaiXSmLGRjKdGGPARlBUwVJcCo+I9MDyaFXIzCC7jZMWlGMmwBA/caWju5lVh
         yRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zlc1Z5RAkaS+PLi8IjlRp7vUkQUrPkJAKFClneQV0+4=;
        b=jCaQHh7NTjNMDF7f1DVCbypY4SiSM53I6dAe/I9iHncWz2LIP+lAUkcm0v3ijkMYVL
         7jx/aFLcmBFPzpfOuVlIGkaDyHKEvTOn/vlZnIRfiJgQ6CxL951V6hBs9Jn0/LsBxb1J
         RR5AX1nub+wvjBJKvNc2SFKp9vNQS1Q/hq0HGDx7PRntNHtZj2VQxMUlbp8ub1ugv61T
         3tBEvml/XQb43v58LTRuC+aseMg6+ghvmqgaGeXcz3lfaWJz78RwRCvqM6XZIMbl1CCq
         DNlmD2ZtPIdhHtG97VPg77GUyEpm1OSJQzDS9ydULf9wcwaUvInEtZg0L6dQiI5i6XiD
         JlFg==
X-Gm-Message-State: APjAAAV7h/gSeDCZmdXPLuJT0KiFobalKff0QQNWiTZdCj4qqh1BYRDe
        5drJXOw2uU2E5lcmboyDaOY1+17Ly+W0gMFdGA4=
X-Google-Smtp-Source: APXvYqzs0Bz8wmwYtNqOt4wvUGYHLM1ecN3L9b4rqTzExniCfH4inr5Kc4YZRlmrKsHhoVkGKXa5dQ82PQcOjVYPBfw=
X-Received: by 2002:a24:f983:: with SMTP id l125mr16700177ith.62.1558064036522;
 Thu, 16 May 2019 20:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
In-Reply-To: <20190430223722.20845-1-gpiccoli@canonical.com>
From:   Eric Ren <renzhengeek@gmail.com>
Date:   Fri, 17 May 2019 11:33:45 +0800
Message-ID: <CAKM4Aez=eC96uyqJa+=Aom2M2eQnknQW_uY4v9NMVpROSiuKSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com,
        jay.vosburgh@canonical.com, kernel@gpiccoli.net,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, 1 May 2019 at 06:38, Guilherme G. Piccoli
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
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Thanks for the bugfix. I also had a panic having very similar
calltrace below as this one,
when using devicemapper in container scenario and deleting many thin
snapshots by dmsetup
remove_all -f, meanwhile executing lvm command like vgs.

After applied this one, my testing doesn't crash kernel any more for
one week.  Could the block
developers please give more feedback/priority on this one?

My panic trace:
```
50515.136279] BUG: unable to handle kernel NULL pointer dereference at
00000000000003b8
[50515.144704] PGD 0 P4D 0
[50515.147576] Oops: 0000 [#1] SMP PTI
[50515.151403] CPU: 24 PID: 45287 Comm: vgs Kdump: loaded Not tainted
4.19.24-9.x86_64#1
[50515.169295] RIP: 0010:generic_make_request+0x24/0x350
[50515.174684] Code: e9 e1 45 42 00 90 0f 1f 44 00 00 55 48 89 e5 41
55 41 54 53 48 89 fb 48 83 e4 f0 48 83 ec 20 48 8b 47 08 f6 47 15 08
8b 77 10 <4c> 8b a0 b8 03 00 00 0f 84 82 00 00 00 49 8b 84 24 50 07 00
00 a8
[50515.194303] RSP: 0018:ffffa90862373a10 EFLAGS: 00010246
[50515.199869] RAX: 0000000000000000 RBX: ffff99d7338b7800 RCX: 0000000000000000
[50515.207347] RDX: ffff99d51d89c380 RSI: 0000000000000000 RDI: ffff99d7338b7800
[50515.214828] RBP: ffffa90862373a48 R08: 0000000000000000 R09: ffff99a840007300
[50515.222305] R10: ffffa90862373b88 R11: 0000000000000000 R12: ffff99d833592200
[50515.229782] R13: ffffa90862373b58 R14: 0000000000000001 R15: 0000000000000000
[50515.237264] FS:  00007fc36b322880(0000) GS:ffff99d83f000000(0000)
knlGS:0000000000000000
[50515.245944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[50515.252036] CR2: 00000000000003b8 CR3: 0000005c53ed0001 CR4: 00000000003626a0
[50515.259519] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[50515.266996] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[50515.274473] Call Trace:
[50515.277264]  ? bio_add_page+0x42/0x50
[50515.281267]  submit_bio+0x6e/0x130
[50515.285013]  new_read+0xa2/0xf0 [dm_bufio]
[50515.289454]  dm_bm_read_lock+0x21/0x70 [dm_persistent_data]
[50515.295369]  ro_step+0x31/0x60 [dm_persistent_data]
[50515.300589]  dm_btree_find_key+0xb0/0x180 [dm_persistent_data]
[50515.306765]  dm_thin_get_highest_mapped_block+0x75/0x90 [dm_thin_pool]
[50515.313639]  thin_status+0x145/0x290 [dm_thin_pool]
...
```
Regards,
Eric
