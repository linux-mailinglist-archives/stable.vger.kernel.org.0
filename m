Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D13111F68
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbfLCXIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbfLCWqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A4420656;
        Tue,  3 Dec 2019 22:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413175;
        bh=OkQcdxTstU1Pzv002g0q7wkNAXVtWVcDMkq6fJScZ2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYFEGoM7PLvVvK479VYVmZylkVmlMhujptVHxyJYTNT89W/54jgnMK9IK/8lIwsgZ
         uG8fsoCoMxg08vkyu0dkhodpJqNvR/Vb8SuMye8DPk0GLL0azCqpijqO2Eg+r3vfb9
         BjKJ0nscVdkESe9FNoYBy2AMdF+KqjgHuzwrBf0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/321] can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open
Date:   Tue,  3 Dec 2019 23:31:33 +0100
Message-Id: <20191203223428.531216022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeroen Hofstee <jhofstee@victronenergy.com>

[ Upstream commit 23c5a9488f076bab336177cd1d1a366bd8ddf087 ]

When the CAN interface is closed it the hardwre is put in power down
mode, but does not reset the error counters / state. Reset the D_CAN on
open, so the reported state and the actual state match.

According to [1], the C_CAN module doesn't have the software reset.

[1] http://www.bosch-semiconductors.com/media/ip_modules/pdf_2/c_can_fd8/users_manual_c_can_fd8_r210_1.pdf

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 9b61bfbea6cd1..24c6015f6c92b 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -52,6 +52,7 @@
 #define CONTROL_EX_PDR		BIT(8)
 
 /* control register */
+#define CONTROL_SWR		BIT(15)
 #define CONTROL_TEST		BIT(7)
 #define CONTROL_CCE		BIT(6)
 #define CONTROL_DISABLE_AR	BIT(5)
@@ -572,6 +573,26 @@ static void c_can_configure_msg_objects(struct net_device *dev)
 				   IF_MCONT_RCV_EOB);
 }
 
+static int c_can_software_reset(struct net_device *dev)
+{
+	struct c_can_priv *priv = netdev_priv(dev);
+	int retry = 0;
+
+	if (priv->type != BOSCH_D_CAN)
+		return 0;
+
+	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_SWR | CONTROL_INIT);
+	while (priv->read_reg(priv, C_CAN_CTRL_REG) & CONTROL_SWR) {
+		msleep(20);
+		if (retry++ > 100) {
+			netdev_err(dev, "CCTRL: software reset failed\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Configure C_CAN chip:
  * - enable/disable auto-retransmission
@@ -581,6 +602,11 @@ static void c_can_configure_msg_objects(struct net_device *dev)
 static int c_can_chip_config(struct net_device *dev)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
+	int err;
+
+	err = c_can_software_reset(dev);
+	if (err)
+		return err;
 
 	/* enable automatic retransmission */
 	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_ENABLE_AR);
-- 
2.20.1



