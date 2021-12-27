Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A41A47FEAD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhL0Pay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbhL0PaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC48B810A2;
        Mon, 27 Dec 2021 15:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4648C36AE7;
        Mon, 27 Dec 2021 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619011;
        bh=JT50CZH9h54tMYdi4kLdq5Xqsz3CSu8kE1ZeECkO7VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hf6SqAktjkNJikoRWYkq9OpTZDS41mSqAfxIW/05gbXQsbUC22Q06cbWNNHz/vWTp
         IcmhwVWhE+xJRBg6I44lKBcy7cjcWi1mGPr4A7lHH5GKX9CJbQToSU+dr9HI633ylG
         wdEWx4fFZx1kJ5jLiqdxspiH5QFMC/E+qSR+Kg3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/29] sfc: falcon: Check null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:27:23 +0100
Message-Id: <20211227151318.901354725@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
index 6a8406dc0c2b4..06f556d373949 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -732,7 +732,10 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
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



