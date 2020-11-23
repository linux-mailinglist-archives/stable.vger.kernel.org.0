Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2172C2C0B25
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbgKWNU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732239AbgKWMjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2F52065E;
        Mon, 23 Nov 2020 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135162;
        bh=lGAiTNLPpgZHf6Z751ZJKF2JpgaVX5LuiCr1mKXV1pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTODjHdLv0JNymj/SYQV6G3ppTqTsqAUSMWqsroqckxYbWU12N0I3PCKfA0A8Nhqg
         wEoX8j6YKzniUwLIX71UrRUxuRU2zAe+mH8Z0Zq0FNCVgpTABy+FJUprsEnSoypmf8
         kYI7O3hqwrKQMEAPTsq6Ys+mrTCyFx6hjWyCmK9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/158] can: m_can: m_can_stop(): set device to software init mode before closing
Date:   Mon, 23 Nov 2020 13:21:55 +0100
Message-Id: <20201123121824.131320309@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit a584e9bc1b7e88f24f8504886eafbe6c73d8a97c ]

There might be some requests pending in the buffer when the interface close
sequence occurs. In some devices, these pending requests might lead to the
module not shutting down properly when m_can_clk_stop() is called.

Therefore, move the device to init state before potentially powering it down.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200825055442.16994-1-faiz_abbas@ti.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 85e3df24e7bfb..661db85d569ce 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1366,6 +1366,9 @@ static void m_can_stop(struct net_device *dev)
 	/* disable all interrupts */
 	m_can_disable_all_interrupts(cdev);
 
+	/* Set init mode to disengage from the network */
+	m_can_config_endisable(cdev, true);
+
 	/* set the state as STOPPED */
 	cdev->can.state = CAN_STATE_STOPPED;
 }
-- 
2.27.0



