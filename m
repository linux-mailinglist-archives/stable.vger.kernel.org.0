Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE3B34C7C6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhC2ISL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhC2IQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C636044F;
        Mon, 29 Mar 2021 08:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005771;
        bh=qoUxGxk9gJE2+hpBf/VZrCxTVRJNIWJ2wIMtvFpXqW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7+rtNnpjzqKn3kDi0Vq6DgUOcBWZ1ZsesYJP44NN+vMcxiF0bYJtsQLgzspu0kk8
         ENac1mXOiBcEFSRmstfkHtb9y10dAVUg9TG6k9ZnvZvtiIJz2y2Z5hDWudj+bIdvNR
         BLrdyByQMXv3g/GjfkO0Ya0dF9yZ73M7FbVqCIcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/111] can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors
Date:   Mon, 29 Mar 2021 09:58:24 +0200
Message-Id: <20210329075617.744814279@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

[ Upstream commit e98d9ee64ee2cc9b1d1a8e26610ec4d0392ebe50 ]

For M_CAN peripherals, m_can_rx_handler() was called with quota = 1,
which caused any error handling to block RX from taking place until
the next time the IRQ handler is called. This had been observed to
cause RX to be blocked indefinitely in some cases.

This is fixed by calling m_can_rx_handler with a sensibly high quota.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Link: https://lore.kernel.org/r/20210303144350.4093750-1-torin@maxiluxsystems.com
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index cf72a7e464ec..b2224113987c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -839,7 +839,7 @@ static int m_can_rx_peripheral(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
-	m_can_rx_handler(dev, 1);
+	m_can_rx_handler(dev, M_CAN_NAPI_WEIGHT);
 
 	m_can_enable_all_interrupts(cdev);
 
-- 
2.30.1



