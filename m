Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D461238EC3E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhEXPNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234238AbhEXPHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CFDB61874;
        Mon, 24 May 2021 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867883;
        bh=WCY1tsQHs0qPaWWClyBnYNlp7D6WjJ9ssswyl7No6Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIigAtLRn8j6Tjrfw2sAtzg8y3dX5DWgnN4Pj16b+tbj9K80Aty25MjEI790WrMEj
         tf8Pp6Zzrym3gGfqXbDaQoYC5XJ/7TU9ZSpMp91NWEP6/JHk2r/s0UQIcBUCjCC7Re
         9Zleil3h524NQ5yrii2cevoT/a3k+pA2W/nFAXZZcjuS5IxD7L2NzZp1eciuiJdLaK
         7ci1Ab7Et8HhpMwSeRIKS+6iEjkji9GJa+2CRnXFz/eu+sSs9wookr65J/k9dfA1VA
         xzH4oGoOQlCsh1zUxFAwf4HyGeGHJ4YGVphu0ZDKplu28R5gIz04pZXbzPia7fARyB
         v+sf4g7y6AoEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/19] media: gspca: properly check for errors in po1030_probe()
Date:   Mon, 24 May 2021 10:51:00 -0400
Message-Id: <20210524145106.2499571-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit dacb408ca6f0e34df22b40d8dd5fae7f8e777d84 ]

If m5602_write_sensor() or m5602_write_bridge() fail, do not continue to
initialize the device but return the error to the calling funtion.

Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-64-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/m5602/m5602_po1030.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/media/usb/gspca/m5602/m5602_po1030.c
index a0a90dd34ca8..a098aeb290c3 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -159,6 +159,7 @@ static const struct v4l2_ctrl_config po1030_greenbal_cfg = {
 int po1030_probe(struct sd *sd)
 {
 	u8 dev_id_h = 0, i;
+	int err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -177,10 +178,13 @@ int po1030_probe(struct sd *sd)
 	for (i = 0; i < ARRAY_SIZE(preinit_po1030); i++) {
 		u8 data = preinit_po1030[i][2];
 		if (preinit_po1030[i][0] == SENSOR)
-			m5602_write_sensor(sd,
-				preinit_po1030[i][1], &data, 1);
+			err = m5602_write_sensor(sd, preinit_po1030[i][1],
+						 &data, 1);
 		else
-			m5602_write_bridge(sd, preinit_po1030[i][1], data);
+			err = m5602_write_bridge(sd, preinit_po1030[i][1],
+						 data);
+		if (err < 0)
+			return err;
 	}
 
 	if (m5602_read_sensor(sd, PO1030_DEVID_H, &dev_id_h, 1))
-- 
2.30.2

