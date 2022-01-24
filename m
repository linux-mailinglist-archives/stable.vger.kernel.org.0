Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34914994FA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391943AbiAXUuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35608 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389369AbiAXUkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0622761573;
        Mon, 24 Jan 2022 20:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A9C340E7;
        Mon, 24 Jan 2022 20:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056849;
        bh=sovLNmWwA9wnuElnBirZEn7t7GuDTXFhhWCtO7yz5rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjbWXJLtxFNqttOX/GRSofIMgGl097xo06k/q5tDGWUv3mxX1U4WzTorbvvksCU0H
         3Cy+DEQcrD5owSztm2Abiqhp+mgzw3lWtr2aJyE08nJqYOgY433pZZeePAU70K5eAG
         USzZw8E8lV6ZksPHpDT6kATz6gmLups+gBocQWV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/846] can: flexcan: add more quirks to describe RX path capabilities
Date:   Mon, 24 Jan 2022 19:42:18 +0100
Message-Id: <20220124184122.462222307@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c5c88591040ee7d84d037328eed9019d3ffab821 ]

Most flexcan IP cores support 2 RX modes:
- FIFO
- mailbox

Some IP core versions cannot receive CAN RTR messages via mailboxes.
This patch adds quirks to document this.

This information will be used in a later patch to switch from FIFO to
more performant mailbox mode at the expense of losing the ability to
receive RTR messages. This trade off is beneficial in certain use
cases.

Link: https://lore.kernel.org/all/20220107193105.1699523-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 66 ++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 02299befe2852..18d7bb99ec1bd 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -252,6 +252,12 @@
 #define FLEXCAN_QUIRK_NR_IRQ_3 BIT(12)
 /* Setup 16 mailboxes */
 #define FLEXCAN_QUIRK_NR_MB_16 BIT(13)
+/* Device supports RX via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX BIT(14)
+/* Device supports RTR reception via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR BIT(15)
+/* Device supports RX via FIFO */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_FIFO BIT(16)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -382,59 +388,78 @@ struct flexcan_priv {
 
 static const struct flexcan_devtype_data fsl_mcf5441x_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16,
+		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16 |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN,
+		FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx25_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
-	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
+		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
-		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_SUPPORT_FD |
-		FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
@@ -2164,8 +2189,25 @@ static int flexcan_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
-	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)) {
-		dev_err(&pdev->dev, "CAN-FD mode doesn't work with FIFO mode!\n");
+	    !((devtype_data->quirks &
+	       (FLEXCAN_QUIRK_USE_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO)) ==
+	      (FLEXCAN_QUIRK_USE_RX_MAILBOX |
+	       FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+	       FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR))) {
+		dev_err(&pdev->dev, "CAN-FD mode doesn't work in RX-FIFO mode!\n");
+		return -EINVAL;
+	}
+
+	if ((devtype_data->quirks &
+	     (FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+	      FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR)) ==
+	    FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR) {
+		dev_err(&pdev->dev,
+			"Quirks (0x%08x) inconsistent: RX_MAILBOX_RX supported but not RX_MAILBOX\n",
+			devtype_data->quirks);
 		return -EINVAL;
 	}
 
-- 
2.34.1



