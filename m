Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B4E26F44E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgIRDN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgIRCB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7B323119;
        Fri, 18 Sep 2020 02:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394517;
        bh=lB+iWkzrjWwT35sfwmRttopkYwQyjYYUw5+6Fd6KN2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2Dx+Kbjv9fl66GSVLrws13WMpKIK4PgKmSt30vdrseKkwNI4Dxjg+dyRWvCkqCwW
         W7FfLxYe5obBoxj8CSO2AUSQ1KfKFD/auHjfke9SGNyxMajckq/M0c3q0GCCzD8ZOC
         30Zt207lS+ptLwNSme9wZNfDKGJO1krg3YIL+4qU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 039/330] mfd: mfd-core: Protect against NULL call-back function pointer
Date:   Thu, 17 Sep 2020 21:56:19 -0400
Message-Id: <20200918020110.2063155-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit b195e101580db390f50b0d587b7f66f241d2bc88 ]

If a child device calls mfd_cell_{en,dis}able() without an appropriate
call-back being set, we are likely to encounter a panic.  Avoid this
by adding suitable checking.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 23276a80e3b48..96d02b6f06fd8 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -28,6 +28,11 @@ int mfd_cell_enable(struct platform_device *pdev)
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int err = 0;
 
+	if (!cell->enable) {
+		dev_dbg(&pdev->dev, "No .enable() call-back registered\n");
+		return 0;
+	}
+
 	/* only call enable hook if the cell wasn't previously enabled */
 	if (atomic_inc_return(cell->usage_count) == 1)
 		err = cell->enable(pdev);
@@ -45,6 +50,11 @@ int mfd_cell_disable(struct platform_device *pdev)
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int err = 0;
 
+	if (!cell->disable) {
+		dev_dbg(&pdev->dev, "No .disable() call-back registered\n");
+		return 0;
+	}
+
 	/* only disable if no other clients are using it */
 	if (atomic_dec_return(cell->usage_count) == 0)
 		err = cell->disable(pdev);
-- 
2.25.1

