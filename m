Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2D6228D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388895AbfGHP0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388894AbfGHP0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F197204EC;
        Mon,  8 Jul 2019 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599603;
        bh=+gFVRr86ErgIQRpn1WpAzQvjmSHwfo1Pg6mSX4tjJO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6qg60u8vQPQ9Q44PpRH7sjbKJBysbwfWaEoijogUE0BpqZ3zkd3vZlaP6Urrxmg+
         89q4li7rOiPyH0PTLpKagC6QUMBL6uscwJNvSchNadIW+HA/e7uvRLVprnFMaKv2js
         HRhzw4aXU/LYH6CgauLV0lXrFcIxZkzBn2TbS0UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/90] drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver
Date:   Mon,  8 Jul 2019 17:12:42 +0200
Message-Id: <20190708150523.396436840@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index bbe57ad9acf1..3df8a9dbccfe 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -310,6 +310,7 @@ err_config_cleanup:
 static void mtk_drm_kms_deinit(struct drm_device *drm)
 {
 	drm_kms_helper_poll_fini(drm);
+	drm_atomic_helper_shutdown(drm);
 
 	component_unbind_all(drm->dev, drm);
 	drm_mode_config_cleanup(drm);
-- 
2.20.1



