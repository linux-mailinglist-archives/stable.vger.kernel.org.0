Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEE247FF65
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhL0PhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:37:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbhL0PgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FC06610B1;
        Mon, 27 Dec 2021 15:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0582C36AEA;
        Mon, 27 Dec 2021 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619370;
        bh=O2UTWx2KI3xyqj7JvOxmQMijVDx8u+L4RZ44geKdLEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVK6IwaCtkRfbiE2IbDGArLG33/vV07VM8Yt/EF+6Qv3CRhHhKG7WcrYyPCqnfzqO
         0syh7xZnqi91qcOHDrjjdZCyj0hlP5RB7zvxlIL/RWemeqFLhqDxrIfShC8lW3oE+3
         GeczjkA56Z6WD07mTz/8DaBN2Mazf4N+GlGWnzFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/47] sfc: falcon: Check null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:30:51 +0100
Message-Id: <20211227151321.315563175@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
index 05ea3523890a9..d516f81ab37a7 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -726,7 +726,10 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
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



