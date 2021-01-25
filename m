Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46707304B36
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbhAZEss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730007AbhAYSpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B38224D4;
        Mon, 25 Jan 2021 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600304;
        bh=A6Tuk1W0KU1j65fNYQ13cRoK160I/YaFsQapL9FOrNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgVH3JMbZ/x7QKrTg8Hr5Zpk+ifLKoWwJoqp88A6SumRgzyYMcSr34gfSE/4q1g8T
         j9PSM3o/AR+syVh8m0ZP9T9b3xFy7XUovWLvChKCl1q2/kWevFBIt5HCmASfl5buZB
         Uk2ePH6ehQkWn5dM97KelB/7jfqL0XdG64/DdRxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/86] can: peak_usb: fix use after free bugs
Date:   Mon, 25 Jan 2021 19:39:33 +0100
Message-Id: <20210125183203.205554514@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 50aca891d7a554db0901b245167cd653d73aaa71 ]

After calling peak_usb_netif_rx_ni(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is accessed
after the peak_usb_netif_rx_ni().

Reordering the lines solves the issue.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Link: https://lore.kernel.org/r/20210120114137.200019-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index dee3e689b54da..96bbdef672bc9 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -512,11 +512,11 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 	else
 		memcpy(cfd->data, rm->d, cfd->len);
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(rm->ts_low));
-
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cfd->len;
 
+	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(rm->ts_low));
+
 	return 0;
 }
 
@@ -578,11 +578,11 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 	if (!skb)
 		return -ENOMEM;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
-
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cf->can_dlc;
 
+	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
+
 	return 0;
 }
 
-- 
2.27.0



