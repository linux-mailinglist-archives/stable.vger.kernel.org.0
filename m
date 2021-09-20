Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA47D4124AF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380986AbhITSg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380610AbhITSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05EDD6330F;
        Mon, 20 Sep 2021 17:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158920;
        bh=bbfVFoNYlRAexRplA8afQH8H/ZNqTdNC9aME4H2hnXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpmL8wFbq0SIXh8MutKdeTXmgSZMxhFl0kxIt78/lm49cIbaS3aa6kHgsVOBKOvFH
         BXc7jo6oHXznou7Lo7LQIBx+8a0fv8vinZO98nlT7LInCFTz0g7MPcC/hMoh6zO6Qf
         2hOEKh3X5HcSqUcgGa901wVwDDopwMAI6S0hynQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/122] bnxt_en: Convert to use netif_level() helpers.
Date:   Mon, 20 Sep 2021 18:44:48 +0200
Message-Id: <20210920163919.617145875@linuxfoundation.org>
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

[ Upstream commit 871127e6ab0d6abb904cec81fc022baf6953be1f ]

Use the various netif_level() helpers to simplify the C code.  This was
suggested by Joe Perches.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1611642024-3166-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 ++++++++++-------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4ee77e1c8de0..563a169e06ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1305,8 +1305,7 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	} else {
 		tpa_info->hash_type = PKT_HASH_TYPE_NONE;
 		tpa_info->gso_type = 0;
-		if (netif_msg_rx_err(bp))
-			netdev_warn(bp->dev, "TPA packet without valid hash\n");
+		netif_warn(bp, rx_err, bp->dev, "TPA packet without valid hash\n");
 	}
 	tpa_info->flags2 = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_flags2);
 	tpa_info->metadata = le32_to_cpu(tpa_start1->rx_tpa_start_cmp_metadata);
@@ -2099,12 +2098,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			fatal_str = "fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		}
-		if (netif_msg_hw(bp)) {
-			netdev_warn(bp->dev, "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
-				    fatal_str, data1, data2,
-				    bp->fw_reset_min_dsecs * 100,
-				    bp->fw_reset_max_dsecs * 100);
-		}
+		netif_warn(bp, hw, bp->dev,
+			   "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
+			   fatal_str, data1, data2,
+			   bp->fw_reset_min_dsecs * 100,
+			   bp->fw_reset_max_dsecs * 100);
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
 		break;
 	}
@@ -2119,13 +2117,11 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!fw_health->enabled)
 			break;
 
-		if (netif_msg_drv(bp))
-			netdev_info(bp->dev, "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
-				    fw_health->enabled, fw_health->master,
-				    bnxt_fw_health_readl(bp,
-							 BNXT_FW_RESET_CNT_REG),
-				    bnxt_fw_health_readl(bp,
-							 BNXT_FW_HEALTH_REG));
+		netif_info(bp, drv, bp->dev,
+			   "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
+			   fw_health->enabled, fw_health->master,
+			   bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG),
+			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
@@ -2137,11 +2133,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
-		if (netif_msg_hw(bp)) {
-			netdev_notice(bp->dev,
-				      "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
-				      data1, data2);
-		}
+		netif_notice(bp, hw, bp->dev,
+			     "Received firmware debug notification, data1: 0x%x, data2: 0x%x\n",
+			     data1, data2);
 		goto async_event_process_exit;
 	case ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG: {
 		struct bnxt_rx_ring_info *rxr;
-- 
2.30.2



