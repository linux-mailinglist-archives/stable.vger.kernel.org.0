Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3956138EA96
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbhEXO4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233485AbhEXOxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DDE061422;
        Mon, 24 May 2021 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867708;
        bh=lGqqaLBNP/9QRAroFbTLl3k3cLDdzW2qBzFiLQ2qiP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLEbpQmKHgncHMtL1bsKkbXMBxzDSZsv61bsEZhyf/iacNI2Jd5+dp0uPLROTz0BR
         Jp0llW2Zr3M0zpGJi/X86r7cROGT3hri6w7unn8zwk3fm9WUJG4Mc8ASDC3gvrN3eh
         qreCyS5/VZ7yA2CXKyQU+6hOAbqQbbK8xW6FH+aLPYQ1dcRLSGsZRgu89YRSdw6tEH
         WAFT3zu7SBZHSqcODI1uMuwUWnEHSddfKn8oEqnHiSYDhNLi7hJxpaRpsGVwmFD9Wm
         dK/upsA+wU3F74oQU8g6NVJ+sInbXbh83OcMifyZ6uPR5VDUpQXDkP21XNPRCGSJ74
         yT4EBDE+jeyZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/62] media: gspca: mt9m111: Check write_bridge for timeout
Date:   Mon, 24 May 2021 10:47:17 -0400
Message-Id: <20210524144744.2497894-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Emad <alaaemadhossney.ae@gmail.com>

[ Upstream commit e932f5b458eee63d013578ea128b9ff8ef5f5496 ]

If m5602_write_bridge times out, it will return a negative error value.
So properly check for this and handle the error correctly instead of
just ignoring it.

Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-62-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
index 50481dc928d0..bf1af6ed9131 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
@@ -195,7 +195,7 @@ static const struct v4l2_ctrl_config mt9m111_greenbal_cfg = {
 int mt9m111_probe(struct sd *sd)
 {
 	u8 data[2] = {0x00, 0x00};
-	int i;
+	int i, err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -213,15 +213,17 @@ int mt9m111_probe(struct sd *sd)
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

