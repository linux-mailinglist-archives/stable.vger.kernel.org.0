Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC4E27DFD0
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 07:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI3FCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 01:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3FCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 01:02:44 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88702C061755;
        Tue, 29 Sep 2020 22:02:44 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so494134ioo.1;
        Tue, 29 Sep 2020 22:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2L4BOn8S8ZEQiaz0ZaNci4yPFlfsiiI1rMiH6j8O80k=;
        b=ccJlmumEMdmdL+AUwMDLoC0Zy9h6HuZmFhnlbTxGx6rf6moISZDdzANWeZTYV+Ld+r
         aryRRJnRTBtkMjdMxMAOFd5loC+1y68iLOFjv/vFOFr5tMgUEP5rPa/b5QQLEIf7BEFb
         PBmRG0Qhr5aGxZWZtBBm/r3anZr35FCgpqREl0b6n9ZMvINQZIBCHuNSwaxZQUfPzBtp
         u+JCrkd13OW+ZffAKTyHksLkK2qVt3bdFEcLMsyS6vAD2gZJvoxGPeeJcTArZWLeuq+7
         okuEgRyL0BivGP9zXHbXhsYLf8HRHfnLpKqKl4NfvH4h09p+eRfuhgBzvZrTzwESBvDH
         i/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2L4BOn8S8ZEQiaz0ZaNci4yPFlfsiiI1rMiH6j8O80k=;
        b=WxNDvGRRtik1DjOr8bSc/vTeCvIubTc1jhj4LFgT/KEvBsVv5Wy108larX0yqVGEqD
         qfBj0gk0TuPS9yssQN2+Rs1HlfHfxuC9n9S6cFNoDgsFTbmK7xRs7GJ6bdoS8rqJ6MRJ
         /KQfBXckxVp3uGxWCDrgGKPqh4z5JYairr9/ltpF8RsP8j9MVSk3KFJMfKqBqswitD+8
         pJYcCcgRu6LtzUDbALGWhDSvd1J2mmTRSliX/la7oQsGWXOcFVj0uh2jOc1P1VrHgqm+
         ndLUZOym06IpwJKjwjJoSC/oKuklG4l3QVi1gi8z2dVJmZ/41VG9+koikRt2YywMSppp
         u9Jg==
X-Gm-Message-State: AOAM533GqN0bf20JXzZzc8YDh0IgLIeFwwS7HcUsUdjveMiiUfUpNNuE
        5SMc20+I/I+r8PUtgx2z4LjyoWz1mXIwZ8WFJ/DHTKoKyTDTdQ==
X-Google-Smtp-Source: ABdhPJx874JdJWi/PjFEU7pyg5PW4eJmki3ci47iJNa8bNx9wAmCd7QnHdVOq+S1Gveo0sskds+UHz8aP585ZMmV8tc=
X-Received: by 2002:a02:c914:: with SMTP id t20mr580463jao.117.1601442163872;
 Tue, 29 Sep 2020 22:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105929.719230296@linuxfoundation.org> <20200929105931.461063397@linuxfoundation.org>
 <CAFxkdAoyenpdGV9XoFqtjEW02UVfa_i56NMKdmDFW89GSrZ5cg@mail.gmail.com>
In-Reply-To: <CAFxkdAoyenpdGV9XoFqtjEW02UVfa_i56NMKdmDFW89GSrZ5cg@mail.gmail.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Tue, 29 Sep 2020 22:02:36 -0700
Message-ID: <CAPGftE9uCh9Wn2or+zBqu3212sfT+4R-FZA_GVxbYks8uJrsSQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 35/99] tools/libbpf: Avoid counting local symbols in
 ABI check
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[adding Michael Ellerman, linux-ppc maintainer]

Hello Justin,

On Tue, 29 Sep 2020 at 14:54, Justin Forbes <jmforbes@linuxtx.org> wrote:
>
> On Tue, Sep 29, 2020 at 6:53 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Tony Ambardar <tony.ambardar@gmail.com>
> >
> > [ Upstream commit 746f534a4809e07f427f7d13d10f3a6a9641e5c3 ]
> >
> > Encountered the following failure building libbpf from kernel 5.8.5 sources
> > with GCC 8.4.0 and binutils 2.34: (long paths shortened)
> >
> >   Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
> >   match with num of versioned symbols in libbpf.so (236). Please make sure
> >   all LIBBPF_API symbols are versioned in libbpf.map.
> > #  --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
> > #  +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
> >   @@ -1,3 +1,5 @@
> >   +_fini
> >   +_init
> >    bpf_btf_get_fd_by_id
> >    bpf_btf_get_next_id
> >    bpf_create_map
> >   make[4]: *** [Makefile:210: check_abi] Error 1
> >
> > Investigation shows _fini and _init are actually local symbols counted
> > amongst global ones:
> >
> >   $ readelf --dyn-syms --wide libbpf.so|head -10
> >
> >   Symbol table '.dynsym' contains 343 entries:
> >      Num:    Value  Size Type    Bind   Vis      Ndx Name
> >        0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
> >        1: 00004098     0 SECTION LOCAL  DEFAULT   11
> >        2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
> >        3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
> >        4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
> >        5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
> >        6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1
> >
> > A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
> > same with the libbpf.so DSO for consistent comparison.
> >
> > Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Link: https://lore.kernel.org/bpf/20200905214831.1565465-1-Tony.Ambardar@gmail.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> This seems to work everywhere else, but breaks PPC64LE.
>

I also ran into a PPC build error while working on some bpf problems,
but it seemed
like a pre-existing PPC issue. I did submit an upstream fix, which is
marked for stable
and being reviewed by Michael. See here for discussion and the patch:
https://lkml.org/lkml/2020/9/17/668.

Is that the same problem you encountered? Does that patch address your issue?

Thanks,
Tony

> Justin
>
> > ---
> >  tools/lib/bpf/Makefile |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --
> >                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> >                            sort -u | wc -l)
> >  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> > +                             awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> >                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
> >
> >  CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
> > @@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
> >                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> >                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
> >                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> > +                   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> >                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
> >                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> >                 diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
> >
> >
