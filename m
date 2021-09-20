Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BED4124AA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379744AbhITSgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380596AbhITSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF44061AA8;
        Mon, 20 Sep 2021 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158918;
        bh=Z0i/wgHZQjp8XjtvtAB1vAOhdowv7/mze2FCA0FLJVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnpNHOm43snCw1D4Jj1/YuQ8HfCD4Fq2YPO4m7yz5qKpdatp2kVRQngRhthYrih9J
         DvWzcqf8I00AwDw8qvL11G9pvhs9U38xtEK/pwsIqnA3+rLqhQGsk6OAjznmo/JEkK
         ZsLCqVCdFfvHGXcTmPJMcGDmZ1DuH3RFuD/Dhiso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/122] bnxt_en: Consolidate firmware reset event logging.
Date:   Mon, 20 Sep 2021 18:44:47 +0200
Message-Id: <20210920163919.585499246@linuxfoundation.org>
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

[ Upstream commit 5863b10aa86a5f5f69a25b55a5c15806c834471a ]

Combine the three netdev_warn() calls into a single call, printed at
the NETIF_MSG_HW log level.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 621634d40966..4ee77e1c8de0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2082,10 +2082,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
-	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY:
-		if (netif_msg_hw(bp))
-			netdev_warn(bp->dev, "Received RESET_NOTIFY event, data1: 0x%x, data2: 0x%x\n",
-				    data1, data2);
+	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
+		char *fatal_str = "non-fatal";
+
 		if (!bp->fw_health)
 			goto async_event_process_exit;
 
@@ -2097,14 +2096,18 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!bp->fw_reset_max_dsecs)
 			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
 		if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
-			netdev_warn(bp->dev, "Firmware fatal reset event received\n");
+			fatal_str = "fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
-		} else {
-			netdev_warn(bp->dev, "Firmware non-fatal reset event received, max wait time %d msec\n",
+		}
+		if (netif_msg_hw(bp)) {
+			netdev_warn(bp->dev, "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
+				    fatal_str, data1, data2,
+				    bp->fw_reset_min_dsecs * 100,
 				    bp->fw_reset_max_dsecs * 100);
 		}
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
 		break;
+	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
 
-- 
2.30.2



