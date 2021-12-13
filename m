Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE1472EA5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhLMOSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:18:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34218 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhLMOSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:18:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B18CEB81062;
        Mon, 13 Dec 2021 14:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CBEC34602;
        Mon, 13 Dec 2021 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639405094;
        bh=NtWdzlEjft5tnQeFaBXUVrmubHd8T7HRkrRLfS+HxKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ef4dtFt35n0BNeZHb5cwHF2nWR84NPJ4B4Ej+DcAmvR7/HzogwktH/W/meMnZnx1/
         Xg3O6A+RredIYQtKTQ5Xmko6sTk52Ckx/QDevDNiQkd9m6eeVOhNiVRfdPIU5wthcz
         kslBCgGFDpF4EoLzXiuVfEO/wBb1eXc3RIOJDVQs=
Date:   Mon, 13 Dec 2021 15:18:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Yuwen Ng <yuwen.ng@mediatek.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: mtu3: add memory barrier before set GPD's HWO
Message-ID: <YbdWI5PD3e6uFz8U@kroah.com>
References: <20211209031424.17842-1-chunfeng.yun@mediatek.com>
 <20211209031424.17842-2-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209031424.17842-2-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 11:14:23AM +0800, Chunfeng Yun wrote:
> There is a seldom issue that the controller access invalid address
> and trigger devapc or emimpu violation. That is due to memory access
> is out of order and cause gpd data is not correct.
> Make sure GPD is fully written before giving it to HW by setting its
> HWO.
> 
> Fixes: 48e0d3735aa5 ("usb: mtu3: supports new QMU format")
> Cc: stable@vger.kernel.org
> Reported-by: Eddie Hung <eddie.hung@mediatek.com>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
>  drivers/usb/mtu3/mtu3_qmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/mtu3/mtu3_qmu.c b/drivers/usb/mtu3/mtu3_qmu.c
> index 3f414f91b589..34bb5ac67efe 100644
> --- a/drivers/usb/mtu3/mtu3_qmu.c
> +++ b/drivers/usb/mtu3/mtu3_qmu.c
> @@ -273,6 +273,8 @@ static int mtu3_prepare_tx_gpd(struct mtu3_ep *mep, struct mtu3_request *mreq)
>  			gpd->dw3_info |= cpu_to_le32(GPD_EXT_FLAG_ZLP);
>  	}
>  
> +	/* make sure GPD is fully written before giving it to HW */
> +	mb();

So this means you are using mmio for this structure?  If so, shouldn't
you be using normal io memory read/write calls as well and not just
"raw" pointers like this:

>  	gpd->dw0_info |= cpu_to_le32(GPD_FLAGS_IOC | GPD_FLAGS_HWO);

Are you sure this is ok?

Sprinkling around mb() calls is almost never the correct solution.

If you need to ensure that a write succeeds, shouldn't you do a read
from it afterward?  Many busses require this, doesn't yours?



>  
>  	mreq->gpd = gpd;
> @@ -306,6 +308,8 @@ static int mtu3_prepare_rx_gpd(struct mtu3_ep *mep, struct mtu3_request *mreq)
>  	gpd->next_gpd = cpu_to_le32(lower_32_bits(enq_dma));
>  	ext_addr |= GPD_EXT_NGP(mtu, upper_32_bits(enq_dma));
>  	gpd->dw3_info = cpu_to_le32(ext_addr);
> +	/* make sure GPD is fully written before giving it to HW */
> +	mb();

Again, mb(); does not ensure that memory-mapped i/o actually hits the
HW.  Or if it does on your platform, how?

mb() is a compiler barrier, not a memory write to a bus barrier.  Please
read Documentation/memory-barriers.txt for more details.

thanks,

greg k-h
