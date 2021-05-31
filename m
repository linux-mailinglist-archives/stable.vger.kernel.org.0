Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEEA395ED4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhEaOEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232873AbhEaOB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB5861947;
        Mon, 31 May 2021 13:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468227;
        bh=/5mkWMxrniQRM0OIO+l/RFMqZzon2mnA8svi+4FOsBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9yv1IWSTahLD9ZqSPpu/7vk4bZtlvaZ56T5k1lfI62uoUBn1TXvIzGBWWPctMIqR
         gozeqBettORYua6IBmuqXc9DEszGDRpfoVtzMKS1w0tb4UUDV+JzT4i01DQb8y27eB
         nBxcGOEc1IsD/dkWwir6tbjCo7r33Iwyj1uI30M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/252] media: gspca: properly check for errors in po1030_probe()
Date:   Mon, 31 May 2021 15:13:50 +0200
Message-Id: <20210531130703.616876282@linuxfoundation.org>
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
index 7bdbb8065146..8fd99ceee4b6 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -155,6 +155,7 @@ static const struct v4l2_ctrl_config po1030_greenbal_cfg = {
 int po1030_probe(struct sd *sd)
 {
 	u8 dev_id_h = 0, i;
+	int err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -173,10 +174,13 @@ int po1030_probe(struct sd *sd)
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



