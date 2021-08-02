Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B0A3DD9B8
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhHBODR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhHBOBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD62D611F2;
        Mon,  2 Aug 2021 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912592;
        bh=k+RdHU1r+os3V+84IRDdh50azqQ888IS+VnuIL+aiRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSA2ESb563S5kClpSs0A1vqEekb9xWWaRrjtmjpOoVcAMuJ1T8TCTgX3fzxBE8BN5
         F2bhao25pLFEKEbuIrPZa/ZZ2ay/w7sDSwn9rUdTfYthcsNeWEUILkyQZb2iY+KAod
         k6n5xbJWTBwKwgyqyCxlnEReFHeW6Tahi8TBH004=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 063/104] octeontx2-pf: Dont enable backpressure on LBK links
Date:   Mon,  2 Aug 2021 15:45:00 +0200
Message-Id: <20210802134346.068728534@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 4c85e57575fb9e6405d02d55aef8025c60abb824 ]

Avoid configure backpressure for LBK links as they
don't support it and enable lmacs before configuration
pause frames.

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fac6474ad694..f43cb1407e8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1243,8 +1243,8 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		/* Add reference */
 		cgx->lmac_idmap[lmac->lmac_id] = lmac;
-		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, true);
 		set_bit(lmac->lmac_id, &cgx->lmac_bmap);
+		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, true);
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cf7875d51d87..16ba457197a2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -921,12 +921,14 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		aq->cq.drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, cq->cqe_cnt);
 		aq->cq.drop_ena = 1;
 
-		/* Enable receive CQ backpressure */
-		aq->cq.bp_ena = 1;
-		aq->cq.bpid = pfvf->bpid[0];
+		if (!is_otx2_lbkvf(pfvf->pdev)) {
+			/* Enable receive CQ backpressure */
+			aq->cq.bp_ena = 1;
+			aq->cq.bpid = pfvf->bpid[0];
 
-		/* Set backpressure level is same as cq pass level */
-		aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+			/* Set backpressure level is same as cq pass level */
+			aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+		}
 	}
 
 	/* Fill AQ info */
@@ -1183,7 +1185,7 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	aq->aura.fc_hyst_bits = 0; /* Store count on all updates */
 
 	/* Enable backpressure for RQ aura */
-	if (aura_id < pfvf->hw.rqpool_cnt) {
+	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
 		/* Set backpressure level for RQ's Aura */
-- 
2.30.2



