Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD1533B89F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhCOOEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhCOOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A738E64F72;
        Mon, 15 Mar 2021 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816816;
        bh=Gas6jNwe4RZf/YuPzedLbOaoOR2AJwngDVXRdb0fRHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsJ9iTTZBn5c6dS9w0P4IR1zFqYgDsUcDPJa4TqVmfIobM6vY0NcL34L0X72/GOrX
         0cgVEw50GISQYIaqJSIZaLEtn3ZQB/Pj8LgwOedoSPduwbuCQK4DqNZ7PP+FSwCI7/
         szv0l2ub6vDYzIkoayt+TB847bRxjDTy4Z+dFcsA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/290] ath11k: fix AP mode for QCA6390
Date:   Mon, 15 Mar 2021 14:53:43 +0100
Message-Id: <20210315135546.296784144@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kalle Valo <kvalo@codeaurora.org>

[ Upstream commit 77d7e87128d4dfb400df4208b2812160e999c165 ]

Commit c134d1f8c436 ("ath11k: Handle errors if peer creation fails") completely
broke AP mode on QCA6390:

kernel: [  151.230734] ath11k_pci 0000:06:00.0: failed to create peer after vdev start delay: -22
wpa_supplicant[2307]: Failed to set beacon parameters
wpa_supplicant[2307]: Interface initialization failed
wpa_supplicant[2307]: wlan0: interface state UNINITIALIZED->DISABLED
wpa_supplicant[2307]: wlan0: AP-DISABLED
wpa_supplicant[2307]: wlan0: Unable to setup interface.
wpa_supplicant[2307]: Failed to initialize AP interface

This was because commit c134d1f8c436 ("ath11k: Handle errors if peer creation
fails") added error handling for ath11k_peer_create(), which had been failing
all along but was unnoticed due to the missing error handling. The actual bug
was introduced already in commit aa44b2f3ecd4 ("ath11k: start vdev if a bss peer is
already created").

ath11k_peer_create() was failing because for AP mode the peer is created
already earlier op_add_interface() and we should skip creation here, but the
check for modes was wrong.  Fixing that makes AP mode work again.

This shouldn't affect IPQ8074 nor QCN9074 as they have hw_params.vdev_start_delay disabled.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: c134d1f8c436 ("ath11k: Handle errors if peer creation fails")
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1614006849-25764-1-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f3c5023f8a45..ee0edd918560 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5262,8 +5262,8 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	if (ab->hw_params.vdev_start_delay &&
-	    (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
-	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)) {
+	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		param.vdev_id = arvif->vdev_id;
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;
-- 
2.30.1



