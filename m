Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFAD4A2D5B
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiA2JXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiA2JXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:23:49 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D006C06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:23:49 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id qe6-20020a17090b4f8600b001b7aaad65b9so2572418pjb.2
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bqzBoRkDi8kVZLIMHecE3nTUwM1cKHwe7YhWSOKzDP4=;
        b=s97mGS9tiPyBqXIXKy3aSh/N4MQ9p3JSjfDa3iVBO/Yre+GETk8gTsrVUntRjvG8/m
         rQrNRXjXcrI0pnn6CapBI1VN2KoFgEQfUybFE0qXREGW7/Ct7OPgPDUzdb0iFQbg5Lok
         GPiSGiEUkxt5e7FpuZofX6lubQiidNESe0CzO+sgmdijG9oXNeQT3Wh2eIlRUgiBEcNS
         G1JfC8l3U2YHhQuvDFlTkIcZQskxd0h9YRiuPXbnanlukqx+0Bt105wGtXQkOAA5SpkV
         pTFHnmpt6XZHRqqG6WQoU6w09u/PM1eStPysheNrb67/4Oj9WUDoVpjQSOb1oF95rTIr
         zcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bqzBoRkDi8kVZLIMHecE3nTUwM1cKHwe7YhWSOKzDP4=;
        b=sqnHeykMGxCTR/ssIGQ4NkKuEG8ePgNvm2CycScR+SPrJXRde9XkM7c/XcVB2Rez7h
         krq06bid/iKu2K5wtlmSb4VNGqfBfdacdmtf/6zdn94ZAnyXEFnxC91veFudK/Fv6dDC
         GgqWXAolO/VjLPijzYue4b6gjEx0D0dega46hti8JFOG2DO7VJRp+aVGyiiC2b0Pf2kX
         X6ka/sWtKEUiqCUTgagsoT7JTwRucHapLLIuqCo/bYmxHrjeR2AJ+3OU1iprPsv/I0qz
         aXJ9CpbDVI60mdgvjvhUJphGvS3AQQpSBN9PHrlSkoAuccfxrp1FNX63bsuT/Jpmy4Jw
         elUw==
X-Gm-Message-State: AOAM531LJv15P8AHugGbSjk3YE7M0nTR9P7M4/xtYE/3UNmlZtIFVtbZ
        4HlD6sA57GmtTjOLIclr+9iDHdCxLgEeKub+jz61Ow==
X-Google-Smtp-Source: ABdhPJxkwCr5AJ3CWlNsUJ2kZldTLSWl6JJt6MW+qo5eS2oZPFbsWd6uXO4KRJK6Arlc6JioXfqDrw3X/aq49qkQFHs=
X-Received: by 2002:a17:90b:1881:: with SMTP id mn1mr23751902pjb.236.1643448228173;
 Sat, 29 Jan 2022 01:23:48 -0800 (PST)
MIME-Version: 1.0
References: <20220119064013.1381172-1-pumahsu@google.com> <e2baf3c5-0d80-9143-5fec-98a9e1474068@linux.intel.com>
In-Reply-To: <e2baf3c5-0d80-9143-5fec-98a9e1474068@linux.intel.com>
From:   Puma Hsu <pumahsu@google.com>
Date:   Sat, 29 Jan 2022 17:23:12 +0800
Message-ID: <CAGCq0LbWSqTJ+M+jxryUmn44FefC7cmS5ouP8BLyFY9z1RePMA@mail.gmail.com>
Subject: Re: [PATCH v5] xhci: re-initialize the HC during resume if HCE was set
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     mathias.nyman@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 9:43 PM Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
>
> On 19.1.2022 8.40, Puma Hsu wrote:
> > When HCE(Host Controller Error) is set, it means an internal
> > error condition has been detected. Software needs to re-initialize
> > the HC, so add this check in xhci resume.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Puma Hsu <pumahsu@google.com>
> > ---
> > v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> > v3: Add stable@vger.kernel.org for stable release.
> > v4: Refine the commit message.
> > v5: Add a debug log. Follow Mathias Nyman <mathias.nyman@linux.intel.co=
m>'s comment.
> >
> >  drivers/usb/host/xhci.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index dc357cabb265..41f594f0f73f 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -1146,8 +1146,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibe=
rnated)
> >               temp =3D readl(&xhci->op_regs->status);
> >       }
> >
> > -     /* If restore operation fails, re-initialize the HC during resume=
 */
> > -     if ((temp & STS_SRE) || hibernated) {
> > +     /* If restore operation fails or HC error is detected, re-initial=
ize the HC during resume */
> > +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
> > +             xhci_warn(xhci, "re-initialize HC during resume, USBSTS:%=
s\n",
> > +                       xhci_decode_usbsts(str, temp));
> >
> >               if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
> >                               !(xhci_all_ports_seen_u0(xhci))) {
> >
>
> Tried to compile, something is missing in this patch:
>
> drivers/usb/host/xhci.c:1152:25: error: =E2=80=98str=E2=80=99 undeclared =
(first use in this function); did you mean =E2=80=98qstr=E2=80=99?

Sorry for missing the declaration, I will fix it.

> -Mathias
