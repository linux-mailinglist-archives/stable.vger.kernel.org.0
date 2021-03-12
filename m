Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0F3398B3
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhCLUxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbhCLUxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:53:08 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D44C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:53:07 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 16so8966593ljc.11
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8dK+kdR+Ia9D858+IkNK4cy01vXdBXb8r7JBQS6iTM=;
        b=JPAqdux6FP/jSvJzpI+QGKWoqHD7US0IJJG90OSDr/8PS9mMT8me4nkgsXR6naZsQn
         GIDRlHHZlxV+JPsfgNHXNz0lqk2c9No65Tb+YFjDlMKFmnIw6/Acru6SQYCB/ZE6TzMq
         On5w6GwrNAMlxRmGd1QiSgG2jK7Mos/dl2gPamwO2dvJWmT9eU4sNpD326rPndMKwpKD
         OTK+OMX84hxiElgpiOw78Z6QyKP3qhrSj/02qxbYcsIS/DfhmX9W7trbLPHol+USFfR9
         VR/5PnhRzB6B4NCwGseK9eLFgtoWLxvoLozdt4Ga52PybdCtYR6Ax9xJpbpjJoMjTL5Z
         t/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8dK+kdR+Ia9D858+IkNK4cy01vXdBXb8r7JBQS6iTM=;
        b=ExkLv5jgHMdv3MM7svBsWIQia9maeUn30XpAzxC+L3mwKGIR2vYRvtEq2Tvqb9Fx7a
         a5z+QGbO6uEBZQ5DbeavtAkoUWazfdxfPys5i4ZKKZFJyP9U9jMMPrOWebST5Qs0642X
         gquE7xDnvMXwPsUj9jurs4xh2yzp8r1capUIPpp+E7stLlWAcv+yJsyPkPgio9YctNdB
         9x+jI6uS9h6pps52QnbP1RqT5Sj3km96HWucy3e7KDovOYWp+MnCWoK2WuR/HO4NVikp
         bwyf+NN4ABLa0DH1mxUAlEe60wx8YaUEQaNl23IqtRoPym0+pG9UJO4HuOZ1kTRvI+Uk
         zKng==
X-Gm-Message-State: AOAM531ArtXAmeNuQk/kgprXJ+nRUEgBr9gROnUI2BEgOtC3iLumeNa4
        Q6Ufg5EH+xfY51N2Jelyc+RvkFbsRKwXphhcwTyXuw==
X-Google-Smtp-Source: ABdhPJzPkuUsJhAduz7cNChe9mPxjyxr/evKcHvnC+dVRmxVMzWKna6d6VTOOB+8JSYLpGD3+Vw3GVdnN/5pjClm+2A=
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr3405610ljp.495.1615582385619;
 Fri, 12 Mar 2021 12:53:05 -0800 (PST)
MIME-Version: 1.0
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
 <20210312203900.1012048-1-manojgupta@google.com>
In-Reply-To: <20210312203900.1012048-1-manojgupta@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 12 Mar 2021 12:52:54 -0800
Message-ID: <CAKwvOdnD90DTS+3zMidxNiapeKoC_vUW62rdn1h7M9i__ieA3Q@mail.gmail.com>
Subject: Re: [PATCH] scripts/recordmcount.{c,pl}: support -ffunction-sections
 .text.* section names
To:     Manoj Gupta <manojgupta@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Doug Anderson <dianders@google.com>,
        Luis Lozano <llozano@google.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 12:39 PM Manoj Gupta <manojgupta@google.com> wrote:
>
> From: Joe Lawrence <joe.lawrence@redhat.com>
>
> commit 9c8e2f6d3d361439cc6744a094f1c15681b55269 upstream.
>
> When building with -ffunction-sections, the compiler will place each
> function into its own ELF section, prefixed with ".text".  For example,
> a simple test module with functions test_module_do_work() and
> test_module_wq_func():
>
>   % objdump --section-headers test_module.o | awk '/\.text/{print $2}'
>   .text
>   .text.test_module_do_work
>   .text.test_module_wq_func
>   .init.text
>   .exit.text
>
> Adjust the recordmcount scripts to look for ".text" as a section name
> prefix.  This will ensure that those functions will be included in the
> __mcount_loc relocations:
>
>   % objdump --reloc --section __mcount_loc test_module.o
>   OFFSET           TYPE              VALUE
>   0000000000000000 R_X86_64_64       .text.test_module_do_work
>   0000000000000008 R_X86_64_64       .text.test_module_wq_func
>   0000000000000010 R_X86_64_64       .init.text
>
> Link: http://lkml.kernel.org/r/1542745158-25392-2-git-send-email-joe.lawrence@redhat.com
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> [nc: Resolve conflict because of missing 42c269c88dc146982a54a8267f71abc99f12852a]

^ Isn't `nc:` here supposed to be your initials, ie. `mg:`, or do I
have that wrong?
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
doesn't clarify.

> Signed-off-by: Manoj Gupta <manojgupta@google.com>
> ---
>  scripts/recordmcount.c  |  2 +-
>  scripts/recordmcount.pl | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
> index 7250fb38350c..8cba4c44da4c 100644
> --- a/scripts/recordmcount.c
> +++ b/scripts/recordmcount.c
> @@ -362,7 +362,7 @@ static uint32_t (*w2)(uint16_t);
>  static int
>  is_mcounted_section_name(char const *const txtname)
>  {
> -       return strcmp(".text",           txtname) == 0 ||
> +       return strncmp(".text",          txtname, 5) == 0 ||
>                 strcmp(".ref.text",      txtname) == 0 ||
>                 strcmp(".sched.text",    txtname) == 0 ||
>                 strcmp(".spinlock.text", txtname) == 0 ||
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index ccd6614ea218..5ca4ec297019 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -138,6 +138,11 @@ my %text_sections = (
>       ".text.unlikely" => 1,
>  );
>
> +# Acceptable section-prefixes to record.
> +my %text_section_prefixes = (
> +     ".text." => 1,
> +);
> +
>  # Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
>  $objdump = 'objdump' if (!$objdump);
>  $objcopy = 'objcopy' if (!$objcopy);
> @@ -503,6 +508,14 @@ while (<IN>) {
>
>         # Only record text sections that we know are safe
>         $read_function = defined($text_sections{$1});
> +       if (!$read_function) {
> +           foreach my $prefix (keys %text_section_prefixes) {
> +               if (substr($1, 0, length $prefix) eq $prefix) {
> +                   $read_function = 1;
> +                   last;
> +               }
> +           }
> +       }
>         # print out any recorded offsets
>         update_funcs();
>
> --
> 2.31.0.rc2.261.g7f71774620-goog
>


-- 
Thanks,
~Nick Desaulniers
