Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73D4996CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354310AbiAXVGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392236AbiAXUuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA303B8105C;
        Mon, 24 Jan 2022 20:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC255C340E5;
        Mon, 24 Jan 2022 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057449;
        bh=W9rtOjKHBw6hBibNcxr0t32NfHgPu+2J1i1+BKiQQuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwiO04yHMLskbLkqfzZd69RPkHgJGP4AHHEFQ6umhTjnh3THRIg9cRRXFsRhAgKRw
         lJVDwbOO4kr/mIQ3xDNqD8kZnURZ0gEaBOlVhFcx1vCaHL8/Wp0FG8NrRVpCgxMBsQ
         f67iPWis4ZTvyBfzNc6Apb4bl/i83mOXB+jAiEVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 816/846] dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending
Date:   Mon, 24 Jan 2022 19:45:33 +0100
Message-Id: <20220124184129.057776609@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a upstream.

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1778,11 +1778,9 @@ static void at_xdmac_issue_pending(struc
 
 	dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);
 
-	if (!at_xdmac_chan_is_cyclic(atchan)) {
-		spin_lock_irqsave(&atchan->lock, flags);
-		at_xdmac_advance_work(atchan);
-		spin_unlock_irqrestore(&atchan->lock, flags);
-	}
+	spin_lock_irqsave(&atchan->lock, flags);
+	at_xdmac_advance_work(atchan);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	return;
 }


