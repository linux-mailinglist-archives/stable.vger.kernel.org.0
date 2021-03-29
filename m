Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFA34C7B6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhC2ISB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233067AbhC2IPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B594619AE;
        Mon, 29 Mar 2021 08:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005738;
        bh=aOjTAFi1KnHiVH8Emq7iphqKr4w+J7RmjkXUr4As2K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/QXyb8msFa171Fha8ZbWe4FBTtf0XXyigspwuiCm2WD7HhOqRMffvxZOe1IbBxIF
         76mzJUOOhkWLa+UK8kgavxzoOq6SHdiRFVQYEwCsSjXr+TWuwPL9k8mLffCQtqKwnz
         ewbHGurcrBaUr0h5Uu8l65qXo/XEnn+hCpzXhd18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/111] can: kvaser_pciefd: Always disable bus load reporting
Date:   Mon, 29 Mar 2021 09:58:20 +0200
Message-Id: <20210329075617.614918289@linuxfoundation.org>
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

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 7c6e6bce08f918b64459415f58061d4d6df44994 ]

Under certain circumstances, when switching from Kvaser's linuxcan driver
(kvpciefd) to the SocketCAN driver (kvaser_pciefd), the bus load reporting
is not disabled.
This is flooding the kernel log with prints like:
[3485.574677] kvaser_pciefd 0000:02:00.0: Received unexpected packet type 0x00000009

Always put the controller in the expected state, instead of assuming that
bus load reporting is inactive.

Note: If bus load reporting is enabled when the driver is loaded, you will
      still get a number of bus load packages (and printouts), before it is
      disabled.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Link: https://lore.kernel.org/r/20210309091724.31262-1-jimmyassarsson@gmail.com
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 72acd1ba162d..e7a26ec9bdc1 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -57,6 +57,7 @@ MODULE_DESCRIPTION("CAN driver for Kvaser CAN/PCIe devices");
 #define KVASER_PCIEFD_KCAN_STAT_REG 0x418
 #define KVASER_PCIEFD_KCAN_MODE_REG 0x41c
 #define KVASER_PCIEFD_KCAN_BTRN_REG 0x420
+#define KVASER_PCIEFD_KCAN_BUS_LOAD_REG 0x424
 #define KVASER_PCIEFD_KCAN_BTRD_REG 0x428
 #define KVASER_PCIEFD_KCAN_PWM_REG 0x430
 /* Loopback control register */
@@ -947,6 +948,9 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		timer_setup(&can->bec_poll_timer, kvaser_pciefd_bec_poll_timer,
 			    0);
 
+		/* Disable Bus load reporting */
+		iowrite32(0, can->reg_base + KVASER_PCIEFD_KCAN_BUS_LOAD_REG);
+
 		tx_npackets = ioread32(can->reg_base +
 				       KVASER_PCIEFD_KCAN_TX_NPACKETS_REG);
 		if (((tx_npackets >> KVASER_PCIEFD_KCAN_TX_NPACKETS_MAX_SHIFT) &
-- 
2.30.1



