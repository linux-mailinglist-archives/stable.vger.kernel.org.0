Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E649216B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344692AbiARIle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbiARIl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:41:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382B7C06173E
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDBB0B81238
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F1C36AE3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642495283;
        bh=gAKzYtljpXm2hzMnggKt95IM+OjME6TqZD2xBxPyVOM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HPd/hmArZjhYPev1gH1ruYxyT2ZWDzWHCni+u+GJC0dcn53RSZgJbgrVSED2aV4ZR
         ohAoVLaS2O0QB0jkl/+RPF1iTj/ZjFn1dNKfQlbgH2thqXCHan93L+/zq0Ays2rpVr
         qL8n4GPebL7WUraV2odiIBv4EkG2EVR1gG1zFfZamgSR6rc7U/41CELFNDiO3+ryMI
         URlMZUk4DbazbN99T6bQjglMT6txe7iRcX2xL1WeXUV1IbcViUBTWK7dBvIWQXbnZ2
         skHfPgWY9QJCzlLt5UeMbr1XFEcpOf4M6Q7Cp1Km0BgUBjFOrnlsBGrWh1FKlnFs4j
         uh2VlAMZIe8Vw==
Received: by mail-wm1-f53.google.com with SMTP id az27-20020a05600c601b00b0034d2956eb04so2990284wmb.5
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:41:23 -0800 (PST)
X-Gm-Message-State: AOAM5320b+BsTHxWxk8ioLtNIDip+LPC8H+fkxdsb6h9bZQWJ5lhy6N0
        QPYF4dhfg4zukHezOUwMgW7DlM5XHxk5VLstGeA=
X-Google-Smtp-Source: ABdhPJy459LLFw18rxvvaQGwk6M5DSQViL6r+6G2ZdtM6kKQnjUA8VkRbAH3vRnbn4LJrozAFmGrxuJ0ncYs7xiQido=
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr3944103wmq.25.1642495281918;
 Tue, 18 Jan 2022 00:41:21 -0800 (PST)
MIME-Version: 1.0
References: <20220118082808.931129-1-ardb@kernel.org> <CAK8P3a0XGEZSTWy=24fEckPxtLoOt7sF7SYzF+QZEMooiW4BsA@mail.gmail.com>
In-Reply-To: <CAK8P3a0XGEZSTWy=24fEckPxtLoOt7sF7SYzF+QZEMooiW4BsA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Jan 2022 09:41:09 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGtHoDYzjv8eUg0xbs4aTZVnRDHCne-cJg=9ZLHzYbOgQ@mail.gmail.com>
Message-ID: <CAMj1kXGtHoDYzjv8eUg0xbs4aTZVnRDHCne-cJg=9ZLHzYbOgQ@mail.gmail.com>
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

On Tue, 18 Jan 2022 at 09:38, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Jan 18, 2022 at 9:28 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > The helpers that are used to implement copy_from_kernel_nofault() and
> > copy_to_kernel_nofault() cast a void* to a pointer to a wider type,
> > which may result in alignment faults on ARM if the compiler decides to
> > use double-word or multiple-word load/store instructions.
> >
> > So use the unaligned accessors where needed: when the type's size > 1
> > and the input was not aligned already by the caller.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 2df4c9a741a0 ("ARM: 9112/1: uaccess: add __{get,put}_kernel_nofault")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> It took me a bit to see whythis works, maybe mention commit 2423de2e6f4d
> ("ARM: 9115/1: mm/maccess: fix unaligned copy_{from,to}_kernel_nofault")
> in the description for clarification.
>

Ack.

> Did you run into actual faults, or did you find this problem by
> reading the code?
>

I was seeing actual faults:

[    4.447003]  copy_from_kernel_nofault from prepend+0x3c/0xb4
[    4.453085]  prepend from prepend_path+0x118/0x34c
[    4.457930]  prepend_path from d_path+0x11c/0x184
[    4.462656]  d_path from proc_pid_readlink+0xbc/0x1d4
[    4.467928]  proc_pid_readlink from vfs_readlink+0xfc/0x110
[    4.473740]  vfs_readlink from do_readlinkat+0xb0/0x110
[    4.479024]  do_readlinkat from ret_fast_syscall+0x0/0x54
