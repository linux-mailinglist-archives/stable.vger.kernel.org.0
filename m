Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B87E4124A6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379952AbhITSgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380562AbhITSe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29C26330C;
        Mon, 20 Sep 2021 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158916;
        bh=OuoYNISQKaS+VW8KpV7xBcXXNd7ZlUJVKae6lHk9z9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOuNpKRE+TasI2D+5LM1X3QLyVUWdWp9MDDFZ+NGhrh75jr2mE7Old54Rwzw1N1u3
         GrRRafqfIKc7xe+fdwpUGopBFHxl0ccK6wGECN3qaQER6p7Y27XG0+Zk5mvGd1HUFH
         KyGFykrhXO7WzynwkjqniQWFAIsijWsVesSmq0Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/122] bnxt_en: log firmware debug notifications
Date:   Mon, 20 Sep 2021 18:44:46 +0200
Message-Id: <20210920163919.553785546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit a44daa8fcbcf572545c4c1a7908b3fbb38388048 ]

Firmware is capable of generating asynchronous debug notifications.
The event data is opaque to the driver and is simply logged. Debug
notifications can be enabled by turning on hardware status messages
using the ethtool msglvl interface.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1def6caba349..621634d40966 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -272,6 +272,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
+	ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION,
 	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
 };
 
@@ -2132,6 +2133,13 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
+		if (netif_msg_hw(bp)) {
+			netdev_notice(bp->dev,
+				      "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
+				      data1, data2);
+		}
+		goto async_event_process_exit;
 	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
 		struct bnxt_rx_ring_info *rxr;
 		u16 grp_idx;
-- 
2.30.2



