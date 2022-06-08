Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4209543201
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbiFHN5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241042AbiFHN5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:57:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4A42A7899;
        Wed,  8 Jun 2022 06:57:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w27so27164308edl.7;
        Wed, 08 Jun 2022 06:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gO2t3wtyEoECjPIovchxxr9ODYsAfeoFgA+IZ5L72V0=;
        b=PiHHzAHatY1MKjUFG1qzCQDC2KMo3eA4xuvJTyVUFMNY2dNiQx6w1ltM+JM4M2v1yJ
         HE72ojGMzxFhZh84E3r9uOe7vdKM2on6QpBMocOHhyX0oEaOflRKib9Op+YnkaApngpN
         5VnXYVqm6/4pzvX/rOQxQTL0EPs3OhnFgF+24ixIsswx9nQlXB/0yFYQ9A/LiGDBEqXi
         K+bSzpiJVP4P6tbY4+FfXBy+G35xKp22FkEaKVfCCdK+UwRVbi1Co5m88E+pOB6QfdMS
         sUnMkyOuoyO3tjmX4rwIMfbKOIN3ZqZMCm7QSYB6fmfUkGQZN0dhUQFwvViiaABTFLS6
         cTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gO2t3wtyEoECjPIovchxxr9ODYsAfeoFgA+IZ5L72V0=;
        b=yyouvF60dqkqgazQpTleF6zhnQzRei0+iL/OvLJKVGQRRMJBMeO7fGruCN4zEuHr0O
         5XAvYblkq4FG6Q1+LFGgJUGHrxQ1kH6KOgN8CKg52oxI13yk1XGZxNREKbfeuEyyav+t
         iqLpzUifL0h8ksSEIpqYkSR8iR9ypj2pA7CgC+8nUpB5ahM6VIWCVTCsFW8sNheojz6j
         7wyzoulmH7kYfdDFjPQfKrmpFAdtye9Wpj8FtXbZCI5hkhhahfh4fSfypmIFi6riiVX+
         9hMM5+83e+UnFEKeLpGdeAW56tusKsTcf5sNO5nsp8SvqaJGUUrE2UnvsrLDUoayNVGm
         2H4g==
X-Gm-Message-State: AOAM532FAniae5AyW4e5bsmRfqZ5syeATcK9ZV4hw9U+N/ckBtlrUVvT
        2c6sdtLsLV+v0kQevcymRHONqS3yH4zXxc1k/qc=
X-Google-Smtp-Source: ABdhPJxKHvLAB+/eK3qiIJqKeCUWriUNsK5OkCNWlwNmS1PD65yA6SC6HMqn2HpFVr2cyKxoriRteevQfT3ihqnTmHU=
X-Received: by 2002:a05:6402:120b:b0:42f:aa44:4d85 with SMTP id
 c11-20020a056402120b00b0042faa444d85mr30127636edw.338.1654696632710; Wed, 08
 Jun 2022 06:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
 <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net> <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
 <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net> <20220608091017.0596dade@gandalf.local.home>
In-Reply-To: <20220608091017.0596dade@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 8 Jun 2022 06:57:00 -0700
Message-ID: <CAADnVQLhP1++YSGXrDTRPU6LR98Qkb5dNrcO1zs8HTUhTr9yHw@mail.gmail.com>
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 8, 2022 at 6:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 8 Jun 2022 14:38:39 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> > >>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > >>
> > >> Steven, I presume you'll pick this fix up?
> > >
> > > I'm currently at Embedded/Kernel Recipes, but yeah, I'll take a look at it. (Just need to finish my slides first ;-)
> >
> > Ok, thanks. If I don't hear back I presume you'll pick it up then.
>
> Yeah, I'm way behind due to the conference. And I'll be on PTO from
> tomorrow and back on Tuesday. And registration for Linux Plumbers is
> supposed to open today (but of course there's issues with that!), thus, I'm
> really have too much on my plate today :-p

Steven,

you missed Davem's presentation at KR about importance of delegation.
You need watch it:
https://youtu.be/ELPENQrtUas?t=9085
