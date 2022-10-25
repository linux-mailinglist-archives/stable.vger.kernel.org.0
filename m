Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32D660C885
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJYJjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiJYJif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:38:35 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67101167F52;
        Tue, 25 Oct 2022 02:36:44 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-367b8adf788so108205957b3.2;
        Tue, 25 Oct 2022 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mNxQEjL/V4yP5gsJ1H7RUL9p3LPRKd3sWcTMKae8OOk=;
        b=HHlNcFVN4C8TgcdRotrtR0A17b7iY52sTc4J1mPK8olxiFR5WTU6LIy2fX6IuOOaU1
         3YdMjnVVe8x40xAkubfqWTZzALfUAp5B6Qu9QZv6nNvDSLjdPUG2Psn8Ak8MRspgQQ7p
         6EeqbBvhDLxX4Eci5XLJPJ/yB/sAo3DF32vHS4r1C0ABrTYDUdka6ef2LeRYJzFY2wwy
         7NzcUp0NX563q0Looevp3F/W8S/IXjtPvcrzXxA9UFO+saB3dEZYd3WGPupNq6UfJS6g
         t1j7/AgFTXN0H9GeWImTajIEP1NdArYCO/AO4PO9dS+NB1SAxc/bSbx10+Zl1OUEQMEY
         zEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mNxQEjL/V4yP5gsJ1H7RUL9p3LPRKd3sWcTMKae8OOk=;
        b=hAmQxhvnWhwnJ98eVnHJqXVFHBE30LNpU0VwCfIoEBUq8lnF/8KaQov/aoOaret1mU
         E+9YoKJa3ABxr07cUD6MWV5alcR1IL2kYYv1Yv0ojZnn9qkHl1YbguzPdCNRg0uS5zkN
         LcUH2jHlcTrImECmo5z3or+4qNS7Lm3JvubzbSB79l4cLj05JpCJM/XzYpYTcVw6Q6X/
         A+VMRsZPQyXZCK0iH9d7or+1mRsJaUwKlpRFgUIhBIiHVXsbxZvbSOLgJICzS8rgwbr5
         NHtHGsJ2ebTARt+eUR32UagmVDtDo7o/xp3lD9bp6AEK0ECk9aKC40VZ5NFPxIMJt5JO
         TZ/w==
X-Gm-Message-State: ACrzQf006MBWV8U0vGYcM96Jk+XfZr/8kvewyl4K4yYz97i0fris8wU8
        DBQ5JNJfIWlv+KOQNsqi2NkCl4yzhh63kDSWc88=
X-Google-Smtp-Source: AMsMyM4et7nfTSr5UaXSMNavui1Bnf26mPkjLKv4PTdv+lYDsQ3jCG1YqJ6dDeXXqY3S8aTJeOsI6kiZU9flhsXTwHY=
X-Received: by 2002:a81:85c5:0:b0:361:1718:7d with SMTP id v188-20020a8185c5000000b003611718007dmr32753894ywf.491.1666690603403;
 Tue, 25 Oct 2022 02:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221025080628.523300-1-nashuiliang@gmail.com> <Y1el0SXrk8paN1Zm@krava>
In-Reply-To: <Y1el0SXrk8paN1Zm@krava>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Tue, 25 Oct 2022 17:36:32 +0800
Message-ID: <CACueBy4qfQYfN8Eu_-gNU2y1eiPXwLKSiVDmZU2DWuD3ZjZPWw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Clean up all resources when register_fprobe_ips
 returns an error
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     stable@vger.kernel.org, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Sorry, I didn't notice this.

On Tue, Oct 25, 2022 at 5:01 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Tue, Oct 25, 2022 at 04:06:28PM +0800, Chuang Wang wrote:
> > When register_fprobe_ips returns an error, bpf_link_cleanup just cleans
> > up bpf_link_primer's resources and forgets to clean up
> > bpf_kprobe_multi_link, addrs, cookies.
> >
> > So, by adding 'goto error', this ensures that all resources are cleaned
> > up.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
> > Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
> > ---
> >  kernel/trace/bpf_trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 1ed08967fb97..5b806ef20857 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2778,7 +2778,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >       err = register_fprobe_ips(&link->fp, addrs, cnt);
> >       if (err) {
> >               bpf_link_cleanup(&link_primer);
> > -             return err;
> > +             goto error;
>
> that should be taken care of bpf_kprobe_multi_link_dealloc,
> through the fput path in bpf_link_cleanup
>
> do you see any related memory leak like report in kmemleak?
>
> jirka
>
> >       }
> >
> >       return bpf_link_settle(&link_primer);
> > --
> > 2.34.1
> >
