Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714F222EF4A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgG0OPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730662AbgG0OPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F382078E;
        Mon, 27 Jul 2020 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859310;
        bh=jSJn4G2I3ZBk2qmVanMQP0AK9waX/QaoJftNVEYKmN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhmlgiUGwz2YjFQm/YSMUghdND5AbtXYMNcBh3qZ/Y0T64pYXUwLqMXS/hxol100G
         c27LnId9w17cE1hnvyBuP817xrVPJysxAHCCI3/X5re2BS+WEMd5KbiQPRkGuPtGz5
         7H3zIQpE/eE2L5LPCPkZyxiA2w5MsTuHUNDliVSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/138] qed: suppress false-positives interrupt error messages on HW init
Date:   Mon, 27 Jul 2020 16:04:13 +0200
Message-Id: <20200727134928.310793819@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit eb61c2d69903e977ffa2b80b1da9d1f758cf228d ]

It was found that qed_pglueb_rbc_attn_handler() can produce a lot of
false-positive error detections on driver load/reload (especially after
crashes/recoveries) and spam the kernel log:

[    4.958275] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d00ff0
[ 2079.146764] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[ 2116.374631] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[ 2135.250564] [qed_pglueb_rbc_attn_handler:324()]ICPL error - 00d80ff0
[...]

Reduce the logging level of two false-positive prone error messages from
notice to verbose on initialization (only) to not mix it with real error
attentions while debugging.

Fixes: 666db4862f2d ("qed: Revise load sequence to avoid PCI errors")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c | 50 +++++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_int.h |  4 +-
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 638047b937c65..4456ce5325a74 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3092,7 +3092,7 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 		}
 
 		/* Log and clear previous pglue_b errors if such exist */
-		qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_main_ptt);
+		qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_main_ptt, true);
 
 		/* Enable the PF's internal FID_enable in the PXP */
 		rc = qed_pglueb_set_pfid_enable(p_hwfn, p_hwfn->p_main_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 9f5113639eaf0..8d106063e9275 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -256,9 +256,10 @@ out:
 #define PGLUE_ATTENTION_ZLR_VALID		(1 << 25)
 #define PGLUE_ATTENTION_ILT_VALID		(1 << 23)
 
-int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
-				struct qed_ptt *p_ptt)
+int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+				bool hw_init)
 {
+	char msg[256];
 	u32 tmp;
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_WR_DETAILS2);
@@ -272,22 +273,23 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 		details = qed_rd(p_hwfn, p_ptt,
 				 PGLUE_B_REG_TX_ERR_WR_DETAILS);
 
-		DP_NOTICE(p_hwfn,
-			  "Illegal write by chip to [%08x:%08x] blocked.\n"
-			  "Details: %08x [PFID %02x, VFID %02x, VF_VALID %02x]\n"
-			  "Details2 %08x [Was_error %02x BME deassert %02x FID_enable deassert %02x]\n",
-			  addr_hi, addr_lo, details,
-			  (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_PFID),
-			  (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VFID),
-			  GET_FIELD(details,
-				    PGLUE_ATTENTION_DETAILS_VF_VALID) ? 1 : 0,
-			  tmp,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_WAS_ERR) ? 1 : 0,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_BME) ? 1 : 0,
-			  GET_FIELD(tmp,
-				    PGLUE_ATTENTION_DETAILS2_FID_EN) ? 1 : 0);
+		snprintf(msg, sizeof(msg),
+			 "Illegal write by chip to [%08x:%08x] blocked.\n"
+			 "Details: %08x [PFID %02x, VFID %02x, VF_VALID %02x]\n"
+			 "Details2 %08x [Was_error %02x BME deassert %02x FID_enable deassert %02x]",
+			 addr_hi, addr_lo, details,
+			 (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_PFID),
+			 (u8)GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VFID),
+			 !!GET_FIELD(details, PGLUE_ATTENTION_DETAILS_VF_VALID),
+			 tmp,
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_WAS_ERR),
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_BME),
+			 !!GET_FIELD(tmp, PGLUE_ATTENTION_DETAILS2_FID_EN));
+
+		if (hw_init)
+			DP_VERBOSE(p_hwfn, NETIF_MSG_INTR, "%s\n", msg);
+		else
+			DP_NOTICE(p_hwfn, "%s\n", msg);
 	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_RD_DETAILS2);
@@ -320,8 +322,14 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_TX_ERR_WR_DETAILS_ICPL);
-	if (tmp & PGLUE_ATTENTION_ICPL_VALID)
-		DP_NOTICE(p_hwfn, "ICPL error - %08x\n", tmp);
+	if (tmp & PGLUE_ATTENTION_ICPL_VALID) {
+		snprintf(msg, sizeof(msg), "ICPL error - %08x", tmp);
+
+		if (hw_init)
+			DP_VERBOSE(p_hwfn, NETIF_MSG_INTR, "%s\n", msg);
+		else
+			DP_NOTICE(p_hwfn, "%s\n", msg);
+	}
 
 	tmp = qed_rd(p_hwfn, p_ptt, PGLUE_B_REG_MASTER_ZLR_ERR_DETAILS);
 	if (tmp & PGLUE_ATTENTION_ZLR_VALID) {
@@ -360,7 +368,7 @@ int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
 
 static int qed_pglueb_rbc_attn_cb(struct qed_hwfn *p_hwfn)
 {
-	return qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_dpc_ptt);
+	return qed_pglueb_rbc_attn_handler(p_hwfn, p_hwfn->p_dpc_ptt, false);
 }
 
 #define QED_DORQ_ATTENTION_REASON_MASK  (0xfffff)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index d473b522afc51..ba5cfebf2d0d0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -431,7 +431,7 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 
 #define QED_MAPPING_MEMORY_SIZE(dev)	(NUM_OF_SBS(dev))
 
-int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn,
-				struct qed_ptt *p_ptt);
+int qed_pglueb_rbc_attn_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+				bool hw_init);
 
 #endif
-- 
2.25.1



