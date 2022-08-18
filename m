Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CDD597E0C
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 07:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiHRF0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 01:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbiHRF0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 01:26:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D3DAEDAD;
        Wed, 17 Aug 2022 22:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D41AB820C3;
        Thu, 18 Aug 2022 05:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45060C433C1;
        Thu, 18 Aug 2022 05:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660800390;
        bh=WJTjzdS6c1W3uyDTb0gdRx+bN6X9MbeQshppyhTvGgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YtEdMwqRdfW1F8NSGcloyZidFvh7UnCnYo45q9D5kuC2errLeBuIrV6DHjQMiwGRx
         pa7UpDvXSHQ9IY1xP7p/YlLfIE0M94Q2+kZzuJzvm9vw9Qb9yf0hn/u+IiSW5x9H8r
         lNd4TerPr2lR5UdzIN1In8vxeDccib3DyudA1Ed4=
Date:   Thu, 18 Aug 2022 07:26:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf] bpf: Fix kernel BUG in purge_effective_progs
Message-ID: <Yv3NhNspJ0hdf55G@kroah.com>
References: <20220813134030.1972696-1-pulehui@huawei.com>
 <CAEf4BzaciJNVP1YsuJTiS9v7wBvTpShj+kMtwkzk8ijnpL_yzw@mail.gmail.com>
 <7cbb4aa6-c576-8671-ea5e-d845a8310394@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbb4aa6-c576-8671-ea5e-d845a8310394@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 10:46:33AM +0800, Pu Lehui wrote:
> 
> 
> On 2022/8/17 4:39, Andrii Nakryiko wrote:
> > On Sat, Aug 13, 2022 at 6:11 AM Pu Lehui <pulehui@huawei.com> wrote:
> > > 
> > > Syzkaller reported kernel BUG as follows:
> > > 
> > > ------------[ cut here ]------------
> > > kernel BUG at kernel/bpf/cgroup.c:925!
> > > invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > CPU: 1 PID: 194 Comm: detach Not tainted 5.19.0-14184-g69dac8e431af #8
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > > RIP: 0010:__cgroup_bpf_detach+0x1f2/0x2a0
> > > Code: 00 e8 92 60 30 00 84 c0 75 d8 4c 89 e0 31 f6 85 f6 74 19 42 f6 84
> > > 28 48 05 00 00 02 75 0e 48 8b 80 c0 00 00 00 48 85 c0 75 e5 <0f> 0b 48
> > > 8b 0c5
> > > RSP: 0018:ffffc9000055bdb0 EFLAGS: 00000246
> > > RAX: 0000000000000000 RBX: ffff888100ec0800 RCX: ffffc900000f1000
> > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888100ec4578
> > > RBP: 0000000000000000 R08: ffff888100ec0800 R09: 0000000000000040
> > > R10: 0000000000000000 R11: 0000000000000000 R12: ffff888100ec4000
> > > R13: 000000000000000d R14: ffffc90000199000 R15: ffff888100effb00
> > > FS:  00007f68213d2b80(0000) GS:ffff88813bc80000(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000055f74a0e5850 CR3: 0000000102836000 CR4: 00000000000006e0
> > > Call Trace:
> > >   <TASK>
> > >   cgroup_bpf_prog_detach+0xcc/0x100
> > >   __sys_bpf+0x2273/0x2a00
> > >   __x64_sys_bpf+0x17/0x20
> > >   do_syscall_64+0x3b/0x90
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7f68214dbcb9
> > > Code: 08 44 89 e0 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 48 89 f8 48 89
> > > f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> > > f0 ff8
> > > RSP: 002b:00007ffeb487db68 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> > > RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f68214dbcb9
> > > RDX: 0000000000000090 RSI: 00007ffeb487db70 RDI: 0000000000000009
> > > RBP: 0000000000000003 R08: 0000000000000012 R09: 0000000b00000003
> > > R10: 00007ffeb487db70 R11: 0000000000000246 R12: 00007ffeb487dc20
> > > R13: 0000000000000004 R14: 0000000000000001 R15: 000055f74a1011b0
> > >   </TASK>
> > > Modules linked in:
> > > ---[ end trace 0000000000000000 ]---
> > > 
> > > Repetition steps:
> > > For the following cgroup tree,
> > > 
> > > root
> > >   |
> > > cg1
> > >   |
> > > cg2
> > > 
> > > 1. attach prog2 to cg2, and then attach prog1 to cg1, both bpf progs
> > > attach type is NONE or OVERRIDE.
> > > 2. write 1 to /proc/thread-self/fail-nth for failslab.
> > > 3. detach prog1 for cg1, and then kernel BUG occur.
> > > 
> > > Failslab injection will cause kmalloc fail and fall back to
> > > purge_effective_progs. The problem is that cg2 have attached another prog,
> > > so when go through cg2 layer, iteration will add pos to 1, and subsequent
> > > operations will be skipped by the following condition, and cg will meet
> > > NULL in the end.
> > > 
> > > `if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))`
> > > 
> > > The NULL cg means no link or prog match, this is as expected, and it's not
> > > a bug. So here just skip the no match situation.
> > > 
> > > Fixes: 4c46091ee985 ("bpf: Fix KASAN use-after-free Read in compute_effective_progs")
> > > Signed-off-by: Pu Lehui <pulehui@huawei.com>
> > > ---
> > >   kernel/bpf/cgroup.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 59b7eb60d5b4..4a400cd63731 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -921,8 +921,10 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
> > >                                  pos++;
> > >                          }
> > >                  }
> > > +
> > > +               /* no link or prog match, skip the cgroup of this layer */
> > > +               continue;
> > >   found:
> > > -               BUG_ON(!cg);
> > 
> > I don't think it's necessary to remove this BUG_ON(), but it also
> > feels unnecessary for purge_effective_progs, so I don't mind it.
> > 
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > 
> 
> Hi,
> 
> Will this patch be accepted? I think we should CC stable.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
