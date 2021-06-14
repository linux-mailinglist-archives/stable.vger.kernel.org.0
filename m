Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA723A5F0C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 11:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhFNJX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 05:23:56 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:43569 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhFNJXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 05:23:55 -0400
Received: by mail-il1-f169.google.com with SMTP id x18so11621135ila.10;
        Mon, 14 Jun 2021 02:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=koMbbAAfea4vPR79jlLeRnqLt4Fgf3xXaHKDKgr88EM=;
        b=oF088aKnl0rrsw88EtKTbp4fZabaOW+rXs93rcQoOB3Kl36qiE1k5kMQDdNxGg6mBF
         8JOL/6BtIjBKT7xduvwaaFBcURZSSr/PCLVwFEE6ti2WpG42SZbQGZK5sAUuOl+/IBrb
         qD8fR8nUxULyXOW/5jnRZnwyZnTLdtfQFk34gmXA14oAjIQq1CNy5slda+PPKjAyLtt1
         KrztUGTQpOKFo3EN2gdUz6Uf9PeZIezXRLKi4yfNZygizCrhdxWGld/oKv4JnYg8mMGO
         t7r7S4iMlOBqxCcf5GxepaFv97mrPItjspc0Q036Kn69F0NV9SDna4NodbFf4pFNf13u
         Bifw==
X-Gm-Message-State: AOAM533MAcJfvskrr3LpSP1m/0y3UhPCcwmp8eJRpHlEkgkzy9n48ZNW
        +Y2pHAH3yR3kvrojrKsF3UvGxG9zn3CUWw==
X-Google-Smtp-Source: ABdhPJyaOJ7c4Dw9jX6e1YB9pQymT3gnSvXDG04wNQ3xmu4/p+UUSaAdT4/RdrLd3DqYNVJceGM1Uw==
X-Received: by 2002:a05:6e02:1a45:: with SMTP id u5mr13194332ilv.242.1623662513149;
        Mon, 14 Jun 2021 02:21:53 -0700 (PDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com. [209.85.166.45])
        by smtp.gmail.com with ESMTPSA id x13sm7300495ilo.11.2021.06.14.02.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:21:53 -0700 (PDT)
Received: by mail-io1-f45.google.com with SMTP id p66so36991674iod.8;
        Mon, 14 Jun 2021 02:21:53 -0700 (PDT)
X-Received: by 2002:a6b:b554:: with SMTP id e81mr14059358iof.163.1623662512885;
 Mon, 14 Jun 2021 02:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
 <YKzlTR1AzUigShtZ@kroah.com> <CAOq732LR9Wf44qiGESH4YCjkwkDezjiTfRz2G3y9G596HgYAHg@mail.gmail.com>
 <YMcaOXsMvkWhb5mg@kroah.com>
In-Reply-To: <YMcaOXsMvkWhb5mg@kroah.com>
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
Date:   Mon, 14 Jun 2021 11:21:42 +0200
X-Gmail-Original-Message-ID: <CAOq732L6ONr0QrXSMT2sHQm5+Rmd6Nd=124QTb18DQLKPOqoRA@mail.gmail.com>
Message-ID: <CAOq732L6ONr0QrXSMT2sHQm5+Rmd6Nd=124QTb18DQLKPOqoRA@mail.gmail.com>
Subject: Re: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
To:     Greg KH <greg@kroah.com>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 at 10:59, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 14, 2021 at 10:54:00AM +0200, Andrew Zaborowski wrote:
> > Hi Greg,
> >
> > On Tue, 25 May 2021 at 13:53, Greg KH <greg@kroah.com> wrote:
> > > On Tue, May 25, 2021 at 01:36:27PM +0200, Andrew Zaborowski wrote:
> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > >
> > > > BUG_ON() should not be used in the kernel code, unless there are
> > > > exceptional reasons to do so. Replace BUG_ON() with WARN() and
> > > > return.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > ---
> > > > No changes from original submission by Jarkko.
> > > >
> > > >  crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > > > index ad8af3d70ac..a00bed3e04d 100644
> > > > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > > > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > > > @@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
> > > >       char *req, *p;
> > > >       int len;
> > > >
> > > > -     BUG_ON(!id_0 && !id_1);
> > > > +     if (!id_0 && !id_1) {
> > > > +             WARN(1, "All ID's are NULL\n");
> > >
> > > You still just rebooted a machine (panic-on-warn is commonly set).
> > >
> > > Please just handle this properly, print an error message with dev_err()
> > > or pr_err() and move on, don't crash things.
> >
> > Like Eric Biggers said, a panic is probably what you want here since
> > this would be a basic bug, if you even want to check this.
>
> Ok, then keep the BUG_ON(), no change needed.
>
> > You can't
> > be looking for a key if you don't have any of the identifiers.  There
> > a 4 current callers, 2 that have checks right before the call and 2
> > where this could be triggered by a bug in an ASN.1 parser or
> > corruption.
> >
> > What's the right way to get this change merged?  There's clearly no
> > need to coordinate with whoever would merge 2/2 of the series.
>
> Why do you need to change this if BUG_ON() is the correct thing to do
> here?

At this function's level the situation is easily recoverable, I guess
the idea is to allow the kernel to continue in the "continue at any
cost" type scenario where you'd have panic_on_* set false.

Best regards
