Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1CF45C1DA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349390AbhKXNWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348491AbhKXNUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:20:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF9A61267;
        Wed, 24 Nov 2021 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758008;
        bh=RuXAnMAUReHuRn5YQmBLvHesUHnsrgsn60AyOpEc1dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQDY8d8V/Qz/VPF7j6zQE8nBkr4Zm0QWuo47M0IPQdpn4RI4x/cfy6CYsBxWqM68l
         VnpZIlgeXMSMmMZ7E8J85N8bynNOOBpfIULkH9m1Z1lXoYP+V1wLw5aKx6q0oeY9yy
         MU7g8BwAqoI3EAseppW7H+yJC9ixJ+Gw7Xw7Rhtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Teng Qi <starmiku1207184332@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/100] iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()
Date:   Wed, 24 Nov 2021 12:57:42 +0100
Message-Id: <20211124115655.706451339@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 057a4b0100106..8850da8e25d69 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1015,6 +1015,8 @@ static int st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u16 req_odr)
 	int err;
 
 	switch (sensor->id) {
+	case ST_LSM6DSX_ID_GYRO:
+		break;
 	case ST_LSM6DSX_ID_EXT0:
 	case ST_LSM6DSX_ID_EXT1:
 	case ST_LSM6DSX_ID_EXT2:
@@ -1040,8 +1042,8 @@ static int st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u16 req_odr)
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



