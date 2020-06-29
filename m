Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425FF20E4E3
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgF2VaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgF2SlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:23 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 408FD255D9
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593455433;
        bh=5/Y+oSLJILudcmOj/zCnd5XQQzrBZBzE0UZ5p0BrOo8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pyXIHMeu8u6JnwTlxLbKzpsF70+IPdCjYLRlvBB/oLOZI4ZSAf/PtB/QyUV7PGt2c
         GDPtxlLj6AzePAnBB77rFrDqgsin0nUtJcic8pAHWQ9stfvDwp6w1k51vMBijiVMZe
         D54qhAOgnhx5++5aNf/R9UZHAa5PjlmIsfOQlkBQ=
Received: by mail-ot1-f52.google.com with SMTP id 72so16410903otc.3
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 11:30:33 -0700 (PDT)
X-Gm-Message-State: AOAM531k7BGigc7zwGMWwpYioK951ti2eXUrjAamQN+9P13NlbCWJT/0
        ZcBS+Tft4eEu+klwPtEzWW63YvY2BiZmlcsdnMI=
X-Google-Smtp-Source: ABdhPJzzfv575w9zplth319XAYuYDsoEb3E5USt+iHbRXUNymMGzh3FucZnT4Kngd9COUQylUYztbNn34UQwppCTgu0=
X-Received: by 2002:a9d:688:: with SMTP id 8mr14405675otx.108.1593455432611;
 Mon, 29 Jun 2020 11:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <1593422635243184@kroah.com> <CAMj1kXHfKHuOdx1MYUzN2QncN6SO6CYcPPXTFsGR67_CniWfAw@mail.gmail.com>
 <20200629154844.GA512815@kroah.com>
In-Reply-To: <20200629154844.GA512815@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 29 Jun 2020 20:30:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFFPO=csSXhxJ5gEpbzKi4r5q2XeLEJvvTfxFh37PhJDQ@mail.gmail.com>
Message-ID: <CAMj1kXFFPO=csSXhxJ5gEpbzKi4r5q2XeLEJvvTfxFh37PhJDQ@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] efi: Make it possible to disable efivar_ssdt
 entirely" was seriously submitted to be applied to the 5.7-stable tree?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Jones <pjones@redhat.com>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 at 17:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 29, 2020 at 05:18:08PM +0200, Ard Biesheuvel wrote:
> > On Mon, 29 Jun 2020 at 11:32, <gregkh@linuxfoundation.org> wrote:
> > >
> > > The patch below was submitted to be applied to the 5.7-stable tree.
> > >
> > > I fail to see how this patch meets the stable kernel rules as found at
> > > Documentation/process/stable-kernel-rules.rst.
> > >
> > > I could be totally wrong, and if so, please respond to
> > > <stable@vger.kernel.org> and let me know why this patch should be
> > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > seen again.
> > >
> >
> > Without this patch, there is no way to disable sideloading of SSDTs
> > via EFI variables, which is a security hole. The fact that this is not
> > governed by the existing ACPI_TABLE_UPGRADE Kconfig option was an
> > oversight, and so distros currently have this functionality enabled
> > inadvertently (although most of them have the lockdown check
> > incorporated as well)
> >
> > SSDTs can manipulate any memory (even kernel memory that has been
> > mapped read-only) by using SystemMemory OpRegions in _INI AML methods,
> > and setting an EFI variable once will make this persist across
> > reboots.
>
> All of this was not in the description of the patch at all, how were we
> supposed to know this?
>

Good point. This patch was the result of same off-list discussion, so
it was obvious to those involved but not for anyone else.

> And this really looks like a new feature now that you are supporting
> something that we previously could not do.  To know that this is a "fix"
> is not obvious :(
>
> I'll go queue it up, but how far back should it go?
>

The feature was added in v4.8, so as close as we can get to that please.

Thanks,
Ard.
