Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2561670A6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgBUHq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgBUHqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:46:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D319520801;
        Fri, 21 Feb 2020 07:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271210;
        bh=sZBeeE6wSzHR2+hE1yzf8GFbm2+TVCvDxqIXTFh+1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2+DO5i/91jSvl45YCeJoa8X/le4tQP8GWgDnY54ZMZaBb9QI9cukIoxNiU/97dvJ
         KV7R3MGElxfP9VhxoQ46945v7AeummR5SSLWZxcdSO8ylmOsAXoKtDG0njK3lTUhD0
         GOMntnk8d7uvJKqvrldlT4AoTWsWhC1sGgEi7nFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 081/399] backlight: qcom-wled: Fix unsigned comparison to zero
Date:   Fri, 21 Feb 2020 08:36:46 +0100
Message-Id: <20200221072410.209452889@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



