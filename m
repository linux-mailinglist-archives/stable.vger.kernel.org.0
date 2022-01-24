Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41302498A4B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiAXTCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57388 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbiAXTAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B27FCB8119D;
        Mon, 24 Jan 2022 19:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2837C340E5;
        Mon, 24 Jan 2022 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050807;
        bh=4jx1Bl4S5uQyeaT0H4TWgXfSBRxVssLycfkRR4kmCkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaYt9ENsPHL31F3ng/UEsgKGmXW/2Sh2PjUe68INQrCSlDyFZObqonXN0swwjVy2E
         qaa36zOmWnlmck1TQRKfOMRgqj6Rggs8UUDMOdlSayY4ySyaWYrXKODa22h59EjMtX
         qXEQe4xaNouaMExAlBe4zgJ6qnIseb1963gx07r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rkardell@mida.se,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/157] media: m920x: dont use stack on USB reads
Date:   Mon, 24 Jan 2022 19:42:55 +0100
Message-Id: <20220124183935.484109346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



