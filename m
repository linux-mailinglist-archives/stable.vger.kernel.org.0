Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5294533E2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhKPORn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhKPORd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:17:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E10DF61A40;
        Tue, 16 Nov 2021 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637072074;
        bh=7G6p0eMBJYpvdBwMo9D60h07DEbfBQdsNKicFx83ZM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jSSx2zqG6YDhoIGugcxwWjMJZ76XGHGU3Bg/hHHvTROWrLd40xaLq0ndVoNXB73F2
         BM09Ms2awQTL54arbQrExeqdeqLrwwazNSqbivPOuEnsoZRWKZG+b3bZVxwFwgSaB4
         sNd33T5ZBMXBDldGU+KrOESAcWmteyqTdUqtsvNY=
Date:   Tue, 16 Nov 2021 15:14:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, f.fainelli@gmail.com,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, linux- stable <stable@vger.kernel.org>,
        pavel@denx.de, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux@roeck-us.net, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
Message-ID: <YZO8yO9tn3C7XhHp@kroah.com>
References: <20211115165313.549179499@linuxfoundation.org>
 <CA+G9fYvxhzL9KUxZcRzMxnbGPK5GKTCtb5kWM3JB09D+-KhVug@mail.gmail.com>
 <CAEf4BzZHsbAhA6RJYias+e10PsXWbOD9ekyNMAHKt5PKAGe=Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZHsbAhA6RJYias+e10PsXWbOD9ekyNMAHKt5PKAGe=Rw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:57:55PM -0800, Andrii Nakryiko wrote:
> On Mon, Nov 15, 2021 at 10:00 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Mon, 15 Nov 2021 at 22:39, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.160 release.
> > > There are 355 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > Perf build broken due to following errors.
> >
> > > Andrii Nakryiko <andrii@kernel.org>
> > >     libbpf: Fix BTF data layout checks and allow empty BTF
> >
> >
> > In file included from btf.c:17:
> > btf.c: In function 'btf_parse_hdr':
> > btf.c:104:62: error: 'struct btf' has no member named 'raw_size'; did
> > you mean 'data_size'?
> >   104 |                 pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> >       |                                                              ^~~~~~~~
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build log:
> > https://builds.tuxbuild.com/20xsgAxLwf4E60xl2dTdXnNS8FZ/
> 
> Greg,
> 
> c733c19fda7b ("libbpf: Fix BTF data layout checks and allow empty
> BTF") should either be dropped, or fixed like the below:
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3380aadb7465..41daf0fa95b9 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -101,7 +101,7 @@ static int btf_parse_hdr(struct btf *btf)
>         }
> 
>         if (meta_left < hdr->str_off + hdr->str_len) {
> -               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> +               pr_debug("Invalid BTF total size:%u\n", btf->data_size);
>                 return -EINVAL;
>         }
> 
> Not sure which one you'd prefer. Both will fix perf build.

I'll go fix it up, thanks.

greg k-h
