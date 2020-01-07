Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C2A132D5B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgAGRpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 12:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgAGRpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 12:45:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25102081E;
        Tue,  7 Jan 2020 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578419149;
        bh=PogBCs252q4wb6OOumVr05KLsm+Fdz6RVqZBul2qrtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kbI+F1PdPXANyDqupC3KhyiN/Bs+bvHh6h0tDe8zGJ3b5+TMjjrQx95gBCOJHoYCf
         QrHrLV/eDCZ7sfO+DgqyoxJvDucmgRcFkF8mlSylcYx1L+MJYOMxU0CVWbl/0kD7DY
         SOnmQwyM75ECq8fPo8uZ4r3X2bOwxrG+9OERliMg=
Date:   Tue, 7 Jan 2020 18:45:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 102/177] nvmem: imx-ocotp: reset error
 status on probe
Message-ID: <20200107174546.GB2011915@kroah.com>
References: <20191210213221.11921-1-sashal@kernel.org>
 <20191210213221.11921-102-sashal@kernel.org>
 <dd048e02-81f7-8aed-34a7-f95a70859391@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd048e02-81f7-8aed-34a7-f95a70859391@armadeus.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 03:50:59PM +0100, Sébastien Szymanski wrote:
> On 12/10/19 10:31 PM, Sasha Levin wrote:
> > From: Lucas Stach <l.stach@pengutronix.de>
> > 
> > [ Upstream commit c33c585f1b3a99d53920bdac614aca461d8db06f ]
> > 
> > If software running before the OCOTP driver is loaded left the
> > controller with the error status pending, the driver will never
> > be able to complete the read timing setup. Reset the error status
> > on probe to make sure the controller is in usable state.
> > 
> > Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > Link: https://lore.kernel.org/r/20191029114240.14905-6-srinivas.kandagatla@linaro.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/nvmem/imx-ocotp.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
> > index afb429a417fe0..926d9cc080cf4 100644
> > --- a/drivers/nvmem/imx-ocotp.c
> > +++ b/drivers/nvmem/imx-ocotp.c
> > @@ -466,6 +466,10 @@ static int imx_ocotp_probe(struct platform_device *pdev)
> >  	if (IS_ERR(priv->clk))
> >  		return PTR_ERR(priv->clk);
> >  
> > +	clk_prepare_enable(priv->clk);
> > +	imx_ocotp_clr_err_if_set(priv->base);
> > +	clk_disable_unprepare(priv->clk);
> > +
> >  	priv->params = of_device_get_match_data(&pdev->dev);
> >  	imx_ocotp_nvmem_config.size = 4 * priv->params->nregs;
> >  	imx_ocotp_nvmem_config.dev = dev;
> > 
> 
> Hi,
> 
> This patch makes kernel 4.19.{92,93} hang at boot on my i.MX6ULL based
> board. It hanks at
> 
> [    3.730078] cpu cpu0: Linked as a consumer to regulator.2
> [    3.737760] cpu cpu0: Linked as a consumer to regulator.3
> 
> Full boot log is here: https://pastebin.com/TS8EFxkr
> 
> The config is imx_v6_v7_defconfig.
> 
> Reverting it makes the kernels boot again.

Does this also cause problems in 5.4.7 and newer?

thanks,

greg k-h
