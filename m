Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E39E12284F
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfLQKIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:08:12 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:40079 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLQKIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 05:08:11 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 47cYjz3GZwz1qv2x;
        Tue, 17 Dec 2019 11:08:07 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 47cYjz2Z3mz1r0n8;
        Tue, 17 Dec 2019 11:08:07 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id LVBJyw7uh_iC; Tue, 17 Dec 2019 11:08:06 +0100 (CET)
X-Auth-Info: dr12vmsJmv00RDQi62FtkfPFZZHSFt36jHq/A6RkKRw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 17 Dec 2019 11:08:05 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     linux-can@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Bich Hemon <bich.hemon@st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "J . D . Schroeder" <jay.schroeder@garmin.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Roger Quadros <rogerq@ti.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH] can: m_can: Fix default pinmux glitch at init
Date:   Tue, 17 Dec 2019 11:07:40 +0100
Message-Id: <20191217100740.2687835-1-marex@denx.de>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current code causes a slight glitch on the pinctrl settings when used.
Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
the device core will automatically set the default pins. This causes the pins
to be momentarily set to the default and then to the sleep state in
register_m_can_dev(). By adding an optional "enable" state, boards can set the
default pin state to be disabled and avoid the glitch when the switch from
default to sleep first occurs. If the "enable" state is not available
pinctrl_get_select() falls back to using the "default" pinctrl state.

Fixes: c9b3bce18da4 ("can: m_can: select pinctrl state in each suspend/resume function")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Bich Hemon <bich.hemon@st.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: J.D. Schroeder <jay.schroeder@garmin.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Roger Quadros <rogerq@ti.com>
Cc: linux-stable <stable@vger.kernel.org>
To: linux-can@vger.kernel.org
---
NOTE: This is commit 033365191136 ("can: c_can: Fix default pinmux glitch at init")
      adapted for m_can driver.
---
 drivers/net/can/m_can/m_can.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b73936..afb6760b17427 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1243,12 +1243,20 @@ static void m_can_chip_config(struct net_device *dev)
 static void m_can_start(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	struct pinctrl *p;
 
 	/* basic m_can configuration */
 	m_can_chip_config(dev);
 
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
+	/* Attempt to use "active" if available else use "default" */
+	p = pinctrl_get_select(cdev->dev, "active");
+	if (!IS_ERR(p))
+		pinctrl_put(p);
+	else
+		pinctrl_pm_select_default_state(cdev->dev);
+
 	m_can_enable_all_interrupts(cdev);
 }
 
-- 
2.24.0.525.g8f36a354ae

