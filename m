Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD95560D7
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFZDtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFZDnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:53 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D9520883;
        Wed, 26 Jun 2019 03:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520633;
        bh=RRF2SmZ25ndOjvk6QjLmzorhtZQ3m2Fth1qQ1Ic4NXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/RfcKL0mv8xcZoYL9jeqJs3SVxnODBvpNT3A0U3sNflbPxnxA9eS282iIeWH7z8E
         LTSqgjD4ucvfovbTnJa6TsV0itJzOhhgIzVEfzDF/uO7OOoLmmHjZXpdDSemEZMhvi
         yna4OzO5PHpEinO5l8mC6PnAmMmd/JHtT7lxVsi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 08/34] drm/mediatek: fix unbind functions
Date:   Tue, 25 Jun 2019 23:43:09 -0400
Message-Id: <20190626034335.23767-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 8fd7a37b191f93737f6280a9b5de65f98acc12c9 ]

detatch panel in mtk_dsi_destroy_conn_enc(), since .bind will try to
attach it again.

Fixes: 2e54c14e310f ("drm/mediatek: Add DSI sub driver")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 66df1b177959..84bb66866631 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -841,6 +841,8 @@ static void mtk_dsi_destroy_conn_enc(struct mtk_dsi *dsi)
 	/* Skip connector cleanup if creation was delegated to the bridge */
 	if (dsi->conn.dev)
 		drm_connector_cleanup(&dsi->conn);
+	if (dsi->panel)
+		drm_panel_detach(dsi->panel);
 }
 
 static void mtk_dsi_ddp_start(struct mtk_ddp_comp *comp)
-- 
2.20.1

