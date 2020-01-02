Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928FC12EF98
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgABW3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbgABW3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:29:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F51C21835;
        Thu,  2 Jan 2020 22:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004179;
        bh=MvCa2z4IbcYYzFMqERVrXJWC8cppStZn4lCDgcHEnIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYp9poZWCto7FfunQr8qdfxP7UDm63qiYDKup4alF6Nzb9jPrPYYFBIQ5OnIIY39f
         NAenziga1SLkOZ72F6ZtQ0uQNqiYkRtM+PWyBtK4h5kZBm8GCnbbAkD64Sv9nZGej6
         9SEKgNPpl1Wpd9flGAOe9fDZYd8G5mTABgtx3yes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 046/171] bnx2x: Fix PF-VF communication over multi-cos queues.
Date:   Thu,  2 Jan 2020 23:06:17 +0100
Message-Id: <20200102220553.349350125@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit dc5a3d79c345871439ffe72550b604fcde9770e1 ]

PF driver doesn't enable tx-switching for all cos queues/clients,
which causes packets drop from PF to VF. Fix this by enabling
tx-switching on all cos queues/clients.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.c    | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index c6e059119b22..e8a09d0afe1c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -2376,15 +2376,21 @@ static int bnx2x_set_pf_tx_switching(struct bnx2x *bp, bool enable)
 	/* send the ramrod on all the queues of the PF */
 	for_each_eth_queue(bp, i) {
 		struct bnx2x_fastpath *fp = &bp->fp[i];
+		int tx_idx;
 
 		/* Set the appropriate Queue object */
 		q_params.q_obj = &bnx2x_sp_obj(bp, fp).q_obj;
 
-		/* Update the Queue state */
-		rc = bnx2x_queue_state_change(bp, &q_params);
-		if (rc) {
-			BNX2X_ERR("Failed to configure Tx switching\n");
-			return rc;
+		for (tx_idx = FIRST_TX_COS_INDEX;
+		     tx_idx < fp->max_cos; tx_idx++) {
+			q_params.params.update.cid_index = tx_idx;
+
+			/* Update the Queue state */
+			rc = bnx2x_queue_state_change(bp, &q_params);
+			if (rc) {
+				BNX2X_ERR("Failed to configure Tx switching\n");
+				return rc;
+			}
 		}
 	}
 
-- 
2.20.1



