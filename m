Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133EF34C78B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhC2IQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232909AbhC2IOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C546197C;
        Mon, 29 Mar 2021 08:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005682;
        bh=PFAR71ApAipVIRFCKTxsrNIFKtTz2IBiMHiedbE2pVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwBqaBRYYwulAYxpuFSXYl46rnolVmlY+oxgKs0WcKRlpQxMAi8USGoZqKH5u6hKR
         w8JSTV4xWiHUfnKSlfnX18kk5LsJc2DJcq+vCHejkwYtlliQyu6jGMmO/ISBWSMziK
         cykMPVgvhvVVr2q2GIiAb4EMip7ZrzJRIOhdIrxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/111] octeontx2-af: Fix irq free in rvu teardown
Date:   Mon, 29 Mar 2021 09:58:28 +0200
Message-Id: <20210329075617.879824341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e581091c09c4..02b4620f7368 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1980,8 +1980,10 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
 
 	for (irq = 0; irq < rvu->num_vec; irq++) {
-		if (rvu->irq_allocated[irq])
+		if (rvu->irq_allocated[irq]) {
 			free_irq(pci_irq_vector(rvu->pdev, irq), rvu);
+			rvu->irq_allocated[irq] = false;
+		}
 	}
 
 	pci_free_irq_vectors(rvu->pdev);
-- 
2.30.1



