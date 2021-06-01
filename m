Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB4397975
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhFARtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhFARti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:49:38 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D481C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 10:47:57 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n133so13732772ybf.6
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 10:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vRIj3/W/7y0c/W0SNa+T29gxGwMk+UiQ4px4sQcfs/A=;
        b=uSQLMYubcERxL//O5cWB9M1hHqBrwtiTDUHcMLPk1zPyByqwvdF8obE7Y6zRuuITf0
         Pq80e4a6icFx7SGbWH4Oy9ZlJqwnCJc4/3KlRlqRSRIfuQt6ro9OJvuUyIUkes0T2se0
         gKUkcnrSdeG2XLkw/1OOAkwhHymHQXnq9MN/mvfz/xaaJvySqyVf1O0huuG7j1782rMI
         mi+o4vJzhZzUyjx5VSXxOuQqUWuEGA4OogoMJPEzS9vy5cGcPKH1jgaJirkHjXqcgPLt
         4ijrMDtTNXHcrwJVYZdSi46ukSSd9HlrVxfROp5iX46fRxtAjtg6gvomEZp4w4WvSDsr
         SgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vRIj3/W/7y0c/W0SNa+T29gxGwMk+UiQ4px4sQcfs/A=;
        b=RZySY7Qne91kflhrZcXArvIvRs5pV1T2YK98GkLF+K7lN8IfXdX4GQO+WLLk3J7DRm
         X9ZPxQ4aQjCX2Prd6CO5f55XARjXGtMRkRU7u509njT/9/+0LAuVMdtgqhK+AaH58NJ3
         +n7kAGZA/qwphZpSf1RjmyRZT5zQkQSODXCJhz3ORWgZr5H6s5Z+fHGT8kWgniLqrzoZ
         CVRdhCEExigrPYZw+msuPTMnqohBP7HUQpqD12SGz5tZglpexCx7HGF8n8H/wEUpk9Q1
         Z5Kn7RK74VvxjTt70DLhp59IWdpgbaAHT7fXYrYWgObElK8VwqZOOFx/FHpgnvk4rwcf
         SFaw==
X-Gm-Message-State: AOAM530ukN1wZub9XTPg0pjCQBl0zOosh/sVD4i1PvO5hCr3hi44uR+p
        MbtrdObVaE+kw22eC9fjbOvAb4RBw5DrJV2W4xGMcA==
X-Google-Smtp-Source: ABdhPJyo0ZlQ55OuF+2guq2ZaoO9r1c1LKQZBkwT+wlqC7IKQxX1rweeajmPyA+wWGYpLfyTc4jsbTcZnXlaTadSEvg=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr41107642ybm.234.1622569676068;
 Tue, 01 Jun 2021 10:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <3724b6d19b0bf4741c44977e083c1a655df57b55.camel@collabora.com>
 <YLZpVGDz4TVEdaK0@kroah.com> <5744b89e9a500a8c2aa97cbad850bc4797fa7115.camel@collabora.com>
In-Reply-To: <5744b89e9a500a8c2aa97cbad850bc4797fa7115.camel@collabora.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Jun 2021 19:47:44 +0200
Message-ID: <CANn89iKFjZJ=AtgAJmk4ZEtS3eL5XKMr6wiFUhtfTb2tFKbcuA@mail.gmail.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
To:     =?UTF-8?Q?Corentin_No=C3=ABl?= <corentin.noel@collabora.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 1, 2021 at 7:09 PM Corentin No=C3=ABl
<corentin.noel@collabora.com> wrote:
>
> Le mardi 01 juin 2021 =C3=A0 19:07 +0200, Greg KH a =C3=A9crit :
> > On Tue, Jun 01, 2021 at 06:06:50PM +0200, Corentin No=C3=ABl wrote:
> > > I've been experiencing crashes with 5.13 that do not occur with
> > > 5.12,
> > > here is the crash trace:
> > >
> > > [   47.713713] skbuff: skb_over_panic: text:ffffffffb73a8354
> > > len:3762
> > > put:3762 head:ffff9e1e1e48e000 data:ffff9e1e1e48e010 tail:0xec2
> > > end:0xec0 dev:<NULL>
> > > [   47.716267] kernel BUG at net/core/skbuff.c:110!
> > > [   47.717197] invalid opcode: 0000 [#1] SMP PTI
> > > [   47.718049] CPU: 2 PID: 730 Comm: llvmpipe-0 Not tainted 5.13.0-
> > > rc3linux-v5.13-rc3-for-mesa-ci-87614d7f3282.tar.bz2 #1
> > > [   47.719739] Hardware name: ChromiumOS crosvm, BIOS 0
> > > [   47.720656] RIP: 0010:skb_panic+0x43/0x45
> > > [   47.721426] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00
> > > 00 50
> > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 78 ae ef b7 e8 7f
> > > 4c fb
> > > ff <0f> 0b 48 8b 14 24 48 c7 c1 a0 22 d1 b7 e8 ab ff ff ff 48 c7 c6
> > > e0
> > > [   47.725944] RSP: 0000:ffffacec01347c20 EFLAGS: 00010246
> > > [   47.726735] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > 00000000ffffdfff
> > > [   47.727820] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > 0000000000000000
> > > [   47.729096] RBP: ffffeb2700792380 R08: ffffffffb8144b08 R09:
> > > 0000000000009ffb
> > > [   47.730260] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > ffff9e1e1e95b300
> > > [   47.731411] R13: 0000000000000000 R14: ffff9e1e1e48e000 R15:
> > > 0000000000000eb2
> > > [   47.732541] FS:  00007f3a82b53700(0000)
> > > GS:ffff9e1f2bd00000(0000)
> > > knlGS:0000000000000000
> > > [   47.733858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   47.734813] CR2: 00000000010d24f8 CR3: 0000000012d6e004 CR4:
> > > 0000000000370ee0
> > > [   47.735968] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [   47.737091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400
> > > [   47.738318] Call Trace:
> > > [   47.738812]  skb_put.cold+0x10/0x10
> > > [   47.739450]  page_to_skb+0xe4/0x400
> > > [   47.740072]  receive_buf+0x86/0x1660
> > > [   47.740693]  ? inet_gro_receive+0x54/0x2c0
> > > [   47.741279]  ? dev_gro_receive+0x194/0x6a0
> > > [   47.741846]  virtnet_poll+0x2b8/0x3c0
> > > [   47.742357]  __napi_poll+0x25/0x150
> > > [   47.742844]  net_rx_action+0x22f/0x280
> > > [   47.743388]  __do_softirq+0xba/0x264
> > > [   47.743947]  irq_exit_rcu+0x90/0xb0
> > > [   47.744435]  common_interrupt+0x40/0xa0
> > > [   47.744978]  ? asm_common_interrupt+0x8/0x40
> > > [   47.745582]  asm_common_interrupt+0x1e/0x40
> > > [   47.746182] RIP: 0033:0x7f3a7a276ed4
> > > [   47.746708] Code: a0 03 00 00 c5 fc 29 84 24 40 0f 00 00 c5 bc
> > > 54 c8
> > > c5 7c 28 84 24 80 01 00 00 c5 bc 59 e9 c5 fe 5b ed c5 fd 76 c0 c5
> > > d5 fa
> > > c0 <c5> fd db ec c5 fd 7f 84 24 20 0f 00 00 c5 fc 5b ed c4 e2 55 b8
> > > cb
> > > [   47.749292] RSP: 002b:00007f3a82b4dba0 EFLAGS: 00000212
> > > [   47.750006] RAX: 00007f3a8c210324 RBX: ffffffffffffffff RCX:
> > > ffffffffffffffff
> > > [   47.750964] RDX: 00007f3a8c210348 RSI: 00007f3a8c21034c RDI:
> > > 00007f3a7c0575a0
> > > [   47.752049] RBP: 00007f3a82b52ca0 R08: 00007f3a8c210350 R09:
> > > 00007f3a8c210354
> > > [   47.753161] R10: 00007f3a8c210358 R11: 000000000000ffef R12:
> > > 00007f3a8c210340
> > > [   47.754260] R13: 00007f3a8c210344 R14: 00007f3a7c057580 R15:
> > > 00007f3a8c21033c
> > > [   47.755354] Modules linked in:
> > > [   47.755871] ---[ end trace a8b692ea99c9cd9e ]---
> > > [   47.756606] RIP: 0010:skb_panic+0x43/0x45
> > > [   47.757297] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00
> > > 00 50
> > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 78 ae ef b7 e8 7f
> > > 4c fb
> > > ff <0f> 0b 48 8b 14 24 48 c7 c1 a0 22 d1 b7 e8 ab ff ff ff 48 c7 c6
> > > e0
> > > [   47.760168] RSP: 0000:ffffacec01347c20 EFLAGS: 00010246
> > > [   47.760896] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > 00000000ffffdfff
> > > [   47.761903] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > 0000000000000000
> > > [   47.762945] RBP: ffffeb2700792380 R08: ffffffffb8144b08 R09:
> > > 0000000000009ffb
> > > [   47.764059] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > ffff9e1e1e95b300
> > > [   47.765169] R13: 0000000000000000 R14: ffff9e1e1e48e000 R15:
> > > 0000000000000eb2
> > > [   47.766261] FS:  00007f3a82b53700(0000)
> > > GS:ffff9e1f2bd00000(0000)
> > > knlGS:0000000000000000
> > > [   47.767512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   47.768389] CR2: 00000000010d24f8 CR3: 0000000012d6e004 CR4:
> > > 0000000000370ee0
> > > [   47.769381] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [   47.770362] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400
> > > [   47.771339] Kernel panic - not syncing: Fatal exception in
> > > interrupt
> > > [   47.772814] Kernel Offset: 0x35c00000 from 0xffffffff81000000
> > > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > >
> > > I've been able to bisect the issue a little bit and the issue
> > > disappeared after reverting the 4 following commits:
> > >  * fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7
> > >  * af39c8f72301b268ad8b04bae646b6025918b82b
> > >  * f5d7872a8b8a3176e65dc6f7f0705ce7e9a699e6
> > >  * f80bd740cb7c954791279590b2e810ba6c214e52
> > >
> > > Here is my kernel config:
> > > https://gitlab.freedesktop.org/tintou/mesa/-/blob/e5d6c56bfae8522e924=
217883d2c6a6bfc1b332b/.gitlab-ci/container/x86_64.config
> >
> > Do you have the same problem with 5.13-rc4?
> >
> > thanks,
> >
> > greg k-h
>
> Yes I tried with rc2, rc3 and rc4 resulting to the same panic.
>
> Thanks,
>


Could you provide a stack trace with file names and line numbers ?

(ie use scripts/decode_stacktrace.sh )

Thanks.
