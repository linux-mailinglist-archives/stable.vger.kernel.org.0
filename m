Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C860D1013CE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKSF1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfKSF1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C3BD21783;
        Tue, 19 Nov 2019 05:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141251;
        bh=dcjRh652H+XEuWKwLgX9wdRsjFVakecNt9ObboueuPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKso55oIC5x9oQNaSmDllmUR0a0u/lRkwFLkYZGb/LS7D+9KhrHSJZOl3YHx7UdeM
         SM8nOw+fCpdGOEyuUD6Bu0A+vSx7OSnme0BlD/LUKi9y7BrjX/RX4BOjSUkQlgN8j/
         3CYKQrtPzoEXooAKvQ2WboxajiLQp2/Z0/E4KTgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/422] wil6210: set edma variables only for Talyn-MB devices
Date:   Tue, 19 Nov 2019 06:14:15 +0100
Message-Id: <20191119051403.513925406@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 596bdbcce90fa93f43ebcb99cefea34bd2e27707 ]

use_rx_hw_reordering is already set to true in wil_set_capabilities
for Talyn-MB devices. Remove its setting from wil_priv_init to
prevent its activation for older chips.
Similarly, move the setting of use_compressed_rx_status to
wil_set_capabilities.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c     | 2 --
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a0fe8cbad104f..d186b6886c6bf 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -653,8 +653,6 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	/* edma configuration can be updated via debugfs before allocation */
 	wil->num_rx_status_rings = WIL_DEFAULT_NUM_RX_STATUS_RINGS;
-	wil->use_compressed_rx_status = true;
-	wil->use_rx_hw_reordering = true;
 	wil->tx_status_ring_order = WIL_TX_SRING_SIZE_ORDER_DEFAULT;
 
 	/* Rx status ring size should be bigger than the number of RX buffers
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 89119e7facd00..c8c6613371d1b 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -108,6 +108,7 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 		set_bit(hw_capa_no_flash, wil->hw_capa);
 		wil->use_enhanced_dma_hw = true;
 		wil->use_rx_hw_reordering = true;
+		wil->use_compressed_rx_status = true;
 		wil_fw_name = ftm_mode ? WIL_FW_NAME_FTM_TALYN :
 			      WIL_FW_NAME_TALYN;
 		if (wil_fw_verify_file_exists(wil, wil_fw_name))
-- 
2.20.1



