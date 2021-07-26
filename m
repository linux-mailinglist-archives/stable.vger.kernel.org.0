Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA613D5F4F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhGZPRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237449AbhGZPPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C06610C7;
        Mon, 26 Jul 2021 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314955;
        bh=cKn8dJxO5oVjmV77TMDwqaO9J6SlCZyZF9iGLfIPcWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/nJlSVLu8CwVtS3OPiMlZcrujxYX3q8mMeEjpBDsIY309mTHHkcwrIKqaQMJB9np
         kylO3mzg2Kv6seQQt0f/ofGBj7FfhOW8W4pbYo+ZGXbTplZlehKgqf1hQGn12BD7M5
         +DSR1qTRsSN5AqJL5zErEgcnYnqNTF3U6tUQ1kSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/108] regulator: hi6421: Use correct variable type for regmap api val argument
Date:   Mon, 26 Jul 2021 17:38:34 +0200
Message-Id: <20210726153832.760757705@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit ae60e6a9d24e89a74e2512204ad04de94921bdd2 ]

Use unsigned int instead of u32 for regmap_read/regmap_update_bits val
argument.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210619124133.4096683-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/hi6421-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index 5ac3d7c29725..f14cbabfa985 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -386,7 +386,7 @@ static int hi6421_regulator_enable(struct regulator_dev *rdev)
 static unsigned int hi6421_regulator_ldo_get_mode(struct regulator_dev *rdev)
 {
 	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
-	u32 reg_val;
+	unsigned int reg_val;
 
 	regmap_read(rdev->regmap, rdev->desc->enable_reg, &reg_val);
 	if (reg_val & info->mode_mask)
@@ -398,7 +398,7 @@ static unsigned int hi6421_regulator_ldo_get_mode(struct regulator_dev *rdev)
 static unsigned int hi6421_regulator_buck_get_mode(struct regulator_dev *rdev)
 {
 	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
-	u32 reg_val;
+	unsigned int reg_val;
 
 	regmap_read(rdev->regmap, rdev->desc->enable_reg, &reg_val);
 	if (reg_val & info->mode_mask)
@@ -411,7 +411,7 @@ static int hi6421_regulator_ldo_set_mode(struct regulator_dev *rdev,
 						unsigned int mode)
 {
 	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
-	u32 new_mode;
+	unsigned int new_mode;
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
@@ -435,7 +435,7 @@ static int hi6421_regulator_buck_set_mode(struct regulator_dev *rdev,
 						unsigned int mode)
 {
 	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
-	u32 new_mode;
+	unsigned int new_mode;
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-- 
2.30.2



