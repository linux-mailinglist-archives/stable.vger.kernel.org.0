Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF41F2F9C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFIAvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgFHXKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B09208C7;
        Mon,  8 Jun 2020 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657813;
        bh=3BabQJM6BN1aJZwxaMkpymzATSEqgRe2H4GvW+yQVss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJ3AvlcE2HUrn+CuknAcK54VNNwCssa9QazWO3UXivaDzRpyX8HyzW+r/nzN19TpP
         oHkA+XaIl3oA+eLZh7EBssgIHi4LZYNuNvWOYOUwY+GxvpyngPlIBSvLtfMYSEVhmz
         M7AMDcmyJvwqmvfNKQj6AUHB7rClE4W9suVRXXZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 188/274] drm/mcde: dsi: Fix return value check in mcde_dsi_bind()
Date:   Mon,  8 Jun 2020 19:04:41 -0400
Message-Id: <20200608230607.3361041-188-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 761e9f4f80a21a4b845097027030bef863001636 ]

The of_drm_find_bridge() function returns NULL on error, it doesn't return
error pointers so this check doesn't work.

Fixes: 5fc537bfd000 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200430073145.52321-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_dsi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mcde/mcde_dsi.c b/drivers/gpu/drm/mcde/mcde_dsi.c
index 7af5ebb0c436..e705afc08c4e 100644
--- a/drivers/gpu/drm/mcde/mcde_dsi.c
+++ b/drivers/gpu/drm/mcde/mcde_dsi.c
@@ -1073,10 +1073,9 @@ static int mcde_dsi_bind(struct device *dev, struct device *master,
 			panel = NULL;
 
 			bridge = of_drm_find_bridge(child);
-			if (IS_ERR(bridge)) {
-				dev_err(dev, "failed to find bridge (%ld)\n",
-					PTR_ERR(bridge));
-				return PTR_ERR(bridge);
+			if (!bridge) {
+				dev_err(dev, "failed to find bridge\n");
+				return -EINVAL;
 			}
 		}
 	}
-- 
2.25.1

