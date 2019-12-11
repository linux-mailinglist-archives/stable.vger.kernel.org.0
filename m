Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924FC11B556
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbfLKPTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbfLKPTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B342073D;
        Wed, 11 Dec 2019 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077564;
        bh=ksPY1Q/x6/FCK+zIqenNAMFA9z6T+2px13YnVzmYDMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+48u+PBfl3k8wwx3lOKe3OTuGwFm4Jvjzt5kW8cM7dY2s8Te+y2ARgZkTCNjtXM6
         TnwoPYDZIsn1w9u99Mkbh8GopNiOM7QT3kZRA8+5t0dRqrVGsdoPWvrrda2XWjANTV
         fsbxw5njh/6NtGmqtR8lElB91d0CC2a8eG0tDRLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/243] USB: serial: f81534: fix reading old/new IC config
Date:   Wed, 11 Dec 2019 16:03:51 +0100
Message-Id: <20191211150343.758928804@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>

[ Upstream commit ab60075f2a4eebca1abb04f712569963fb4d9d6c ]

The F81532/534 had a internal configuration space to save & control
IC state with address F81534_CUSTOM_ADDRESS_START (0x2f00). Layout
as following:
	+00h: to indicate the section is valid
	+01h~04h: UART Mode & port availability
	+05h~08h: Output pin control on IC power on
	+09h~12h: Output pin control on working <-- New added

Old driver will use +05~08h as default on working, but newer IC will
configed with shutdown mode(7) in 05h~08h and working mode with RS232(1)
in 09h~12h. It'll make mainstream driver not working.

This patch will make mainstream driver compatible older and newer IC.
If using a old IC, the +05h~08h will be 00h~06h, we'll direct apply it.
If using a new IC, the +05h~08h will be 07h or larger, we'll read +09h~12h
to apply newer configuration.

Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/f81534.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/f81534.c b/drivers/usb/serial/f81534.c
index 4dfbff20bda4c..db6c93c04b3c8 100644
--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -45,14 +45,17 @@
 #define F81534_CONFIG1_REG		(0x09 + F81534_UART_BASE_ADDRESS)
 
 #define F81534_DEF_CONF_ADDRESS_START	0x3000
-#define F81534_DEF_CONF_SIZE		8
+#define F81534_DEF_CONF_SIZE		12
 
 #define F81534_CUSTOM_ADDRESS_START	0x2f00
 #define F81534_CUSTOM_DATA_SIZE		0x10
 #define F81534_CUSTOM_NO_CUSTOM_DATA	0xff
 #define F81534_CUSTOM_VALID_TOKEN	0xf0
 #define F81534_CONF_OFFSET		1
-#define F81534_CONF_GPIO_OFFSET		4
+#define F81534_CONF_INIT_GPIO_OFFSET	4
+#define F81534_CONF_WORK_GPIO_OFFSET	8
+#define F81534_CONF_GPIO_SHUTDOWN	7
+#define F81534_CONF_GPIO_RS232		1
 
 #define F81534_MAX_DATA_BLOCK		64
 #define F81534_MAX_BUS_RETRY		20
@@ -1359,8 +1362,19 @@ static int f81534_set_port_output_pin(struct usb_serial_port *port)
 	serial_priv = usb_get_serial_data(serial);
 	port_priv = usb_get_serial_port_data(port);
 
-	idx = F81534_CONF_GPIO_OFFSET + port_priv->phy_num;
+	idx = F81534_CONF_INIT_GPIO_OFFSET + port_priv->phy_num;
 	value = serial_priv->conf_data[idx];
+	if (value >= F81534_CONF_GPIO_SHUTDOWN) {
+		/*
+		 * Newer IC configure will make transceiver in shutdown mode on
+		 * initial power on. We need enable it before using UARTs.
+		 */
+		idx = F81534_CONF_WORK_GPIO_OFFSET + port_priv->phy_num;
+		value = serial_priv->conf_data[idx];
+		if (value >= F81534_CONF_GPIO_SHUTDOWN)
+			value = F81534_CONF_GPIO_RS232;
+	}
+
 	pins = &f81534_port_out_pins[port_priv->phy_num];
 
 	for (i = 0; i < ARRAY_SIZE(pins->pin); ++i) {
-- 
2.20.1



