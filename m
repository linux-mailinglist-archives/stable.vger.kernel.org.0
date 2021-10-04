Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC19420ED0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbhJDN2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236644AbhJDN0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77560619E0;
        Mon,  4 Oct 2021 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353105;
        bh=b1EO2jLRRSP1cObfg2czLkT3lsMblga0o2LNOVE8mnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiKjbgnqMGFUNhsOAZKxOFxtqppfyGADlwB0c2WtX4vAkl4piG0kz/Hf82YCEYGk7
         RrNhgqJsmURwK2lhOR5yRKGj6sRCTyLs/5QaQ2oyfAr+qW7nGjbtQ8HVWqygqqBHJV
         VtVWkd/qHOGCl2KqKk0DBr+IC6FrUxKTIRLZgU9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/93] net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
Date:   Mon,  4 Oct 2021 14:52:56 +0200
Message-Id: <20211004125036.482185602@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 0472e95ffeac8e61259eec17ab61608c6b35599d ]

HCLGE_FLAG_MQPRIO_ENABLE is supposed to set when enable
multiple TCs with tc mqprio, and HCLGE_FLAG_DCB_ENABLE is
supposed to set when enable multiple TCs with ets. But
the driver mixed the flags when updating the tm configuration.

Furtherly, PFC should be available when HCLGE_FLAG_MQPRIO_ENABLE
too, so remove the unnecessary limitation.

Fixes: 5a5c90917467 ("net: hns3: add support for tc mqprio offload")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  7 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 31 +++----------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index a93c7eb4e7cb..28a90ead4795 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -248,6 +248,10 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	}
 
 	hclge_tm_schd_info_update(hdev, num_tc);
+	if (num_tc > 1)
+		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
+	else
+		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 
 	ret = hclge_ieee_ets_to_tm_info(hdev, ets);
 	if (ret)
@@ -313,8 +317,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u8 i, j, pfc_map, *prio_tc;
 	int ret;
 
-	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
-	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
+	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
 	if (pfc->pfc_en == hdev->tm_info.pfc_en)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 42e82bf69b8e..69d081515c60 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -646,14 +646,6 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
 		hdev->tm_info.prio_tc[i] =
 			(i >= hdev->tm_info.num_tc) ? 0 : i;
-
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 }
 
 static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
@@ -684,10 +676,10 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 
 static void hclge_update_fc_mode_by_dcb_flag(struct hclge_dev *hdev)
 {
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE)) {
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en) {
 		if (hdev->fc_mode_last_time == HCLGE_FC_PFC)
 			dev_warn(&hdev->pdev->dev,
-				 "DCB is disable, but last mode is FC_PFC\n");
+				 "Only 1 tc used, but last mode is FC_PFC\n");
 
 		hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
 	} else if (hdev->tm_info.fc_mode != HCLGE_FC_PFC) {
@@ -713,7 +705,7 @@ static void hclge_update_fc_mode(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_pfc_info_init(struct hclge_dev *hdev)
+void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
 {
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		hclge_update_fc_mode(hdev);
@@ -729,7 +721,7 @@ static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 
 	hclge_tm_vport_info_update(hdev);
 
-	hclge_pfc_info_init(hdev);
+	hclge_tm_pfc_info_update(hdev);
 }
 
 static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
@@ -1465,19 +1457,6 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
 	hclge_tm_schd_info_init(hdev);
 }
 
-void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
-{
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
-
-	hclge_pfc_info_init(hdev);
-}
-
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init)
 {
 	int ret;
@@ -1523,7 +1502,7 @@ int hclge_tm_vport_map_update(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE))
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en)
 		return 0;
 
 	return hclge_tm_bp_setup(hdev);
-- 
2.33.0



