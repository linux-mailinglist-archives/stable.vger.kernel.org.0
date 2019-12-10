Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3F1196F0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfLJVaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfLJVJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89207246BB;
        Tue, 10 Dec 2019 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012197;
        bh=Q/WB4rKuF1LKvZvuCApJ15O1SGEplzZkLXpoMKEtV/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOmECpCTbb5ZPyZ7l8DeqHwuPnxF+SaH+zP6hQ52/PsAVMSXlajGWvpjHDhrfoH/q
         uYvH7Jp+NbdhPveAMDy6ffvfDjk/6roiAJ2iGDxAblsJqbdoc+VmN1buchQrJytXLd
         kQuGPf3gGtqDbHkSATXf52WIg6sDIx3mEzi/x+VE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 151/350] media: imx7-mipi-csis: Add a check for devm_regulator_get
Date:   Tue, 10 Dec 2019 16:04:16 -0500
Message-Id: <20191210210735.9077-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a0219deefe9ee5006a28d48522f76b217d198c51 ]

devm_regulator_get may return an error but mipi_csis_phy_init misses
a check for it.
This may lead to problems when regulator_set_voltage uses the unchecked
pointer.
This patch adds a check for devm_regulator_get to avoid potential risk.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 73d8354e618c4..e50b1f88e25b5 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -350,6 +350,8 @@ static void mipi_csis_sw_reset(struct csi_state *state)
 static int mipi_csis_phy_init(struct csi_state *state)
 {
 	state->mipi_phy_regulator = devm_regulator_get(state->dev, "phy");
+	if (IS_ERR(state->mipi_phy_regulator))
+		return PTR_ERR(state->mipi_phy_regulator);
 
 	return regulator_set_voltage(state->mipi_phy_regulator, 1000000,
 				     1000000);
@@ -966,7 +968,10 @@ static int mipi_csis_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	mipi_csis_phy_init(state);
+	ret = mipi_csis_phy_init(state);
+	if (ret < 0)
+		return ret;
+
 	mipi_csis_phy_reset(state);
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
2.20.1

