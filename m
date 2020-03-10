Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79BF17FDA4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgCJMwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbgCJMwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B2120674;
        Tue, 10 Mar 2020 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844739;
        bh=hN6a469Tivn8u3TsieBjrDtp/aqNDl1Fq/Mz22z/h+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oohqfemI2TZmaOCoYBag81LyjdZsb7hNy2whuYN6yM77tO5PUfr4NQvlMPrOhuLHS
         1/Dod4PjA1y2U63OlMz01NsSwc179+HGsnCUBxvF+Gv8Z+A2tVEHqtLLcCulJ3S+em
         kVpgW0eDVKg2tQMtgw/rqCYZQ2iCZroFn7L+51Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Fabio Estevam <festevam@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 100/168] dmaengine: imx-sdma: fix context cache
Date:   Tue, 10 Mar 2020 13:39:06 +0100
Message-Id: <20200310123645.512315344@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit d288bddd8374e0a043ac9dde64a1ae6a09411d74 upstream.

There is a DMA problem with the serial ports on i.MX6.

When the following sequence is performed:

1) Open a port
2) Write some data
3) Close the port
4) Open a *different* port
5) Write some data
6) Close the port

The second write sends nothing and the second close hangs.
If the first close() is omitted it works.

Adding logs to the the UART driver shows that the DMA is being setup but
the callback is never invoked for the second write.

This used to work in 4.19.

Git bisect leads to:
	ad0d92d: "dmaengine: imx-sdma: refine to load context only once"

This commit adds a "context_loaded" flag used to avoid unnecessary context
setups.
However the flag is only reset in sdma_channel_terminate_work(),
which is only invoked in a worker triggered by sdma_terminate_all() IF
there is an active descriptor.

So, if no active descriptor remains when the channel is terminated, the
flag is not reset and, when the channel is later reused the old context
is used.

Fix the problem by always resetting the flag in sdma_free_chan_resources().

Cc: stable@vger.kernel.org
Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: ad0d92d7ba6a ("dmaengine: imx-sdma: refine to load context only once")
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-sdma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1335,6 +1335,7 @@ static void sdma_free_chan_resources(str
 
 	sdmac->event_id0 = 0;
 	sdmac->event_id1 = 0;
+	sdmac->context_loaded = false;
 
 	sdma_set_channel_priority(sdmac, 0);
 


