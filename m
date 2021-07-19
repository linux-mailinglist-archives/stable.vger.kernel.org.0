Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96283CD3C3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhGSKnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 06:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236491AbhGSKm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 06:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09334610CC;
        Mon, 19 Jul 2021 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626693818;
        bh=+MNpgNaFqW2ZiZAktLeNlF/Hkgwafj2mHobAqr4pDLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ScUCC1Y7kdv7dK2/NeDyS8NhlT2mNvZk32vV1wVVFmvB720kHlqaDVhu3JyWjai5x
         4cOLogx6sH/0OaHVrHkK0GXQYujlWsBNb5kkS1HAXR/On3dXD/tqJq9UFXJpf5GA3u
         Qei34IAUauGndiVVJW6lM5P/K7Kw9bZMMlOMOqMg=
Date:   Mon, 19 Jul 2021 13:23:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Xiaotian Feng <xtfeng@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5.12 237/242] drm/ast: Remove reference to struct
 drm_device.pdev
Message-ID: <YPVgtybrZLxe3XeW@kroah.com>
References: <20210715182551.731989182@linuxfoundation.org>
 <20210715182634.577299401@linuxfoundation.org>
 <CAJn8CcF+gfXToErpZv=pWmBKF-i--oVWmaM=6AQ8YZCb21X=oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJn8CcF+gfXToErpZv=pWmBKF-i--oVWmaM=6AQ8YZCb21X=oA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 05:57:30PM +0800, Xiaotian Feng wrote:
> On Fri, Jul 16, 2021 at 5:13 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Thomas Zimmermann <tzimmermann@suse.de>
> >
> > commit 0ecb51824e838372e01330752503ddf9c0430ef7 upstream.
> >
> > Using struct drm_device.pdev is deprecated. Upcast with to_pci_dev()
> > from struct drm_device.dev to get the PCI device structure.
> >
> > v9:
> >         * fix remaining pdev references
> >
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> > Fixes: ba4e0339a6a3 ("drm/ast: Fixed CVE for DP501")
> > Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
> > Cc: kernel test robot <lkp@intel.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: dri-devel@lists.freedesktop.org
> > Link: https://patchwork.freedesktop.org/patch/msgid/20210429105101.25667-2-tzimmermann@suse.de
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/gpu/drm/ast/ast_main.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > --- a/drivers/gpu/drm/ast/ast_main.c
> > +++ b/drivers/gpu/drm/ast/ast_main.c
> > @@ -411,7 +411,6 @@ struct ast_private *ast_device_create(co
> >                 return ast;
> >         dev = &ast->base;
> >
> > -       dev->pdev = pdev;
> >         pci_set_drvdata(pdev, dev);
> >
> >         ast->regs = pcim_iomap(pdev, 1, 0);
> > @@ -453,8 +452,8 @@ struct ast_private *ast_device_create(co
> >
> >         /* map reserved buffer */
> >         ast->dp501_fw_buf = NULL;
> > -       if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0)) {
> > -               ast->dp501_fw_buf = pci_iomap_range(dev->pdev, 0, dev->vram_mm->vram_size, 0);
> > +       if (dev->vram_mm->vram_size < pci_resource_len(pdev, 0)) {
> > +               ast->dp501_fw_buf = pci_iomap_range(pdev, 0, dev->vram_mm->vram_size, 0);
> >                 if (!ast->dp501_fw_buf)
> >                         drm_info(dev, "failed to map reserved buffer!\n");
> >         }
> >
> 
> Hi Greg,
> 
>      This backport is incomplete for 5.10 kernel,  kernel is panicked
> on RIP: ast_device_create+0x7d.  When I look into the crash code, I
> found
> 
> struct ast_private *ast_device_create(struct drm_driver *drv,
>                                       struct pci_dev *pdev,
>                                       unsigned long flags)
> {
> .......
>         dev->pdev = pdev;  // This is removed
>         pci_set_drvdata(pdev, dev);
> 
>         ast->regs = pcim_iomap(pdev, 1, 0);
>         if (!ast->regs)
>                 return ERR_PTR(-EIO);
> 
>         /*
>          * If we don't have IO space at all, use MMIO now and
>          * assume the chip has MMIO enabled by default (rev 0x20
>          * and higher).
>          */
>         if (!(pci_resource_flags(dev->pdev, 2) & IORESOURCE_IO)) { //
> dev->pdev is in used here.
>                 drm_info(dev, "platform has no IO space, trying MMIO\n");
>                 ast->ioregs = ast->regs + AST_IO_MM_OFFSET;
>         }
> 
>         That's because commit 46fb883c3d0d8a823ef995ddb1f9b0817dea6882
> is not backported to 5.10 kernel.

So what should I do here?  Backport that commit (was was not called
out), or just revert this?

thanks,

greg k-h
