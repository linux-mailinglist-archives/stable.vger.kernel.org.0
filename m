Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A94BE97C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbiBUJGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:06:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343987AbiBUJEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50632DD70;
        Mon, 21 Feb 2022 00:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C8CB80EBB;
        Mon, 21 Feb 2022 08:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA38C340E9;
        Mon, 21 Feb 2022 08:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433930;
        bh=ww4qvgER5OPZ4qzfq4h55HS9IV8nlvw5JDBb4dbZ2SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpew3xnRZCpT1e3NMO5M5VLZCr9iZmG/UC03ZYnoHzZ4DCAcUq7WaZ0avYFai724t
         ar2pr0ufgZTP6zRnX1KMW3tZvW7T3TrJBHHEy8lhs2n3GoRNp01SmyPw2aGB7tAB+C
         vWmSo+kUAYC3BoJoH/AFYfXwbIEjZNn1WCVIcsp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>,
        Mickael GARDET <m.gardet@overkiz.com>
Subject: [PATCH 5.4 33/80] dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending
Date:   Mon, 21 Feb 2022 09:49:13 +0100
Message-Id: <20220221084916.660763875@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Change-Id: If1bf3e13329cebb9904ae40620f6cf2b7f06fe9f
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Mickael GARDET <m.gardet@overkiz.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1726,11 +1726,13 @@ static irqreturn_t at_xdmac_interrupt(in
 static void at_xdmac_issue_pending(struct dma_chan *chan)
 {
 	struct at_xdmac_chan *atchan = to_at_xdmac_chan(chan);
+	unsigned long flags;
 
 	dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);
 
-	if (!at_xdmac_chan_is_cyclic(atchan))
-		at_xdmac_advance_work(atchan);
+	spin_lock_irqsave(&atchan->lock, flags);
+	at_xdmac_advance_work(atchan);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	return;
 }


