Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C203D2E174D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgLWDIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgLWCSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E19223380;
        Wed, 23 Dec 2020 02:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689854;
        bh=G5zqusR92rRhDGaUSQvE5Qeq+1DwyScqSVbE98ULT+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpd1nE33h2B2FZWkqawlfHTOsVUiwDWcBpQqgZ2ygtPAKCPlY7fkPvR7eAoiKPA1c
         wlxD1q/8tIiV/wOH+qQKwg1Zjeunhc08VJlP+myVrs6x3mSf2cNBDJKlUUkFEYTXDQ
         Xmfzy16CX440ad3ewj/EcAP/bXYWfvrmS1lCEYgMAH1Tp4/48IdVy741/IAPG40s8o
         BuXJQRkFoWBCQXjjCVobUqKlgmR85Bj6kN+Xch87LgTHCS4OOa0PhrslotklZKMHGj
         BeFDaDNGCGz5aCcuQrN4QnuRzRBv363BPwpm/h+jstiVgnbaEQ6QC5cq5/FX6njrzJ
         aG9wwOhRDKwuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 052/217] drm: panel: simple: add missing platform_driver_unregister() in panel_simple_init
Date:   Tue, 22 Dec 2020 21:13:41 -0500
Message-Id: <20201223021626.2790791-52-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 2be358fb46f7d..2966ac13c5382 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4644,8 +4644,10 @@ static int __init panel_simple_init(void)
 
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

