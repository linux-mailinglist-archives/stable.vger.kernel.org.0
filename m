Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441C5199673
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 14:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgCaM03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 08:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730343AbgCaM02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 08:26:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E7420848;
        Tue, 31 Mar 2020 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657588;
        bh=ARYr/LKj+yZwEU4iRvbH7FzrNzmdYr/PkmH9b2I+f04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xq3N5hZp0GIAPSlbTvfr9BXe+y4LG9Uv3UovNY6Yk0YIOKwgVfPY8EgPzaDoKW2wd
         vSVoDGymgwdCPsZ71SZRea/1NWtuKq69d3jLgndLZgXHbCs5wgttrZgiQhTEhFWfll
         uO8myYXyLDlkGXOuzt5Hxw9vtfHh2ORTVvvFJdpw=
Date:   Tue, 31 Mar 2020 14:12:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.5 138/170] netfilter: nft_fwd_netdev: allow to redirect
 to ifb via ingress
Message-ID: <20200331121228.GB1617997@kroah.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085438.148415210@linuxfoundation.org>
 <20200331101603.wmsbhgmjc6vf4esk@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331101603.wmsbhgmjc6vf4esk@salvia>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 12:16:03PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Mar 31, 2020 at 10:59:12AM +0200, Greg Kroah-Hartman wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > commit bcfabee1afd99484b6ba067361b8678e28bbc065 upstream.
> > 
> > Set skb->tc_redirected to 1, otherwise the ifb driver drops the packet.
> > Set skb->tc_from_ingress to 1 to reinject the packet back to the ingress
> > path after leaving the ifb egress path.
> > 
> > This patch inconditionally sets on these two skb fields that are
> > meaningful to the ifb driver. The existing forward action is guaranteed
> > to run from ingress path.
> > 
> > Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  net/netfilter/nft_fwd_netdev.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- a/net/netfilter/nft_fwd_netdev.c
> > +++ b/net/netfilter/nft_fwd_netdev.c
> > @@ -28,6 +28,10 @@ static void nft_fwd_netdev_eval(const st
> >  	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
> >  	int oif = regs->data[priv->sreg_dev];
> >  
> > +	/* These are used by ifb only. */
> > +	pkt->skb->tc_redirected = 1;
> > +	pkt->skb->tc_from_ingress = 1;
> 
> This patch also requires:
> 
> 2c64605b590e net: Fix CONFIG_NET_CLS_ACT=n and CONFIG_NFT_FWD_NETDEV={y, m} build
> 
> Otherwise build breaks with CONFIG_NET_CLS_ACT=n.

Thanks for the hint, will go do that now.

greg k-h
