Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE58656E21
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 20:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiL0TJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 14:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0TJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 14:09:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDF6B0A;
        Tue, 27 Dec 2022 11:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC926120C;
        Tue, 27 Dec 2022 19:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DBAC433F2;
        Tue, 27 Dec 2022 19:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672168145;
        bh=g3AyVzPiNK7FxMi/7WTq97Bc0fAXmoQbAX8mHjVaQxI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yym3KAPbn9qNC2OBGMjYtPvT6kmkA4f39Rpge2jGHEt/aiN06KQ4uFAokbNObVfRn
         z7tOPMD0DdV5mgpqPeRatxbc0Uxcx4COj3ju27HabhkmY5IO33lmt0T73jBz9a2H4B
         p5ZspCX3XwZ0Hlg901SyXBijbohBVkD6Pv+nWz3xb8EMGq4nEA+UaqvR4NVsYDLh+j
         13Y19RCxUW6M3qEDJPcpbs/qM4nqyUMeP2sd42VqwqC4msSiYNffilWp2YinfZkUx1
         yGOPM6k8BC9QL/sv5Las3SfCYVToR7lI8yhGtL0+FR8PE26uQR8peEv6vQb/KzcPpO
         4IB8buq1y0pVQ==
Received: by mail-lf1-f50.google.com with SMTP id p36so20765392lfa.12;
        Tue, 27 Dec 2022 11:09:05 -0800 (PST)
X-Gm-Message-State: AFqh2kqUFVZLi7XUqFNTAmI3BvoXh22Ob/wD9lUdvL+M65JDV3vnyPPA
        48MIkYcJBl1b/nKIOYwPFUb9BidUwY+xYc9BqgA=
X-Google-Smtp-Source: AMrXdXvcF3XoVDzIwaHd3nCZ+sdH8SqawTNuZbXSdUpEEloMj4+gOul+o/MJ1P2kmhyb/Nb4II/ZIxSU2n6rn2aDsMc=
X-Received: by 2002:a05:6512:1395:b0:4b5:b46b:17c7 with SMTP id
 p21-20020a056512139500b004b5b46b17c7mr2364489lfa.215.1672168143388; Tue, 27
 Dec 2022 11:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20221224133146.780578-1-nashuiliang@gmail.com> <Y6ofUzLHZKraIDre@krava>
In-Reply-To: <Y6ofUzLHZKraIDre@krava>
From:   Song Liu <song@kernel.org>
Date:   Tue, 27 Dec 2022 11:08:50 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7A7NFNeOrQn4AnvgqXvapCK7=XsZcirtYW4p+wNvJfjA@mail.gmail.com>
Message-ID: <CAPhsuW7A7NFNeOrQn4AnvgqXvapCK7=XsZcirtYW4p+wNvJfjA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix panic due to wrong pageattr of im->image
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 26, 2022 at 2:25 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Sat, Dec 24, 2022 at 09:31:46PM +0800, Chuang Wang wrote:
> > In the scenario where livepatch and kretfunc coexist, the pageattr of
> > im->image is rox after arch_prepare_bpf_trampoline in
> > bpf_trampoline_update, and then modify_fentry or register_fentry returns
> > -EAGAIN from bpf_tramp_ftrace_ops_func, the BPF_TRAMP_F_ORIG_STACK flag
> > will be configured, and arch_prepare_bpf_trampoline will be re-executed.
> >
> > At this time, because the pageattr of im->image is rox,
> > arch_prepare_bpf_trampoline will read and write im->image, which causes
> > a fault. as follows:
> >
> >   insmod livepatch-sample.ko    # samples/livepatch/livepatch-sample.c
> >   bpftrace -e 'kretfunc:cmdline_proc_show {}'
> >
> > BUG: unable to handle page fault for address: ffffffffa0206000
> > PGD 322d067 P4D 322d067 PUD 322e063 PMD 1297e067 PTE d428061
> > Oops: 0003 [#1] PREEMPT SMP PTI
> > CPU: 2 PID: 270 Comm: bpftrace Tainted: G            E K    6.1.0 #5
> > RIP: 0010:arch_prepare_bpf_trampoline+0xed/0x8c0
> > RSP: 0018:ffffc90001083ad8 EFLAGS: 00010202
> > RAX: ffffffffa0206000 RBX: 0000000000000020 RCX: 0000000000000000
> > RDX: ffffffffa0206001 RSI: ffffffffa0206000 RDI: 0000000000000030
> > RBP: ffffc90001083b70 R08: 0000000000000066 R09: ffff88800f51b400
> > R10: 000000002e72c6e5 R11: 00000000d0a15080 R12: ffff8880110a68c8
> > R13: 0000000000000000 R14: ffff88800f51b400 R15: ffffffff814fec10
> > FS:  00007f87bc0dc780(0000) GS:ffff88803e600000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffffffa0206000 CR3: 0000000010b70000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > <TASK>
> >  bpf_trampoline_update+0x25a/0x6b0
> >  __bpf_trampoline_link_prog+0x101/0x240
> >  bpf_trampoline_link_prog+0x2d/0x50
> >  bpf_tracing_prog_attach+0x24c/0x530
> >  bpf_raw_tp_link_attach+0x73/0x1d0
> >  __sys_bpf+0x100e/0x2570
> >  __x64_sys_bpf+0x1c/0x30
> >  do_syscall_64+0x5b/0x80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > With this patch, when modify_fentry or register_fentry returns -EAGAIN
> > from bpf_tramp_ftrace_ops_func, the pageattr of im->image will be reset
> > to nx+rw.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")

Good catch! Thanks for the fix!

> > Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
>
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <song@kernel.org>

>
> jirka
>
> > ---
> >  kernel/bpf/trampoline.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 11f5ec0b8016..d0ed7d6f5eec 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -488,6 +488,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
> >               /* reset fops->func and fops->trampoline for re-register */
> >               tr->fops->func = NULL;
> >               tr->fops->trampoline = 0;
> > +
> > +             /* reset im->image memory attr for arch_prepare_bpf_trampoline */
> > +             set_memory_nx((long)im->image, 1);
> > +             set_memory_rw((long)im->image, 1);
> >               goto again;
> >       }
> >  #endif
> > --
> > 2.37.2
> >
