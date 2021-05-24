Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2138EBB5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhEXPGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhEXPCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862F861466;
        Mon, 24 May 2021 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867826;
        bh=OM0tZT06vTC/AJtNAz4TRFPhTCe0YWjeKkByYYgJLyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tx1TsIJ3QuwgZZkDHpgZxpeFlyHouIC2Qzj4U8fisvCnF1RMmmNFYw5bCJc6olvm8
         wwMS4oshDx5wXRIg7ca4VIcIpG+e+LMEROnelRV+d5eYwSGQeTyi/GXNZv/WyZjrXz
         UUGqJwkAhGQhtD7Vv9WYuENHF51S1mcm5XxXHlVK/Obq8/AbBZ1KdFARHNrmf2TQ60
         e5pfl1inqhgZUJuWyft9sP6QL+3LR2wXkrCPWM4C7ADYQjYMYKtSbvErvIug9fLZbl
         VUjZ8/u4JCAbKSiXcQ/mTFI96++sNB9ZB0cHPVf+6i/rQSpStHjsJQkx2vOlzk3HJK
         Zcp/k880qs+Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/25] media: gspca: mt9m111: Check write_bridge for timeout
Date:   Mon, 24 May 2021 10:49:57 -0400
Message-Id: <20210524145008.2499049-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Emad <alaaemadhossney.ae@gmail.com>

[ Upstream commit 656025850074f5c1ba2e05be37bda57ba2b8d491 ]

In mt9m111_probe, m5602_write_bridge can timeout and return a negative
error value. The fix checks for this error and passes it upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
index c9947c4a0f63..5f7216c3e34d 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
@@ -199,7 +199,7 @@ static const struct v4l2_ctrl_config mt9m111_greenbal_cfg = {
 int mt9m111_probe(struct sd *sd)
 {
 	u8 data[2] = {0x00, 0x00};
-	int i;
+	int i, err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -217,15 +217,17 @@ int mt9m111_probe(struct sd *sd)
 	/* Do the preinit */
 	for (i = 0; i < ARRAY_SIZE(preinit_mt9m111); i++) {
 		if (preinit_mt9m111[i][0] == BRIDGE) {
-			m5602_write_bridge(sd,
-				preinit_mt9m111[i][1],
-				preinit_mt9m111[i][2]);
+			err = m5602_write_bridge(sd,
+					preinit_mt9m111[i][1],
+					preinit_mt9m111[i][2]);
 		} else {
 			data[0] = preinit_mt9m111[i][2];
 			data[1] = preinit_mt9m111[i][3];
-			m5602_write_sensor(sd,
-				preinit_mt9m111[i][1], data, 2);
+			err = m5602_write_sensor(sd,
+					preinit_mt9m111[i][1], data, 2);
 		}
+		if (err < 0)
+			return err;
 	}
 
 	if (m5602_read_sensor(sd, MT9M111_SC_CHIPVER, data, 2))
-- 
2.30.2

