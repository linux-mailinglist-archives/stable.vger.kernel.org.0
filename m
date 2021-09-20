Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADB4124AB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380434AbhITSgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380607AbhITSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD4361AAB;
        Mon, 20 Sep 2021 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158922;
        bh=HzmyB4NeliNYJMcapaVYsLThk20FbsJ+EoGdMF6U8Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isTDm0RW+27bynbS0oG7tRB/v6NOPE2q3+qBSpXiE6xvUnDc2w2nuKYqiDB/g4DT+
         XXH6Y7k7KMViqY16ydyZWeQ2HedDBlbCiCFZLWSs18v/nC+FMEvIoSYUW/SoVSGH0H
         abjZZ0MZqDJKLGeme45f9lciDhwMg7rFxirf1Vxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/122] bnxt_en: Improve logging of error recovery settings information.
Date:   Mon, 20 Sep 2021 18:44:49 +0200
Message-Id: <20210920163919.650215064@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit f4d95c3c194de04ae7b44f850131321c7ceb9312 ]

We currently only log the error recovery settings if it is enabled.
In some cases, firmware disables error recovery after it was
initially enabled.  Without logging anything, the user will not be
aware of this change in setting.

Log it when error recovery is disabled.  Also, change the reset count
value from hexadecimal to decimal.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 563a169e06ca..4c1c41495e9f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2114,14 +2114,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 
 		fw_health->enabled = EVENT_DATA1_RECOVERY_ENABLED(data1);
 		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
-		if (!fw_health->enabled)
+		if (!fw_health->enabled) {
+			netif_info(bp, drv, bp->dev,
+				   "Error recovery info: error recovery[0]\n");
 			break;
-
-		netif_info(bp, drv, bp->dev,
-			   "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
-			   fw_health->enabled, fw_health->master,
-			   bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG),
-			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
+		}
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
@@ -2130,6 +2127,10 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
 		fw_health->last_fw_reset_cnt =
 			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		netif_info(bp, drv, bp->dev,
+			   "Error recovery info: error recovery[1], master[%d], reset count[%u], health status: 0x%x\n",
+			   fw_health->master, fw_health->last_fw_reset_cnt,
+			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
-- 
2.30.2



