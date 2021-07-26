Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F39A3D6183
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhGZPcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238076AbhGZP3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1727E60C41;
        Mon, 26 Jul 2021 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315811;
        bh=Go1iKbPM/vtqA/2HqRpjLUeZFIYJ3ls5OtMWS70sE7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5J75fKB9DX+fOoblEY4fYjU8PeNSmJTtn9KFqmUP7xPsdVfkQxZS3SS9qiipsne4
         vYjodVKQhipFto/I5N+f00SZj1fba9f+4dhcy7rOPcSFAhtItSslwNwS7q1S3jAiny
         TeOC/ydyKuH6YHumpDjVFGHAbEePr/y8vTGX96XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 069/223] regulator: hi6421: Use correct variable type for regmap api val argument
Date:   Mon, 26 Jul 2021 17:37:41 +0200
Message-Id: <20210726153848.514995028@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index dc631c1a46b4..bff8c515dcde 100644
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



