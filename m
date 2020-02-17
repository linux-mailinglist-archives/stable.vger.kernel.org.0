Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C8D161700
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgBQQJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 11:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgBQQJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 11:09:14 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3602620718
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581955753;
        bh=129E5dpmonhuuGEqnPt7lC4zi2JhO3hBLFhawtF68g8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=D7vrYwkxOHuGMGxpy8vxqUAzzyFdky71rujHi2ETx2aWgfObizKm4McHDc+XBkQFf
         wH1ZBgS7Q5puIj+WPFpIrWKqAGjObq9gRrnaeKGFsjdkPSAy3ED+jNdKi8laHvMHI5
         RPSdwjK20D23cT18FAAze5dTkfX4Ehwf3jbEe7mY=
Received: by mail-wr1-f53.google.com with SMTP id t3so20398670wru.7
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 08:09:13 -0800 (PST)
X-Gm-Message-State: APjAAAVnYZ1LwLls5T5simUZV3LavyRm1OqNBFK+H2arjjSwSIZPupIY
        oZ8Z4vdAVwX8Oo3b3zW7z/SU5X+i2L95OBs+o4WQTA==
X-Google-Smtp-Source: APXvYqw5V6wRzlQYZ+HZnck9ioKlAk3ziBoyHmTxXATFE0s6yyi28HtHtkIKgIeickLp1e3NsQkfzzX5U8CDh+7OhxY=
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr23175166wrr.208.1581955751662;
 Mon, 17 Feb 2020 08:09:11 -0800 (PST)
MIME-Version: 1.0
References: <20200217123354.21140-1-Jason@zx2c4.com> <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
 <20200217155402.GB1461852@kroah.com>
In-Reply-To: <20200217155402.GB1461852@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 17 Feb 2020 17:09:00 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu_uQvONH=vAcckPEn+HWOOsiQdt_Dsscw2Y3KEUObafxA@mail.gmail.com>
Message-ID: <CAKv+Gu_uQvONH=vAcckPEn+HWOOsiQdt_Dsscw2Y3KEUObafxA@mail.gmail.com>
Subject: Re: [PATCH] efi: READ_ONCE rng seed size before munmap
To:     Greg KH <greg@kroah.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Feb 2020 at 16:54, Greg KH <greg@kroah.com> wrote:
>
> On Mon, Feb 17, 2020 at 04:23:03PM +0100, Ard Biesheuvel wrote:
> > On Mon, 17 Feb 2020 at 13:34, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > This function is consistent with using size instead of seed->size
> > > (except for one place that this patch fixes), but it reads seed->size
> > > without using READ_ONCE, which means the compiler might still do
> > > something unwanted. So, this commit simply adds the READ_ONCE
> > > wrapper.
> > >
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: stable@vger.kernel.org
> >
> > Thanks Jason
> >
> > I've queued this in efi/urgent with a fixes: tag rather than a cc:
> > stable, since it only applies clean to v5.4 and later.
>
> Why do that?  That just makes it harder for me to know to pick it up for
> 5.4 and newer.
>
> > We'll need a
> > backport to 4.14 and 4.19 as well, which has a trivial conflict
> > (s/add_bootloader_randomness/add_device_randomness/) but we'll need to
> > wait for this patch to hit Linus's tree first.
>
> Ok, if you are going to send it on to me for stable, that's fine, but
> usually you can just wait for the rejection notices for older kernels
> before having to worry about this.  In other words, you are doing more
> work than you have to here :)
>

So just

Cc: <stable@vger.kernel.org>

without any context is your preferred method?
