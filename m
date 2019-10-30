Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE5EA167
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfJ3QCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 12:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfJ3PvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:12 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88CBD20856;
        Wed, 30 Oct 2019 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450671;
        bh=RR+w7adT0I5Z7lEfES6VOEqvuA92c5DKM6Bs1k4wfsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK3H2v3E/MBQw82Nw9XuIJgdbrENN0Msygx02vIXjWytIu+xpbHvAEV2HwSe4PtAd
         Be0tGCBRBOIovtwPgjYXIcS9uOTPKz99vyCdZ2QcuipuO0GRvv+AyUnS3XpaSQI808
         zKNzH04cc2N8+o5sTtxjSW2y2SoNtMXfqqWij65Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yizhuo <yzhai003@ucr.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 20/81] regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized
Date:   Wed, 30 Oct 2019 11:48:26 -0400
Message-Id: <20191030154928.9432-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>

[ Upstream commit 1252b283141f03c3dffd139292c862cae10e174d ]

In function pfuze100_regulator_probe(), variable "val" could be
initialized if regmap_read() fails. However, "val" is used to
decide the control flow later in the if statement, which is
potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
Link: https://lore.kernel.org/r/20190929170957.14775-1-yzhai003@ucr.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pfuze100-regulator.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index df5df1c495adb..689537927f6f7 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -788,7 +788,13 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 
 		/* SW2~SW4 high bit check and modify the voltage value table */
 		if (i >= sw_check_start && i <= sw_check_end) {
-			regmap_read(pfuze_chip->regmap, desc->vsel_reg, &val);
+			ret = regmap_read(pfuze_chip->regmap,
+						desc->vsel_reg, &val);
+			if (ret) {
+				dev_err(&client->dev, "Fails to read from the register.\n");
+				return ret;
+			}
+
 			if (val & sw_hi) {
 				if (pfuze_chip->chip_id == PFUZE3000 ||
 					pfuze_chip->chip_id == PFUZE3001) {
-- 
2.20.1

