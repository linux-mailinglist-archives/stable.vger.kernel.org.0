Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79ADC560AF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfFZDoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfFZDn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:59 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8231020883;
        Wed, 26 Jun 2019 03:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520639;
        bh=jR+4A1dwMOdo0F/s8t4BNQ1CilH+GXDKBG8569YINPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPqq6y8Z9KMBkyrPHLdY/0kQpYXXSxfN4b32NlZQ/KxrwJO64nH1T6k5/XLmMNx1u
         fq9mZx5ngIDrVrBIh3CZyUYvrxKNB51eOWGiiwXq/Iav441hHsR2fQcj60DU8dH5no
         Txns8/7kun7nBWelcgdHzyZOQol1wycKBDl9eIYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 11/34] drm/mediatek: clear num_pipes when unbind driver
Date:   Tue, 25 Jun 2019 23:43:12 -0400
Message-Id: <20190626034335.23767-11-sashal@kernel.org>
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

[ Upstream commit a4cd1d2b016d5d043ab2c4b9c4ec50a5805f5396 ]

num_pipes is used for mutex created in mtk_drm_crtc_create(). If we
don't clear num_pipes count, when rebinding driver, the count will
be accumulated. From mtk_disp_mutex_get(), there can only be at most
10 mutex id. Clear this number so it starts from 0 in every rebind.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 3df8a9dbccfe..fd83046d8376 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -393,6 +393,7 @@ static void mtk_drm_unbind(struct device *dev)
 	drm_dev_unregister(private->drm);
 	mtk_drm_kms_deinit(private->drm);
 	drm_dev_put(private->drm);
+	private->num_pipes = 0;
 	private->drm = NULL;
 }
 
-- 
2.20.1

