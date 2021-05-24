Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE4738EC57
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhEXPOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhEXPIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B59613BF;
        Mon, 24 May 2021 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867903;
        bh=KpXUfUt1fgpC5ziZfFWsPNZKhPmQ3MUUVXWsAFs9LM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmmUqzQGlcCSLfEZTjMwMi5Jhc7VkikZMcWoAqytiA+A4II/4MpFp+vG0gv2qrHPO
         nWDbYx6RFpY+gnnu2k1WefS/G55xpf7YSWoSq+XXOqc7drUFNi2SyPBhQ6PxzI7Jhh
         I26+NvOKDatfzayd+EZD7WC+Q9O7pfouL4HjntlqynYs588LVBvsHxssnFvrAXnlL4
         w2bEgnz4bBUY202wwZ5cbP7VKSfCnPRLcgHABlKTlSbQNLllXyLL2IesffKrXeY8Nl
         rTfZawuW6Uee8JUhfyiYzcMCSXHaVS3JuyzTuZcPBy15INyc8Cdw/DCBQC2jFtLctb
         bauv5BKLblvAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/16] media: gspca: mt9m111: Check write_bridge for timeout
Date:   Mon, 24 May 2021 10:51:24 -0400
Message-Id: <20210524145130.2499829-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
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
index 27fcef11aef4..67bb207f4eb2 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
@@ -55,7 +55,7 @@ static const struct v4l2_ctrl_config mt9m111_greenbal_cfg = {
 int mt9m111_probe(struct sd *sd)
 {
 	u8 data[2] = {0x00, 0x00};
-	int i;
+	int i, err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -73,15 +73,17 @@ int mt9m111_probe(struct sd *sd)
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

