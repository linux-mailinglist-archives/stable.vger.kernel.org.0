Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D3A1A55EB
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgDKXND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbgDKXNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E1721841;
        Sat, 11 Apr 2020 23:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646782;
        bh=4preyET11OEyv7wXhx2hGsIb1dpvel1gneQuWfIGOcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNn1k67QjoMovZ7bva4P7G/CI92EtXYcTbkV1zR0l7pi0qcFaYThmUoW8HNN8u4uv
         wWbCfs5x5/fknZo3fMb3mvoxRa/u2U5gwp2hOMnpqxlo87tPxE36mDuthEI/aPyYF0
         5FQlL2CHpNn/6bSVnOt2JZ9wUwih0xJQJgG9UQi8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 48/66] drm/msm/a5xx: Always set an OPP supported hardware value
Date:   Sat, 11 Apr 2020 19:11:45 -0400
Message-Id: <20200411231203.25933-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index ba6f3c14495c0..dd298abc5f393 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1474,18 +1474,31 @@ static const struct adreno_gpu_funcs funcs = {
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
2.20.1

