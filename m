Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5441212A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357074AbhITSCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350727AbhITSAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3DE263227;
        Mon, 20 Sep 2021 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158154;
        bh=nZa1LrpL0x/o1GYvWiwkzvbZzI6NCmZVHmx29e7yE/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlgcKDyQM2pH/MgShaJEqBfMnOn+9l+0LOamj2ZcJeB8U3GYItOPVTe6mR0jsvNKb
         KvrEutDniIyBjp6CgHKfQrEAESCGfAfMOud6QTPL+EK4A5McmyP96guL/YgIG4hUCH
         mB9GSS7kwuYDejQ5jktNyEP6hIfjIl4XmR+pCu68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Vinod Koul <vkoul@kernel.org>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 026/260] dmaengine: imx-sdma: remove duplicated sdma_load_context
Date:   Mon, 20 Sep 2021 18:40:44 +0200
Message-Id: <20210920163932.014958342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

commit e555a03b112838883fdd8185d613c35d043732f2 upstream.

Since sdma_transfer_init() will do sdma_load_context before any
sdma transfer, no need once more in sdma_config_channel().

Fixes: ad0d92d7ba6a ("dmaengine: imx-sdma: refine to load context only once")
Cc: <stable@vger.kernel.org>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/imx-sdma.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1134,7 +1134,6 @@ static void sdma_set_watermarklevel_for_
 static int sdma_config_channel(struct dma_chan *chan)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
-	int ret;
 
 	sdma_disable_channel(chan);
 
@@ -1174,9 +1173,7 @@ static int sdma_config_channel(struct dm
 		sdmac->watermark_level = 0; /* FIXME: M3_BASE_ADDRESS */
 	}
 
-	ret = sdma_load_context(sdmac);
-
-	return ret;
+	return 0;
 }
 
 static int sdma_set_channel_priority(struct sdma_channel *sdmac,


