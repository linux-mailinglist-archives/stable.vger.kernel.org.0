Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADE1491D63
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbiARDfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiARDdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:33:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DBFC037003;
        Mon, 17 Jan 2022 19:08:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 033B760B32;
        Tue, 18 Jan 2022 03:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9159DC36AE3;
        Tue, 18 Jan 2022 03:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475334;
        bh=4jx1Bl4S5uQyeaT0H4TWgXfSBRxVssLycfkRR4kmCkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCgnDIvH4iWVbiCmVsIZ67R78D4ZdEuXJHeWZ0xpx1tdbkBKgp1XCZP+LHoA0eynd
         F6us8nTH5ef4nKJe9s+1KrjixsFlrIBrYo+85YCHXq9rTtmt0HJr9p4NQKLVSf1+4x
         u6tttKsHwhdF49+gqEHiFnwlcx48pfM754rKCgtdf9CH+EFGvv5IBwKtNrFUJuAHoD
         W9I9G34OQOH6GlKPbddGvs64qrS79ajeMSmQCO/VQz5HRuv4uGuVGguTcH8TllPjtn
         +z787P08qBbU0F3Puh3YVDKpX3jzoXU4kH2zZfC9ZNuHhoYADiXumL6c98GA4Fu0Wm
         oqq0I4CTckicQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        rkardell@mida.se, Sasha Levin <sashal@kernel.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/29] media: m920x: don't use stack on USB reads
Date:   Mon, 17 Jan 2022 22:08:04 -0500
Message-Id: <20220118030822.1955469-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit a2ab06d7c4d6bfd0b545a768247a70463e977e27 ]

Using stack-allocated pointers for USB message data don't work.
This driver is almost OK with that, except for the I2C read
logic.

Fix it by using a temporary read buffer, just like on all other
calls to m920x_read().

Link: https://lore.kernel.org/all/ccc99e48-de4f-045e-0fe4-61e3118e3f74@mida.se/
Reported-by: rkardell@mida.se
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/m920x.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index eafc5c82467f4..5b806779e2106 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -284,6 +284,13 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 			/* Should check for ack here, if we knew how. */
 		}
 		if (msg[i].flags & I2C_M_RD) {
+			char *read = kmalloc(1, GFP_KERNEL);
+			if (!read) {
+				ret = -ENOMEM;
+				kfree(read);
+				goto unlock;
+			}
+
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction?
 				 * Send STOP, otherwise send ACK. */
@@ -291,9 +298,12 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 
 				if ((ret = m920x_read(d->udev, M9206_I2C, 0x0,
 						      0x20 | stop,
-						      &msg[i].buf[j], 1)) != 0)
+						      read, 1)) != 0)
 					goto unlock;
+				msg[i].buf[j] = read[0];
 			}
+
+			kfree(read);
 		} else {
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction? Then send STOP. */
-- 
2.34.1

