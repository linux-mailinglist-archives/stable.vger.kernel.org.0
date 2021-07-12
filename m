Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2083C4E09
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbhGLHQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243313AbhGLHPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E970661407;
        Mon, 12 Jul 2021 07:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073923;
        bh=vxxzwghUPvKWL6mkxNTfK5I1Ix+Oc8iWfuFb8y6GI/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMpfHCZiJZNaCETdcPOc07azH70xR6n9E4OnofH655MgWEHKkSSamQhLq2SXuYom9
         r1lt1y8VbaUB6T6eJnWiaY1tlJBraKB9d53+5E9qRPxuQMCLWV6GD/0cSY+kN1lDM+
         Ey4XOGqY2tIGWPgsMC2nMV+iWcgPtoouZKdVwPXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 406/700] wcn36xx: Move hal_buf allocation to devm_kmalloc in probe
Date:   Mon, 12 Jul 2021 08:08:09 +0200
Message-Id: <20210712061019.570346768@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit ef48667557c53d4b51a1ee3090eab7699324c9de ]

Right now wcn->hal_buf is allocated in wcn36xx_start(). This is a problem
since we should have setup all of the buffers we required by the time
ieee80211_register_hw() is called.

struct ieee80211_ops callbacks may run prior to mac_start() and therefore
wcn->hal_buf must be initialized.

This is easily remediated by moving the allocation to probe() taking the
opportunity to tidy up freeing memory by using devm_kmalloc().

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210605173347.2266003-1-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index afb4877eaad8..dabed4e3ca45 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -293,23 +293,16 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 		goto out_free_dxe_pool;
 	}
 
-	wcn->hal_buf = kmalloc(WCN36XX_HAL_BUF_SIZE, GFP_KERNEL);
-	if (!wcn->hal_buf) {
-		wcn36xx_err("Failed to allocate smd buf\n");
-		ret = -ENOMEM;
-		goto out_free_dxe_ctl;
-	}
-
 	ret = wcn36xx_smd_load_nv(wcn);
 	if (ret) {
 		wcn36xx_err("Failed to push NV to chip\n");
-		goto out_free_smd_buf;
+		goto out_free_dxe_ctl;
 	}
 
 	ret = wcn36xx_smd_start(wcn);
 	if (ret) {
 		wcn36xx_err("Failed to start chip\n");
-		goto out_free_smd_buf;
+		goto out_free_dxe_ctl;
 	}
 
 	if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
@@ -336,8 +329,6 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 
 out_smd_stop:
 	wcn36xx_smd_stop(wcn);
-out_free_smd_buf:
-	kfree(wcn->hal_buf);
 out_free_dxe_ctl:
 	wcn36xx_dxe_free_ctl_blks(wcn);
 out_free_dxe_pool:
@@ -372,8 +363,6 @@ static void wcn36xx_stop(struct ieee80211_hw *hw)
 
 	wcn36xx_dxe_free_mem_pools(wcn);
 	wcn36xx_dxe_free_ctl_blks(wcn);
-
-	kfree(wcn->hal_buf);
 }
 
 static void wcn36xx_change_ps(struct wcn36xx *wcn, bool enable)
@@ -1401,6 +1390,12 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	mutex_init(&wcn->hal_mutex);
 	mutex_init(&wcn->scan_lock);
 
+	wcn->hal_buf = devm_kmalloc(wcn->dev, WCN36XX_HAL_BUF_SIZE, GFP_KERNEL);
+	if (!wcn->hal_buf) {
+		ret = -ENOMEM;
+		goto out_wq;
+	}
+
 	ret = dma_set_mask_and_coherent(wcn->dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
 		wcn36xx_err("failed to set DMA mask: %d\n", ret);
-- 
2.30.2



