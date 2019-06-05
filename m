Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16533637B
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 20:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFESms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 14:42:48 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:33336 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFESmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 14:42:47 -0400
Received: by mail-it1-f196.google.com with SMTP id v193so240560itc.0
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 11:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tb3AsUPpK2GIv5fgvYVpcgDU5/gP5sotzobQUmB0Ib4=;
        b=FFyb5FTwdfq2lfjZ5UNKjnE3e/r2uFUyCmOfyJOpedhml6nw+BGdFwpyxfyHPD0f7/
         rEO++unxGsKdphMqlpJPq2jyYUMAWpffYXZ2+0gW6fsNLVLp+GWNoKIx4Bvsv/j8a+hW
         CW8hPN8Yi1Yw8Zek7YkvFBYng6BFuOrxm5I0y57dm/M345vnLUtQtwD4f/O7qOk7IN/1
         xGwZV922z7gBwDtBR+S0sTufgi3FxQ1oZZRNOq+Raf9ABT81ncZGmTDLtZcQayocqwLM
         WVMXajhLQmGEr8m6UvDIIw3OGpkM5Zfm7MzgV/uGk3uu95oIKBBZz06Mf4twZHzwCurG
         LYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tb3AsUPpK2GIv5fgvYVpcgDU5/gP5sotzobQUmB0Ib4=;
        b=tOgl8nuYO/xjHrtHjnKK3woKKmsi90fYMoISM4iaxL6+FTk8FR5HHNqtCxDeAfQhkS
         dlT/7MHCg2x1YA8u61PyshqZeB1/Dt/rB+8bGdhfh8uRP2j/Bq+4jcCkm4tfE3JyQz19
         5clfO+JoF46Jw3pPRxTwxjnxU4bz2C/s0F0g/kGmrIXXxPj1s7UroUJURtMKXEWQhHnR
         NGbGJHKroM7KKWcolxjGcBHb0n1LBB4oDLOPNJrylrrBuIj0pc9z6GgnEK6WrmIkiOo9
         lbislE8HBLkv12qw4YfEs43GcBQBQC7FFPIznbIZBQm8b4UzNl99KnISlqhx/zp06UER
         S50A==
X-Gm-Message-State: APjAAAVr2M3KmbVexYrBQ2RJBA1gT3H+E08j24mWesLMzOlVvADh8gIF
        7ABSmL7JfXLwTpbmPvm2bUY6zwr1zSSAi/TzoA9CRg==
X-Google-Smtp-Source: APXvYqxakciBcE0cDitL0gdocex8qsiZFZdUy6cXYeX5t4/xGuD1tW+v4IIDXMqIolO29RI1u+y81tpFSB0UKkNdcms=
X-Received: by 2002:a24:740f:: with SMTP id o15mr12084363itc.76.1559760167133;
 Wed, 05 Jun 2019 11:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <779905244.a0lJJiZRjM@devpool35> <20190605162626.GA31164@kroah.com>
In-Reply-To: <20190605162626.GA31164@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 5 Jun 2019 20:42:32 +0200
Message-ID: <CAKv+Gu9QkKwNVpfpQP7uDd2-66jU=qkeA7=0RAoO4TNaSbG+tg@mail.gmail.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Rolf Eike Beer <eb@emlix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Jun 2019 at 18:26, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > I decided to dig out a toy project which uses a DragonBoard 410c. This has
> > been "running" with kernel 4.9, which I would keep this way for unrelated
> > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it was
> > buildable, which was good enough.
> >
> > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> >
> > aarch64-unknown-linux-gnueabi-ld: ./drivers/firmware/efi/libstub/lib.a(arm64-
> > stub.stub.o): in function `handle_kernel_image':
> > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:63:
> > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > aarch64-unknown-linux-gnueabi-ld: ./drivers/firmware/efi/libstub/lib.a(arm64-
> > stub.stub.o): relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not be used
> > when making a shared object; recompile with -fPIC
> > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:63:
> > (.init.text+0xc): dangerous relocation: unsupported relocation
> > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target 'vmlinux' failed
> > -make[1]: *** [vmlinux] Error 1
> >
> > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca from
> > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be), reverting
> > this commit fixes the build.
> >
> > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as 9.1.0. See
> > the attached .config for reference.
> >
> > If you have questions or patches just ping me.
>
> Does Linus's latest tree also fail for you (or 5.1)?
>
> Nick, do we need to add another fix that is in mainline for this to work
> properly?
>

For the record, this is an example of why I think backporting those
clang enablement patches is a bad idea. We can't actually build those
kernels with clang, can we? So what is the point? </grumpy>

It would be helpful to get a relocation dump (objdump -r) of
arm64-stub.o to figure out which symbol needs a 'hidden' annotation to
prevent GCC from emitting it as a PIC reference requiring a GOT.
Alternatively, we can just revert this patch from 4.9
