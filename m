Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF327C74B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgI2Lw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgI2LrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E807C21924;
        Tue, 29 Sep 2020 11:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380031;
        bh=ZD/xgTH7LS+3kFGKeWYPbAfpEgDKQ0hghjOgRLp8vU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHIfOysyVC7q0ESjUkWmHXGgwoxlpjqLfI0XeQdBvi/tX1ZwwVGV9WLFj8aiGnzmd
         E09sf0G6qFcvabaN0pEe2cTpGCMNiiGIcPDYoc+3jj1/DVz5XmrCbiRLpd/lNJuluM
         dlKswn+foBzAyJGbyWbM/w5uGxdlnmh0eETF/lH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 37/99] net: qed: Disable aRFS for NPAR and 100G
Date:   Tue, 29 Sep 2020 13:01:20 +0200
Message-Id: <20200929105931.553215599@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 2d2fe8433796603091ac8ea235b9165ac5a85f9a ]

In CMT and NPAR the PF is unknown when the GFS block processes the
packet. Therefore cannot use searcher as it has a per PF database,
and thus ARFS must be disabled.

Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c   |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 ++
 include/linux/qed/qed_if.h                 |  1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index dbdac983ccde5..105d9afe825f1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4191,7 +4191,8 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
 					BIT(QED_MF_LLH_PROTO_CLSS) |
 					BIT(QED_MF_LL2_NON_UNICAST) |
-					BIT(QED_MF_INTER_PF_SWITCH);
+					BIT(QED_MF_INTER_PF_SWITCH) |
+					BIT(QED_MF_DISABLE_ARFS);
 			break;
 		case NVM_CFG1_GLOB_MF_MODE_DEFAULT:
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
@@ -4204,6 +4205,14 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 		DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
 			cdev->mf_bits);
+
+		/* In CMT the PF is unknown when the GFS block processes the
+		 * packet. Therefore cannot use searcher as it has a per PF
+		 * database, and thus ARFS must be disabled.
+		 *
+		 */
+		if (QED_IS_CMT(cdev))
+			cdev->mf_bits |= BIT(QED_MF_DISABLE_ARFS);
 	}
 
 	DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 29810a1aa2106..b2cd153321720 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2001,6 +2001,9 @@ void qed_arfs_mode_configure(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt,
 			     struct qed_arfs_config_params *p_cfg_params)
 {
+	if (test_bit(QED_MF_DISABLE_ARFS, &p_hwfn->cdev->mf_bits))
+		return;
+
 	if (p_cfg_params->mode != QED_FILTER_CONFIG_MODE_DISABLE) {
 		qed_gft_config(p_hwfn, p_ptt, p_hwfn->rel_pf_id,
 			       p_cfg_params->tcp,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 11367a248d55e..05eff348b22a8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -289,6 +289,8 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 		dev_info->fw_eng = FW_ENGINEERING_VERSION;
 		dev_info->b_inter_pf_switch = test_bit(QED_MF_INTER_PF_SWITCH,
 						       &cdev->mf_bits);
+		if (!test_bit(QED_MF_DISABLE_ARFS, &cdev->mf_bits))
+			dev_info->b_arfs_capable = true;
 		dev_info->tx_switching = true;
 
 		if (hw_info->b_wol_support == QED_WOL_SUPPORT_PME)
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 8cb76405cbce1..78ba1dc54fd57 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -648,6 +648,7 @@ struct qed_dev_info {
 #define QED_MFW_VERSION_3_OFFSET	24
 
 	u32		flash_size;
+	bool		b_arfs_capable;
 	bool		b_inter_pf_switch;
 	bool		tx_switching;
 	bool		rdma_supported;
-- 
2.25.1



