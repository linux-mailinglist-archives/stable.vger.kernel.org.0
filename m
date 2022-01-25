Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749D349B2B5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380740AbiAYLI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:08:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33576 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380278AbiAYLGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:06:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D6A7B817B6;
        Tue, 25 Jan 2022 11:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D2BC340E0;
        Tue, 25 Jan 2022 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643108799;
        bh=79ZI1JT+t/0XUq5Nd2ugbFp9FNFvpyW7RBwf/PEiaOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UddznvuzlmuabaNfZ910sOYv5zSt2ptwySdcu5NvWjvh94qnj2gQM5xic4vdlBqbw
         b/hbRQCRnUKqwrCGNDmIk7BJfzwOJ+VbSEiLu0+w2bPM8K4DbzEq6agp7JQW6b0qL3
         VhTh7tZit0OMd1nrj3CSOB3vbGNOs6seav7LVhS8=
Date:   Tue, 25 Jan 2022 12:06:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux@roeck-us.net,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux- stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
Message-ID: <Ye/ZvUzng9NWTuPM@kroah.com>
References: <20220124184100.867127425@linuxfoundation.org>
 <29a0f562-af46-f4d0-182c-09c8d99e0a93@applied-asynchrony.com>
 <CAEf4BzaOHPD72jTsdJjUa6md2AyRp2LnArNKyrKCva6pWCdzaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzaOHPD72jTsdJjUa6md2AyRp2LnArNKyrKCva6pWCdzaA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 02:09:13PM -0800, Andrii Nakryiko wrote:
> On Mon, Jan 24, 2022 at 12:36 PM Holger Hoffstätte
> <holger@applied-asynchrony.com> wrote:
> >
> > On 2022-01-24 19:31, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.17 release.
> >
> > Oh noes :(
> >
> >    DESCEND bpf/resolve_btfids
> >    MKDIR     /tmp/linux-5.15.17/tools/bpf/resolve_btfids//libbpf
> >    GEN     /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/bpf_helper_defs.h
> >    MKDIR   /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/
> >    CC      /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o
> > libbpf.c: In function 'bpf_object__elf_collect':
> > libbpf.c:3038:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
> >   3038 |                         if (sh->sh_type != SHT_PROGBITS)
> >        |                               ^~
> > libbpf.c:3042:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
> >   3042 |                         if (sh->sh_type != SHT_PROGBITS)
> >        |                               ^~
> > make[4]: *** [/tmp/linux-5.15.17/tools/build/Makefile.build:97: /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o] Error 1
> > make[3]: *** [Makefile:158: /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o] Error 2
> > make[2]: *** [Makefile:44: /tmp/linux-5.15.17/tools/bpf/resolve_btfids//libbpf/libbpf.a] Error 2
> > make[1]: *** [Makefile:72: bpf/resolve_btfids] Error 2
> > make: *** [Makefile:1371: tools/bpf/resolve_btfids] Error 2
> >
> > Reverting "libbpf-validate-that-.btf-and-.btf.ext-sections-cont.patcht" aka
> > this one:
> >
> > > Andrii Nakryiko <andrii@kernel.org>
> > >      libbpf: Validate that .BTF and .BTF.ext sections contain data
> >
> > makes it build & run fine. I looked for followups but couldn't find anything that
> > stood out, maybe the BPF folks (cc'ed) know what's missing/wrong.
> >
> 
> That small fix depends on much bigger refactoring in ad23b7238474
> ("libbpf: Use Elf64-specific types explicitly for dealing with ELF").
> I think this small fix can be dropped.
> 
> That's sort of a general rule with libbpf-related fixes, they are
> usually not that critical to backport to stable, because most users
> use/build libbpf from its Github mirror, which is always taken from
> latest bpf-next. Libbpf is also not supposed to be used with untrusted
> inputs (i.e., BPF object files) as BPF programs are loaded into the
> kernel under root.

Ok, thanks, I'll drop this from all queues now.

greg k-h
