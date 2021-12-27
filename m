Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0D448005D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhL0Ppv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238856AbhL0PoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78183C08E84B;
        Mon, 27 Dec 2021 07:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37414B810BF;
        Mon, 27 Dec 2021 15:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80358C36AE7;
        Mon, 27 Dec 2021 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619708;
        bh=AkEmWFKcs775ht6TOIBc5GNczvpZ500dXl7l+wE56Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2laqYIZqx4rNhiV8X5wIkS8GYZBbp7gGBvPP0BiaFw/2TfNpuxBOxvNBYGxYi3F/A
         NVBVKmJzh0g9upfRuCAaXVyjUORte5jR0l3MmEg1ZgeGkqUGB0dRpROG+J/ZOI+9U5
         d2QWCA8DqQksk+HyvtfaS/DfteMiwxWmX2COR9m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/128] sfc: falcon: Check null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:30:16 +0100
Message-Id: <20211227151332.894112627@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9b8bdd1eb5890aeeab7391dddcf8bd51f7b07216 ]

Because of the possible failure of the kcalloc, it should be better to
set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
the consistency.

Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20211220140344.978408-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/falcon/rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 966f13e7475dd..11a6aee852e92 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -728,7 +728,10 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
 					    efx->rx_bufs_per_page);
 	rx_queue->page_ring = kcalloc(page_ring_size,
 				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
-	rx_queue->page_ptr_mask = page_ring_size - 1;
+	if (!rx_queue->page_ring)
+		rx_queue->page_ptr_mask = 0;
+	else
+		rx_queue->page_ptr_mask = page_ring_size - 1;
 }
 
 void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
-- 
2.34.1



