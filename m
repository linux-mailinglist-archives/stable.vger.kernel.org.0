Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1D26B56F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgIOXoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgIOXnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 19:43:53 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC5C061788
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:43:52 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id 7so2944317vsp.6
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1DPRkUZDl392dX2kwtfz30F6Ge2UvEVr5Xwbj157Pec=;
        b=TgmvDqGep6Mg+RrQgN0IuphaYGXD5YK6lGXof/b3gC2ZUQI3baIKi/dcwzaEEh+X9a
         oVea6cQC/2QlSGMIIl6TSuGQfMJiz1SODtof0lTh5O2mr72EIG45+zImzt9+OA4FzN2X
         irXtM6lwLw9k7aRfZgduhshxzqoVtaD297lhYn3gAOG23peLwr9zIDlNfZJtEIPPXCtN
         8yLaBAIo0ODxh2rUchR66hr05MQz694vyC3ulncxAawih0GO1dRVCEShB5sp8Xe+l+w6
         OargJSouEY7d9+Qua7bC9zf667ZfZXDkqqKzdXWG9HynCmT2wM1DEGPKQKYwGYOkHfTo
         TYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1DPRkUZDl392dX2kwtfz30F6Ge2UvEVr5Xwbj157Pec=;
        b=mF2ODH/WkWo2qvebLsOacPP4btM+l9048uNVOF9wsXzXKiMds1b/isuGAmX6RfR3sk
         byhM8JJD/Jsg7+q9b+McRD77rZJIqn5a/6uqgudbEga0Mb6kuBI5lG3Iy6641E+uo1eK
         Mu1ueMeDlfpJAKfcfHlSb8UI/gxhtx98OPEG/buOyZ9tcKDJJLvsGtDLXlxOqY9XVW+V
         TTMpctei+zMRhM0gbUh/lcR81yd2F0FYAnppahKHwkkP+pIVE8N7mzxUOoagHUawV6P2
         xpSfKVdDm1GpXGHrMFz/hoKdkmrwZbDQoKQOQFSzx00jkNdBrnGaHdGxX91Wt/EHENK6
         w3Bw==
X-Gm-Message-State: AOAM532I0lALIyUrSfJmgAsxWdIhJT6JVnpdigSaCcikE6TVWMxfqi8D
        SQxuPyBjZr4MPFbTFWd86avXoxScQQGaT4jrLKPq
X-Google-Smtp-Source: ABdhPJxDsDmh1UhpZ9JnDm+RZz60OFyCMd+BjldyowwnjBe3TMzfHABs8c5D/Ic9i9iCyeyQ6GuTtZ3TexGVYicQ4kQ=
X-Received: by 2002:a67:f7cb:: with SMTP id a11mr3011158vsp.58.1600213431006;
 Tue, 15 Sep 2020 16:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net> <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
In-Reply-To: <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 15 Sep 2020 16:43:39 -0700
Message-ID: <CAGG=3QUUgqLFdKMtJQuvASdD2JiGuiM4BcYrUrpLto+jmB6ohw@mail.gmail.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 4:40 PM Andrew Cooper <andrew.cooper3@citrix.com> w=
rote:
>
> On 16/09/2020 00:11, Andy Lutomirski wrote:
> >> On Sep 15, 2020, at 2:24 PM, Nick Desaulniers <ndesaulniers@google.com=
> wrote:
> >>
> >> =EF=BB=BFOn Tue, Sep 15, 2020 at 1:56 PM Andy Lutomirski <luto@kernel.=
org> wrote:
> >>> The old smap_save() code was:
> >>>
> >>>  pushf
> >>>  pop %0
> >>>
> >>> with %0 defined by an "=3Drm" constraint.  This is fine if the
> >>> compiler picked the register option, but it was incorrect with an
> >>> %rsp-relative memory operand.
> >> It is incorrect because ... (I think mentioning the point about the
> >> red zone would be good, unless there were additional concerns?)
> > This isn=E2=80=99t a red zone issue =E2=80=94 it=E2=80=99s a just-plain=
-wrong issue.  The popf is storing the result in the wrong place in memory =
=E2=80=94 it=E2=80=99s RSP-relative, but RSP is whatever the compiler think=
s it should be minus 8, because the compiler doesn=E2=80=99t know that push=
fq changed RSP.
>
> It's worse than that.  Even when stating that %rsp is modified in the
> asm, the generated code sequence is still buggy, for recent Clang and GCC=
.
>
> https://godbolt.org/z/ccz9v7
>
> It's clearly not safe to ever use memory operands with pushf/popf asm
> fragments.
>
Would this apply to native_save_fl() and native_restore_fl in
arch/x86/include/asm/irqflags.h? It was like that two revisions ago,
but it was changed (back) to "=3Drm" with a comment about it being safe.

> >> This is something we should fix.  Bill, James, and I are discussing
> >> this internally.  Thank you for filing a bug; I owe you a beer just
> >> for that.
> > I=E2=80=99m looking forward to the day that beers can be exchanged in p=
erson again :)
>
> +1 to that.
>
+100

-bw
