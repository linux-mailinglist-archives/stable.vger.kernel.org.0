Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2838305B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhEQO0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239549AbhEQOYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 806B6613D8;
        Mon, 17 May 2021 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260774;
        bh=78lOjUkP4NZDr4zyoU7dXRmggRszU0d7vbXK+8DvjTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPSAFdmo520nabiAnk92IXZAfO+wOq3+2WQzCTAqraKHsf0PBRmQ7f5zIl1oEbF5b
         0qche3/cVC04GsDTrX8n9XxqJHs+7w01b2CQYMPGCjNGOUhXev4KFJIqNQyyZoRitI
         +Iv/ijiVisQ0dGQYWuIvppprMJLXzmjIjipG28ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 233/363] can: m_can: m_can_tx_work_queue(): fix tx_skb race condition
Date:   Mon, 17 May 2021 16:01:39 +0200
Message-Id: <20210517140310.456885137@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 0c8d36bc668c..f71127229caf 100644
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



