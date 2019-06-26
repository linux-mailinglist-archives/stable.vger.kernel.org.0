Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3CF55FC2
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfFZDl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfFZDl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:59 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC3CE216FD;
        Wed, 26 Jun 2019 03:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520518;
        bh=0T6x30Mb7rcEkAoYggXrp5pmG6ocNITkX5Dryxz2IyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqNgzF21gYwkcQbLGssTPjF8mTYdjfMEDekWUj6X0lX1P+l+9+j8YQ7NNxMzyecQ4
         GZCo0pmEyYJ6XIdV1np2+skbzSJJLnoh5sAZtZZ1OjkOZ1U1psTHoXktnXMeTQmSUS
         XZWpHGfGFE31Da2GQ3K5weaKbwHOW1GfO34gbWfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 17/51] drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver
Date:   Tue, 25 Jun 2019 23:40:33 -0400
Message-Id: <20190626034117.23247-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit cf49b24ffa62766f8f04cd1c4cf17b75d29b240a ]

shutdown all CRTC when unbinding drm driver.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index e7362bdafa82..8718d123ccaa 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -311,6 +311,7 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 static void mtk_drm_kms_deinit(struct drm_device *drm)
 {
 	drm_kms_helper_poll_fini(drm);
+	drm_atomic_helper_shutdown(drm);
 
 	component_unbind_all(drm->dev, drm);
 	drm_mode_config_cleanup(drm);
-- 
2.20.1

