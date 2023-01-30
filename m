Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0515681C40
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjA3VEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 16:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjA3VE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 16:04:27 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E4947EDB;
        Mon, 30 Jan 2023 13:04:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m2so35242733ejb.8;
        Mon, 30 Jan 2023 13:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7PgfiDJfXr3snHFNvpVEuL8JdLQTDd0vNID/MExBMQw=;
        b=JymqcdzWTjmwsGWSJ6/Q8tMC8BCwZuJxzPG7pzdb4uIEnKd/Nqag4dBJCYeCTHxtPl
         Sq4aBvKbZHpQ1YLTymviHFcLlgYAsT05LfOLwOH8eJybmdHBk7Ys7nq1E7mCjlUeJcpE
         759JFskqVZwYuE2zwAV8XjEOIbKqb1BVASQUKWy+zWvYPkzzakx9PoIGxQOBZXQLcJrF
         4fI3gO5cVFhL/+KjydxjqvYUvYxfkSfUjMwizRx7142kOtuSLnTfAUOLexRlmLkO2Bw5
         oxk0/8xNIqpqchG+2nwxUp6rfD9dtbgOMYKD6Id/xqA5E0EcZu0cs+B2vuGNG63yCGCP
         KJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PgfiDJfXr3snHFNvpVEuL8JdLQTDd0vNID/MExBMQw=;
        b=6VKESxgncXr4y2ddwy7Dl6/pM1ynpf9xCTGqDBoRZYMHnBbfSsWpgUobZCWve6fXlF
         EtBQeHeSUYuQ+R4BHI2h0W6OBWm6XvbRtUMQBYLYo/p6+AoHTwvGHqvZnCs6s8RTyVyH
         5/19hMYP3gdWxzreOrUDT5MIMglTYnpL8Djs55R6Rd6Wbc7tIBh+sfQSzwbAeSRKILyE
         xGJkb36zlqd0K+fLRnusZamkCN235hIYcWfKogTHiFwwqSJulYDc+LvFZupRREME00ij
         jarLBWf4AscwYe5taPNk4nxSr/HeNSFigVExRducomm+XMnEupFJAltEnWfgv01Gf6OE
         csWg==
X-Gm-Message-State: AO0yUKXVGj31XBgi7mY6QKmsCLk3Hc9I9Tebtqmi7PsQM0tdbgoPNCga
        Qw7rrUIx6PXHjeP7hEzjkmOAsQCysyqvsqbazKw=
X-Google-Smtp-Source: AK7set/142GEEA0/4909juyZJfVRjmlJ6/58BsZBMmdfRBeZKiCN/6AL8iJ53MG8sQb1I9hTgaHGJcltO1NuoZzoazs=
X-Received: by 2002:a17:906:b2d7:b0:883:8fdc:fbba with SMTP id
 cf23-20020a170906b2d700b008838fdcfbbamr1882584ejb.215.1675112646635; Mon, 30
 Jan 2023 13:04:06 -0800 (PST)
MIME-Version: 1.0
References: <20230130183549.85471-1-mathieu.desnoyers@efficios.com>
In-Reply-To: <20230130183549.85471-1-mathieu.desnoyers@efficios.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Jan 2023 13:03:55 -0800
Message-ID: <CAADnVQLve5je3GKesCjn5HhuxgOe2u1OX7GQnx-58dsuUFWbZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests: bpf: Fix incorrect kernel headers
 search path
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 10:36 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> building against kernel headers from the build environment in scenarios
> where kernel headers are installed into a specific output directory
> (O=...).
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Cc: <bpf@vger.kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Mykola Lysenko <mykolal@fb.com>
> Cc: <stable@vger.kernel.org>    [5.18+]
> ---
>  tools/testing/selftests/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index c22c43bbee19..6998c816afef 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -327,7 +327,7 @@ endif
>  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>  BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)          \
>              -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> -            -I$(abspath $(OUTPUT)/../usr/include)
> +            $(KHDR_INCLUDES)

It breaks the build:
https://github.com/kernel-patches/bpf/actions/runs/4047075637/jobs/6960655246

make[1]: *** No rule to make target '/linux/bpf.h', needed by
'/tmp/work/bpf/bpf/tools/testing/selftests/bpf/bpf-helpers.rst'. Stop.
