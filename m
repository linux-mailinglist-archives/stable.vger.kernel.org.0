Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE0934C6BE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhC2IJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231597AbhC2IJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3179D61976;
        Mon, 29 Mar 2021 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005339;
        bh=l0TnfoC3iwcbasXlWt60i7coeKpZBz6xlaNVQi6hvsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQRwYwPQomoV/kXXumyYn2I1oIrNsFZ5wGdS3FOtjTix7oEdhpqIwOaaZxzn+65TJ
         54r8XbFrvKx5gNcMbp+LAhAdnsc2Y/OHIPtI0w5OIERSCN2ADQiiZ6+qHS3EfOq1ZU
         Qc+Bu6Yl8ofk+j2/m1vnSDtqRZbzpoSPd84ROaLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mariusz Madej <mariusz.madej@xtrack.com>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/72] can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
Date:   Mon, 29 Mar 2021 09:58:23 +0200
Message-Id: <20210329075611.837841245@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
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
index fbb970220c2d..e87c3bb82081 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -520,9 +520,6 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	}
 
 	while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
-		if (rxfs & RXFS_RFL)
-			netdev_warn(dev, "Rx FIFO 0 Message Lost\n");
-
 		m_can_read_fifo(dev, rxfs);
 
 		quota--;
-- 
2.30.1



