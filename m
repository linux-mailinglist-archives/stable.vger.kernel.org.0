Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEDD15F2CE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgBNPu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbgBNPu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3782724681;
        Fri, 14 Feb 2020 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695457;
        bh=sZBeeE6wSzHR2+hE1yzf8GFbm2+TVCvDxqIXTFh+1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xM3772z1C9pO2vUrPiD1uH+u4dGk7CnTjJqGTf04tUWLEDcIYS9qa2xgzDq4RRyGz
         lkrtU58Vv2vbSwjzcI7bUNux3OvL+q+8yHsA4lPcvCcMl6g7uyGN2Zntt8xMagCUd3
         RC8kxPfOY5tmk/6sm1DeWHotUcgic08lOdujxt1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 095/542] backlight: qcom-wled: Fix unsigned comparison to zero
Date:   Fri, 14 Feb 2020 10:41:27 -0500
Message-Id: <20200214154854.6746-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 7af43a76695db71a57203793fb9dd3c81a5783b1 ]

Fixes coccicheck warning:
./drivers/video/backlight/qcom-wled.c:1104:5-15:
	WARNING: Unsigned expression compared with zero: string_len > 0

The unsigned variable string_len is assigned a return value from the call
to of_property_count_elems_of_size(), which may return negative error code.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Kiran Gunda <kgunda@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index d46052d8ff415..3d276b30a78c9 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -956,8 +956,8 @@ static int wled_configure(struct wled *wled, int version)
 	struct wled_config *cfg = &wled->cfg;
 	struct device *dev = wled->dev;
 	const __be32 *prop_addr;
-	u32 size, val, c, string_len;
-	int rc, i, j;
+	u32 size, val, c;
+	int rc, i, j, string_len;
 
 	const struct wled_u32_opts *u32_opts = NULL;
 	const struct wled_u32_opts wled3_opts[] = {
-- 
2.20.1

