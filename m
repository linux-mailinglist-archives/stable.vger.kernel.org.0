Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A213B44B607
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbhKIWYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344083AbhKIWWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A57D619EA;
        Tue,  9 Nov 2021 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496317;
        bh=/muP2UIDb2cnSO54BuNa9JqODtLJYe/zlk6ygSqVLao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWY7jpar138aPiheD+VerpgIC1TRsU0uUuOMssCl/HYxVJPBzMiRDcCGlpNTQsZiu
         233t9iZzqCfuOnMvYedgrdqdoz0NEROfgfTCSznb3n5pjqF1eC8+jrnpSbhxEoNu0n
         pjhJPZZ69E7OHgCFn1uaBrsYCJWYt3LfkVTtoxJRVgDX0JCEJY47Z8s6rpIg3A5TkG
         PC8nTkKd8tWO4cTUA9DBH1R+pkQxum3SQmWMpsJ2xs7BmQvzq6Dey+DrtMNQY5UdfM
         9awxsbMDTp6b8FG8Yz88xU/2jdxdnAn5FwmLzTT5ze19LIchIDf0s0twwCq3hcAt9b
         ZBPTD6whX91pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 66/82] iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()
Date:   Tue,  9 Nov 2021 17:16:24 -0500
Message-Id: <20211109221641.1233217-66-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Teng Qi <starmiku1207184332@gmail.com>

[ Upstream commit 94be878c882d8d784ff44c639bf55f3b029f85af ]

The length of hw->settings->odr_table is 2 and ref_sensor->id is an enum
variable whose value is between 0 and 5.
However, the value ST_LSM6DSX_ID_MAX (i.e. 5) is not caught properly in
 switch (sensor->id) {

If ref_sensor->id is ST_LSM6DSX_ID_MAX, an array overflow will ocurrs in
function st_lsm6dsx_check_odr():
  odr_table = &sensor->hw->settings->odr_table[sensor->id];

and in function st_lsm6dsx_set_odr():
  reg = &hw->settings->odr_table[ref_sensor->id].reg;

To avoid this array overflow, handle ST_LSM6DSX_ID_GYRO explicitly and
return -EINVAL for the default case.

The enum value ST_LSM6DSX_ID_MAX is only present as an easy way to check
the limit and as such is never used, however this is not locally obvious.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20211011114003.976221-1-starmiku1207184332@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index db45f1fc0b817..8dbf744c5651f 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1279,6 +1279,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
 	int err;
 
 	switch (sensor->id) {
+	case ST_LSM6DSX_ID_GYRO:
+		break;
 	case ST_LSM6DSX_ID_EXT0:
 	case ST_LSM6DSX_ID_EXT1:
 	case ST_LSM6DSX_ID_EXT2:
@@ -1304,8 +1306,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
 		}
 		break;
 	}
-	default:
-		break;
+	default: /* should never occur */
+		return -EINVAL;
 	}
 
 	if (req_odr > 0) {
-- 
2.33.0

