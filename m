Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7D48D37D
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 09:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiAMIVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 03:21:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55734 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiAMIVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 03:21:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DCC261C1D;
        Thu, 13 Jan 2022 08:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F2EC36AE3;
        Thu, 13 Jan 2022 08:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642062082;
        bh=fX/nWZScQTmUqIw2Cq7C1GzYpE8hxVmOiMEjPokZ9v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wfkto1UK/V1x9kr+AQ6EhVxlBTp9ZBgPZZ6ca+y+RE3Biw+CgVzCMgQGIWeDZnmmi
         T18Q3RzRDxTbTHbgsbhlEYvbvAfk/n1FZyvmj0kwXVz9H2prSpdtLUCQ24uvT7K7N9
         508+wgFvVzB8OD/xB8kU6JOinJCdzLkxJ5h/VhdE=
Date:   Thu, 13 Jan 2022 09:21:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Puma Hsu <pumahsu@google.com>
Cc:     mathias.nyman@intel.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] xhci: re-initialize the HC during resume if HCE was
 set
Message-ID: <Yd/g/ywBWZG7gF8v@kroah.com>
References: <20211229112551.3483931-1-pumahsu@google.com>
 <Yd1tUKhyZf26OVNQ@kroah.com>
 <CAGCq0LZb8nQDvcz=LswWi4qKd-65ys6iPjTKh=46dVtYLDEUVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGCq0LZb8nQDvcz=LswWi4qKd-65ys6iPjTKh=46dVtYLDEUVw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 03:54:27PM +0800, Puma Hsu wrote:
> On Tue, Jan 11, 2022 at 7:43 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Dec 29, 2021 at 07:25:51PM +0800, Puma Hsu wrote:
> > > When HCE(Host Controller Error) is set, it means an internal
> > > error condition has been detected. It needs to re-initialize
> > > the HC too.
> >
> > What is "It" in the last sentence?
> 
> Maybe I can change "It" to "Software", xHCI specification uses
> "Software" when describing this.

Please change it to something better :)

> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Puma Hsu <pumahsu@google.com>
> >
> > What commit id does this fix?
> 
> This commit is not used to fix a specific commit. We find a condition
> that when XHCI runs the resume process but the HCE flag is set, then
> the Run/Stop bit of USBCMD cannot be set so that HC would not be
> enabled. In fact, HC may already meet a problem at this moment.
> Besides, in xHCI requirements specification revision 1.2, Table 5-21
> BIT(12) claims that Software should re-initialize the xHC when HCE is
> set. Therefore, I think this commit could be the error handling for
> HCE.

So this problem has been there since the driver was first added to the
kernel?  Should it go to stable kernels as well?  If so, how far back in
time?

> > > ---
> > > v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> > > v3: Add stable@vger.kernel.org for stable release.
> > >
> > >  drivers/usb/host/xhci.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > > index dc357cabb265..ab440ce8420f 100644
> > > --- a/drivers/usb/host/xhci.c
> > > +++ b/drivers/usb/host/xhci.c
> > > @@ -1146,8 +1146,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> > >               temp = readl(&xhci->op_regs->status);
> > >       }
> > >
> > > -     /* If restore operation fails, re-initialize the HC during resume */
> > > -     if ((temp & STS_SRE) || hibernated) {
> > > +     /* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> > > +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
> >
> > But if STS_HCE is set on suspend, that means the suspend was broken so
> > you wouldn't get here, right?
> 
> In xhci_suspend(), it seems doesn't really check whether STS_HCE is
> set and then break the suspend(The only case for checking HCE is when
> STS_SAVE setting failed). So suspend function may be still able to
> finish even if HCE is set? Then xhci_resume will still be called.

Is this a problem?

> > Or can the error happen between suspend and resume?
> >
> > This seems like a big hammer for when the host controller throws an
> > error.  Why is this the only place that it should be checked for?  What
> > caused the error that can now allow it to be fixed?
> 
> I believe this is not the only place that the host controller may set
> HCE, the host controller may set HCE anytime it sees an error in my
> opinion, not only in suspend or resume.

Then where else should it be checked?  Where else will your silicon set
this bit as part of the normal operating process?

thanks,

greg k-h
