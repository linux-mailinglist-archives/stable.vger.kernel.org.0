Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7EC3C53CF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348770AbhGLH4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350696AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9D3061C37;
        Mon, 12 Jul 2021 07:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076039;
        bh=bRA9MO+/azoqErmAuG1xTKjP9xrXDSRYaQe+GYuEIKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToNBlwm/xDg6fRWfBJIAtabBv45Db5qANqQYohZhuhYX7Cd8lS/loZPaYKg78iYYH
         MJkNETkFz+d8rdzyey3C9LYY6G2VbIpjCbdBDCnVEZRFB2OlsxU3ffKctkhuw9xxu3
         CxsMi7xoC9fCmgUsiZmOeVBMFpWcVNVL59qsGYTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seevalamuthu Mariappan <seevalam@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 470/800] ath11k: send beacon template after vdev_start/restart during csa
Date:   Mon, 12 Jul 2021 08:08:13 +0200
Message-Id: <20210712061017.163035485@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seevalamuthu Mariappan <seevalam@codeaurora.org>

[ Upstream commit 979ebc54cf13bd1e3eb6e21766d208d5de984fb8 ]

Firmware has added assert if beacon template is received after
vdev_down. Firmware expects beacon template after vdev_start
and before vdev_up. This change is needed to support MBSSID EMA
cases in firmware.

Hence, Change the sequence in ath11k as expected from firmware.
This new change is not causing any issues with older
firmware.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1.r3-00011-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1.r4-00008-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Seevalamuthu Mariappan <seevalam@codeaurora.org>
[sven@narfation.org: added tested-on/fixes information]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210525133028.2805615-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 9d0ff150ec30..eb52332dbe3f 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5379,11 +5379,6 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 		if (WARN_ON(!arvif->is_up))
 			continue;
 
-		ret = ath11k_mac_setup_bcn_tmpl(arvif);
-		if (ret)
-			ath11k_warn(ab, "failed to update bcn tmpl during csa: %d\n",
-				    ret);
-
 		ret = ath11k_mac_vdev_restart(arvif, &vifs[i].new_ctx->def);
 		if (ret) {
 			ath11k_warn(ab, "failed to restart vdev %d: %d\n",
@@ -5391,6 +5386,11 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 			continue;
 		}
 
+		ret = ath11k_mac_setup_bcn_tmpl(arvif);
+		if (ret)
+			ath11k_warn(ab, "failed to update bcn tmpl during csa: %d\n",
+				    ret);
+
 		ret = ath11k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 					 arvif->bssid);
 		if (ret) {
-- 
2.30.2



