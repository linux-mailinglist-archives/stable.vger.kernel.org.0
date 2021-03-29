Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492934C7C4
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhC2ISK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhC2IQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B87561481;
        Mon, 29 Mar 2021 08:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005768;
        bh=077RX44+BFRkNFzqSJNAS9Tt159ikzUIBovIe/UlrTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkEQKZfjI8iuk+4TiYuDwNSuL/3LSHtT3M3QssDDsIcxxi7xe/0X4rVd2KIwSPFaA
         yLtLpwS3lCGntTdkG/bTnnU8omae4KcGyGnlpdTHYd3FqTFjLPqBihsI5KJ93XKkBl
         E0IbrRzYTQsnMpdLn1bIgejkV9oGMwCajOu4FAIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mariusz Madej <mariusz.madej@xtrack.com>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/111] can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
Date:   Mon, 29 Mar 2021 09:58:23 +0200
Message-Id: <20210329075617.705742867@linuxfoundation.org>
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

[ Upstream commit c0e399f3baf42279f48991554240af8c457535d1 ]

Message loss from RX FIFO 0 is already handled in
m_can_handle_lost_msg(), with netdev output included.

Removing this warning also improves driver performance under heavy
load, where m_can_do_rx_poll() may be called many times before this
interrupt is cleared, causing this message to be output many
times (thanks Mariusz Madej for this report).

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Link: https://lore.kernel.org/r/20210303103151.3760532-1-torin@maxiluxsystems.com
Reported-by: Mariusz Madej <mariusz.madej@xtrack.com>
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8a842545e3f6..cf72a7e464ec 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -501,9 +501,6 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	}
 
 	while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
-		if (rxfs & RXFS_RFL)
-			netdev_warn(dev, "Rx FIFO 0 Message Lost\n");
-
 		m_can_read_fifo(dev, rxfs);
 
 		quota--;
-- 
2.30.1



