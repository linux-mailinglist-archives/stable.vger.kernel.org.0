Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374D92E144F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgLWCXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgLWCX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D8B23381;
        Wed, 23 Dec 2020 02:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690189;
        bh=d+jnG9khOxDlTsbt+UFQssINvJMTzV+aT2ypQH3ZMMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgJORgoiL3j0yBi7h/HGTHghhdVEKcDzFCbZ5UGz4oeDnO78hPxqBNnQaQxhHi5LO
         UUjRgZXptZYQxzcsZwTNa5CC4tW9/DYiGo/DTq/dfKuVGA5i4kdhkNnrnCx6eJDw6r
         GV0QHq+xDO51S+HkXH7RlPZqtJNUCaIxjirCg4HY6cbCHjh6H8OCV1F63jeX8/23us
         WmjgnSOtQLTuYlEXPtix1/icii2i57lsv9gKjNCFLrL4KJdLr8eOC8eGRSHp9ZXqR4
         fffgT+OFeWWf3MAatErcJozC9Kr/JEXEAA6pZQBsIAeu1F1SunDtYGbRaGvs3NVLMi
         nq8PRDf9Tn7mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 13/66] drm: panel: simple: add missing platform_driver_unregister() in panel_simple_init
Date:   Tue, 22 Dec 2020 21:21:59 -0500
Message-Id: <20201223022253.2793452-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index 6df312ba1826b..37b018a81ee0e 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2417,8 +2417,10 @@ static int __init panel_simple_init(void)
 
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

