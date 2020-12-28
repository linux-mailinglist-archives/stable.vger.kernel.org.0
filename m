Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D0E2E4080
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503796AbgL1OxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441630AbgL1OTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFF122B2C;
        Mon, 28 Dec 2020 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165124;
        bh=9g0/XxWyP3jMlOsB5v6yCEAHuPcYlFakdyDme1xpF90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9Uq+TmgZMFgxJ038nCf9KWDK+conzJRmbihJ36QHuYDcLgRKHaHdr1LsTQ9jDJ07
         2sAycyA7j19PeGEUSmDRVM/KxGdQygIs5pZyt7QOavaRqF1liA2t5UvYcE6dGK8R6b
         5kVEXHDXRAsojnczReBAsj20RqlE03X9b8bJnsGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 421/717] dmaengine: ti: k3-udma: Correct normal channel offset when uchan_cnt is not 0
Date:   Mon, 28 Dec 2020 13:46:59 +0100
Message-Id: <20201228125041.133605068@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit e2de925bbfe321ba0588c99f577c59386ab1f428 ]

According to different sections of the TRM, the hchan_cnt of CAP3 includes
the number of uchan in UDMA, thus the start offset of the normal channels
are hchan_cnt.

Fixes: daf4ad0499aa4 ("dmaengine: ti: k3-udma: Query throughput level information from hardware")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201208090440.31792-2-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 82cf6c77f5c93..d3902784cae24 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3201,8 +3201,7 @@ static int udma_setup_resources(struct udma_dev *ud)
 	} else if (UDMA_CAP3_UCHAN_CNT(cap3)) {
 		ud->tpl_levels = 3;
 		ud->tpl_start_idx[1] = UDMA_CAP3_UCHAN_CNT(cap3);
-		ud->tpl_start_idx[0] = ud->tpl_start_idx[1] +
-				       UDMA_CAP3_HCHAN_CNT(cap3);
+		ud->tpl_start_idx[0] = UDMA_CAP3_HCHAN_CNT(cap3);
 	} else if (UDMA_CAP3_HCHAN_CNT(cap3)) {
 		ud->tpl_levels = 2;
 		ud->tpl_start_idx[0] = UDMA_CAP3_HCHAN_CNT(cap3);
-- 
2.27.0



