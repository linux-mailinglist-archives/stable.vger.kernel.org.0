Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A18412643
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386256AbhITS4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385807AbhITSw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F4163383;
        Mon, 20 Sep 2021 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159318;
        bh=AV3XuGOzlaAqvqRuTjT43u2zLAVdU4oHwauY6QUT+jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8/JU6d/nbi5xHvdg3ivGKpjnqMnTPCreC1qpAV6lpLTqTqhImlyyIYAHjwXlfvlp
         RZij61Tk5yyeTRI4ozl4tA8hOuj4riKekEhwFvTyZ2YRnPNtK7LFA97u44sYxmUouE
         p9GvzB50G/Ah36NR+OiQQiV8XgIgtyJHIcm1GLCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 164/168] bnxt_en: Fix possible unintended driver initiated error recovery
Date:   Mon, 20 Sep 2021 18:45:02 +0200
Message-Id: <20210920163927.070105317@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1b2b91831983aeac3adcbb469aa8b0dc71453f89 ]

If error recovery is already enabled, bnxt_timer() will periodically
check the heartbeat register and the reset counter.  If we get an
error recovery async. notification from the firmware (e.g. change in
primary/secondary role), we will immediately read and update the
heartbeat register and the reset counter.  If the timer for the next
health check expires soon after this, we may read the heartbeat register
again in quick succession and find that it hasn't changed.  This will
trigger error recovery unintentionally.

The likelihood is small because we also reset fw_health->tmr_counter
which will reset the interval for the next health check.  But the
update is not protected and bnxt_timer() can miss the update and
perform the health check without waiting for the full interval.

Fix it by only reading the heartbeat register and reset counter in
bnxt_async_event_process() if error recovery is trasitioning to the
enabled state.  Also add proper memory barriers so that when enabling
for the first time, bnxt_timer() will see the tmr_counter interval and
perform the health check after the full interval has elapsed.

Fixes: 7e914027f757 ("bnxt_en: Enable health monitoring.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 25 ++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1acf8633399f..2660dfc6875a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2172,25 +2172,34 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!fw_health)
 			goto async_event_process_exit;
 
-		fw_health->enabled = EVENT_DATA1_RECOVERY_ENABLED(data1);
-		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
-		if (!fw_health->enabled) {
+		if (!EVENT_DATA1_RECOVERY_ENABLED(data1)) {
+			fw_health->enabled = false;
 			netif_info(bp, drv, bp->dev,
 				   "Error recovery info: error recovery[0]\n");
 			break;
 		}
+		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
 		fw_health->tmr_counter = fw_health->tmr_multiplier;
-		fw_health->last_fw_heartbeat =
-			bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
-		fw_health->last_fw_reset_cnt =
-			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		if (!fw_health->enabled) {
+			fw_health->last_fw_heartbeat =
+				bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
+			fw_health->last_fw_reset_cnt =
+				bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		}
 		netif_info(bp, drv, bp->dev,
 			   "Error recovery info: error recovery[1], master[%d], reset count[%u], health status: 0x%x\n",
 			   fw_health->master, fw_health->last_fw_reset_cnt,
 			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
+		if (!fw_health->enabled) {
+			/* Make sure tmr_counter is set and visible to
+			 * bnxt_health_check() before setting enabled to true.
+			 */
+			smp_wmb();
+			fw_health->enabled = true;
+		}
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
@@ -11250,6 +11259,8 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	if (!fw_health->enabled || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return;
 
+	/* Make sure it is enabled before checking the tmr_counter. */
+	smp_rmb();
 	if (fw_health->tmr_counter) {
 		fw_health->tmr_counter--;
 		return;
-- 
2.30.2



