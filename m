Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9455627C5BD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgI2Lia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730307AbgI2Lhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8B8208B8;
        Tue, 29 Sep 2020 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379468;
        bh=pjw6RpTrrdd3v2Fpt0avN8pPLD46b9F+zZQ1N1erV2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1OIvlZXeRgKMoMDt4fRwRIyfTxZL/KDD6XOQNbO9BZIF0IVRrBFmjd4FEvmbjPu3
         dlt9aZ8V+v/QPLVPteDs/dSX3M52z/r87zmedN5U64UNWrq6epzdQRQqr+vhpfa57V
         vyPlWmKWceSo9ICUGgnpcWmQAk9dN81Py1rxPnC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/388] drm/msm/a5xx: Always set an OPP supported hardware value
Date:   Tue, 29 Sep 2020 12:58:27 +0200
Message-Id: <20200929110019.002955001@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

[ Upstream commit 0478b4fc5f37f4d494245fe7bcce3f531cf380e9 ]

If the opp table specifies opp-supported-hw as a property but the driver
has not set a supported hardware value the OPP subsystem will reject
all the table entries.

Set a "default" value that will match the default table entries but not
conflict with any possible real bin values. Also fix a small memory leak
and free the buffer allocated by nvmem_cell_read().

Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 24b55103bfe00..c8fb21cc0d6ff 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1414,18 +1414,31 @@ static const struct adreno_gpu_funcs funcs = {
 static void check_speed_bin(struct device *dev)
 {
 	struct nvmem_cell *cell;
-	u32 bin, val;
+	u32 val;
+
+	/*
+	 * If the OPP table specifies a opp-supported-hw property then we have
+	 * to set something with dev_pm_opp_set_supported_hw() or the table
+	 * doesn't get populated so pick an arbitrary value that should
+	 * ensure the default frequencies are selected but not conflict with any
+	 * actual bins
+	 */
+	val = 0x80;
 
 	cell = nvmem_cell_get(dev, "speed_bin");
 
-	/* If a nvmem cell isn't defined, nothing to do */
-	if (IS_ERR(cell))
-		return;
+	if (!IS_ERR(cell)) {
+		void *buf = nvmem_cell_read(cell, NULL);
+
+		if (!IS_ERR(buf)) {
+			u8 bin = *((u8 *) buf);
 
-	bin = *((u32 *) nvmem_cell_read(cell, NULL));
-	nvmem_cell_put(cell);
+			val = (1 << bin);
+			kfree(buf);
+		}
 
-	val = (1 << bin);
+		nvmem_cell_put(cell);
+	}
 
 	dev_pm_opp_set_supported_hw(dev, &val, 1);
 }
-- 
2.25.1



