Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5348D33F
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 08:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiAMHzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 02:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiAMHzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 02:55:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93233C061751
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 23:55:04 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso8816423pjd.1
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 23:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ART6mChcRaBTPOdw4Uw1NRQaOClQpOziB1B27u8xfNE=;
        b=nYWiWIKg/nVi8VfR+gG0iCaYOIxo38iFp/F1K4FphKugIVoZR/sQpiCyTIzvuxlDQn
         PIRGruVO71yEFP73kb+1flbyKCrqIuUmnIPmxBNOjH7xMVQ2mLdpqLW4K0nZvK3JgPhm
         PDPUBPeifa23/g59smCmTB92MEODa9vSozKb1rmPlN3kBAJBH5neWxtUl+DVEV+PsMvo
         /KgwhAdcDLDxNP6rWyfdSwqueDlCYqm4z1/Q0FQSvLIwH4LLVPROtMgvJAcVm5nbVCQJ
         f/A2r9UrvgLFle17KYhbAjzJULINVhf+NWbc2Z6Wyt9cxuwh6BJ0HzyjXKF47A8Pu4GH
         vRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ART6mChcRaBTPOdw4Uw1NRQaOClQpOziB1B27u8xfNE=;
        b=Dmg7yTqMl7R1+eOWkIB9xllMXOwI+ZhDVASghiC4x62XyDFLEEH/StZFxwuaxbCqT7
         y1xRSBllzxR85wrrvi0EnxuquxSoVNa61GWH1ZQ8LInnrmQ9Ur9Nejypr3egw5FX9me8
         hppzSqIzn0efDmGEDXMvKWsgm+Dr1JajgBCSRSKDPe8cHVf6de2q6SqJW7db26vZQhbe
         Kw7egZbzPFkUhkBqpbaYnktkOtiP3zJfItkCmr9GnFb1z9YG6sxmZE4Mj0vobLFzMuc9
         VgNd+RCbW66t7Crew+LlHPR/OZFWlNA5D3z5klRzBFEq5fV8t2+GVGcUwT8E+Ip5u2/m
         r3Zw==
X-Gm-Message-State: AOAM53275b1C2aSPwzdYESkfcxqUa6hb6jJqFXVMSEw9N2xfrK57jKS/
        8i9cDj9SiNH1aj6gT+4+1Y55RMfN8Mz3fxciDdxd/g==
X-Google-Smtp-Source: ABdhPJwM5gn08aUuzygROzs39EPlG4SL7oMN99ERLiPPxp08rpNtghsTcio9VCzaeuhLNOb1bMRdw3LFhy8bjGsLA50=
X-Received: by 2002:a17:90a:cc0d:: with SMTP id b13mr13200915pju.236.1642060503539;
 Wed, 12 Jan 2022 23:55:03 -0800 (PST)
MIME-Version: 1.0
References: <20211229112551.3483931-1-pumahsu@google.com> <Yd1tUKhyZf26OVNQ@kroah.com>
In-Reply-To: <Yd1tUKhyZf26OVNQ@kroah.com>
From:   Puma Hsu <pumahsu@google.com>
Date:   Thu, 13 Jan 2022 15:54:27 +0800
Message-ID: <CAGCq0LZb8nQDvcz=LswWi4qKd-65ys6iPjTKh=46dVtYLDEUVw@mail.gmail.com>
Subject: Re: [PATCH v3] xhci: re-initialize the HC during resume if HCE was set
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@intel.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 7:43 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 29, 2021 at 07:25:51PM +0800, Puma Hsu wrote:
> > When HCE(Host Controller Error) is set, it means an internal
> > error condition has been detected. It needs to re-initialize
> > the HC too.
>
> What is "It" in the last sentence?

Maybe I can change "It" to "Software", xHCI specification uses
"Software" when describing this.

>
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Puma Hsu <pumahsu@google.com>
>
> What commit id does this fix?

This commit is not used to fix a specific commit. We find a condition
that when XHCI runs the resume process but the HCE flag is set, then
the Run/Stop bit of USBCMD cannot be set so that HC would not be
enabled. In fact, HC may already meet a problem at this moment.
Besides, in xHCI requirements specification revision 1.2, Table 5-21
BIT(12) claims that Software should re-initialize the xHC when HCE is
set. Therefore, I think this commit could be the error handling for
HCE.

>
> > ---
> > v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> > v3: Add stable@vger.kernel.org for stable release.
> >
> >  drivers/usb/host/xhci.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index dc357cabb265..ab440ce8420f 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -1146,8 +1146,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> >               temp = readl(&xhci->op_regs->status);
> >       }
> >
> > -     /* If restore operation fails, re-initialize the HC during resume */
> > -     if ((temp & STS_SRE) || hibernated) {
> > +     /* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> > +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
>
> But if STS_HCE is set on suspend, that means the suspend was broken so
> you wouldn't get here, right?

In xhci_suspend(), it seems doesn't really check whether STS_HCE is
set and then break the suspend(The only case for checking HCE is when
STS_SAVE setting failed). So suspend function may be still able to
finish even if HCE is set? Then xhci_resume will still be called.

> Or can the error happen between suspend and resume?
>
> This seems like a big hammer for when the host controller throws an
> error.  Why is this the only place that it should be checked for?  What
> caused the error that can now allow it to be fixed?

I believe this is not the only place that the host controller may set
HCE, the host controller may set HCE anytime it sees an error in my
opinion, not only in suspend or resume.
I think this could be a recovery if xhci finds HCE during the resume process.
If someone finds HCE in other functions, it may also need to do the
recovery too.


> thanks,
>
> greg k-h
