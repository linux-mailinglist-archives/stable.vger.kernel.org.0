Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F26201328
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388925AbgFSP5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392630AbgFSPT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66015217A0;
        Fri, 19 Jun 2020 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579997;
        bh=Nzj33yMcNsTqDcHz96UKV5DTW8bq53Qh/4LF7am2yZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+HJQnPYVk/3ycXUahn2dH7yrid1GlF27G0nfcwkegCNo064ZNBz1rD6/vNoGEWCK
         KzqwjOH9DTp7bww+1xPBJWun+XyIV/xVAOa2Brd3/MvIeinrO+FDNTbSDSOHIQg9WK
         QHAOqjOtbyR2DGp7r2m3RPQ5gIloiBadiaMKHJds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 054/376] ath11k: Fix some resource leaks in error path in ath11k_thermal_register()
Date:   Fri, 19 Jun 2020 16:29:32 +0200
Message-Id: <20200619141712.909592912@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 25ca180ad380a0c7286442a922e7fbcc6a9f6083 ]

If 'thermal_cooling_device_register()' fails, we must undo what has been
allocated so far. So we must go to 'err_thermal_destroy' instead of
returning directly

In case of error in 'ath11k_thermal_register()', the previous
'thermal_cooling_device_register()' call must also be undone. Move the
'ar->thermal.cdev = cdev' a few lines above in order for this to be done
in 'ath11k_thermal_unregister()' which is called in the error handling
path.

Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200513201454.258111-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.c b/drivers/net/wireless/ath/ath11k/thermal.c
index 259dddbda2c7..5a7e150c621b 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.c
+++ b/drivers/net/wireless/ath/ath11k/thermal.c
@@ -174,9 +174,12 @@ int ath11k_thermal_register(struct ath11k_base *sc)
 		if (IS_ERR(cdev)) {
 			ath11k_err(sc, "failed to setup thermal device result: %ld\n",
 				   PTR_ERR(cdev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_thermal_destroy;
 		}
 
+		ar->thermal.cdev = cdev;
+
 		ret = sysfs_create_link(&ar->hw->wiphy->dev.kobj, &cdev->device.kobj,
 					"cooling_device");
 		if (ret) {
@@ -184,7 +187,6 @@ int ath11k_thermal_register(struct ath11k_base *sc)
 			goto err_thermal_destroy;
 		}
 
-		ar->thermal.cdev = cdev;
 		if (!IS_REACHABLE(CONFIG_HWMON))
 			return 0;
 
-- 
2.25.1



