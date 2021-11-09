Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14144B7C2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbhKIWh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344744AbhKIWf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:35:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E896360F42;
        Tue,  9 Nov 2021 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496532;
        bh=T/VLGws0oxAJsjjoi9Cn7Me0fLjDhjG950pEH7pakLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNSAIKYfveVI3W3IS/ncUPb3W0oQb26AXEsBHVfWC1C8Sv1oPF+FxpwcBV0wkw2h8
         oet2CwvfpFgoPnabug4QVNSYiaDYji6ZOHbBo5nusqxwWHCGljOYGdRUFQp/SozPgj
         p+cS1ESVQWzkaeYBVUsF0q5O6JJn2NvPc8GCMpc/DSrKQpLBseRv2bg+P/l800x/VZ
         1WQ85Xw4yC7mETk43RF1gNOBLY+A/GptzL0bw0agwv0I0B5jjrZTJow+1L1hnSHDIj
         X5ahFnzzbNMYNxg8F4pArOtNRu82WcnkkBLtVzzvZxBj9mBd4zb85djrxOR4XQlHkp
         32s8N3LqTuPXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 44/50] iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()
Date:   Tue,  9 Nov 2021 17:20:57 -0500
Message-Id: <20211109222103.1234885-44-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index 2ab1ac5a2412f..558ca3843bb95 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1465,6 +1465,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
 	int err;
 
 	switch (sensor->id) {
+	case ST_LSM6DSX_ID_GYRO:
+		break;
 	case ST_LSM6DSX_ID_EXT0:
 	case ST_LSM6DSX_ID_EXT1:
 	case ST_LSM6DSX_ID_EXT2:
@@ -1490,8 +1492,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
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

