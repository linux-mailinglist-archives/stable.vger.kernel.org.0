Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F334A3FFF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358053AbiAaKUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348432AbiAaKUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1D0C061714;
        Mon, 31 Jan 2022 02:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA3761363;
        Mon, 31 Jan 2022 10:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E24C340E8;
        Mon, 31 Jan 2022 10:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643624423;
        bh=3FvrwIVyIouUVvMJY8LZ5TVwk/lR4V0MKYC+KqrJ+kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b0xlS4YrpJ3Vgc9idqkgKGGjX9wev/5R4y/UjXEOFbxutTMyYxOq6TgtyC0WT18xE
         Uo94rf2TZKDhOJR3an+0gBMPYIzsNe/XbZ0apYWFyaofsT8ncT/E1AkZQTOiB1E5UP
         rpeEd9xtiASUFZRllfSpwBMJbGJvnLGWEUQmO/bxZMfWav7qm5C5WtWq0rf/2+T2dK
         xlY40sbr5kFKuSD77j/aSc13UPHp4PU3FxAGVvWlg0NVoSylXZrsUhog88+LpFbbGF
         nrsTPTUfETH3uH0pSPrq9n78u4/v322lQYV2bNg84jretTeWT+yo5YyNVTKCApReHM
         E0iU+s1qo+j6A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nETn6-0002DQ-7P; Mon, 31 Jan 2022 11:20:08 +0100
Date:   Mon, 31 Jan 2022 11:20:08 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] media: davinci: vpif: fix unbalanced runtime PM
 enable
Message-ID: <Yfe32PGiFNYvr2hh@hovoldconsulting.com>
References: <20211222142025.30364-1-johan@kernel.org>
 <20211222142025.30364-3-johan@kernel.org>
 <CA+V-a8thJtWjL+2-TNdbZTe=hKCVYz2vwAL-uCNeW+-TmVKPVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8thJtWjL+2-TNdbZTe=hKCVYz2vwAL-uCNeW+-TmVKPVg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lad,

and sorry about the late reply.

On Tue, Jan 04, 2022 at 06:11:08PM +0000, Lad, Prabhakar wrote:
> Hi Johan,
> 
> Thank you for the patch.
> 
> On Wed, Dec 22, 2021 at 2:20 PM Johan Hovold <johan@kernel.org> wrote:
> >
> > Make sure to disable runtime PM before returning on probe errors.
> >
> > Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
> > Cc: stable@vger.kernel.org      # 4.12: 4024d6f601e3c
> > Cc: Kevin Hilman <khilman@baylibre.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/media/platform/davinci/vpif.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> > index 9752a5ec36f7..1f5eacf48580 100644
> > --- a/drivers/media/platform/davinci/vpif.c
> > +++ b/drivers/media/platform/davinci/vpif.c
> > @@ -428,6 +428,7 @@ static int vpif_probe(struct platform_device *pdev)
> >         static struct resource *res_irq;
> >         struct platform_device *pdev_capture, *pdev_display;
> >         struct device_node *endpoint = NULL;
> > +       int ret;
> >
> >         vpif_base = devm_platform_ioremap_resource(pdev, 0);
> >         if (IS_ERR(vpif_base))
> > @@ -456,8 +457,8 @@ static int vpif_probe(struct platform_device *pdev)
> >         res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >         if (!res_irq) {
> >                 dev_warn(&pdev->dev, "Missing IRQ resource.\n");
> > -               pm_runtime_put(&pdev->dev);
> Maybe just add pm_runtime_disable(&pdev->dev); here, rest diff won't
> be required.

I chose to do it this way in order to make the following patches
smaller and easier to review.

Thanks for reviewing.

Johan
