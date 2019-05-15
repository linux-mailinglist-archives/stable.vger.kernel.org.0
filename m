Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59DC1F055
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfEOL1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731887AbfEOL1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55CA920862;
        Wed, 15 May 2019 11:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919651;
        bh=CXB5IUkU623dBOmRC9Olz3+gVAQ0n96HHidPJsfDQUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNFxM264PC4ZqgZvtXbzMgdrTVFpuC5PS3Z+yXnWedNyiUulDQvfy5aI4ZERoAskx
         1oI++MxPVbQ3TvFJ/ni9Hv5DalVgNMddghm72QGVW43s9luijSPAwwhWmXLt7zF7V1
         NjJeOx/gHLCG/6jqt7Kg5BGD0CXcCQH33BqffbkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 043/137] qed: Fix missing DORQ attentions
Date:   Wed, 15 May 2019 12:55:24 +0200
Message-Id: <20190515090656.559697485@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4476b8a6151b2dd86c09b5acec64f66430db55d ]

When the DORQ (doorbell block) is overflowed, all PFs get attentions at the
same time. If one PF finished handling the attention before another PF even
started, the second PF might miss the DORQ's attention bit and not handle
the attention at all.
If the DORQ attention is missed and the issue is not resolved, another
attention will not be sent, therefore each attention is treated as a
potential DORQ attention.
As a result, the attention callback is called more frequently so the debug
print was moved to reduce its quantity.
The number of periodic doorbell recovery handler schedules was reduced
because it was the previous way to mitigating the missed attention issue.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  1 +
 drivers/net/ethernet/qlogic/qed/qed_int.c  | 20 ++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 +-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index d5fece7eb1698..07ae600d0f357 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -436,6 +436,7 @@ struct qed_db_recovery_info {
 
 	/* Lock to protect the doorbell recovery mechanism list */
 	spinlock_t lock;
+	bool dorq_attn;
 	u32 db_recovery_counter;
 };
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b994f81eb51c3..00688f4c04645 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -436,17 +436,19 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 	struct qed_ptt *p_ptt = p_hwfn->p_dpc_ptt;
 	int rc;
 
-	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
-	DP_NOTICE(p_hwfn->cdev, "DORQ attention. int_sts was %x\n", int_sts);
+	p_hwfn->db_recovery_info.dorq_attn = true;
 
 	/* int_sts may be zero since all PFs were interrupted for doorbell
 	 * overflow but another one already handled it. Can abort here. If
 	 * This PF also requires overflow recovery we will be interrupted again.
 	 * The masked almost full indication may also be set. Ignoring.
 	 */
+	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
 	if (!(int_sts & ~DORQ_REG_INT_STS_DORQ_FIFO_AFULL))
 		return 0;
 
+	DP_NOTICE(p_hwfn->cdev, "DORQ attention. int_sts was %x\n", int_sts);
+
 	/* check if db_drop or overflow happened */
 	if (int_sts & (DORQ_REG_INT_STS_DB_DROP |
 		       DORQ_REG_INT_STS_DORQ_FIFO_OVFL_ERR)) {
@@ -503,6 +505,17 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 	return -EINVAL;
 }
 
+static void qed_dorq_attn_handler(struct qed_hwfn *p_hwfn)
+{
+	if (p_hwfn->db_recovery_info.dorq_attn)
+		goto out;
+
+	/* Call DORQ callback if the attention was missed */
+	qed_dorq_attn_cb(p_hwfn);
+out:
+	p_hwfn->db_recovery_info.dorq_attn = false;
+}
+
 /* Instead of major changes to the data-structure, we have a some 'special'
  * identifiers for sources that changed meaning between adapters.
  */
@@ -1076,6 +1089,9 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 		}
 	}
 
+	/* Handle missed DORQ attention */
+	qed_dorq_attn_handler(p_hwfn);
+
 	/* Clear IGU indication for the deasserted bits */
 	DIRECT_REG_WR((u8 __iomem *)p_hwfn->regview +
 				    GTT_BAR0_MAP_REG_IGU_CMD +
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 6adf5bda9811e..26bfcbeebc4ca 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -966,7 +966,7 @@ static void qed_update_pf_params(struct qed_dev *cdev,
 	}
 }
 
-#define QED_PERIODIC_DB_REC_COUNT		100
+#define QED_PERIODIC_DB_REC_COUNT		10
 #define QED_PERIODIC_DB_REC_INTERVAL_MS		100
 #define QED_PERIODIC_DB_REC_INTERVAL \
 	msecs_to_jiffies(QED_PERIODIC_DB_REC_INTERVAL_MS)
-- 
2.20.1



