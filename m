Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3AC171B1
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 08:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfEHGfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 02:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfEHGfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 02:35:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A71F521019;
        Wed,  8 May 2019 06:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557297353;
        bh=sWVpp/CJFMDokqdQ+85Irw1Hg3zdyDOw5QYwGEIADSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmWCwLMindKbYT60YXOnwSJTIp8N/2STq/iAkVM7acQPRj2RRwciDfS88Xb26kbLB
         U1jBb96f32oZQWcjrr4D4Grmtj/S04SpXfToH6Gqp2bY15+kayD28Gnygs0r/yAI+4
         R+tyaoncN3r/o7GZdY7w7y8BRaNuxLAkbzsqznpU=
Date:   Wed, 8 May 2019 08:35:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 38/99] net: stmmac: use correct DMA buffer size in
 the RX descriptor
Message-ID: <20190508063550.GA28651@kroah.com>
References: <20190506143053.899356316@linuxfoundation.org>
 <20190506143057.399914447@linuxfoundation.org>
 <20190508001014.hlemsaqvir3umv2i@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508001014.hlemsaqvir3umv2i@toshiba.co.jp>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 09:10:14AM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Mon, May 06, 2019 at 04:32:11PM +0200, Greg Kroah-Hartman wrote:
> > [ Upstream commit 583e6361414903c5206258a30e5bd88cb03c0254 ]
> > 
> > We always program the maximum DMA buffer size into the receive descriptor,
> > although the allocated size may be less. E.g. with the default MTU size
> > we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> > memory may get corrupted.
> > 
> > Fix by using exact buffer sizes.
> > 
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  .../net/ethernet/stmicro/stmmac/descs_com.h   | 22 ++++++++++++-------
> >  .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  2 +-
> >  .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |  2 +-
> >  .../net/ethernet/stmicro/stmmac/enh_desc.c    | 10 ++++++---
> >  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +-
> >  .../net/ethernet/stmicro/stmmac/norm_desc.c   | 10 ++++++---
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++--
> 
> This commit is incomplete and we need the following commit:
> 
> commit f87db4dbd52f2f8a170a2b51cb0926221ca7c9e2
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Wed Apr 17 09:49:39 2019 +0800
> 
>     net: stmmac: Use bfsize1 in ndesc_init_rx_desc
> 
>     gcc warn this:
> 
>     drivers/net/ethernet/stmicro/stmmac/norm_desc.c: In function ndesc_init_rx_desc:
>     drivers/net/ethernet/stmicro/stmmac/norm_desc.c:138:6: warning: variable 'bfsize1' set but not used [-Wunused-but-set-variable]
> 
>     Like enh_desc_init_rx_desc, we should use bfsize1
>     in ndesc_init_rx_desc to calculate 'p->des1'
> 
>     Fixes: 583e63614149 ("net: stmmac: use correct DMA buffer size in the RX descriptor")
>     Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>     Reviewed-by: Aaro Koskinen <aaro.koskinen@nokia.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> And this fix is also needed for 5.0.14-rc.
> Please apply this commit to 4.19.y-rc and 5.0.y-rc.

Thanks, now queued up.

greg k-h
