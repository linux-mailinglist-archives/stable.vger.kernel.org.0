Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A133988E
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhCLUmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhCLUm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:42:28 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5595C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:42:27 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso16555806wmi.3
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=82KaU8rRGbC4SRlavZEO/o0WBgI/8cKjqwRh6gM9xL4=;
        b=dPeOC/QYJlD6XedfIvkkf+QCtOknF8ll9DimFepj143F7qWUpD6N/VDXLsIbu95aeq
         S/1n3chzJqdtSfkCHJcpGwUMRjvBNJUQ6mGkPCpHbhBwUDGHqEy6y8nJ9DxNA8YoKmO6
         jWXkHeIdoql4KtkUzLVp09ztjUrAncodbp871Du7xuBwApstpwXuSPxipCj3zXxg1pZf
         odXzeneSa3o4ccgehOsYA8FJCFGt/+pIz1sdAkgQQA55B2LwnwHdwwYXpYAHkr7dFNTG
         zjPC/tcJPtXjuaqk09Kzyde4V7hXaQlPPS+XaeIgpmUnptc3mJfqF+4RP5O2fqoWKVXB
         AtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=82KaU8rRGbC4SRlavZEO/o0WBgI/8cKjqwRh6gM9xL4=;
        b=VH8+8jo8TFKO5f5mCOuAGwe4fDBXdP+HkTUWX8p7ryOGXIHEpx0qkHea2F/JVm4T30
         gaspJ+aBqPPddcyFZ0VQui5G3Fxqc8gC5gNzXmNQaHMpYKEArTi+3KUQx6UIAfuqT+ir
         iV7rjk2a3SHq/I1Awj/5Xlr48vHWECTsf+7wRfECrHooOajmXODgEsH7uAp+9Lvf8Z/k
         XQnzQpnWm35PxHKmYOVjQsaTBQqBLOq3hQGyOy0gvA6U3Fhu60WNC+TO9DxRPSbuLELp
         S6ZA03NZ9HeJbydV7uv4WzVZxwaZZrvD9VB3ZjUZ5l7k71hhWf9EJ/IjKJ6FhRRBy0wA
         me8w==
X-Gm-Message-State: AOAM532OvsxmThIdNzkSFxBOMV7ym79QCWVWr0BgPC7zA4Uw/mO8WVuJ
        9eNXHdgA/M4OEDEITHN3ZJqpTZecd+DzaP7YWV2tXQ==
X-Google-Smtp-Source: ABdhPJwIrk4f3Yw+bbOTwbomuktKVdekQAmAYAf/Iuglm5QA+EZ/RkR214KQPx0BR1M5kOXgDk/f7OaFxclanyQNRMU=
X-Received: by 2002:a1c:5416:: with SMTP id i22mr14764626wmb.146.1615581746480;
 Fri, 12 Mar 2021 12:42:26 -0800 (PST)
MIME-Version: 1.0
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
 <20210312203900.1012048-1-manojgupta@google.com>
In-Reply-To: <20210312203900.1012048-1-manojgupta@google.com>
From:   Manoj Gupta <manojgupta@google.com>
Date:   Fri, 12 Mar 2021 12:42:15 -0800
Message-ID: <CAH=QcsjRO26U_Y12B9LWJakvrFa+hyT4V5dmKjmYGRLNO5b=9A@mail.gmail.com>
Subject: Re: [PATCH] scripts/recordmcount.{c,pl}: support -ffunction-sections
 .text.* section names
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
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

This patch should apply cleanly to 4.4.y and 4.9.y branches.

Thanks,
Manoj
