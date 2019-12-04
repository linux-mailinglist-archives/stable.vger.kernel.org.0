Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFA1113497
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfLDSAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbfLDSAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:00:46 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27082084B;
        Wed,  4 Dec 2019 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482445;
        bh=CdHIyb+spZ4uCTNPuHhgh/IkApWBIPe8m08Pr7pEfmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEycKN0muBBxVYNirZI1p3nJ5G1I28fnJVPP7jYVRVwfhRJ+cYuuJGfwtBIQzM4Ix
         fbCaiJlfg5V6s6IcfEC53nG4AKgOsWdScgswciVilCEQGV3y08z8yyWpFJZXmM16UA
         0hx8dpMPL2iszwL3vXishkWkMvTeZJIoyZBgQVV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 40/92] drivers/regulator: fix a missing check of return value
Date:   Wed,  4 Dec 2019 18:49:40 +0100
Message-Id: <20191204174332.953475965@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



