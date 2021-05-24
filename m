Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49A138EA99
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhEXO44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233119AbhEXOx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F3C6141B;
        Mon, 24 May 2021 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867711;
        bh=/5mkWMxrniQRM0OIO+l/RFMqZzon2mnA8svi+4FOsBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzQlC6QQBjvpnPWsag1biNvQ3utDrFozd2Bk5V1BlB3BkC6A1YTBvM2wcpcu6fW3z
         EAmyUX1RWzWHuNH5r1kxGa91K7falNwb9fLDOMWLAQatM3k/4AGUWP6hxSLo0PYUd/
         3pPBbEuBGG1MiyUYRqj67P92hBWBmAOv/UZKXGKiEZTJxIibxTKQ18juBodc6fUVWw
         9/FdsQJXKXakpfoPZv3vZ4s4NfgpJ5ogNCX4IfSRb0FG94v1vzLDpiGrt2asoYl+2U
         Z8iJRjOpopLEWr4RIR1jI4NyQigd9VeWjfhvQQ5E5c/9vve1ET/Uxb4pTICt1hLQ2m
         hDrEhpkVsREyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/62] media: gspca: properly check for errors in po1030_probe()
Date:   Mon, 24 May 2021 10:47:19 -0400
Message-Id: <20210524144744.2497894-38-sashal@kernel.org>
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

