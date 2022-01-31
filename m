Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2294A47EB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376437AbiAaNUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiAaNUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A790CC061714;
        Mon, 31 Jan 2022 05:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3916B82AE1;
        Mon, 31 Jan 2022 13:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3F5C340EE;
        Mon, 31 Jan 2022 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643635210;
        bh=qk/GzWF+PrZ1CJd+U4cjuHtK3Pd/DekAoW2KSXSyNPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hGd2izQErHbOw9LEBcl3F1TlOXSeLwd/5wFFQJMYLIGUZLPFdN8/DINM+t5FybI2e
         t4QwGUA69EUrzH3GzfG9VB4I7xQHGXn8FF9C+jvPX/y3SsFA/aSkEuY34ydtarvJV/
         6fo4wCvtH2rvTCrWaWk3+xuTZGk8QGXKYtEwZ0WM=
Date:   Mon, 31 Jan 2022 14:20:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrey Konovalov <andreyknvl@gmail.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: raw-gadget: fix handling of dual-direction-capable
 endpoints
Message-ID: <YffiB97o/EMldKxg@kroah.com>
References: <20220126205214.2149936-1-jannh@google.com>
 <CA+fCnZe_p+JwUWwumgGm185vWSdAK_z-UFDp7-HWKANB4YjA=g@mail.gmail.com>
 <CAG48ez0pke5fqEuWGecMAKLpsdVoW3JM3M-SkajHcq_dsrQ_4A@mail.gmail.com>
 <CA+fCnZdXpBHFN3u5exkbLkUsPaFVsbFi=evsPd3uMMfV=tKAeg@mail.gmail.com>
 <CA+fCnZc4kavuHbGXAbzQJSLG=f9Oc--O-H=OT_xkKb0AooyyAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZc4kavuHbGXAbzQJSLG=f9Oc--O-H=OT_xkKb0AooyyAQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 10:58:42PM +0100, Andrey Konovalov wrote:
> On Wed, Jan 26, 2022 at 11:37 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > On Wed, Jan 26, 2022 at 11:31 PM Jann Horn <jannh@google.com> wrote:
> > >
> > > On Wed, Jan 26, 2022 at 11:12 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> > > > On Wed, Jan 26, 2022 at 9:52 PM Jann Horn <jannh@google.com> wrote:
> > > > >
> > > > > Under dummy_hcd, every available endpoint is *either* IN or OUT capable.
> > > > > But with some real hardware, there are endpoints that support both IN and
> > > > > OUT. In particular, the PLX 2380 has four available endpoints that each
> > > > > support both IN and OUT.
> > > > >
> > > > > raw-gadget currently gets confused and thinks that any endpoint that is
> > > > > usable as an IN endpoint can never be used as an OUT endpoint.
> > > > >
> > > > > Fix it by looking at the direction in the configured endpoint descriptor
> > > > > instead of looking at the hardware capabilities.
> > > > >
> > > > > With this change, I can use the PLX 2380 with raw-gadget.
> > > > >
> > > > > Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
> > > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > > ---
> > > > >  drivers/usb/gadget/legacy/raw_gadget.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
> > > > > index c5a2c734234a..d86c3a36441e 100644
> > > > > --- a/drivers/usb/gadget/legacy/raw_gadget.c
> > > > > +++ b/drivers/usb/gadget/legacy/raw_gadget.c
> > > > > @@ -1004,7 +1004,7 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
> > > > >                 ret = -EBUSY;
> > > > >                 goto out_unlock;
> > > > >         }
> > > > > -       if ((in && !ep->ep->caps.dir_in) || (!in && ep->ep->caps.dir_in)) {
> > > > > +       if (in != usb_endpoint_dir_in(ep->ep->desc)) {
> > > > >                 dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
> > > > >                 ret = -EINVAL;
> > > > >                 goto out_unlock;
> > > > >
> > > > > base-commit: 0280e3c58f92b2fe0e8fbbdf8d386449168de4a8
> > > > > --
> > > > > 2.35.0.rc0.227.g00780c9af4-goog
> > > > >
> >
> > Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> > Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
> 
> Greg, could you PTAL and pick this up?
> 
> It also makes sense to include this fix into stable kernels.
> 
> Cc: <stable@vger.kernel.org>

Now picked up, thanks.

greg k-h
