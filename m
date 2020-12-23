Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AED2E13C9
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgLWCez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730307AbgLWCYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA4223331;
        Wed, 23 Dec 2020 02:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690270;
        bh=Ait/CLw5riTXXa0Of3dKHdg8gYmyCiXpDaJ1mESEnQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALbPt1harAorh2awbMKNklDOTIOzk8+WvxqO6lATusJLG5qZW6KzH7PUZ9UWZ7h3B
         /6Ih7xvlbtfOb5sQcQddvBRCQT/WJIjVpzlF4SO9Pi+vzEu4KE8hlig/4NlUQdiDbE
         utBhr0ZE6VqzBYIXzXPL0F1E4VuLxCP1i47A5vBaXn+Tf4H2cn9TtX3IsNNLsXyPlU
         AoZ/BHIDb16dYCfldueV7MXgBVuTdPRyvXqJ0NF9Ia2du07IMIG8Tlx0TkRQsYsVvY
         1bQNbCHjF1t4cxn2dqYWcFGaq73KTBfwBjvN+OPH4y3L5AcCB9eZPrhNouapNO7P36
         LM3GJjnerw63w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 11/48] drm: panel: simple: add missing platform_driver_unregister() in panel_simple_init
Date:   Tue, 22 Dec 2020 21:23:39 -0500
Message-Id: <20201223022417.2794032-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit f2e66f212a9de04afc2caa5ec79057c0ac75c728 ]

Add the missing platform_driver_unregister() before return
from panel_simple_init in the error handling case when failed
to register panel_simple_dsi_driver with CONFIG_DRM_MIPI_DSI
enabled.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201031011856.137307-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 57f32d1bb3127..05ca6c8a660e4 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1990,8 +1990,10 @@ static int __init panel_simple_init(void)
 
 	if (IS_ENABLED(CONFIG_DRM_MIPI_DSI)) {
 		err = mipi_dsi_driver_register(&panel_simple_dsi_driver);
-		if (err < 0)
+		if (err < 0) {
+			platform_driver_unregister(&panel_simple_platform_driver);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.27.0

