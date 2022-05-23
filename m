Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B7531C62
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiEWTVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiEWTVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C466FD39;
        Mon, 23 May 2022 11:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C0160EE1;
        Mon, 23 May 2022 18:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA565C34117;
        Mon, 23 May 2022 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653332254;
        bh=OWd/ySVRtm861E8s8n2JRU3oIy2zcHMEA7OAhMhMD0Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rgXY4jQNr0jhd2VzDnzONqyxpjq+DRy7d0Oyo9+o2BfKTInHLjPJ1o0tfZ1y1ppAy
         984gQNu/KwNwZCeWVDO7IbYSPTYtaWpTtWxkMqmok/4rnbMuekaZFrT69ZRmNNhp5D
         ZexwYNr2MfGvFAyNt4X7WlMejvKXYjNJYJ/Hf2iFdBzPdkOW8YlNZCOKSJ5scW34+y
         SNaxKIKj2cEzYZOhploOy8ERqEzcm0usw+FIs46tV7vFc6Bgk1/rFCaz05qyxGC/H0
         991Qe9BSTkT029qIHmYszoOFewxjCxf1mfrUO36BYuyRMQqvso5SAXmGZWS/0noSyl
         HoyKsRNJEPBSA==
Received: by mail-yb1-f176.google.com with SMTP id f16so27083837ybk.2;
        Mon, 23 May 2022 11:57:33 -0700 (PDT)
X-Gm-Message-State: AOAM532GllkrkMsPDn2g7x4s0CWvtY31fC+OKTyivJgTuZzQIWq6eoz8
        5nCqSV97EZJdvcEG/QHCFQaTVIIuyUNMQmtF2ww=
X-Google-Smtp-Source: ABdhPJwpUl45mQF6Le9oPjjLEKhMIiKzbdco5QLvubl7g1xdHP7v4zCKIkAA/3ljv3Sr8nF2nkHCz5b7Avv1D89CaN0=
X-Received: by 2002:a25:1e56:0:b0:64e:a226:6f6b with SMTP id
 e83-20020a251e56000000b0064ea2266f6bmr22903931ybe.322.1653332252808; Mon, 23
 May 2022 11:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220512220808.766832-1-song@kernel.org>
In-Reply-To: <20220512220808.766832-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Mon, 23 May 2022 11:57:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW48q=_aFh6SO8fBJ-Zh9upRDo0RL3QySbnkum9EROBLyw@mail.gmail.com>
Message-ID: <CAPhsuW48q=_aFh6SO8fBJ-Zh9upRDo0RL3QySbnkum9EROBLyw@mail.gmail.com>
Subject: Re: [PATCH] ftrace: clean up hash direct_functions on register failures
To:     open list <linux-kernel@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kernel Team <kernel-team@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 3:08 PM Song Liu <song@kernel.org> wrote:
>
> We see the following GPF when register_ftrace_direct fails:
>
> [ ] general protection fault, probably for non-canonical address \
>   0x200000000000010: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
> [...]
> [ ] RIP: 0010:ftrace_find_rec_direct+0x53/0x70
> [ ] Code: 48 c1 e0 03 48 03 42 08 48 8b 10 31 c0 48 85 d2 74 [...]
> [ ] RSP: 0018:ffffc9000138bc10 EFLAGS: 00010206
> [ ] RAX: 0000000000000000 RBX: ffffffff813e0df0 RCX: 000000000000003b
> [ ] RDX: 0200000000000000 RSI: 000000000000000c RDI: ffffffff813e0df0
> [ ] RBP: ffffffffa00a3000 R08: ffffffff81180ce0 R09: 0000000000000001
> [ ] R10: ffffc9000138bc18 R11: 0000000000000001 R12: ffffffff813e0df0
> [ ] R13: ffffffff813e0df0 R14: ffff888171b56400 R15: 0000000000000000
> [ ] FS:  00007fa9420c7780(0000) GS:ffff888ff6a00000(0000) knlGS:000000000
> [ ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ ] CR2: 000000000770d000 CR3: 0000000107d50003 CR4: 0000000000370ee0
> [ ] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ ] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ ] Call Trace:
> [ ]  <TASK>
> [ ]  register_ftrace_direct+0x54/0x290
> [ ]  ? render_sigset_t+0xa0/0xa0
> [ ]  bpf_trampoline_update+0x3f5/0x4a0
> [ ]  ? 0xffffffffa00a3000
> [ ]  bpf_trampoline_link_prog+0xa9/0x140
> [ ]  bpf_tracing_prog_attach+0x1dc/0x450
> [ ]  bpf_raw_tracepoint_open+0x9a/0x1e0
> [ ]  ? find_held_lock+0x2d/0x90
> [ ]  ? lock_release+0x150/0x430
> [ ]  __sys_bpf+0xbd6/0x2700
> [ ]  ? lock_is_held_type+0xd8/0x130
> [ ]  __x64_sys_bpf+0x1c/0x20
> [ ]  do_syscall_64+0x3a/0x80
> [ ]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ ] RIP: 0033:0x7fa9421defa9
> [ ] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 9 f8 [...]
> [ ] RSP: 002b:00007ffed743bd78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> [ ] RAX: ffffffffffffffda RBX: 00000000069d2480 RCX: 00007fa9421defa9
> [ ] RDX: 0000000000000078 RSI: 00007ffed743bd80 RDI: 0000000000000011
> [ ] RBP: 00007ffed743be00 R08: 0000000000bb7270 R09: 0000000000000000
> [ ] R10: 00000000069da210 R11: 0000000000000246 R12: 0000000000000001
> [ ] R13: 00007ffed743c4b0 R14: 00000000069d2480 R15: 0000000000000001
> [ ]  </TASK>
> [ ] Modules linked in: klp_vm(OK)
> [ ] ---[ end trace 0000000000000000 ]---
>
> One way to trigger this is:
>   1. load a livepatch that patches kernel function xxx;
>   2. run bpftrace -e 'kfunc:xxx {}', this will fail (expected for now);
>   3. repeat #2 => gpf.
>
> This is because the entry is added to direct_functions, but not removed.
> Fix this by remove the entry from direct_functions when
> register_ftrace_direct fails.
>
> Also remove the last trailing space from ftrace.c, so we don't have to
> worry about it anymore.
>
> Cc: stable@vger.kernel.org
> Fixes: 763e34e74bb7 ("ftrace: Add register_ftrace_direct()")
> Signed-off-by: Song Liu <song@kernel.org>

Hi Steven,

Could you please share your thoughts on this fix?

Thanks,
Song

> ---
>  kernel/trace/ftrace.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4f1d2f5e7263..375293c5f3e9 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4465,7 +4465,7 @@ int ftrace_func_mapper_add_ip(struct ftrace_func_mapper *mapper,
>   * @ip: The instruction pointer address to remove the data from
>   *
>   * Returns the data if it is found, otherwise NULL.
> - * Note, if the data pointer is used as the data itself, (see
> + * Note, if the data pointer is used as the data itself, (see
>   * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
>   * if the data pointer was set to zero.
>   */
> @@ -5200,8 +5200,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
>
>         if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
>                 ret = register_ftrace_function(&direct_ops);
> -               if (ret)
> +               if (ret) {
>                         ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
> +                       remove_hash_entry(direct_functions, entry);
> +               }
>         }
>
>         if (ret) {
> --
> 2.30.2
>
