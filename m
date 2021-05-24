Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E135538EC5B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhEXPOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234805AbhEXPJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2A826191F;
        Mon, 24 May 2021 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867904;
        bh=ZLSLEAHz+odBCjxBEJd4M0bW9wsgwR8skocIbqmHwt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hk5goBM0/iR2ghX4n4A7fOUW5tTneXNIasV1hzNR9O4v1L99lOfvoinNvrJtQ7yJH
         c21OK+PcRKNtSBJvCcV3DX8DZvP3QIUTvqctB3cKvLyj6GxQw7r1wMT20/8t0769TJ
         V/YwZShAHvFwSGMOqYRFVgI54TD5MwucHQemsx5WnQ1jE8JCYRtr6ZPHi9t8wpn24I
         HnioIIrtDOPkm6QsZyXl20CDYB4m3PKSuoQQheAkepMBLdHrn7riin4BZ+FCAa7Z5R
         SVpZ/DPBT+uzFFJoa5qBoG+Ab9g3Gob534PiV725nZL7CJrdr8k98WAn0aIVbQVT6t
         9JOeeVtd1jY2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/16] media: gspca: properly check for errors in po1030_probe()
Date:   Mon, 24 May 2021 10:51:25 -0400
Message-Id: <20210524145130.2499829-11-sashal@kernel.org>
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
index 4bf5c43424b7..971253dafb57 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -55,6 +55,7 @@ static const struct v4l2_ctrl_config po1030_greenbal_cfg = {
 int po1030_probe(struct sd *sd)
 {
 	u8 dev_id_h = 0, i;
+	int err;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
 	if (force_sensor) {
@@ -73,10 +74,13 @@ int po1030_probe(struct sd *sd)
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

