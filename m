Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0293CEA07F
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfJ3P5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfJ3P5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:06 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC32A2083E;
        Wed, 30 Oct 2019 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451026;
        bh=H/xK7rTKzYIYlsmIXXA56zLqgxHAPcGT4SOcy8KU/GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsfYXKouhhKLeiNovieOmOMR5jMdZdSy4/l4qLhp3iDHzjXcXxmnPmi999D9d2UGT
         O+OIRml3lOEpeG7z/jBw6x3R5I2sBaP0Y2PdYCGiis1X7R+9LGxR147LODTdF/UpLf
         BK0oCQEoOEXppkSCd7/5sobaAwPVCP/cm6RVOCAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yizhuo <yzhai003@ucr.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/18] regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized
Date:   Wed, 30 Oct 2019 11:56:44 -0400
Message-Id: <20191030155700.10748-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
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
index 86b348740fcdc..ffb1f61d2c752 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -608,7 +608,13 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 
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
 				if (pfuze_chip->chip_id == PFUZE3000) {
 					desc->volt_table = pfuze3000_sw2hi;
-- 
2.20.1

