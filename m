Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2452395ED0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhEaOD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232862AbhEaOB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786FA6138C;
        Mon, 31 May 2021 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468222;
        bh=lGqqaLBNP/9QRAroFbTLl3k3cLDdzW2qBzFiLQ2qiP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHfMlo/M6WBYci6+RPPep7tOLBS3/CCLUFauoCqbGaMDJPJAf7Q3mqT7sPb0MvRBo
         MtXqCXM/K3rauwDc1Q7fX8yGSGy4sLowNzqp01r+MsJ/7LjiCrhlXG67+V6tGx0kH1
         la1V9LY/OSOQevLHwKqqaggVe0vdmh6feu1t/aLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/252] media: gspca: mt9m111: Check write_bridge for timeout
Date:   Mon, 31 May 2021 15:13:48 +0200
Message-Id: <20210531130703.552806031@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



