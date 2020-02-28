Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADC17379F
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgB1MwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 07:52:03 -0500
Received: from mail1.skidata.com ([91.230.2.99]:63410 "EHLO mail1.skidata.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgB1MwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 07:52:02 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 07:52:01 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skidata.com; i=@skidata.com; q=dns/txt; s=selector1;
  t=1582894322; x=1614430322;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g/fumDPqX7LPA3wXxiP1dS805jxlDQnX8YtVKUMeu98=;
  b=LjZqGN6QzHklV6YiFhSqYetNYrYn8bjM9JqpeNng0UnezFAhpXrmWHu6
   BR00jGPg9M60QK0/3c53EzQOl7pviMJdWbMhtV1RDFZs69ZXSb4gZ+UDZ
   IyrcsN3YS6f4pUHcYIELYAAq/4/6UTFyooVHfu7+gjezTQWvplbXIli2R
   py2/kIf5QaLbO1V2Ok9xocu3wrSp+nVMjS26vrQaAq4tDeZRwzF3l8lIO
   sueyrPpHw9mXayIKPTd3Xf2iQFx1LQdN59MY/dl6ZPiibZ5AnKGYKOHpB
   +yGbuGGoZX9QySvs52yvAk7TcMOomPxGMwzFvcxlXRqyJyDv8jBLn07Q9
   Q==;
IronPort-SDR: 08BFDbudq1MaMeOSQQ+Gr+tpOdBaghZBiTJoclI9zpC7I1cY4eavjFCRIGYIm6UxiXKZiGbpCh
 5nEss8HtL7INBEMdm9q0dm9ZdiGzxuQDeYYNUGresM574MXNUjSs40GfPn4EeZDM61hp230D75
 kp96qCOjdjvkfVtBPmqGyuBgtjq0aNsJOeLu5Dr+3VPNJYAVB4gZHbebABmkrTYdW2swMKek1c
 nrh19pKH2WaOn+Wxg3inHxnCqCBpPIPzAUyWogmBvnV0OAWuSWAmjfATc078ZFTvTr/SskG9i6
 Q80=
X-IronPort-AV: E=Sophos;i="5.70,496,1574118000"; 
   d="scan'208";a="22939519"
Date:   Fri, 28 Feb 2020 13:44:48 +0100
From:   Richard Leitner <richard.leitner@skidata.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
CC:     <dmaengine@vger.kernel.org>, <stable@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: imx-sdma: fix context cache
Message-ID: <20200228124448.GA1689606@pcleri>
References: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
X-Originating-IP: [192.168.111.252]
X-ClientProxiedBy: sdex3srv.skidata.net (192.168.111.81) To
 sdex5srv.skidata.net (192.168.111.83)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Jan 29, 2020 at 02:40:06PM +0100, Martin Fuzzey wrote:
> There is a DMA problem with the serial ports on i.MX6.
> 
> When the following sequence is performed:
> 
> 1) Open a port
> 2) Write some data
> 3) Close the port
> 4) Open a *different* port
> 5) Write some data
> 6) Close the port
> 
> The second write sends nothing and the second close hangs.
> If the first close() is omitted it works.
> 
> Adding logs to the the UART driver shows that the DMA is being setup but
> the callback is never invoked for the second write.
> 
> This used to work in 4.19.
> 
> Git bisect leads to:
> 	ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
> 
> This commit adds a "context_loaded" flag used to avoid unnecessary context
> setups.
> However the flag is only reset in sdma_channel_terminate_work(),
> which is only invoked in a worker triggered by sdma_terminate_all() IF
> there is an active descriptor.
> 
> So, if no active descriptor remains when the channel is terminated, the
> flag is not reset and, when the channel is later reused the old context
> is used.
> 
> Fix the problem by always resetting the flag in sdma_free_chan_resources().
> 
> Fixes: ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> 

Thanks for the patch!
We were chasing this issue for days and just found your patch as we were
preparing our (quite similar) solution for submission ;-)

I've successfully tested your patch on a custom i.MX6Solo board.
Therefore feel free to add

Tested-by: Richard Leitner <richard.leitner@skidata.com>

regards;rl
