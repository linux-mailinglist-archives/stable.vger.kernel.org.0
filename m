Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A7312EF14
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgABWee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgABWee (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10A722314;
        Thu,  2 Jan 2020 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004473;
        bh=BloFgXpPaLhMZbOca3zw/Acezw0jJYPeAReQ1OWmrlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqhvwJSpZz6NapTPVKI+y/9YCHNMJEkNRmMFZyvT8fKFOhtwDJ3KSBneKMFeehEtH
         2HJF4Iv1OsV1h5nZJCKXAT5no+DMsPAB57KvlVjo+lUj94gsiI7C432K4qbo8OLyjZ
         pF0G0A162tM7hjHxzrHE+UoUFvYBTbeQq9Of2qTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 021/137] mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring
Date:   Thu,  2 Jan 2020 23:06:34 +0100
Message-Id: <20200102220549.534498494@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit d10dcb615c8e29d403a24d35f8310a7a53e3050c ]

In mwifiex_pcie_init_evt_ring, a new skb is allocated which should be
released if mwifiex_map_pci_memory() fails. The release for skb and
card->evtbd_ring_vbase is added.

Fixes: 0732484b47b5 ("mwifiex: separate ring initialization and ring creation routines")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwifiex/pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 268e50ba88a5..4c0a65692899 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -577,8 +577,11 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		skb_put(skb, MAX_EVENT_SIZE);
 
 		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
-					   PCI_DMA_FROMDEVICE))
+					   PCI_DMA_FROMDEVICE)) {
+			kfree_skb(skb);
+			kfree(card->evtbd_ring_vbase);
 			return -1;
+		}
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
-- 
2.20.1



