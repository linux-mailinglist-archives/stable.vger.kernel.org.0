Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA82127ED83
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgI3Pkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 11:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgI3Pkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 11:40:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3957AC061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 08:40:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so2331969wrx.7
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 08:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Kl2Qd9DygVOpqWB4QvrjPtrBb/z+P5PDh0hUEj2+t8=;
        b=KZrVCEC5/Wv+orMHsjVSmKr+y0GLZepxtFRVopYUKjsPsHSJZcZpbjRIy49UptMWRd
         FB45fGhhZPN/QyFOG3ugTk/cslCBzTtUEA9ca+dvifnguUB3DRBk6lGDJOe/ephxgHAZ
         zXPMsPerE9BfJZAQtQa914ki48jd/di3vfpEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Kl2Qd9DygVOpqWB4QvrjPtrBb/z+P5PDh0hUEj2+t8=;
        b=bJCryCTZaWFdGCz25/w9CLzhvDfHUtxTKpDA7hw9UYadGPwqVCSIfYTSpJtJSCeJQD
         hNCCQhvcZ9QQbi/H1SN4MDKrAmAIDZc7gAYi/cNp3fg3KpmreD78pyDnYgWbQg/XVxgG
         wq8JA2mvWVEfqFlXaYHnAFUV8RvjQXk4i8niOarV0tK1gFTkujYYdGxPI0fm804hLJMY
         hzdnFtdA73+TiMgr0E4FsnwU8gRVXJovwhyz80qVPjpEjjIdFw8ZUJE/cojTn9dAoFSZ
         YDlZo8dKWZamWJInALiMyAUb7G1dM7tesIMY1i53R1ECoJfKbay9e7NM/afzV2bWJZC7
         OmPg==
X-Gm-Message-State: AOAM533qV4tkhb/88pPeTyUASM0SrvN4zt57c66KGW1NUxd90r8Fgn1t
        piGWbICPRENMs+G34WqLsQ1oMtF3KkNzOdUq7hrewQ==
X-Google-Smtp-Source: ABdhPJyovthY6wL6WkzoBh46/ttwHT8LSDLHRz39NUSk95y8G78RCIWbtSvH4XGpkqyG0BfoG8t1cXgZCGMmIy/KDFo=
X-Received: by 2002:adf:e9c1:: with SMTP id l1mr3876277wrn.68.1601480445753;
 Wed, 30 Sep 2020 08:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105929.719230296@linuxfoundation.org> <20200929105931.461063397@linuxfoundation.org>
 <CAFxkdAoyenpdGV9XoFqtjEW02UVfa_i56NMKdmDFW89GSrZ5cg@mail.gmail.com> <CAPGftE9uCh9Wn2or+zBqu3212sfT+4R-FZA_GVxbYks8uJrsSQ@mail.gmail.com>
In-Reply-To: <CAPGftE9uCh9Wn2or+zBqu3212sfT+4R-FZA_GVxbYks8uJrsSQ@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 30 Sep 2020 10:40:33 -0500
Message-ID: <CAFxkdAqNwLB6xs1c+0PveuWtj64BQVfsqkunufo0Kf8MNANMYQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 35/99] tools/libbpf: Avoid counting local symbols in
 ABI check
To:     Tony Ambardar <tony.ambardar@gmail.com>
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

On Wed, Sep 30, 2020 at 12:02 AM Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> [adding Michael Ellerman, linux-ppc maintainer]
>
> Hello Justin,
>
> On Tue, 29 Sep 2020 at 14:54, Justin Forbes <jmforbes@linuxtx.org> wrote:
> >
> > On Tue, Sep 29, 2020 at 6:53 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Tony Ambardar <tony.ambardar@gmail.com>
> > >
> > > [ Upstream commit 746f534a4809e07f427f7d13d10f3a6a9641e5c3 ]
> > >
> > > Encountered the following failure building libbpf from kernel 5.8.5 sources
> > > with GCC 8.4.0 and binutils 2.34: (long paths shortened)
> > >
> > >   Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
> > >   match with num of versioned symbols in libbpf.so (236). Please make sure
> > >   all LIBBPF_API symbols are versioned in libbpf.map.
> > > #  --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
> > > #  +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
> > >   @@ -1,3 +1,5 @@
> > >   +_fini
> > >   +_init
> > >    bpf_btf_get_fd_by_id
> > >    bpf_btf_get_next_id
> > >    bpf_create_map
> > >   make[4]: *** [Makefile:210: check_abi] Error 1
> > >
> > > Investigation shows _fini and _init are actually local symbols counted
> > > amongst global ones:
> > >
> > >   $ readelf --dyn-syms --wide libbpf.so|head -10
> > >
> > >   Symbol table '.dynsym' contains 343 entries:
> > >      Num:    Value  Size Type    Bind   Vis      Ndx Name
> > >        0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
> > >        1: 00004098     0 SECTION LOCAL  DEFAULT   11
> > >        2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
> > >        3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
> > >        4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
> > >        5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
> > >        6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1
> > >
> > > A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
> > > same with the libbpf.so DSO for consistent comparison.
> > >
> > > Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
> > > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > Link: https://lore.kernel.org/bpf/20200905214831.1565465-1-Tony.Ambardar@gmail.com
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> > This seems to work everywhere else, but breaks PPC64LE.
> >
>
> I also ran into a PPC build error while working on some bpf problems,
> but it seemed
> like a pre-existing PPC issue. I did submit an upstream fix, which is
> marked for stable
> and being reviewed by Michael. See here for discussion and the patch:
> https://lkml.org/lkml/2020/9/17/668.
>
> Is that the same problem you encountered? Does that patch address your issue?

It is not, the issue I see is:
Warning: Num of global symbols in sharedobjs/libbpf-in.o (259) does
NOT match with num of versioned symbols in libbpf.so (50). Please make
sure all LIBBPF_API symbols are versioned in libbpf.map.

I only see it on ppc64le with this patch, all other arch that Fedora
builds are fine (x86_64, i686, aarch64, armv7, s390).  If I revert
this patch, all builds succeed.  We are using gcc 10.2.1 though.

Justin

>
> Thanks,
> Tony
>
> > Justin
> >
> > > ---
> > >  tools/lib/bpf/Makefile |    2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > --- a/tools/lib/bpf/Makefile
> > > +++ b/tools/lib/bpf/Makefile
> > > @@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --
> > >                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> > >                            sort -u | wc -l)
> > >  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> > > +                             awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> > >                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
> > >
> > >  CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
> > > @@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
> > >                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> > >                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
> > >                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> > > +                   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> > >                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
> > >                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> > >                 diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
> > >
> > >
