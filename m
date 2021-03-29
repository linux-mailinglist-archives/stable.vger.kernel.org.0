Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B429D34CA64
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhC2Ii1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233599AbhC2Ifx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE3B16195B;
        Mon, 29 Mar 2021 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006928;
        bh=XB90kKCUcPpcabc7lrpg59WezPOjiqU8dGO/bCClFgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIKXh4DcEcuB8mnTwieoC2byDa8I/5pFjUeRixAxcfwrwZherAzcSVkoWgG2MYYtM
         Cih5bicw9Z4mtuJ/+ApX91uAFNjqQ0c7Hd5CU2HGr6aZc71guQMhBHdOJiGsctjfKi
         Rr17aCR4KZGZTcMsayDgVhzJOLtWxBjtoMM8H0M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mariusz Madej <mariusz.madej@xtrack.com>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 154/254] can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
Date:   Mon, 29 Mar 2021 09:57:50 +0200
Message-Id: <20210329075638.268608957@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index da551fd0f502..678679a8c907 100644
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



