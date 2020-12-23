Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2318F2E15AD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgLWCvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbgLWCVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AF0022AAF;
        Wed, 23 Dec 2020 02:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690084;
        bh=JpzsYhIPc2i3ZBFtNNF+yl5CNLwXZPL8pbU13R4GHhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg5+ZrMF04a4y/riE0TM68cIGIYNfgaE7BkUbiFN7BLEeb7P2D2ZbuxpDsruBhpFN
         2DINZFv68rx2iZwmcc/VoInE8k1htiHaJ2JZ3khT/C1B0wV9elFByBIb0OzMTkQUJT
         AqjzMNb787htcAymEm17xYpRZ8BTVMWdtiioLuvXkffhLB/V8ToIJk4ZzGPIyLk6Qb
         1yf57+MP5eu+PcSUSJ8fjIXiUVYVWq8C1cvxb8ZJ6G1x2DNEq4mwh39+jaJIMKVI2Z
         lvi5pEEGSGXqdCYCN037FqGzYjstreCO/sND5qPWSlNxmwItO7ZG44/W3OUmfBCDwE
         8k+xV3dI1oFuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 16/87] drm: panel: simple: add missing platform_driver_unregister() in panel_simple_init
Date:   Tue, 22 Dec 2020 21:19:52 -0500
Message-Id: <20201223022103.2792705-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 8814aa38c5e7b..eead8f075c94b 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2878,8 +2878,10 @@ static int __init panel_simple_init(void)
 
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

