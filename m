Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61AF21FA40
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgGNSu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgGNSu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C144D22B3F;
        Tue, 14 Jul 2020 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752655;
        bh=Ph/2Lcc+Ow4U1icyFt7+6fCPl1Qqh/+7JBO2gz2tJC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pes5UVphFE/wDzVvq0HPhjVtUP0JDpgS2TmG6Ykly68rtt/G5vDpUkRDTQZPT677y
         7b6nqn+8imC50lFyZa7fX5OXEo+CeC6r3kjAPXdksK+zs0oJhzaUvqI+vJIPulHQIB
         6za96a33r/riDcvHNVVqTkYMc8C9OQjcSQ7zgHio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/109] qed: Populate nvm-file attributes while reading nvm config partition.
Date:   Tue, 14 Jul 2020 20:44:04 +0200
Message-Id: <20200714184108.445486727@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit 13cf8aab7425a253070433b5a55b4209ceac8b19 ]

NVM config file address will be modified when the MBI image is upgraded.
Driver would return stale config values if user reads the nvm-config
(via ethtool -d) in this state. The fix is to re-populate nvm attribute
info while reading the nvm config values/partition.

Changes from previous version:
-------------------------------
v3: Corrected the formatting in 'Fixes' tag.
v2: Added 'Fixes' tag.

Fixes: 1ac4329a1cff ("qed: Add configuration information to register dump and debug data")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c |  4 ++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 12 +++---------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   |  7 +++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h   |  7 +++++++
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 859caa6c1a1fb..8e7be214f9598 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -8197,6 +8197,10 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		DP_ERR(cdev, "qed_dbg_mcp_trace failed. rc = %d\n", rc);
 	}
 
+	/* Re-populate nvm attribute info */
+	qed_mcp_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_populate(p_hwfn);
+
 	/* nvm cfg1 */
 	rc = qed_dbg_nvm_image(cdev,
 			       (u8 *)buffer + offset + REGDUMP_HEADER_SIZE,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index ecd14474a6031..638047b937c65 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4423,12 +4423,6 @@ static int qed_get_dev_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
-static void qed_nvm_info_free(struct qed_hwfn *p_hwfn)
-{
-	kfree(p_hwfn->nvm_info.image_att);
-	p_hwfn->nvm_info.image_att = NULL;
-}
-
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
@@ -4513,7 +4507,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	return rc;
 err3:
 	if (IS_LEAD_HWFN(p_hwfn))
-		qed_nvm_info_free(p_hwfn);
+		qed_mcp_nvm_info_free(p_hwfn);
 err2:
 	if (IS_LEAD_HWFN(p_hwfn))
 		qed_iov_free_hw_info(p_hwfn->cdev);
@@ -4574,7 +4568,7 @@ int qed_hw_prepare(struct qed_dev *cdev,
 		if (rc) {
 			if (IS_PF(cdev)) {
 				qed_init_free(p_hwfn);
-				qed_nvm_info_free(p_hwfn);
+				qed_mcp_nvm_info_free(p_hwfn);
 				qed_mcp_free(p_hwfn);
 				qed_hw_hwfn_free(p_hwfn);
 			}
@@ -4608,7 +4602,7 @@ void qed_hw_remove(struct qed_dev *cdev)
 
 	qed_iov_free_hw_info(cdev);
 
-	qed_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_free(p_hwfn);
 }
 
 static void qed_chain_free_next_ptr(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 36ddb89856a86..9401b49275f0a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3149,6 +3149,13 @@ int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn)
 	return rc;
 }
 
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn)
+{
+	kfree(p_hwfn->nvm_info.image_att);
+	p_hwfn->nvm_info.image_att = NULL;
+	p_hwfn->nvm_info.valid = false;
+}
+
 int
 qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 			  enum qed_nvm_images image_id,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 9c4c2763de8d7..e38297383b007 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1192,6 +1192,13 @@ void qed_mcp_read_ufp_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
  */
 int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn);
 
+/**
+ * @brief Delete nvm info shadow in the given hardware function
+ *
+ * @param p_hwfn
+ */
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn);
+
 /**
  * @brief Get the engine affinity configuration.
  *
-- 
2.25.1



