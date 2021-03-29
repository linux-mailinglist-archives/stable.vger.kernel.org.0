Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3925034CA61
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhC2Ii0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhC2Ifr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7A0619E8;
        Mon, 29 Mar 2021 08:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006920;
        bh=2Yymh7UoYzvt39/OBVceDQNNT0AXD3CzFp1nOlcBs48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tK9OfLf3frSNbe5kXSiYDwXQh3V2jOd026P/oU4512GFKxS3zM2Z2tGQ5hPGMzujb
         387uSPOl6l6VVBAEcFUvNNrN5M6H73E4erANNtc/oU2gSy54KJcGqc8c+oTyjqcwdX
         ehMR6Ber1FoDw2dUExidV2zX3J/qInPhZr098I/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 151/254] can: kvaser_pciefd: Always disable bus load reporting
Date:   Mon, 29 Mar 2021 09:57:47 +0200
Message-Id: <20210329075638.169218147@linuxfoundation.org>
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
index 969cedb9b0b6..0d77c60f775e 100644
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
@@ -949,6 +950,9 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
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



