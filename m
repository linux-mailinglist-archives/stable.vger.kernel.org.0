Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB5396068
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhEaOZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhEaOXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F16C66141D;
        Mon, 31 May 2021 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468762;
        bh=DKm/4LqZEMd3LR14FJ9YG0VfrPqVTXlodDeLd28VrlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtYIp+tk70mHEeN+CGdyD11ymTe2aKqTHGUsd2NbyqyW/WPkH6p296fIEs5mkkEh8
         2YSLNzKujU7SIIbiIyz1FB3C+o+i0pSuvwh7zeScTGLvhUbXj5qR0bkdvbkn1gnbde
         +edZui/Fac1HyIfClwlAGLP+PgA1scELTfilJ3Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/177] Revert "media: gspca: Check the return value of write_bridge for timeout"
Date:   Mon, 31 May 2021 15:14:34 +0200
Message-Id: <20210531130651.958562011@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 8e23e83c752b54e98102627a1cc09281ad71a299 ]

This reverts commit a21a0eb56b4e8fe4a330243af8030f890cde2283.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

Different error values should never be "OR" together and expect anything
sane to come out of the result.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-63-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/m5602/m5602_po1030.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/media/usb/gspca/m5602/m5602_po1030.c
index d680b777f097..7bdbb8065146 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -154,7 +154,6 @@ static const struct v4l2_ctrl_config po1030_greenbal_cfg = {
 
 int po1030_probe(struct sd *sd)
 {
-	int rc = 0;
 	u8 dev_id_h = 0, i;
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
@@ -174,14 +173,11 @@ int po1030_probe(struct sd *sd)
 	for (i = 0; i < ARRAY_SIZE(preinit_po1030); i++) {
 		u8 data = preinit_po1030[i][2];
 		if (preinit_po1030[i][0] == SENSOR)
-			rc |= m5602_write_sensor(sd,
+			m5602_write_sensor(sd,
 				preinit_po1030[i][1], &data, 1);
 		else
-			rc |= m5602_write_bridge(sd, preinit_po1030[i][1],
-						data);
+			m5602_write_bridge(sd, preinit_po1030[i][1], data);
 	}
-	if (rc < 0)
-		return rc;
 
 	if (m5602_read_sensor(sd, PO1030_DEVID_H, &dev_id_h, 1))
 		return -ENODEV;
-- 
2.30.2



