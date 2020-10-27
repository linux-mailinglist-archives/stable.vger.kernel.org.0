Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A9729C505
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824081AbgJ0SCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901157AbgJ0OTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:19:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B964206D4;
        Tue, 27 Oct 2020 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808382;
        bh=fIbukp3m2QveeUORO/IMEMaUQMhydI4UAjf0A0KrCkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhEwF3REe+m4I73u9Ra8XUsHODRCR2U5qis8wN0hO27s4zdF1nxfLgKrsjARlLqS7
         LBtM+n11YCE2q4ZdP+fZNdHq549fpSlO0I2KMRXq7Qj3G6yU6BR8ohLR5VmzYisBB0
         SWtDFM7y5OyMlkSaFVa8hbO/FhiOGZIcQtu2u8R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/264] ath10k: Fix the size used in a dma_free_coherent() call in an error handling path
Date:   Tue, 27 Oct 2020 14:52:08 +0100
Message-Id: <20201027135433.982495148@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 454530a9950b5a26d4998908249564cedfc4babc ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

Fixes: 1863008369ae ("ath10k: fix shadow register implementation for WCN3990")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200802122227.678637-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f761d651c16e7..2276d608bca35 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1453,7 +1453,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
 		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
 		if (ret) {
 			dma_free_coherent(ar->dev,
-					  (nentries * sizeof(struct ce_desc_64) +
+					  (nentries * sizeof(struct ce_desc) +
 					   CE_DESC_RING_ALIGN),
 					  src_ring->base_addr_owner_space_unaligned,
 					  base_addr);
-- 
2.25.1



