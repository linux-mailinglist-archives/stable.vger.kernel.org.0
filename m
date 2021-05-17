Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BED3835D4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbhEQPZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244898AbhEQPWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 336B96100C;
        Mon, 17 May 2021 14:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262098;
        bh=9IkQ9mZeWOwq3GbBHS8mlxqs3SyzIfj0vWbQq9v08ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0P5aX7ee6XWK3BpKm4h+RGley0+33jHEFlnkW1y5Icj9ge1KK/8JPfT2XINrIgsTI
         Z1b/ciR2TTSqEyok/F+IU+aEiPqpDuL7ZJUhIOQih1j3vnRUIRgOnH1DrAI6mKdGXW
         60Lj5Xe9Fuzibld3qcdsVw4sraF94s14wMvkpW6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 215/329] can: m_can: m_can_tx_work_queue(): fix tx_skb race condition
Date:   Mon, 17 May 2021 16:02:06 +0200
Message-Id: <20210517140309.401910312@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e04b2cfe61072c7966e1a5fb73dd1feb30c206ed ]

The m_can_start_xmit() function checks if the cdev->tx_skb is NULL and
returns with NETDEV_TX_BUSY in case tx_sbk is not NULL.

There is a race condition in the m_can_tx_work_queue(), where first
the skb is send to the driver and then the case tx_sbk is set to NULL.
A TX complete IRQ might come in between and wake the queue, which
results in tx_skb not being cleared yet.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Tested-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 44b3f4b3aea5..f6c135d0a35f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1455,6 +1455,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	int i;
 	int putidx;
 
+	cdev->tx_skb = NULL;
+
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -1571,7 +1573,6 @@ static void m_can_tx_work_queue(struct work_struct *ws)
 						   tx_work);
 
 	m_can_tx_handler(cdev);
-	cdev->tx_skb = NULL;
 }
 
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
-- 
2.30.2



