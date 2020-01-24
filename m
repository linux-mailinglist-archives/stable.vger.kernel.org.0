Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A198148481
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgAXLLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbgAXLK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:10:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B05320663;
        Fri, 24 Jan 2020 11:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864257;
        bh=w9gU8MpJ2KXjD8KCVg0qRTU/5thYmsM2eeneluKZ1Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSmaSiop60E2sgy1GpyuxOAeoFMqFtOTReVauLzUMNbvg8CQr5cx5BRG+L7jzcND2
         qDBnTes83+6vuEqRpLv//9sy17nlq9M80qa4gvyONgd00q+KsdPPs14ScX1t2JW9vt
         mvp/yr7Sw3drRs1WaMNfEPJ/HaAPUbRwWjfnD2tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/639] net: dsa: qca8k: Enable delay for RGMII_ID mode
Date:   Fri, 24 Jan 2020 10:26:26 +0100
Message-Id: <20200124093114.027149724@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit a968b5e9d5879f9535d6099505f9e14abcafb623 ]

RGMII_ID specifies that we should have internal delay, so resurrect the
delay addition routine but under the RGMII_ID mode.

Fixes: 40269aa9f40a ("net: dsa: qca8k: disable delay for RGMII mode")
Tested-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca8k.c | 12 ++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 33232cc9fb04d..6c04f32e96418 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -451,6 +451,18 @@ qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
 		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		/* RGMII_ID needs internal delay. This is enabled through
+		 * PORT5_PAD_CTRL for all ports, rather than individual port
+		 * registers
+		 */
+		qca8k_write(priv, reg,
+			    QCA8K_PORT_PAD_RGMII_EN |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		break;
 	case PHY_INTERFACE_MODE_SGMII:
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 		break;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 613fe5c50236c..d146e54c8a6c6 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -40,6 +40,7 @@
 						((0x8 + (x & 0x3)) << 22)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
 						((0x10 + (x & 0x3)) << 20)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
-- 
2.20.1



