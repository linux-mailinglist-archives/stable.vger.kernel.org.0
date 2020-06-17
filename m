Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A537E1FC951
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 10:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFQI6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 04:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgFQI6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 04:58:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06A421531;
        Wed, 17 Jun 2020 08:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592384291;
        bh=mDR+ofY8QB6uRFFjiDnRcj5sol5AFxdnuO/QpadX0pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tU/j09zyWSE0WSmJyoVHac0JVoS+WLM7QnAz2U5WJwt5LI9GQp16e6pQK3YfpgLsV
         6tlw8vHjsBa42EwxQc/91ukmocwjhpHo6O1foNNx+eWCNGbgcokUZwA/T+uJGQihY2
         rYK/r7dHGa/q/rXwqiKMuEmzKL74lf3IeuV0gw6I=
Date:   Wed, 17 Jun 2020 10:58:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul@gmail.com>
Cc:     Bin Liu <b-liu@ti.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: musb: mediatek: add reset FADDR to zero in
 reset interrupt handle
Message-ID: <20200617085804.GA1736257@kroah.com>
References: <20200525025049.3400-1-b-liu@ti.com>
 <20200525025049.3400-5-b-liu@ti.com>
 <CACCg+XNfOaE7LE01NPeR6amvCTyrJaJ3sj3AF+Se49T0YFy_Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACCg+XNfOaE7LE01NPeR6amvCTyrJaJ3sj3AF+Se49T0YFy_Uw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 04:17:07PM +0800, Macpaul Lin wrote:
> Bin Liu <b-liu@ti.com> 於 2020年5月25日 週一 上午10:53寫道：
> >
> > From: Macpaul Lin <macpaul.lin@mediatek.com>
> >
> > When receiving reset interrupt, FADDR need to be reset to zero in
> > peripheral mode. Otherwise ep0 cannot do enumeration when re-plugging USB
> > cable.
> >
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > Acked-by: Min Guo <min.guo@mediatek.com>
> > Signed-off-by: Bin Liu <b-liu@ti.com>
> > ---
> >  drivers/usb/musb/mediatek.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
> > index 6196b0e8d77d..eebeadd26946 100644
> > --- a/drivers/usb/musb/mediatek.c
> > +++ b/drivers/usb/musb/mediatek.c
> > @@ -208,6 +208,12 @@ static irqreturn_t generic_interrupt(int irq, void *__hci)
> >         musb->int_rx = musb_clearw(musb->mregs, MUSB_INTRRX);
> >         musb->int_tx = musb_clearw(musb->mregs, MUSB_INTRTX);
> >
> > +       if ((musb->int_usb & MUSB_INTR_RESET) && !is_host_active(musb)) {
> > +               /* ep0 FADDR must be 0 when (re)entering peripheral mode */
> > +               musb_ep_select(musb->mregs, 0);
> > +               musb_writeb(musb->mregs, MUSB_FADDR, 0);
> > +       }
> > +
> >         if (musb->int_usb || musb->int_tx || musb->int_rx)
> >                 retval = musb_interrupt(musb);
> >
> > --
> > 2.17.1
> >
> Could this bug fix also been applied to stable kernel?

Sure, what is the git commit of it in Linus's tree?

thanks,

greg k-h
