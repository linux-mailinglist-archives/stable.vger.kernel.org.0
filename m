Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA43839113B
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 09:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhEZHOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 03:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhEZHO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 03:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E2ED6138C;
        Wed, 26 May 2021 07:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622013161;
        bh=k9arDdstTg+dErXlKKRgWXiQeI0XgpdsxR3Vbwv+9IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xok57HNca//G/NCMBezDnPz+GkQ2NPiZbpVq0+NJLsKpPYlhPff4vaAH84gf0dpZC
         Yt+Nj93vEy4BqL4OgrSRLLJxuddy5zZGrOmBAgakGpLOS0Bvfc06bPH/Bp2KLPhvIx
         zCVJSx+bW+Goh+lNi+Y/XVDRsTPFKHcx8uo7CIoA=
Date:   Wed, 26 May 2021 09:12:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Igor Torrente <igormtorrente@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 4.4 28/31] video: hgafb: fix potential NULL pointer
 dereference
Message-ID: <YK305zUnT83u3sRI@kroah.com>
References: <20210524152322.919918360@linuxfoundation.org>
 <20210524152323.833888129@linuxfoundation.org>
 <20210525204704.GA12631@duo.ucw.cz>
 <2a22a7ec-3a47-92dc-5052-c9e7bb2d604b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a22a7ec-3a47-92dc-5052-c9e7bb2d604b@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 06:06:15PM -0300, Igor Torrente wrote:
> Hi Pavel,
> 
> On 5/25/21 5:47 PM, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
> > > 
> > > commit dc13cac4862cc68ec74348a80b6942532b7735fa upstream.
> > > 
> > > The return of ioremap if not checked, and can lead to a NULL to be
> > > assigned to hga_vram. Potentially leading to a NULL pointer
> > > dereference.
> > > 
> > > The fix adds code to deal with this case in the error label and
> > > changes how the hgafb_probe handles the return of hga_card_detect.
> > 
> > This will break hgafb completely, right? And crash system without hga
> > card as a bonus.
> > 
> > > +++ b/drivers/video/fbdev/hgafb.c
> > > @@ -285,6 +285,8 @@ static int hga_card_detect(void)
> > >   	hga_vram_len  = 0x08000;
> > >   	hga_vram = ioremap(0xb0000, hga_vram_len);
> > > +	if (!hga_vram)
> > > +		return -ENOMEM;
> > >   	if (request_region(0x3b0, 12, "hgafb"))
> > >   		release_io_ports = 1;
> > > @@ -344,13 +346,18 @@ static int hga_card_detect(void)
> > >   			hga_type_name = "Hercules";
> > >   			break;
> > >   	}
> > > -	return 1;
> > > +	return 0;
> > 
> > Ok, so calling convention is now "0 means detected".
> > 
> > 
> > > @@ -548,13 +555,11 @@ static struct fb_ops hgafb_ops = {
> > >   static int hgafb_probe(struct platform_device *pdev)
> > >   {
> > >   	struct fb_info *info;
> > > +	int ret;
> > ...
> > > +	ret = hga_card_detect();
> > > +	if (!ret)
> > > +		return ret;
> > >   	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
> > >   		hga_type_name, hga_vram_len/1024);
> > > 
> > 
> > If the card is detected, 0 is returned, !0 is true, and we abort
> > detection....
> 
> Yes, you are right! There's a patch that fixes it:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-linus&id=02625c965239b71869326dd0461615f27307ecb3
> 
> As far as I know, this patch should be queue up soon to all stable branches.
> 
> Greg should have more details about it.

Good catch, I'll go queue that up now, thanks.

greg k-h
