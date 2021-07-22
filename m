Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6C3D1E40
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 08:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhGVFsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 01:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhGVFsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 01:48:37 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB322C061575;
        Wed, 21 Jul 2021 23:29:12 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id c204so3044333ybb.4;
        Wed, 21 Jul 2021 23:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=omt89YrYl8SYlYFr5IxniwvXvCqTlIiuhpE846cjoPM=;
        b=a+H1u/mFwtesHWVLhdIrJqCzj4UPaHxGL+9D16I9vQhIwK7VC1MAGCZpxCaLdNeOuE
         tFSNjz4VN3G6Fd/aOh0yPIQTd8BlojvLAyKlFKCZRVqzDpdfSO+iK00ktZhaizQcJYN6
         Sk4QtJmxsGQtb3y6Xr/+fry4KcSzxGAA0EPRfFyd+0OY3mJqcghoT2d+Fjts4Lqfjua2
         XN/1uRnU6GypAJi+VnqSFE08n0H726MICGGXHecr9XS4/pYbh18ClSGG5M8mCY0hPeaC
         0yEbBoXn3LciZizvB85Xp9bw6S6Eh7gd0JSkPvwN2sXXxX9+UvHMDLdJtqu+2NQXqMyr
         UzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=omt89YrYl8SYlYFr5IxniwvXvCqTlIiuhpE846cjoPM=;
        b=U3XOCj96c6td/CvDGB7S3hBnVHWTEjtSOzklJY1kx/Crqjelhi1zcq+kw0YY9Er/jm
         +EKJaDcp1yw9aOlv+eVeKwzGVjagNLPH5saJrk5vXI19cruiGvrYfiCvAOW1Pp21vNvi
         njga2sP28sw6r+DmhW57+DnWHicjnTmDu4QuLqgOueZSP57NqYA86YHwqdaXTG7vGj+o
         cLpxfbTUkChf7vshS2d5gaAHMPYOp94WrUosyJnoOq+KHWXygRoWc9trsBx9bnpuoOUx
         uZ8XyhNwLV8o5J4Iww6c57aEbCp2yxixjGWw+MxeJaaZrnZ0ShhMdkWf40ldvtbB3RY/
         hWFw==
X-Gm-Message-State: AOAM530smCrEbwQ10ZsKtAhhFvNICSxjVnGDs/yAfyDQ2OA2dztEk6B5
        Ypg9TDStK2lKCuQTBgGX5zVVDzp0+3hwkuJBzbM=
X-Google-Smtp-Source: ABdhPJyIooVbmkw2z8xPVNZqp2GmmDjaPawo26lQBn5JUMhMh0X8EPiP/EURj8Pi5f0ATJzHE6pJRpoJjPIQJNyRwOA=
X-Received: by 2002:a25:dcd:: with SMTP id 196mr50939729ybn.306.1626935352097;
 Wed, 21 Jul 2021 23:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUhbmVO_dV86LJLz3S4PFu9oFp4_5HWSkKLwqc-ZkQK=yYZfw@mail.gmail.com>
 <mhng-4e9664d5-a766-40d3-8757-230788677472@palmerdabbelt-glaptop>
In-Reply-To: <mhng-4e9664d5-a766-40d3-8757-230788677472@palmerdabbelt-glaptop>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Thu, 22 Jul 2021 14:29:00 +0800
Message-ID: <CAEUhbmXx9qvUE28aw0aTo7nAOnL2VkzCcmJ4Pe0koY3SVYT2Og@mail.gmail.com>
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 1:53 PM Palmer Dabbelt <palmerdabbelt@google.com> w=
rote:
>
> On Thu, 15 Jul 2021 19:14:20 PDT (-0700), bmeng.cn@gmail.com wrote:
> > On Thu, Jul 8, 2021 at 9:29 PM Bin Meng <bmeng.cn@gmail.com> wrote:
> >>
> >> Hi Palmer,
> >>
> >> On Thu, Jul 1, 2021 at 10:20 AM Bin Meng <bmeng.cn@gmail.com> wrote:
> >> >
> >> > On Thu, Jul 1, 2021 at 10:08 AM Kefeng Wang <wangkefeng.wang@huawei.=
com> wrote:
> >> > >
> >> > >
> >> > > On 2021/6/30 19:58, Bin Meng wrote:
> >> > > > On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> w=
rote:
> >> > > >> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@h=
uawei.com> wrote:
> >> > > >>>
> >> > > >>> On 2021/6/28 9:15, Bin Meng wrote:
> >> > > >>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@=
huawei.com> wrote:
> >> > > >>>>> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed b=
y
> >> > > >>>>>
> >> > > >>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-=
wangkefeng.wang@huawei.com/
> >> > > >>>> What are we on the patch you mentioned?
> >> > > >>>>
> >> > > >>>> I don't see it applied in the linux/master.
> >> > > >>>>
> >> > > >>>> Also there should be a "Fixes" tag and stable@vger.kernel.org=
 cc'ed
> >> > > >>>> because 32-bit is broken since v5.12.
> >> > > >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv=
/linux/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
> >> > > >>>
> >> > > >>> it's on Palmer' riscv-next.
> >> > > >> Not sure riscv-next is for which release? This is a regression =
and
> >> > > >> should be on 5.13.
> >> > > >>
> >> > > >>> Hi Palmer, should I resend or could you help me to add the fix=
es tag?
> >> > > > Your patch mixed 2 things (fix plus one feature) together, so it=
 is
> >> > > > not proper to back port your patch.
> >> > >
> >> > > "mem=3D" will change the range of memblock, so the fix part must b=
e included.
> >> > >
> >> >
> >> > Yes, so you can rebase the "mem=3D" changes on top of my patch.
> >> >
> >> > The practice is that we should not mix 2 things in one patch. I can
> >> > imagine that you wanted to add "mem=3D" to RISC-V and suddenly found=
 the
> >> > existing logic was broken, so you sent one patch to do both.
> >> >
> >> > >
> >> > > >
> >> > > > Here is my 2 cents:
> >> > > >
> >> > > > 1. Drop your patch from riscv-next
> >> > > > 2. Apply my patch as it is a simple fix to previous commit. This
> >> > > > allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
> >> > > > 3. Rebase your patch against mine, and resend v2
> >> > > >
> >> > > > Let me know if this makes sense.
> >> > >
> >> > > It is not a big problem for me, but I have no right abourt riscv-n=
ext,
> >> > >
> >> > > let's wait Palmer's advise.
> >> > >
> >> >
> >> > Sure. Palmer, let me know your thoughts.
> >>
> >> Ping?
> >
> > Ping?
>
> Sorry, I missed this one.  It looks like the patch that adds mem=3D and
> fixes the bug has already been merged, so I'm not really quite sure what
> the right thing to do is here: we don't really want the mem=3D code on
> stable, but we do want the fix.  I went ahead and did
>
> commit 444818b599189fd8b6c814da542ff8cfc9fe67d4 (HEAD -> fixes, palmer/fi=
xes)
> gpg: Signature made Wed 21 Jul 2021 10:21:05 PM PDT
> gpg:                using RSA key 2B3C3747446843B24A943A7A2E1319F35FBB188=
9
> gpg:                issuer "palmer@dabbelt.com"
> gpg: Good signature from "Palmer Dabbelt <palmer@dabbelt.com>" [ultimate]
> gpg:                 aka "Palmer Dabbelt <palmerdabbelt@google.com>" [ult=
imate]
> Merge: e73f0f0ee754 d0e4dae74470
> Author: Palmer Dabbelt <palmerdabbelt@google.com>
> Date:   Wed Jul 21 22:18:58 2021 -0700
>
>     Merge remote-tracking branch 'riscv/riscv-fix-32bit' into fixes
>
>     This contains a single fix for 32-bit boot.  It happens this was alre=
ady
>     fixed by c9811e379b21 ("riscv: Add mem kernel parameter support"), bu=
t
>     the bug existed before that feature addition so I've applied the patc=
h
>     earlier and then merged it in (which results in a conflict, which is
>     fixed via not changing the resulting tree).
>
>     * riscv/riscv-fix-32bit:
>       riscv: Fix 32-bit RISC-V boot failure
>
> as that"s the best I could come up with -- then the fix will land on
> master, which should cause it to get pulled onto stable.
>
> Greg: is there a better way to make something like this get to stable?

We can:

1. git revert c9811e379b21 ("riscv: Add mem kernel parameter support")
2. git am <this patch>, cc stable
3. Kefeng resent a new patch that adds the mem kernel parameter
support, on top of mine

Regards,
Bin
