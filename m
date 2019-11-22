Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5003F106587
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfKVFvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbfKVFvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB8D20726;
        Fri, 22 Nov 2019 05:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401872;
        bh=Z+GRDGXvde3IqbQAMR4FdDnPTDNca8lROt2Va9pj+gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s53GS3P8P+SgyGd+4N2jasZm2MwqYgXor6uxxFRuHtrmUFEqclG/bZVYosFy+4JJ9
         JnOrasUO8aHqCuoHysa7bgw9x4+JPWDDhleF6+3JcTEejx0UOGQiFTpR8ln5t6Tp7Y
         nagd/jmqSmGxAtOPFwKOAofqD5oxhSekD35CX1ho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 108/219] drivers/regulator: fix a missing check of return value
Date:   Fri, 22 Nov 2019 00:47:20 -0500
Message-Id: <20191122054911.1750-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index bb5ab7d78895b..c2cc392a27d40 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -443,13 +443,16 @@ static int palmas_ldo_write(struct palmas *palmas, unsigned int reg,
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

