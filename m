Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAA93F2750
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 09:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbhHTHJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 03:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbhHTHJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 03:09:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CF8C061575
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 00:08:37 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id h9so18199024ejs.4
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 00:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=tZyS+zXa1Utgu1YkWDpQkftwI+AG9c8wXg8Bo5VkgJM=;
        b=XogW8rGOW6/tdWw0ZKA3JxvyqAbJCI6lEDDU7fvgasNzT+o800W3F2gKp9fejx/fy3
         VqFGtNy/fuJfUNq2JrI1m4CZ8MOYxzDJtO/+4xgSkxJww0TxpY/ThctCmcOHN4SCL6FL
         +vQTY8DjH21YBJ2leSKoXDGVxmyO1Gh7U4fdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tZyS+zXa1Utgu1YkWDpQkftwI+AG9c8wXg8Bo5VkgJM=;
        b=SJzbqJ0wO8/xQORYsiFLDG6cnQai4KjGILW3+6edv1qqBjHbzEGgfVVINPyZKEe5Cl
         KhB1WGWnoUmj0kj68awpSQv93sK6XO5I0F1H3yJd1+0Zjl/xxq4C1vwPIIMgyGSiGORA
         m9LqogmmpAxtM34jdET+euKM7XcTBSsoMMaF2zIB+55n2shaYFiQWVrn9EAeXBSSAPab
         TuWmvRI0mpriCQU4OjOG0DrMtbEUq2GGx14DVWEsFTcNfTEtmPcIGJ0waebpjRcTgvAt
         xKdKsMD6r3YoA43MK7iLLxK2Ao3vb4u9brLG5efhqJYRqc5ydLHoYzwFT0SK9jjutRVh
         DoXQ==
X-Gm-Message-State: AOAM530e0KE0vhhllUAuAUgvqp+Tt5dySFSiwqVBXhEp9c9GA5Fks+nx
        SfPLzWINpfQVEawiWAPgAGQKQQ==
X-Google-Smtp-Source: ABdhPJyyGdJimIeNUa5bT+wDN8Nb2/rDE+ePtHJAG3OyMAFMOcG+Qizyvz71eWwE+cJnle3s0hRkRw==
X-Received: by 2002:a17:906:184e:: with SMTP id w14mr20107548eje.526.1629443316292;
        Fri, 20 Aug 2021 00:08:36 -0700 (PDT)
Received: from carbon (78-83-68-78.spectrumnet.bg. [78.83.68.78])
        by smtp.gmail.com with ESMTPSA id z70sm3045792ede.76.2021.08.20.00.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 00:08:35 -0700 (PDT)
Date:   Fri, 20 Aug 2021 10:08:35 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fixes of set_register(s) return value
 evaluation;
Message-ID: <YR9U80Iv9I2SjABw@carbon>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org
References: <20210819090539.15879-1-petko.manolov@konsulko.com>
 <20210819123429.7b15f08e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819123429.7b15f08e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-08-19 12:34:29, Jakub Kicinski wrote:
> On Thu, 19 Aug 2021 12:05:39 +0300 Petko Manolov wrote:
> >   - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
> >     Kicinski;
> >   - hurried up and removed redundant assignment in pegasus_open() before yet
> >     another checker complains;
> >   - explicitly check for negative value in pegasus_set_wol(), even if
> >     usb_control_msg_send() never return positive number we'd still be in sync
> >     with the rest of the driver style;
> > 
> > Fixes: 8a160e2e9aeb net: usb: pegasus: Check the return value of get_geristers() and friends;
> 
> I guess this is fine but not exactly the preferred format, please see
> Submitting patches.

If the preferred format involves brackets and quotes - so be it.

> > Reported-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> > ---
> >  drivers/net/usb/pegasus.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> > index 652e9fcf0b77..1ef93082c772 100644
> > --- a/drivers/net/usb/pegasus.c
> > +++ b/drivers/net/usb/pegasus.c
> > @@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> >  		write_mii_word(pegasus, 0, 0x1b, &auxmode);
> >  	}
> >  
> > -	return 0;
> > +	return ret;
> 
> yup
> 
> >  fail:
> >  	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> >  	return ret;
> > @@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
> >  	if (!pegasus->rx_skb)
> >  		goto exit;
> >  
> > -	res = set_registers(pegasus, EthID, 6, net->dev_addr);
> > +	set_registers(pegasus, EthID, 6, net->dev_addr);
> 
> yup
> 
> >  	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
> >  			  usb_rcvbulkpipe(pegasus->usb, 1),
> > @@ -932,7 +932,7 @@ pegasus_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
> >  	pegasus->wolopts = wol->wolopts;
> >  
> >  	ret = set_register(pegasus, WakeupControl, reg78);
> > -	if (!ret)
> > +	if (ret < 0)
> >  		ret = device_set_wakeup_enable(&pegasus->usb->dev,
> >  						wol->wolopts);
> 
> now this looks incorrect and unrelated to recent changes (IOW the
> commit under Fixes), please drop this chunk

It may not be related, but the change is:

	a) obviously correct; and

	b) in sync with the rest of 'ret' evaluations;

To be honest i do not envision usb_control_msg_send() returning positive value
anytime soon, but (ret < 0) looks "more" correct than (!ret).


		Petko
