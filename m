Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50197371BB2
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhECQrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhECQpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B9761621;
        Mon,  3 May 2021 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059953;
        bh=bgsQ4C6uIetDSOq7p3giD0blDWPX1UU1oDNWpWVUFGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Av2q5a14jTVoWEFfNySXYgP4nJ4Lv0RIngixYZpArKQChxHHsGhjDnyUNJkanNdZV
         CaxAdZ+NZtapQRo0QNBcqiw34U7/pK1hQ1QcL89MwZZ4up6ysjKFCK3mr9MQ4TP4mh
         HU+0h0W4j0NWgj2uJCSI7jYUJO/hVezEIGKZHono5QyeQLTR8pDDBuHfflErCJthZI
         tYODsNOeSJy5TtZvJ+5omF3TAb4fDDbArnV5L2+PHo7MYaF2LdOiclwhSjtAhVdq7b
         N6MkECi411pOplOYy5Fub4XZAOrtHV2DL/8IvI3oTLXR8ioz+nIBMGhtVQyRzT/NQv
         TG9ralplt3PhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiran Gunda <kgunda@codeaurora.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 029/100] backlight: qcom-wled: Fix FSC update issue for WLED5
Date:   Mon,  3 May 2021 12:37:18 -0400
Message-Id: <20210503163829.2852775-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiran Gunda <kgunda@codeaurora.org>

[ Upstream commit 4d6e9cdff7fbb6bef3e5559596fab3eeffaf95ca ]

Currently, for WLED5, the FSC (Full scale current) setting is not
updated properly due to driver toggling the wrong register after
an FSC update.

On WLED5 we should only toggle the MOD_SYNC bit after a brightness
update. For an FSC update we need to toggle the SYNC bits instead.

Fix it by adopting the common wled3_sync_toggle() for WLED5 and
introducing new code to the brightness update path to compensate.

Signed-off-by: Kiran Gunda <kgunda@codeaurora.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 83a187fdaa1d..cd11c5776438 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -348,7 +348,7 @@ static int wled3_sync_toggle(struct wled *wled)
 	return rc;
 }
 
-static int wled5_sync_toggle(struct wled *wled)
+static int wled5_mod_sync_toggle(struct wled *wled)
 {
 	int rc;
 	u8 val;
@@ -445,10 +445,23 @@ static int wled_update_status(struct backlight_device *bl)
 			goto unlock_mutex;
 		}
 
-		rc = wled->wled_sync_toggle(wled);
-		if (rc < 0) {
-			dev_err(wled->dev, "wled sync failed rc:%d\n", rc);
-			goto unlock_mutex;
+		if (wled->version < 5) {
+			rc = wled->wled_sync_toggle(wled);
+			if (rc < 0) {
+				dev_err(wled->dev, "wled sync failed rc:%d\n", rc);
+				goto unlock_mutex;
+			}
+		} else {
+			/*
+			 * For WLED5 toggling the MOD_SYNC_BIT updates the
+			 * brightness
+			 */
+			rc = wled5_mod_sync_toggle(wled);
+			if (rc < 0) {
+				dev_err(wled->dev, "wled mod sync failed rc:%d\n",
+					rc);
+				goto unlock_mutex;
+			}
 		}
 	}
 
@@ -1459,7 +1472,7 @@ static int wled_configure(struct wled *wled)
 		size = ARRAY_SIZE(wled5_opts);
 		*cfg = wled5_config_defaults;
 		wled->wled_set_brightness = wled5_set_brightness;
-		wled->wled_sync_toggle = wled5_sync_toggle;
+		wled->wled_sync_toggle = wled3_sync_toggle;
 		wled->wled_cabc_config = wled5_cabc_config;
 		wled->wled_ovp_delay = wled5_ovp_delay;
 		wled->wled_auto_detection_required =
-- 
2.30.2

