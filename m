Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C8516AC64
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 17:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgBXQ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 11:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbgBXQ55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 11:57:57 -0500
Received: from localhost (unknown [122.182.199.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D8E720836;
        Mon, 24 Feb 2020 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582563476;
        bh=/1bbEbIQcOxdlPPRg6xaUyuKQtDYNCF5hHOF4bi9Dvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSIX1bCxbpk+2AJam2QywGeWlRX7OxLdOc3qL45tSA1QX24QoNZL0tomMGZHpGM7U
         Qj360wozS445bx4ySv6JlYcQH9rp+Dqs6e45ssdEkA6fJ7ZxSPNw++9qtgXSG/Bi2w
         RRR5AbGfS7xFkUkGKe8pxQz05FGdm9WvBtMw/rQA=
Date:   Mon, 24 Feb 2020 22:27:52 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        dmaengine@vger.kernel.org, stable <stable@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: imx-sdma: fix context cache
Message-ID: <20200224165752.GE2618@vkoul-mobl>
References: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
 <CAOMZO5AFJvEdWNSsnsRW70_M6rzyvO4ip3zJHET2Gc2Wzj5RPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AFJvEdWNSsnsRW70_M6rzyvO4ip3zJHET2Gc2Wzj5RPQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29-01-20, 17:19, Fabio Estevam wrote:
> Hi Martin,
> 
> Thanks for the fix.
> 
> On Wed, Jan 29, 2020 at 10:41 AM Martin Fuzzey
> <martin.fuzzey@flowbird.group> wrote:
> >
> > There is a DMA problem with the serial ports on i.MX6.
> >
> > When the following sequence is performed:
> >
> > 1) Open a port
> > 2) Write some data
> > 3) Close the port
> > 4) Open a *different* port
> > 5) Write some data
> > 6) Close the port
> >
> > The second write sends nothing and the second close hangs.
> > If the first close() is omitted it works.
> >
> > Adding logs to the the UART driver shows that the DMA is being setup but
> > the callback is never invoked for the second write.
> >
> > This used to work in 4.19.
> >
> > Git bisect leads to:
> >         ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
> >
> > This commit adds a "context_loaded" flag used to avoid unnecessary context
> > setups.
> > However the flag is only reset in sdma_channel_terminate_work(),
> > which is only invoked in a worker triggered by sdma_terminate_all() IF
> > there is an active descriptor.
> >
> > So, if no active descriptor remains when the channel is terminated, the
> > flag is not reset and, when the channel is later reused the old context
> > is used.
> >
> > Fix the problem by always resetting the flag in sdma_free_chan_resources().
> >
> > Fixes: ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
> 
> Nit: in the Fixes tag we use 12 digits for the commit ID and the
> Subject is enclosed by parenthesis.
> 
> The preferred format would be:
> 
> Fixes: ad0d92d7ba6a ("dmaengine: imx-sdma: refine to load context only once")
> 
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Applied, with updated Fixes line. Thanks

-- 
~Vinod
