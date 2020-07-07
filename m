Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AA7216E9F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 16:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgGGOVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 10:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgGGOVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 10:21:41 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13EDB2075B
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594131701;
        bh=OaGrk5pCXn7tmtFOJstv/7IHbIppokpXZR16N5HhmpU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=19KU//URys3SRYnGB44fZCXnHhgSLepQF/bMrmJNnMb9oDY98dnZbKOLfVz/TyTBX
         G3C+nd+7ZpiLvYYm6l1KZ1rppfAB7ySJHLm0ModKiTFqn628rmJmFKAikdcrhhj6bQ
         ol6ALctbBLUu9RY/57EEVzeGG7iJ2hA0fTmCs5WM=
Received: by mail-ot1-f50.google.com with SMTP id a21so11136401otq.8
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 07:21:41 -0700 (PDT)
X-Gm-Message-State: AOAM533qog5GR4MNNcC5pQZssy349ac0wyTN6/95ddF9BkYIx/2apkt+
        u8wOMXUhA54lPLVmOTzfPS6XKhy27Eas4MHftMk=
X-Google-Smtp-Source: ABdhPJyU1u542jd5NAbQzwKPp92LS4az8DzMU1GOCz8HmjqFSB4RE2KpJO/UlLmK68Qp4sEC1UYShZf4hAbvDDi6IME=
X-Received: by 2002:a9d:4a8f:: with SMTP id i15mr48783509otf.77.1594131700374;
 Tue, 07 Jul 2020 07:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <1593422635243184@kroah.com> <CAMj1kXHfKHuOdx1MYUzN2QncN6SO6CYcPPXTFsGR67_CniWfAw@mail.gmail.com>
 <20200629154844.GA512815@kroah.com> <CAMj1kXFFPO=csSXhxJ5gEpbzKi4r5q2XeLEJvvTfxFh37PhJDQ@mail.gmail.com>
 <20200707141031.GD4064836@kroah.com>
In-Reply-To: <20200707141031.GD4064836@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 7 Jul 2020 17:21:29 +0300
X-Gmail-Original-Message-ID: <CAMj1kXF8=jQZ_yGVDhhdrEVbF18_UrqOz03pWBUZP4wEJ41ncA@mail.gmail.com>
Message-ID: <CAMj1kXF8=jQZ_yGVDhhdrEVbF18_UrqOz03pWBUZP4wEJ41ncA@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] efi: Make it possible to disable efivar_ssdt
 entirely" was seriously submitted to be applied to the 5.7-stable tree?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Jones <pjones@redhat.com>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Jul 2020 at 17:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 29, 2020 at 08:30:21PM +0200, Ard Biesheuvel wrote:
> > On Mon, 29 Jun 2020 at 17:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Jun 29, 2020 at 05:18:08PM +0200, Ard Biesheuvel wrote:
> > > > On Mon, 29 Jun 2020 at 11:32, <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > The patch below was submitted to be applied to the 5.7-stable tree.
> > > > >
> > > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > > Documentation/process/stable-kernel-rules.rst.
> > > > >
> > > > > I could be totally wrong, and if so, please respond to
> > > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > > seen again.
> > > > >
> > > >
> > > > Without this patch, there is no way to disable sideloading of SSDTs
> > > > via EFI variables, which is a security hole. The fact that this is not
> > > > governed by the existing ACPI_TABLE_UPGRADE Kconfig option was an
> > > > oversight, and so distros currently have this functionality enabled
> > > > inadvertently (although most of them have the lockdown check
> > > > incorporated as well)
> > > >
> > > > SSDTs can manipulate any memory (even kernel memory that has been
> > > > mapped read-only) by using SystemMemory OpRegions in _INI AML methods,
> > > > and setting an EFI variable once will make this persist across
> > > > reboots.
> > >
> > > All of this was not in the description of the patch at all, how were we
> > > supposed to know this?
> > >
> >
> > Good point. This patch was the result of same off-list discussion, so
> > it was obvious to those involved but not for anyone else.
> >
> > > And this really looks like a new feature now that you are supporting
> > > something that we previously could not do.  To know that this is a "fix"
> > > is not obvious :(
> > >
> > > I'll go queue it up, but how far back should it go?
> > >
> >
> > The feature was added in v4.8, so as close as we can get to that please.
>
> Ok, got it applied back to 4.9 now, thanks.
>

Thanks Greg.
