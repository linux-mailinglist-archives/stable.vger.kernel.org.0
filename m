Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0AE105B17
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfKUUZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUUZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:25:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBADE20643;
        Thu, 21 Nov 2019 20:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574367917;
        bh=G/nGSTL1B57XIuGO5ynEHLcReSss6lj0KfyUv9aNKdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cp0Bp0sUjt8CPblEyVlxHBFiSLOGYda3VM29BL0sfOcMua/LG0WacwAL/nAgTb3k4
         zr2liKzh3jH42zJweTi0oxtb0H61H6LHBSbRuL29FxchkMPwWolpl7+2l53MvRNVwd
         KpvT0gUi5p4Q5tEoRUsVaOm5AW7IrhPhed8pL/tc=
Date:   Thu, 21 Nov 2019 21:25:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 233/422] netfilter: nf_tables: avoid BUG_ON usage
Message-ID: <20191121202514.GA812833@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051414.205983228@linuxfoundation.org>
 <20191121201618.GB15106@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121201618.GB15106@duo.ucw.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 09:16:18PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Florian Westphal <fw@strlen.de>
> > 
> > [ Upstream commit fa5950e498e7face21a1761f327e6c1152f778c3 ]
> > 
> > None of these spots really needs to crash the kernel.
> > In one two cases we can jsut report error to userspace, in the other
> > cases we can just use WARN_ON (and leak memory instead).
> 
> Do these conditions trigger for someone, to warrant -stable patch?
> 
> > +++ b/net/netfilter/nft_cmp.c
> > @@ -79,7 +79,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> >  
> >  	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
> >  			    tb[NFTA_CMP_DATA]);
> > -	BUG_ON(err < 0);
> > +	if (err < 0)
> > +		return err;
> >  
> >  	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
> >  	err = nft_validate_register_load(priv->sreg, desc.len);
> > @@ -129,7 +130,8 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
> >  
> >  	err = nft_data_init(NULL, &data, sizeof(data), &desc,
> >  			    tb[NFTA_CMP_DATA]);
> > -	BUG_ON(err < 0);
> > +	if (err < 0)
> > +		return err;
> >  
> >  	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
> >  	err = nft_validate_register_load(priv->sreg, desc.len);
> 
> This goes from "kill kernel with backtrace" to "silently return
> failure". Should WARN_ON() be preserved here?

if this can be triggered, then the people running with panic-on-warn
would reboot.  It's best to handle it properly here.  And it isn't
"silent", the error is returned.

thanks,

greg k-h
