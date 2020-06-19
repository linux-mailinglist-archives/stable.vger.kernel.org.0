Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597D320046B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgFSIvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbgFSIvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:51:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE9D214DB;
        Fri, 19 Jun 2020 08:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592556706;
        bh=+3EKnGY3tKJ041sxTHddGESHH8ydpd6WPq3jHXnYMis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGY0Ar/9VLI0/0v6eWtEb38G0oeoyCfpnoivWqJLykbxMgYwhXBw+1pFaXBolu9n+
         OkAZfhVRUlw9WatgcnUo95ln/lnSxgYMLBzujFb/mfZd8mz4XxtTkFMKwfAOMmx/AL
         JaDME+xNf0ZJCxQFEdUdoXgk6+UzAPF+gZyXcS5o=
Date:   Fri, 19 Jun 2020 10:51:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Macpaul Lin <macpaul@gmail.com>, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: musb: mediatek: add reset FADDR to zero in
 reset interrupt handle
Message-ID: <20200619085143.GA677266@kroah.com>
References: <20200525025049.3400-1-b-liu@ti.com>
 <20200525025049.3400-5-b-liu@ti.com>
 <CACCg+XNfOaE7LE01NPeR6amvCTyrJaJ3sj3AF+Se49T0YFy_Uw@mail.gmail.com>
 <20200617085804.GA1736257@kroah.com>
 <1592386317.5395.2.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1592386317.5395.2.camel@mtkswgap22>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 05:31:57PM +0800, Macpaul Lin wrote:
> On Wed, 2020-06-17 at 10:58 +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 17, 2020 at 04:17:07PM +0800, Macpaul Lin wrote:
> > > Bin Liu <b-liu@ti.com> 於 2020年5月25日 週一 上午10:53寫道：
> > > >
> > > > From: Macpaul Lin <macpaul.lin@mediatek.com>
> > > >
> > > > When receiving reset interrupt, FADDR need to be reset to zero in
> > > > peripheral mode. Otherwise ep0 cannot do enumeration when re-plugging USB
> > > > cable.
> > > >
> > > > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > > > Acked-by: Min Guo <min.guo@mediatek.com>
> > > > Signed-off-by: Bin Liu <b-liu@ti.com>
> > > > ---
> > > >  drivers/usb/musb/mediatek.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
> > > > index 6196b0e8d77d..eebeadd26946 100644
> > > > --- a/drivers/usb/musb/mediatek.c
> > > > +++ b/drivers/usb/musb/mediatek.c
> > > > @@ -208,6 +208,12 @@ static irqreturn_t generic_interrupt(int irq, void *__hci)
> > > >         musb->int_rx = musb_clearw(musb->mregs, MUSB_INTRRX);
> > > >         musb->int_tx = musb_clearw(musb->mregs, MUSB_INTRTX);
> > > >
> > > > +       if ((musb->int_usb & MUSB_INTR_RESET) && !is_host_active(musb)) {
> > > > +               /* ep0 FADDR must be 0 when (re)entering peripheral mode */
> > > > +               musb_ep_select(musb->mregs, 0);
> > > > +               musb_writeb(musb->mregs, MUSB_FADDR, 0);
> > > > +       }
> > > > +
> > > >         if (musb->int_usb || musb->int_tx || musb->int_rx)
> > > >                 retval = musb_interrupt(musb);
> > > >
> > > > --
> > > > 2.17.1
> > > >
> > > Could this bug fix also been applied to stable kernel?
> > 
> > Sure, what is the git commit of it in Linus's tree?
> > 
> > thanks,
> > 
> > greg k-h
> 
> The commit id of this patch should be
> 402bcac4b25b520c89ba60db85eb6316f36e797f

Now queued up, thanks.

greg k-h
