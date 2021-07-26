Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C763D6086
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhGZPW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237404AbhGZPWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0C960240;
        Mon, 26 Jul 2021 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315396;
        bh=j3wE9b5BjrC6n/xTO2y74WujNoBcqvyf2zLfTFFuLzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2fVLN0AvaQ6Och/aKSnu4gFpVJGG3R/sCPvweiIKlitXUVS+qr26l+z7Vyx3alyt
         qTHTeOOujA9EkiuPljAtUj3Qnd0tt2rC1+GvXHQgjU0rQ9TULH+AjJjoZ+5P6PCF5U
         iNQBvtzbcERC1i+2FXP3nqmd0RO4a8WVoL4GtJ/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/167] bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()
Date:   Mon, 26 Jul 2021 17:38:34 +0200
Message-Id: <20210726153842.134771885@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 6cd657cb3ee6f4de57e635b126ffbe0e51d00f1a ]

In the BNXT_FW_RESET_STATE_POLL_VF state in bnxt_fw_reset_task() after all
VFs have unregistered, we need to check for BNXT_STATE_ABORT_ERR after
we acquire the rtnl_lock.  If the flag is set, we need to abort.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f003f08de167..dee6bcfe2fe2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11480,6 +11480,10 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		bp->fw_reset_timestamp = jiffies;
 		rtnl_lock();
+		if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+			rtnl_unlock();
+			goto fw_reset_abort;
+		}
 		bnxt_fw_reset_close(bp);
 		if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
 			bp->fw_reset_state = BNXT_FW_RESET_STATE_POLL_FW_DOWN;
-- 
2.30.2



