Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE96B3205
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 00:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjCIXUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 18:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCIXUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 18:20:17 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD06CF4B7F
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 15:20:15 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id v48so2337278uad.6
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 15:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678404015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rnSlv/rmjMDZUxybeJVifkYNGPUHnfVxFIfeq1kf7IY=;
        b=TQ5NV6TQGumFikTyM6kNsgCEnE/kyO78cIo3cAVUv/HKv4J7O37baiRyJHxsUo7hCw
         tRFiaLvmu3NMfGPErd1v8EPJlT8xt578Uiir94fVnV/q/AQgDOs6eg3qWTubqy0nRaus
         NN5eZDKE1pj9mqcod3O2Y9Z1mzdIPAFyFIV3YArBVY7x2SgJdVekt5YblIdbt5he4P9N
         2q5he3O+/5KurruS1sk3fYNrh1NpcAmhTflSFM6WuFDgXCxoEZUJO1hRb0oJJOr+H10O
         ugtZ/ASKtyBzsBNyMvEFytXAjXG7TbPd1yc4Sw9WF0WsFppIilsTCwFWjSCVH3vWqSye
         0GPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678404015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rnSlv/rmjMDZUxybeJVifkYNGPUHnfVxFIfeq1kf7IY=;
        b=SCuoACedgRF+gymo+oc4uXljcnfeHKxrDU2o1p8LpFc9URx7VfPql4FVDBqjhr3KEQ
         le3go+wXdGouZsUnVB3JHjOqXfvXMyAgQeMpHXM1tadJuyzkN1xeoVls0oBGdy41jzhA
         zuT8NINmclLvdPgYnAT75wMzSfHDo4XZ6gVGyJviH+yUlymO0vQ3a6yENGAGIhNWWfgG
         /5sfzo92sSjT84r8sC1mv4CiZFaygXbrpeSOEoqbULZscENqfBEXV6Ra/fgFoF7683kA
         PMfN+jfAWq6sPrTeGr7Gsip9oZapDApnbKNJnFHMyeRD2JyV2hLPcHiQ/oK0b0L+NWoQ
         neaw==
X-Gm-Message-State: AO0yUKXQ9/fQznKOftAOTE+fwu5wD3FJrIkCOoTSJd2ZXwcoG2NOXCtk
        7HUcY5nRHJrQJ+YwRN01m+7PhO3PudmfuyqZv9HgHA==
X-Google-Smtp-Source: AK7set+L6zLR+gRS/iA552uIT6W/6f8DkT8CZtR7ZjTQsevZx3fGHENFeWF1CxlWZMz34NHLLJXGBQGdqI4W9iPwqfg=
X-Received: by 2002:a9f:3001:0:b0:68b:817b:eec8 with SMTP id
 h1-20020a9f3001000000b0068b817beec8mr15421336uab.0.1678404014773; Thu, 09 Mar
 2023 15:20:14 -0800 (PST)
MIME-Version: 1.0
References: <20230309101752.2025459-1-elver@google.com> <510ecaa9-508c-4f85-b6aa-fc42d2a96254@paulmck-laptop>
In-Reply-To: <510ecaa9-508c-4f85-b6aa-fc42d2a96254@paulmck-laptop>
From:   Marco Elver <elver@google.com>
Date:   Fri, 10 Mar 2023 00:19:35 +0100
Message-ID: <CANpmjNOGbSsXLqM59HQJ04T4ueMWjQjzpt4QqyKpne=KbHWREg@mail.gmail.com>
Subject: Re: [PATCH] kcsan: Avoid READ_ONCE() in read_instrumented_memory()
To:     paulmck@kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, Haibo Li <haibo.li@mediatek.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 Mar 2023 at 23:08, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Thu, Mar 09, 2023 at 11:17:52AM +0100, Marco Elver wrote:
> > Haibo Li reported:
> >
> >  | Unable to handle kernel paging request at virtual address
> >  |   ffffff802a0d8d7171
> >  | Mem abort info:o:
> >  |   ESR = 0x9600002121
> >  |   EC = 0x25: DABT (current EL), IL = 32 bitsts
> >  |   SET = 0, FnV = 0 0
> >  |   EA = 0, S1PTW = 0 0
> >  |   FSC = 0x21: alignment fault
> >  | Data abort info:o:
> >  |   ISV = 0, ISS = 0x0000002121
> >  |   CM = 0, WnR = 0 0
> >  | swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000002835200000
> >  | [ffffff802a0d8d71] pgd=180000005fbf9003, p4d=180000005fbf9003,
> >  | pud=180000005fbf9003, pmd=180000005fbe8003, pte=006800002a0d8707
> >  | Internal error: Oops: 96000021 [#1] PREEMPT SMP
> >  | Modules linked in:
> >  | CPU: 2 PID: 45 Comm: kworker/u8:2 Not tainted
> >  |   5.15.78-android13-8-g63561175bbda-dirty #1
> >  | ...
> >  | pc : kcsan_setup_watchpoint+0x26c/0x6bc
> >  | lr : kcsan_setup_watchpoint+0x88/0x6bc
> >  | sp : ffffffc00ab4b7f0
> >  | x29: ffffffc00ab4b800 x28: ffffff80294fe588 x27: 0000000000000001
> >  | x26: 0000000000000019 x25: 0000000000000001 x24: ffffff80294fdb80
> >  | x23: 0000000000000000 x22: ffffffc00a70fb68 x21: ffffff802a0d8d71
> >  | x20: 0000000000000002 x19: 0000000000000000 x18: ffffffc00a9bd060
> >  | x17: 0000000000000001 x16: 0000000000000000 x15: ffffffc00a59f000
> >  | x14: 0000000000000001 x13: 0000000000000000 x12: ffffffc00a70faa0
> >  | x11: 00000000aaaaaaab x10: 0000000000000054 x9 : ffffffc00839adf8
> >  | x8 : ffffffc009b4cf00 x7 : 0000000000000000 x6 : 0000000000000007
> >  | x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffffc00a70fb70
> >  | x2 : 0005ff802a0d8d71 x1 : 0000000000000000 x0 : 0000000000000000
> >  | Call trace:
> >  |  kcsan_setup_watchpoint+0x26c/0x6bc
> >  |  __tsan_read2+0x1f0/0x234
> >  |  inflate_fast+0x498/0x750
> >  |  zlib_inflate+0x1304/0x2384
> >  |  __gunzip+0x3a0/0x45c
> >  |  gunzip+0x20/0x30
> >  |  unpack_to_rootfs+0x2a8/0x3fc
> >  |  do_populate_rootfs+0xe8/0x11c
> >  |  async_run_entry_fn+0x58/0x1bc
> >  |  process_one_work+0x3ec/0x738
> >  |  worker_thread+0x4c4/0x838
> >  |  kthread+0x20c/0x258
> >  |  ret_from_fork+0x10/0x20
> >  | Code: b8bfc2a8 2a0803f7 14000007 d503249f (78bfc2a8) )
> >  | ---[ end trace 613a943cb0a572b6 ]-----
> >
> > The reason for this is that on certain arm64 configuration since
> > e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when
> > CONFIG_LTO=y"), READ_ONCE() may be promoted to a full atomic acquire
> > instruction which cannot be used on unaligned addresses.
> >
> > Fix it by avoiding READ_ONCE() in read_instrumented_memory(), and simply
> > forcing the compiler to do the required access by casting to the
> > appropriate volatile type. In terms of generated code this currently
> > only affects architectures that do not use the default READ_ONCE()
> > implementation.
> >
> > The only downside is that we are not guaranteed atomicity of the access
> > itself, although on most architectures a plain load up to machine word
> > size should still be atomic (a fact the default READ_ONCE() still relies
> > on itself).
> >
> > Reported-by: Haibo Li <haibo.li@mediatek.com>
> > Tested-by: Haibo Li <haibo.li@mediatek.com>
> > Cc: <stable@vger.kernel.org> # 5.17+
> > Signed-off-by: Marco Elver <elver@google.com>
>
> Queued, thank you!
>
> This one looks like it might want to go into v6.4 rather than later.

Yes, I think that'd be appropriate - thank you!

Thanks,
-- Marco
