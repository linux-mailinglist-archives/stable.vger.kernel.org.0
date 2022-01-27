Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87449DAE8
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 07:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiA0Gjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 01:39:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57824 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbiA0Gjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 01:39:41 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2022 01:39:41 EST
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B8AA920582;
        Thu, 27 Jan 2022 07:33:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RD8ONOuL5xsy; Thu, 27 Jan 2022 07:33:02 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 462F120519;
        Thu, 27 Jan 2022 07:33:02 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 34F4480004A;
        Thu, 27 Jan 2022 07:33:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 07:33:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 27 Jan
 2022 07:33:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5796131805DC; Thu, 27 Jan 2022 07:33:01 +0100 (CET)
Date:   Thu, 27 Jan 2022 07:33:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Antony Antony <antony.antony@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 173/563] xfrm: interface with if_id 0 should return
 error
Message-ID: <20220127063301.GQ1223722@gauss3.secunet.de>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124184030.397155595@linuxfoundation.org>
 <20220126215937.GA31158@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220126215937.GA31158@duo.ucw.cz>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 10:59:37PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 8dce43919566f06e865f7e8949f5c10d8c2493f5 ]
> > 
> > xfrm interface if_id = 0 would cause xfrm policy lookup errors since
> > Commit 9f8550e4bd9d.
> > 
> > Now explicitly fail to create an xfrm interface when if_id = 0
> 
> This will break changelink completely, AFAICT.
> 
> > @@ -672,7 +677,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
> >  {
> >  	struct xfrm_if *xi = netdev_priv(dev);
> >  	struct net *net = xi->net;
> > -	struct xfrm_if_parms p;
> > +	struct xfrm_if_parms p = {};
> > +
> > +	if (!p.if_id) {
> > +		NL_SET_ERR_MSG(extack, "if_id must be non zero");
> > +		return -EINVAL;
> > +	}
> >  
> >  	xfrmi_netlink_parms(data, &p);
> >  	xi = xfrmi_locate(net, &p);
> 
> if_id will be always 0, because it was not yet initialized.
> 
> Best regards,
> 									Pavel
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

Can you please resend this with proper commit message and 'Fixes:' tag?

Thanks!
