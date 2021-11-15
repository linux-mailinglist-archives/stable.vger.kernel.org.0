Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB04D451EBD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344633AbhKPAhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344894AbhKOTZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9328636DF;
        Mon, 15 Nov 2021 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003175;
        bh=cx/URazu15VIIopSlbPy6ZcloJxLoH9o7jGc4o9BHdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0bB1DCXqpqUP/G72Pttut3JsslZJAcEX31lubsNhkx9tJdraJRq5zMtVryMd1F6Y
         Fg4lV15dFaOcaJAj1xJT6qb9TfOfOaZjS+Yf7u3jXDMAEzPqpvxQOqlvkgfn242Xyi
         p/Uwh4/INKvk5i5m2N2iB5i4qCvXY2CdJbHkrWqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 837/917] net: hns3: allow configure ETS bandwidth of all TCs
Date:   Mon, 15 Nov 2021 18:05:32 +0100
Message-Id: <20211115165457.424853922@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 688db0c7a4a69ddc8b8143a1cac01eb20082a3aa ]

Currently, driver only allow configuring ETS bandwidth of TCs according
to the max TC number queried from firmware. However, the hardware actually
supports 8 TCs and users may need to configure ETS bandwidth of all TCs,
so remove the restriction.

Fixes: 330baff5423b ("net: hns3: add ETS TC weight setting in SSU module")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 90013c131e949..375ebf105a9aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -129,7 +129,7 @@ static int hclge_ets_sch_mode_validate(struct hclge_dev *hdev,
 	u32 total_ets_bw = 0;
 	u8 i;
 
-	for (i = 0; i < hdev->tc_max; i++) {
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index a50e2edbf4a0f..429652a8cde16 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1123,7 +1123,6 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 
 static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 {
-#define DEFAULT_TC_WEIGHT	1
 #define DEFAULT_TC_OFFSET	14
 
 	struct hclge_ets_tc_weight_cmd *ets_weight;
@@ -1136,13 +1135,7 @@ static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		struct hclge_pg_info *pg_info;
 
-		ets_weight->tc_weight[i] = DEFAULT_TC_WEIGHT;
-
-		if (!(hdev->hw_tc_map & BIT(i)))
-			continue;
-
-		pg_info =
-			&hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
+		pg_info = &hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
 		ets_weight->tc_weight[i] = pg_info->tc_dwrr[i];
 	}
 
-- 
2.33.0



