Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7215BB7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfEGF4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfEGFhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F5B20675;
        Tue,  7 May 2019 05:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207467;
        bh=rwX0tiC2cPttjHpQiUo5GVwYjA875W49HkVs9nxYQ3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iz7h105VJ5kXKxgegd2X5zCtYFHZ4vc4W3RS2Nmpt9x242DNy/S1pCIuhORtGrAkH
         3Xy+gTmsZZc42dfOuUyezjIaKY3skRMYVtqt/ehOWElcVuRZlWjKLaPel0lOf3sqsU
         WNKPBZ+WKXtLogbv90HB/k9SOCNBvbBsMOj0p0Go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 59/81] drm/sun4i: Unbind components before releasing DRM and memory
Date:   Tue,  7 May 2019 01:35:30 -0400
Message-Id: <20190507053554.30848-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit e02bc29b2cfa7806830d6da8b2322cddd67e8dfe ]

Our components may still be using the DRM device driver (if only to
access our driver's private data), so make sure to unbind them before
the final drm_dev_put.

Also release our reserved memory after component unbind instead of
before to match reverse creation order.

Fixes: f5a9ed867c83 ("drm/sun4i: Fix component unbinding and component master deletion")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190424090413.6918-1-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 62703630090a..57f61ec4bc6b 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -158,10 +158,11 @@ static void sun4i_drv_unbind(struct device *dev)
 	drm_kms_helper_poll_fini(drm);
 	sun4i_framebuffer_free(drm);
 	drm_mode_config_cleanup(drm);
-	of_reserved_mem_device_release(dev);
-	drm_dev_put(drm);
 
 	component_unbind_all(dev, NULL);
+	of_reserved_mem_device_release(dev);
+
+	drm_dev_put(drm);
 }
 
 static const struct component_master_ops sun4i_drv_master_ops = {
-- 
2.20.1

