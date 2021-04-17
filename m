Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B9E362C86
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 03:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhDQBBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 21:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDQBBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 21:01:06 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7804BC061574;
        Fri, 16 Apr 2021 18:00:39 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id p15so13652370iln.3;
        Fri, 16 Apr 2021 18:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iY+RihvUPyX8tk9Gf02ocgT2AcANbu5qgEKSYd9h/Ek=;
        b=N/Jg6sWs2uTjuQV8jiDzF6n5Lf3QwDms6wQEpSc8aWUFWSMPkbQ9QEMbRYUk6xfqBj
         dzck2Rm9wPsvncZr7eAWIH/wSp/IcaLZhcQGNjOPXh8yPty1LyIcR6Mlte++IiC6AM1r
         ordl5QUCnOxEsKIyaXsVFCZe99JutM+4Ofn41bUD32SHhNQJBvYNf5QELhXqW+7e5c4N
         meIktTQ8UNgn4agwzzCwycOjPqcNWEZ4Z30EPVybzvpvMQlc6TwR8CR0Qa64cH8hNXKA
         kmn3JEMYRCJ9FZuM+MdA33Bb+KaUsCEH+Oj5ZzAAJAvHPcSMeu8LohfQ2RFTgZ6jb4VF
         K8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iY+RihvUPyX8tk9Gf02ocgT2AcANbu5qgEKSYd9h/Ek=;
        b=rfQia6xgiGhntUV1ObpCA5e9BJA0ElOV4ytArbfhPbmpvJZYkFUVak3Hty1puNXfBh
         4lp14iRnlCeuyUXpHoPnqjcsdtm5Ot8pBYNn4+8hrCbFtBkCC3A+ora7AJiM8V6cknro
         Fd61DHVaLZ2ycx0/zw88wpWdXzT2y+uyD4AgCtaJb3rwgpTVR+xOnwMnzvV4t4tIhtxO
         cdyLWjKQhYmzd9rtW9DBX4q45vAvsxYVT0dJ5A8v/Yrrcj9IZRtOox3YjeSo8Yonl8bu
         u+xhTZsZydVWmGunXffJFDVPH/DifNCI02dPNBta9/0hSBWqndhR0X/HweNyAGflf7vH
         S4kg==
X-Gm-Message-State: AOAM530BOwxBxFu88uZrSOdKdCbbccoESCbysOcSuV5Zy9WijrbfVr2F
        AgJoxRP401/qXvdDIKqcj3Nvpqgy6Q/i4T6jTfk=
X-Google-Smtp-Source: ABdhPJzsa5kRDU9e1LTH578C8d3QJIyrDRz+zu/YLglh/0yMAo2iePlaNMdHQwGNda+kPmEY9OrI07+IhNdKg1wI6nA=
X-Received: by 2002:a92:c78a:: with SMTP id c10mr9318404ilk.64.1618621237415;
 Fri, 16 Apr 2021 18:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200917000757.1232850-1-Tony.Ambardar@gmail.com>
 <20200917135437.1238787-1-Tony.Ambardar@gmail.com> <CAPGftE-Q+Q479j7SikDBQLiM+VKbpXpRYnTeEJeAHeZrh_Ok2A@mail.gmail.com>
 <87r1jaeclf.fsf@mpe.ellerman.id.au>
In-Reply-To: <87r1jaeclf.fsf@mpe.ellerman.id.au>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Fri, 16 Apr 2021 18:00:26 -0700
Message-ID: <CAPGftE_JthCCWdH8sgTNp7WVcuUu7zPCpmG1KWZ8iovcEwSd2w@mail.gmail.com>
Subject: Re: [PATCH v3] powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Apr 2021 at 03:41, Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Tony Ambardar <tony.ambardar@gmail.com> writes:
> > Hello Michael,
> >
> > The latest version of this patch addressed all feedback I'm aware of
> > when submitted last September, and I've seen no further comments from
> > reviewers since then.
> >
> > Could you please let me know where this stands and if anything further
> > is needed?
>
> Sorry, it's still sitting in my inbox :/
>
> I was going to reply to suggest we split the tools change out. The
> headers under tools are usually updated by another maintainer, I think
> it might even be scripted.
>
> Anyway I've applied your patch and done that (dropped the change to
> tools/.../errno.h), which should also mean the stable backport is more
> likely to work automatically.
>
> It will hit mainline in v5.13-rc1 and then be backported to the stable
> trees.
>
> I don't think you actually need the tools version of the header updated
> to fix your bug? In which case we can probably just wait for it to be
> updated automatically when the tools headers are sync'ed with the kernel
> versions.
>
> cheers

I appreciate the follow up. My original bug was indeed with the tools
header but is being patched locally, so waiting for those headers to
sync with the kernel versions is fine if it simplifies things overall.

Thanks,
Tony
