Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34CC47FF07
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhL0PfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbhL0PeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3D4C06175A;
        Mon, 27 Dec 2021 07:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAA64610B1;
        Mon, 27 Dec 2021 15:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC2EC36AEA;
        Mon, 27 Dec 2021 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619241;
        bh=ajpn7ygUOWOV9TJpfWpVd+F8alDAjfbT1LNk+RLc7Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2wvj6qK6yX3zrq5Ibu9qgj0OXtMA1zeZCN4e/8PpS2A+pJHKe27lPexhytUMFzL+
         VdJhiC55F0fmMZo+SnfzInzurwj2jTTmhYcmdleN+oC+K6vLZMwqFNTZzuA2QSFNUt
         iLb878INCWkPPZf1rSD4BdMQTB3TYSPTxAiA7FwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/38] sfc: falcon: Check null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:30:56 +0100
Message-Id: <20211227151320.015328013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
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
index 02456ed13a7d4..5b93a3af4575d 100644
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



