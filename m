Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8090117FE55
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgCJMqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgCJMqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:46:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04AE24695;
        Tue, 10 Mar 2020 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844370;
        bh=zBcaWmOWFsefY4orvoW3vKI4XM4VDFpW+rPtM3jGBuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFh5vt9eFZ7P1uKUv4ExmMKi9FEzHKaZgH9eJrvgmJVHy7oRyXWz266UHMZ/7D/CW
         7AP0lO577hyvrIyfQ4zHq0AetRQLFghgVwecFr2d+NjPhyoj1oINDH09NdLyMw5KT/
         acQe4TgUwaRdswcKmrQi+2MXSFzn5lfTtgLcQBfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harigovindan P <harigovi@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/88] drm/msm/dsi: save pll state before dsi host is powered off
Date:   Tue, 10 Mar 2020 13:39:04 +0100
Message-Id: <20200310123620.058490663@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harigovindan P <harigovi@codeaurora.org>

[ Upstream commit a1028dcfd0dd97884072288d0c8ed7f30399b528 ]

Save pll state before dsi host is powered off. Without this change
some register values gets resetted.

Signed-off-by: Harigovindan P <harigovi@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index 10d49d43c17eb..d46b9e75a8473 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -438,6 +438,7 @@ static void dsi_mgr_bridge_post_disable(struct drm_bridge *bridge)
 	struct msm_dsi *msm_dsi1 = dsi_mgr_get_dsi(DSI_1);
 	struct mipi_dsi_host *host = msm_dsi->host;
 	struct drm_panel *panel = msm_dsi->panel;
+	struct msm_dsi_pll *src_pll;
 	bool is_dual_dsi = IS_DUAL_DSI();
 	int ret;
 
@@ -471,6 +472,10 @@ static void dsi_mgr_bridge_post_disable(struct drm_bridge *bridge)
 								id, ret);
 	}
 
+	/* Save PLL status if it is a clock source */
+	src_pll = msm_dsi_phy_get_pll(msm_dsi->phy);
+	msm_dsi_pll_save_state(src_pll);
+
 	ret = msm_dsi_host_power_off(host);
 	if (ret)
 		pr_err("%s: host %d power off failed,%d\n", __func__, id, ret);
-- 
2.20.1



