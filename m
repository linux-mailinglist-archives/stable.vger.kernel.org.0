Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB45F492649
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 14:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiARNAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 08:00:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55718 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbiARNAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 08:00:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A57D2B8165F
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 13:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72928C340E7
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642510848;
        bh=Sz4+EBrrg/ocmc2Gdc+FZso9VyaSCo8D64U92LXOFm0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JRs3Db+vwPgkiCb3Kz0fqLITR8nCjWRMXNJbEw7SrwE4nq1FDGKciXyAVvqozGvdc
         /5A6xi42zVGgNsPX0eyEzvzB21SoU5fYtxiQgvzIUr2BTMYAAY6xyYJpJ9uSnH+ctS
         KRrLway4czD3bWlSUcs5rBeG++RRoklNVQsgkXhVDV9mS/bvUd4oLcE5Cd9/lZHh6G
         Gg3OGc8rSuCpDpp2wAz9CgmbzX6UjUqg1HWitvVM6VThaieo9WZO3F0nQwiXDKSmDN
         upGzM14j3d3hqr3sllmvbVSZ5NC7dD9Fb02onCFAComlQnzDWb9E3Xik8R8wiV6DKB
         mkiJoC7iISIBg==
Received: by mail-wm1-f49.google.com with SMTP id c2so21948484wml.1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 05:00:48 -0800 (PST)
X-Gm-Message-State: AOAM533A/zBaNypc/TYkvZRAokW9E0AB7W3ITYq45/m3qp2iCVLVKOBD
        fkqOuGoZQn3C71gstu3SknO2zgu6DKQwy7NSonA=
X-Google-Smtp-Source: ABdhPJyjZdUDe1z1IpjJ/dVdEcBlBQMmcIp6jA1/fQj4ifqvcKf5nLaVmQjQNJnt4IT9KraAr8sysk7mTTwO32YOw0o=
X-Received: by 2002:a5d:6541:: with SMTP id z1mr21975565wrv.550.1642510846681;
 Tue, 18 Jan 2022 05:00:46 -0800 (PST)
MIME-Version: 1.0
References: <20220118082808.931129-1-ardb@kernel.org> <CAK8P3a0XGEZSTWy=24fEckPxtLoOt7sF7SYzF+QZEMooiW4BsA@mail.gmail.com>
 <CAMj1kXGtHoDYzjv8eUg0xbs4aTZVnRDHCne-cJg=9ZLHzYbOgQ@mail.gmail.com>
In-Reply-To: <CAMj1kXGtHoDYzjv8eUg0xbs4aTZVnRDHCne-cJg=9ZLHzYbOgQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Jan 2022 14:00:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFh-XFr8tBrYcobrR1G9YBwV-BvAyBtVQPUqDOe+Dw7fw@mail.gmail.com>
Message-ID: <CAMj1kXFh-XFr8tBrYcobrR1G9YBwV-BvAyBtVQPUqDOe+Dw7fw@mail.gmail.com>
Subject: Re: [PATCH] ARM: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 at 09:41, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 18 Jan 2022 at 09:38, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Tue, Jan 18, 2022 at 9:28 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > The helpers that are used to implement copy_from_kernel_nofault() and
> > > copy_to_kernel_nofault() cast a void* to a pointer to a wider type,
> > > which may result in alignment faults on ARM if the compiler decides to
> > > use double-word or multiple-word load/store instructions.
> > >
> > > So use the unaligned accessors where needed: when the type's size > 1
> > > and the input was not aligned already by the caller.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 2df4c9a741a0 ("ARM: 9112/1: uaccess: add __{get,put}_kernel_nofault")
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> >
> > It took me a bit to see whythis works, maybe mention commit 2423de2e6f4d
> > ("ARM: 9115/1: mm/maccess: fix unaligned copy_{from,to}_kernel_nofault")
> > in the description for clarification.
> >
>
> Ack.
>

I've dropped this into the patch system as #9719/1, with the above
suggestions incorporated into the commit log.

Thanks,
> > Did you run into actual faults, or did you find this problem by
> > reading the code?
> >
>
> I was seeing actual faults:
>
> [    4.447003]  copy_from_kernel_nofault from prepend+0x3c/0xb4
> [    4.453085]  prepend from prepend_path+0x118/0x34c
> [    4.457930]  prepend_path from d_path+0x11c/0x184
> [    4.462656]  d_path from proc_pid_readlink+0xbc/0x1d4
> [    4.467928]  proc_pid_readlink from vfs_readlink+0xfc/0x110
> [    4.473740]  vfs_readlink from do_readlinkat+0xb0/0x110
> [    4.479024]  do_readlinkat from ret_fast_syscall+0x0/0x54
