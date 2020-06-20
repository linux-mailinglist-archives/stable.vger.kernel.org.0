Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D8202283
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgFTICm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFTICl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:02:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6AA23A3B;
        Sat, 20 Jun 2020 08:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592640161;
        bh=WkFMscvtq7pzCpfRxKD4yECkLA3IbyFOwSemtQJxTso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qp5D3EvrWjRMKTbVTXGKOFWAwEzXD0RThqhcgF4G2Vg9qDSZ8Jwxfg/hLlOU+MsbK
         0qzF2zF4JFTP12U04oZx9QTz1jFDezJEjOhWUvfpjxuZNpcn3sYKjcFY1UkURtzxYg
         BLHBWoCqz+CUEOXz+J8g2kKOZTD+tumX103B158g=
Date:   Sat, 20 Jun 2020 10:02:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 172/267] net: ethernet: fec: move GPR register
 offset and bit into DT
Message-ID: <20200620080237.GB2302354@kroah.com>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.046148582@linuxfoundation.org>
 <20200619210432.GA12233@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619210432.GA12233@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 11:04:32PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 8a448bf832af537d26aa557d183a16943dce4510 ]
> > 
> > The commit da722186f654 (net: fec: set GPR bit on suspend by DT
> > configuration) set the GPR reigster offset and bit in driver for
> > wake on lan feature.
> > 
> > But it introduces two issues here:
> > - one SOC has two instances, they have different bit
> > - different SOCs may have different offset and bit
> > 
> > So to support wake-on-lan feature on other i.MX platforms, it should
> > configure the GPR reigster offset and bit from DT.
> 
> Ok, so this really is not a bugfix.
> 
> Plus, it really depends on dts changes...
> 
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> >  {
> >  	struct device_node *gpr_np;
> > +	u32 out_val[3];
> >  	int ret = 0;
> >  
> > -	if (!dev_info)
> > -		return 0;
> > -
> > -	gpr_np = of_parse_phandle(np, "gpr", 0);
> > +	gpr_np = of_parse_phandle(np, "fsl,stop-mode", 0);
> >  	if (!gpr_np)
> >  		return 0;
> >
> 
> ...and those changes are not present in v4.19. There's no
> fsl,stop-mode in v4.19, unlike mainline.
> 
> pavel@amd:~/cip/krc$ grep -ri fsl,stop-mode arch/arm*/boot/dts
> pavel@amd:~/cip/krc$
> 
> This will break driver for everyone, AFAICT. Please drop it from
> stable.

Thanks for the report, dropping it from everywhere.

greg k-h
