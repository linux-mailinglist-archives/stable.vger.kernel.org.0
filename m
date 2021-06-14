Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92203A5EA4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhFNI41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 04:56:27 -0400
Received: from mail-il1-f173.google.com ([209.85.166.173]:39527 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhFNI41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 04:56:27 -0400
Received: by mail-il1-f173.google.com with SMTP id j14so8769643ila.6;
        Mon, 14 Jun 2021 01:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FKPtahfvBkN42177Q0TQNVCJygRNxxqVej1aFsnPYkw=;
        b=Z6Zjky4WsIuH0HRMIQaHg420uqwjpiYSqNkRFGWl5YwELPS4yIzjQ96RXXza2f1eXR
         uo140UBiXdnDHEoTA3649Rm6xRCH+EjK31WwzZw/rPmwqm5+qh4Wm3ABMUe69UKf8m4P
         gIB6c2JcFpV/jGWdZ7j68rkHcO3zHBgYswiuZtpsGbJKj5LXCOxQwE2W7jF0iEzzFquz
         rXL14gZHu5FAB/TCqQKQmpdbofrRS8W1v/VUoF4VYfhnb6nqzkIv8dkC46M68qeQEMWC
         O3aKM8ugESJkgXPjNqFlf9iz0J723Bgo3yA0sUm9LWdQk16w9fRkr7rtWULEbrLq9J5I
         bGog==
X-Gm-Message-State: AOAM5329AhlElNIrOwzlsHha0A5PDeqTqlOGtiMLcFFvoKwMdlUUw31F
        vtj0jfcQFxeGF68XKLbxayuiCcO1CCix1g==
X-Google-Smtp-Source: ABdhPJy23NtC2T0SZPps0o5z79nAoIpcVIlLFMfRN3wXEdnCAKRHp+MdhSQr9X0/imy+HsnL5knVTQ==
X-Received: by 2002:a92:690d:: with SMTP id e13mr13122497ilc.257.1623660852384;
        Mon, 14 Jun 2021 01:54:12 -0700 (PDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com. [209.85.166.43])
        by smtp.gmail.com with ESMTPSA id j4sm7569071iom.28.2021.06.14.01.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 01:54:12 -0700 (PDT)
Received: by mail-io1-f43.google.com with SMTP id p66so36915315iod.8;
        Mon, 14 Jun 2021 01:54:12 -0700 (PDT)
X-Received: by 2002:a05:6602:2d83:: with SMTP id k3mr13817767iow.5.1623660852005;
 Mon, 14 Jun 2021 01:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210525113628.2682248-1-andrew.zaborowski@intel.com> <YKzlTR1AzUigShtZ@kroah.com>
In-Reply-To: <YKzlTR1AzUigShtZ@kroah.com>
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
Date:   Mon, 14 Jun 2021 10:54:00 +0200
X-Gmail-Original-Message-ID: <CAOq732LR9Wf44qiGESH4YCjkwkDezjiTfRz2G3y9G596HgYAHg@mail.gmail.com>
Message-ID: <CAOq732LR9Wf44qiGESH4YCjkwkDezjiTfRz2G3y9G596HgYAHg@mail.gmail.com>
Subject: Re: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
To:     Greg KH <greg@kroah.com>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, 25 May 2021 at 13:53, Greg KH <greg@kroah.com> wrote:
> On Tue, May 25, 2021 at 01:36:27PM +0200, Andrew Zaborowski wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> >
> > BUG_ON() should not be used in the kernel code, unless there are
> > exceptional reasons to do so. Replace BUG_ON() with WARN() and
> > return.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > No changes from original submission by Jarkko.
> >
> >  crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > index ad8af3d70ac..a00bed3e04d 100644
> > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > @@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
> >       char *req, *p;
> >       int len;
> >
> > -     BUG_ON(!id_0 && !id_1);
> > +     if (!id_0 && !id_1) {
> > +             WARN(1, "All ID's are NULL\n");
>
> You still just rebooted a machine (panic-on-warn is commonly set).
>
> Please just handle this properly, print an error message with dev_err()
> or pr_err() and move on, don't crash things.

Like Eric Biggers said, a panic is probably what you want here since
this would be a basic bug, if you even want to check this.  You can't
be looking for a key if you don't have any of the identifiers.  There
a 4 current callers, 2 that have checks right before the call and 2
where this could be triggered by a bug in an ASN.1 parser or
corruption.

What's the right way to get this change merged?  There's clearly no
need to coordinate with whoever would merge 2/2 of the series.

Best regards
