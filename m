Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0810645A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKVGRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbfKVGNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D580020717;
        Fri, 22 Nov 2019 06:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403217;
        bh=CdHIyb+spZ4uCTNPuHhgh/IkApWBIPe8m08Pr7pEfmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnKDAy6+m+aZ8ospJRxutH35yuTBQG/sKBCJAUyYpFHUd6+LJAu7Mpp7VNkbmRJyQ
         2S0adRkf9GvZoZ7mx2tlNYOinOvwvK+USn1ideG2DvPraTl+U+GDgc7S1TU3YzaxDA
         fXkUB3T1V+mlH2AFtJC5RmOUGwXOnhDqgAu7WEJU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 32/68] drivers/regulator: fix a missing check of return value
Date:   Fri, 22 Nov 2019 01:12:25 -0500
Message-Id: <20191122061301.4947-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 966e927bf8cc6a44f8b72582a1d6d3ffc73b12ad ]

If palmas_smps_read() fails, we should not use the read data in "reg"
which may contain random value. The fix inserts a check for the return
value of palmas_smps_read(): If it fails, we return the error code
upstream and stop using "reg".

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/palmas-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 8217613807d37..4a4766c43e616 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -435,13 +435,16 @@ static int palmas_ldo_write(struct palmas *palmas, unsigned int reg,
 static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
 {
 	int id = rdev_get_id(dev);
+	int ret;
 	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
 	struct palmas_pmic_driver_data *ddata = pmic->palmas->pmic_ddata;
 	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 	unsigned int reg;
 	bool rail_enable = true;
 
-	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);
+	ret = palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);
+	if (ret)
+		return ret;
 
 	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
-- 
2.20.1

