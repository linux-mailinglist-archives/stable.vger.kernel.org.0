Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE54312C7BB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbfL2Rp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfL2Rpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861C2206A4;
        Sun, 29 Dec 2019 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641555;
        bh=cQKQEIL4h1OMi/WgToUi1jM7to2vQzP926WSOjjcE1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5p5LtnmYzgcIMvrjwowxZNtz3QZonTCnzrcNmCFG9dAKwVQnceQaFGGr9ED4eK9R
         x/9GM1aTqGbqu97QmiuwXHLgy2ocJUJ66rAW/i833P1XvxaiweHe/20I8TzmRV7w32
         UDbLHdISidzevC9lPlaoRaRcpJaHfmZPDLyDtaVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/434] mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring
Date:   Sun, 29 Dec 2019 18:22:48 +0100
Message-Id: <20191229172709.320620663@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index eff06d59e9df..096334e941a1 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -687,8 +687,11 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
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



