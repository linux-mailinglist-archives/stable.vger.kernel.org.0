Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14622E6C34
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgL1Wzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgL1Tsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 14:48:36 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83981C0613D6;
        Mon, 28 Dec 2020 11:47:56 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v67so10616545ybi.1;
        Mon, 28 Dec 2020 11:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJxWnY3S6EVUF/zhRpyGnoCte1dOf0xelEIF09j73nE=;
        b=RCZifI1lUFBuAuSjA+FJzk6ncmyhWCzRBCsChj43TCMv3dLeHpj8+LhbvI+z1vkPEN
         iQw2b2k33JsygORAbwXGo8lkjxUjPgjuYLD19MEUO/ityxb4RFaK9Pty/F8UX02V0XBu
         W/TJhGZlTTHa9MT8AY8cHtL+Dqe4Ye44juGhW1PKQh+9HyyW1dGYvqHVKhpTFcYVBFId
         uwLi8Y1oQVK/OaeFy3D29tgEoVwXD1RQfBpN/FVYSVID0V86YMuGReq0cy3WrCByKOV7
         mHiy9h/PR9GzAr+aO6zRoASfPuse+XzrIobf1xDvyyzklQNzgLP7LQdWF/hBkY1lxlZL
         eKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJxWnY3S6EVUF/zhRpyGnoCte1dOf0xelEIF09j73nE=;
        b=QpnTUE7nuUai9BqlnsTEjfIPNX4F3Zey7kf07h7C//b8zOJcXXr8v7NWzwJjUc9xzM
         ZGwt2whqNCuXrzsRwu8pIuGIXC5/ciEo54nnDBu2qjJD8cake9oYZL0CG5n/u7vZom5E
         nhu/PaVjN8AsjFkkCgwUA0Jxl8AJO5lR3pmIzZ7Qpn2mrk5++5iGdKVcJsEUuWbTlWvo
         ZCc6lWcb3bVjor/sr+SbzYZeQ/GXsRaH5xdo3UebtcgO+i9fO2I5tcjt1XF2yG2j9tH+
         OYXYf0gZJgcKN0hGeL/ww/uYx1z78tRCFoBir2IDkZvlUrgnLlsb2MwW7iaAZJbtoRj4
         m9Eg==
X-Gm-Message-State: AOAM531qJrHrzjHpsflvQ+3Y0IRk9LGrPD6T0iHMDcoxP0Zo9mpPfA3r
        WIrTP7HgwKSYq8rtLJaO9z9SDHd/PMcPCg4lJhg=
X-Google-Smtp-Source: ABdhPJyshbe47AaEyX0gpX5HJt+JCQjfxlMQHpk/yBV2w/ItPm5nzLQWre/A/IVCufs4uHzvsjmsRVnbiwyV4D5qfoc=
X-Received: by 2002:a25:2c4c:: with SMTP id s73mr48282328ybs.230.1609184875632;
 Mon, 28 Dec 2020 11:47:55 -0800 (PST)
MIME-Version: 1.0
References: <20201228124937.240114599@linuxfoundation.org> <20201228124942.316302285@linuxfoundation.org>
 <CA+G9fYsekTQvNQQEGYi==s9Dv+NPOSEg4jzcyYdAAwpYAYtdtw@mail.gmail.com>
In-Reply-To: <CA+G9fYsekTQvNQQEGYi==s9Dv+NPOSEg4jzcyYdAAwpYAYtdtw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Dec 2020 11:47:44 -0800
Message-ID: <CAEf4BzZyCP8Kw=5DJiG0Uw1+3usbOy5FiJpqVTqOJJNDdZMNrw@mail.gmail.com>
Subject: Re: [PATCH 5.4 106/453] libbpf: Fix BTF data layout checks and allow
 empty BTF
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 7:49 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Perf build failed on stable-rc 5.4 branch due to this patch.
>
> On Mon, 28 Dec 2020 at 19:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Andrii Nakryiko <andrii@kernel.org>
> >
> > [ Upstream commit d8123624506cd62730c9cd9c7672c698e462703d ]
> >
> > Make data section layout checks stricter, disallowing overlap of types and
> > strings data.
> >
> > Additionally, allow BTFs with no type data. There is nothing inherently wrong
> > with having BTF with no types (put potentially with some strings). This could
> > be a situation with kernel module BTFs, if module doesn't introduce any new
> > type information.
> >
> > Also fix invalid offset alignment check for btf->hdr->type_off.
> >
> > Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Link: https://lore.kernel.org/bpf/20201105043402.2530976-8-andrii@kernel.org
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c | 16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index d606a358480da..3380aadb74655 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -100,22 +100,18 @@ static int btf_parse_hdr(struct btf *btf)
> >                 return -EINVAL;
> >         }
> >
> > -       if (meta_left < hdr->type_off) {
> > -               pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
> > +       if (meta_left < hdr->str_off + hdr->str_len) {
> > +               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>
> In file included from btf.c:17:0:
> btf.c: In function 'btf_parse_hdr':
> btf.c:104:48: error: 'struct btf' has no member named 'raw_size'; did
> you mean 'data_size'?
>    pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>                                                 ^
> libbpf_internal.h:59:40: note: in definition of macro '__pr'
>   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>                                         ^~~~~~~~~~~
> btf.c:104:3: note: in expansion of macro 'pr_debug'
>    pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>    ^~~~~~~~
>

This patch fixes the bug introduced back in 8a138aed4a80 ("bpf: btf:
Add BTF support to libbpf"), but a bunch of other refactorings
happened since then, adding/renaming struct btf internals. The fix
here is not that critical, so it's probably best to just drop this
patch from the stable, if possible. Would it be ok, Greg?

> full build log link,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/346/consoleText
>
> --
> Linaro LKFT
> https://lkft.linaro.org
