Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425182C3A77
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 09:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgKYIFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 03:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgKYIFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 03:05:55 -0500
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34153206E0;
        Wed, 25 Nov 2020 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606291554;
        bh=wJF+14WomI9Dcbe3mX4Wqvtijyx397eV3UPxbqBo+xQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QtsZMGZLVFRbD4XJwT8GSKNAxtH0DPgDeTFxuwV8y9494NAhh0Ncax02o55HBW3/C
         EBkb1zwoDZ/ATv+puaTTA1OLH+lSw/kd1/Z6mE1Zv+UmYRp+szl25RI5xo1Ik2WNih
         A+7Bmp4DIG6WjzVz581BQWFd2RUhl9II256MTaoY=
Received: by mail-ot1-f41.google.com with SMTP id f16so1425908otl.11;
        Wed, 25 Nov 2020 00:05:54 -0800 (PST)
X-Gm-Message-State: AOAM533OaSxl1QpvkllZP6YsP4yDHB5MfLU3E13mO9W9QMyoDCpgPOSW
        +Uu7R/IuYsknMBHoivsRj+IT3ASzA0dnPjq747U=
X-Google-Smtp-Source: ABdhPJwuxmHA2/SXY66MciIptOhzXRn1hJ6pAuSs4eM1ZilA/3CH6j0YHPxHLj6ZSLX3r1HmZqR10FS6L1u9fAkX7wk=
X-Received: by 2002:a05:6830:3099:: with SMTP id f25mr1947945ots.77.1606291553421;
 Wed, 25 Nov 2020 00:05:53 -0800 (PST)
MIME-Version: 1.0
References: <20201125075303.3963-1-ardb@kernel.org> <97016e69314d90aef859ae6d98e4bb9c@natalenko.name>
In-Reply-To: <97016e69314d90aef859ae6d98e4bb9c@natalenko.name>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Nov 2020 09:05:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG0D7H=A=2DjjNxqHRC26dhWR2c-i3b2Enc4sLoYgFbJQ@mail.gmail.com>
Message-ID: <CAMj1kXG0D7H=A=2DjjNxqHRC26dhWR2c-i3b2Enc4sLoYgFbJQ@mail.gmail.com>
Subject: Re: [PATCH] efivarfs: revert "fix memory leak in efivarfs_create()"
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-efi <linux-efi@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@google.com>,
        David Laight <David.Laight@aculab.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Nov 2020 at 09:05, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> Hello.
>
> On 25.11.2020 08:53, Ard Biesheuvel wrote:
> > The memory leak addressed by commit fe5186cf12e3 is a false positive:
> > all allocations are recorded in a linked list, and freed when the
> > filesystem is unmounted. This leads to double frees, and as reported
> > by David, leads to crashes if SLUB is configured to self destruct when
> > double frees occur.
> >
> > So drop the redundant kfree() again, and instead, mark the offending
> > pointer variable so the allocation is ignored by kmemleak.
> >
> > Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
>
> Should also have:
>
> Cc: <stable@vger.kernel.org> # v5.9
>

No it should not. The fixes tag should be sufficient.

> > Fixes: fe5186cf12e3 ("efivarfs: fix memory leak in efivarfs_create()")
> > Reported-by: David Laight <David.Laight@aculab.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  fs/efivarfs/inode.c | 1 +
> >  fs/efivarfs/super.c | 1 -
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> > index 96c0c86f3fff..38324427a2b3 100644
> > --- a/fs/efivarfs/inode.c
> > +++ b/fs/efivarfs/inode.c
> > @@ -103,6 +103,7 @@ static int efivarfs_create(struct inode *dir,
> > struct dentry *dentry,
> >       var->var.VariableName[i] = '\0';
> >
> >       inode->i_private = var;
> > +     kmemleak_ignore(var);
> >
> >       err = efivar_entry_add(var, &efivarfs_list);
> >       if (err)
> > diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> > index f943fd0b0699..15880a68faad 100644
> > --- a/fs/efivarfs/super.c
> > +++ b/fs/efivarfs/super.c
> > @@ -21,7 +21,6 @@ LIST_HEAD(efivarfs_list);
> >  static void efivarfs_evict_inode(struct inode *inode)
> >  {
> >       clear_inode(inode);
> > -     kfree(inode->i_private);
> >  }
> >
> >  static const struct super_operations efivarfs_ops = {
>
> --
>    Oleksandr Natalenko (post-factum)
