Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5618499B9B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575085AbiAXVvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60674 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349038AbiAXVnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4339860917;
        Mon, 24 Jan 2022 21:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB4C340E5;
        Mon, 24 Jan 2022 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060580;
        bh=W9rtOjKHBw6hBibNcxr0t32NfHgPu+2J1i1+BKiQQuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1ppR6Wsoy4+tyxR47st3tirPug++TBtgLgCEbmYw12aJ/pIcq2pjSgPM36O/fn/O
         epsIq53vQRira/9xAJNGM2pEhHgdezcY39OIGzi6lPbggaAsHTlD/JE49gFagbV18z
         1hPenuWWy2ce6eu6h6A9DJJ6pPJOYFNxhWGtANYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.16 0995/1039] dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending
Date:   Mon, 24 Jan 2022 19:46:24 +0100
Message-Id: <20220124184158.736305404@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


