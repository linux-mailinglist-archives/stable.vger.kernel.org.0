Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F7D59A4DF
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354772AbiHSRsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354820AbiHSRrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 13:47:14 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E6BD5EB3
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:13:50 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u9so6884583lfg.11
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=edg8lK0cSqRr9RuI8JDP5IrO1qX/mkNkGe7tR1FyceM=;
        b=JbpEeM3LmaZg4DRJJpStFU53Gd1ryMDuKjMAfF6g+kqPtgpIU3Ls4NTo3SL/btxnqC
         tJqoY3AiiI4FN/qq6IqSr1OV4ZqUHcl7nFuUlN5HIzTZKXoPruMSEMy90MwENLtwZ28r
         56TnufYCaUs4tYioKNOo5y9CdUZiVe0bvhS3ifBJZ92976Ca0NxvQB0PTTjuRlEHg27l
         cHWHLVjB82y3eBY4FXYii6uSSuQ61M/LkZxF7Ninx/OM/K2qe3fvG8ZPrpWuJU4aOs+G
         BJ4vXYzg6wt4dZq73s1G/r/5wpjbL7EGfI84mU0Eiu09j3X79oJwP83NDlh5jSC14fox
         iMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=edg8lK0cSqRr9RuI8JDP5IrO1qX/mkNkGe7tR1FyceM=;
        b=sYxgvzjBSIHxDhp7/UNAmRugRrxV66M2yCzgk0jr5P1xZ8XdnOwktddWIOmY8meETW
         7h357egdpYGvtA9Icfx9HvizvO7diy9B/TX6WJUoWXWNGRyAxFBvwXwoRq/q5VBVC2mU
         P3bckfEohH1frKd31cE0MRhsFglcJXLDlt/7e3/1fCZ2B0ERu1e8sfo9WFaTK7egdm/q
         y7cuO1oOp8f5HHPJNcP2OkdGZgdMoWfJarp1r5FEg+hB2xlLGKTPix0mfnZ3M9YYK0XQ
         PuD3pBJxN0rMmWX1hNGDM9Z31Xzdtcl6blM1uqUvYF+z9mYpSzq79JtPsSix8LwGL1jx
         v1jw==
X-Gm-Message-State: ACgBeo1NQLmsOJRHaXfrLK/gbNEbi8ViVXZUL+PvkvNFCb1ezRT3sxxO
        v9YL/NJGWqpNwanSztd+clESRsCS/QMdnjhnZDMXig==
X-Google-Smtp-Source: AA6agR7Ug/2q+/DeCl94fc+McGXHwOFifbrv7g/ZFyCweAxodclr6jIcrvFs5tqrGJuuT1RNGO2dBUUVakteqjYXYf0=
X-Received: by 2002:a05:6512:158b:b0:48b:38:cff8 with SMTP id
 bp11-20020a056512158b00b0048b0038cff8mr2578141lfb.100.1660929228166; Fri, 19
 Aug 2022 10:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153829.135562864@linuxfoundation.org> <20220819153829.269574566@linuxfoundation.org>
In-Reply-To: <20220819153829.269574566@linuxfoundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 19 Aug 2022 10:13:36 -0700
Message-ID: <CAKwvOd=DQcLbmk0R+h80s4dQ3NrPy+RXqHKnOrAtyam+-QOCyw@mail.gmail.com>
Subject: Re: [PATCH 5.10 002/545] x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fangrui Song <maskray@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry for not reporting this sooner; been out sick all week with COVID.

On Fri, Aug 19, 2022 at 8:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
>
> commit ffcf9c5700e49c0aee42dcba9a12ba21338e8136 upstream.
>

<snip>

> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -68,6 +68,10 @@ LDFLAGS_vmlinux := -pie $(call ld-option
>  ifdef CONFIG_LD_ORPHAN_WARN
>  LDFLAGS_vmlinux += --orphan-handling=warn
>  endif
> +LDFLAGS_vmlinux += -z noexecstack
> +ifeq ($(CONFIG_LD_IS_BFD),y)

5.10.y is missing CONFIG_LD_IS_BFD. Specifically

commit 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
which first landed in v5.12-rc1.  I'd recommend simply dropping the
`ifeq` guards; the ld-option guard will still work.  Otherwise GNU BFD
2.39 users will observe linker warnings related to rwx-segments.

Greg, do you mind dropping this patch and I'll supply a v2, or is it
too late and I should send a patch on top?

> +LDFLAGS_vmlinux += $(call ld-option,--no-warn-rwx-segments)
> +endif
>  LDFLAGS_vmlinux += -T
>
>  hostprogs      := mkpiggy

-- 
Thanks,
~Nick Desaulniers
