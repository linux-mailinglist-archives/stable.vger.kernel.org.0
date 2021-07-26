Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827F43D620B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhGZPeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233965AbhGZPc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3339A60F6F;
        Mon, 26 Jul 2021 16:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316006;
        bh=v5v+jA4duPhkghHHQHMCrHTgWjQ1dqMl1WJe76HfQ2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGUOBTmwmrNwtZuw45GeBifQdqy04fxNvr2FjSu11mwjVWbyC43beBC+JOZJMpbnB
         aGUltJz8ugFjoKJsBsby90C1liT0YzGLyeL7JI1LG0OI4sS6OoRfVMt/oRc50C3qnZ
         TUXCox+gPlklZnbpaG0lbR+2SYhH8pCdNHxRXSaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 106/223] bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()
Date:   Mon, 26 Jul 2021 17:38:18 +0200
Message-Id: <20210726153849.745612812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index d57fb1613cfc..07efab5bad95 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11882,6 +11882,10 @@ static void bnxt_fw_reset_task(struct work_struct *work)
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



