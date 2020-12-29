Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEAA2E6F87
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 10:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgL2Jnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 04:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgL2Jnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 04:43:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F5E1206ED;
        Tue, 29 Dec 2020 09:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609234989;
        bh=sUnwYXpbxM4Oah3agUrzRr2W6shz/+ZuVqCPcEvWiRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vv8z0EfOpPnxCpLi9Fv6/spzoMU8jJkDaYuwRVjX0iaETImfS0IGhp7qWgUFO7KfW
         thg/wk+SheALGMtmf8w8pF37lF2FcubW2JctL/HUA5lJQmNCA/5LL7QgMp1NAxR9pN
         1digr2SR4YMxhOQbr4DKxAVf6WUfqxYjR9WLcBR8=
Date:   Tue, 29 Dec 2020 10:44:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.4 106/453] libbpf: Fix BTF data layout checks and allow
 empty BTF
Message-ID: <X+r6fb7wIpM3HMi7@kroah.com>
References: <20201228124937.240114599@linuxfoundation.org>
 <20201228124942.316302285@linuxfoundation.org>
 <CA+G9fYsekTQvNQQEGYi==s9Dv+NPOSEg4jzcyYdAAwpYAYtdtw@mail.gmail.com>
 <CAEf4BzZyCP8Kw=5DJiG0Uw1+3usbOy5FiJpqVTqOJJNDdZMNrw@mail.gmail.com>
 <20201228230925.GH2790422@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228230925.GH2790422@sasha-vm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 06:09:25PM -0500, Sasha Levin wrote:
> On Mon, Dec 28, 2020 at 11:47:44AM -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 28, 2020 at 7:49 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > > 
> > > Perf build failed on stable-rc 5.4 branch due to this patch.
> > > 
> > > On Mon, 28 Dec 2020 at 19:15, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Andrii Nakryiko <andrii@kernel.org>
> > > >
> > > > [ Upstream commit d8123624506cd62730c9cd9c7672c698e462703d ]
> > > >
> > > > Make data section layout checks stricter, disallowing overlap of types and
> > > > strings data.
> > > >
> > > > Additionally, allow BTFs with no type data. There is nothing inherently wrong
> > > > with having BTF with no types (put potentially with some strings). This could
> > > > be a situation with kernel module BTFs, if module doesn't introduce any new
> > > > type information.
> > > >
> > > > Also fix invalid offset alignment check for btf->hdr->type_off.
> > > >
> > > > Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> > > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > Link: https://lore.kernel.org/bpf/20201105043402.2530976-8-andrii@kernel.org
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/btf.c | 16 ++++++----------
> > > >  1 file changed, 6 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > > > index d606a358480da..3380aadb74655 100644
> > > > --- a/tools/lib/bpf/btf.c
> > > > +++ b/tools/lib/bpf/btf.c
> > > > @@ -100,22 +100,18 @@ static int btf_parse_hdr(struct btf *btf)
> > > >                 return -EINVAL;
> > > >         }
> > > >
> > > > -       if (meta_left < hdr->type_off) {
> > > > -               pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
> > > > +       if (meta_left < hdr->str_off + hdr->str_len) {
> > > > +               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> > > 
> > > In file included from btf.c:17:0:
> > > btf.c: In function 'btf_parse_hdr':
> > > btf.c:104:48: error: 'struct btf' has no member named 'raw_size'; did
> > > you mean 'data_size'?
> > >    pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> > >                                                 ^
> > > libbpf_internal.h:59:40: note: in definition of macro '__pr'
> > >   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
> > >                                         ^~~~~~~~~~~
> > > btf.c:104:3: note: in expansion of macro 'pr_debug'
> > >    pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> > >    ^~~~~~~~
> > > 
> > 
> > This patch fixes the bug introduced back in 8a138aed4a80 ("bpf: btf:
> > Add BTF support to libbpf"), but a bunch of other refactorings
> > happened since then, adding/renaming struct btf internals. The fix
> > here is not that critical, so it's probably best to just drop this
> > patch from the stable, if possible. Would it be ok, Greg?
> 
> I'll drop it, thanks.

Thanks for dropping this and doing the other fixups.  I'll go push out
some -rc2 releases soon...

greg k-h
