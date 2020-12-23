Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC79F2E132B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgLWC2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgLWC0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5409E22525;
        Wed, 23 Dec 2020 02:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690330;
        bh=I3OWIgay7oTUIYZ62EAIrrMkd7mFHGl0lmW7+gGcC3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWCqSe2t0BSIyzWUI50bl3NvJPmLty3HrwPNUwxPiDE49DYVfRl/QuKEnNrCo2so/
         jK44FcUTy9rH1HWVqyR8fzALr/SkDcQKA7PnKY0tHwSjO9sovNLnGWyBwTE7bMesWF
         xthk5r6dI+R1C7vYlX0aUNrfSFpbKWHCrPDwdOluhGBTpiDggCwzBbD94hF424qEIu
         IGqwS+tFfNme+Ybs9VHX1WZmh7Rj3PZSzim5n/GbnEFKim9lQQvb1B2IQ3gJCi62il
         7uq0tvvIGRNrWQTBDZ7F3OoEW0ntqOl++howV8BKIF2zvZY+ltAPVOWDhRdIosqStS
         /cFBpdUzMsCZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 10/38] drm: panel: simple: add missing platform_driver_unregister() in panel_simple_init
Date:   Tue, 22 Dec 2020 21:24:48 -0500
Message-Id: <20201223022516.2794471-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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
index 64b23bdebd1d1..7740772e4d575 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1435,8 +1435,10 @@ static int __init panel_simple_init(void)
 
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

