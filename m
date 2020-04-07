Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABF71A06A3
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 07:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgDGFmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 01:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGFmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 01:42:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCAF206F5;
        Tue,  7 Apr 2020 05:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586238152;
        bh=QIRrn6My6HdlNXOSqc29iQjUrL4q0bCMmbmpYKRe/EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATf1NYS0f28qOW/3ECAujxcltmNFLeQUzoAb7JV86tpumTZw33qCq9PsR7QKMUS8n
         4eKLZDw7ZQJZ03iS6MB/VgnYESZhv6RvxxiMJZvn3PLmXDvA3abgcRRBf0N8M2BnMj
         XKeHTRcYMM0keBywoGT6aAsIIcFJNovB5TzcwgVg=
Date:   Tue, 7 Apr 2020 07:42:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 040/102] net: dsa: Fix duplicate frames flooded by
 learning
Message-ID: <20200407054227.GA257896@kroah.com>
References: <20200401161530.451355388@linuxfoundation.org>
 <20200401161540.401786749@linuxfoundation.org>
 <5b036a64-db51-d687-758f-c8b0a5b0c72b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b036a64-db51-d687-758f-c8b0a5b0c72b@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 05:42:16PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/1/2020 9:17 AM, Greg Kroah-Hartman wrote:
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > [ Upstream commit 0e62f543bed03a64495bd2651d4fe1aa4bcb7fe5 ]
> > 
> > When both the switch and the bridge are learning about new addresses,
> > switch ports attached to the bridge would see duplicate ARP frames
> > because both entities would attempt to send them.
> > 
> > Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
> > Reported-by: Maxime Bizon <mbizon@freebox.fr>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/dsa/tag_brcm.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/net/dsa/tag_brcm.c
> > +++ b/net/dsa/tag_brcm.c
> > @@ -84,6 +84,8 @@ static struct sk_buff *brcm_tag_xmit(str
> >  		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
> >  	brcm_tag[3] = (1 << p->port) & BRCM_IG_DSTMAP1_MASK;
> >  
> > +	skb->offload_fwd_mark = 1;
> 
> This is incorrectly placed, the assignment should be in brcm_tag_rcv().
> It looks like only linux-4.9.y is affected. Sorry for not noticing this
> earlier. Do you want me to submit a correcting patch?

Yes please, that would make it easier for me.

thanks,

greg k-h
