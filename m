Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2B029C2D6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369225AbgJ0Rke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902437AbgJ0OdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8132C20709;
        Tue, 27 Oct 2020 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809200;
        bh=ftXuAqiT+3LxPSTuRGNFhG7x62H/dfz1NXAzJSc4A+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsQwltHu/iCdo1LpESbjoXCAoHSCNCQEObGYjVbxFEh5HwZ0ZB1GRqpyNPzNEme+b
         5MspM2LYaueEIhjDP8yT6sNY98EIxNPshLnrEZTuYnUUhguHjq0o1y0ErUK+I49yoe
         aXvax6U88U2uqopUPk9KT4b8q9SSnxvSgwndEHNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/408] ath10k: Fix the size used in a dma_free_coherent() call in an error handling path
Date:   Tue, 27 Oct 2020 14:50:48 +0100
Message-Id: <20201027135500.196170656@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index eca87f7c5b6c1..01e05af5ae085 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1555,7 +1555,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
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



