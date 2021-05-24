Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCAC38E988
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhEXOtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhEXOsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C77C613D2;
        Mon, 24 May 2021 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867627;
        bh=lGqqaLBNP/9QRAroFbTLl3k3cLDdzW2qBzFiLQ2qiP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+8hjFU8SBwji/hrs0X7ZOfwssz1a03Arh1B4Q/REsk7Kk86P1bGeuaCSaD9TX7KH
         4gucVtNry43AAT1hQac3NvxbF3cCXZQilgAycn9Q8B833Q4RNgPWvPDELA500MTITc
         b3vRVUe83H552jA7NnQ8gZjGlr53zr6AwXEsc8BczyLcwBPzvRgBY/2El3rA4++SHU
         dNR7/srL6wpd4YBjMTWwOguvzZ/DN+i4I0HLy7BlgltPPMRS8jGK2Qh1N+N61h+L9J
         0EWPFxMl1Uoc9GJXkO7lAufDLsi9x4/lTKXgCbYFZP0kLyjtnSOclg+ua7VB7FETOC
         0xmnuGtj9M//g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 36/63] media: gspca: mt9m111: Check write_bridge for timeout
Date:   Mon, 24 May 2021 10:45:53 -0400
Message-Id: <20210524144620.2497249-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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

