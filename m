Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8734CA78
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhC2Iim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234669AbhC2IhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D6D61879;
        Mon, 29 Mar 2021 08:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006975;
        bh=EMBZbY3/Y3S2d7LVj2c6aS1/lml6GJVQZIgkqBQYo4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1jKRewkfTUhjjZyi6GCG8pDOyMXa9BhWwaibORP1ogSIx3Xn3VUS4gqxDI8LOy8O
         mfu3oClLa21wexVYgQkdGW6H6t6gJAlFwom9YMeMApKLSOQ6CZvn4Ijc6RNynJLZT4
         OrQTfqxUqHLhF5JS0titWzHtiqt1y2JsTZlxUAjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 175/254] octeontx2-af: Fix irq free in rvu teardown
Date:   Mon, 29 Mar 2021 09:58:11 +0200
Message-Id: <20210329075638.909990514@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit ae2619dd4fccdad9876aa5f900bd85484179c50f ]

Current devlink code try to free already freed irqs as the
irq_allocate flag is not cleared after free leading to kernel
crash while removing rvu driver. The patch fixes the irq free
sequence and clears the irq_allocate flag on free.

Fixes: 7304ac4567bc ("octeontx2-af: Add mailbox IRQ and msg handlers")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8fd712860a1..e3fc6d1c0ec3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2358,8 +2358,10 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
 
 	for (irq = 0; irq < rvu->num_vec; irq++) {
-		if (rvu->irq_allocated[irq])
+		if (rvu->irq_allocated[irq]) {
 			free_irq(pci_irq_vector(rvu->pdev, irq), rvu);
+			rvu->irq_allocated[irq] = false;
+		}
 	}
 
 	pci_free_irq_vectors(rvu->pdev);
@@ -2873,8 +2875,8 @@ static void rvu_remove(struct pci_dev *pdev)
 	struct rvu *rvu = pci_get_drvdata(pdev);
 
 	rvu_dbg_exit(rvu);
-	rvu_unregister_interrupts(rvu);
 	rvu_unregister_dl(rvu);
+	rvu_unregister_interrupts(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
-- 
2.30.1



