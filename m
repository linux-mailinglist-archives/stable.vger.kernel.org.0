Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11507450C4B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhKORhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhKOReR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9012E632B3;
        Mon, 15 Nov 2021 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996950;
        bh=Q188tE+CFIfiwEELCFPdM1wmlgjeC6KOrGZlMsUFjpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2XzknEqpQKVI56Fur3CWsdWoWOvV0fwEt7/AT2rKGz34JnTTZapWEwulXDIqn7KN
         uUVeAyTEP3moxSvyybjEctH6+ZkHHCt6UXxJb139FIETFdYEUKfdaNFes1sqQCneS4
         nJCQpdLfxNFh6w6robHde4pVgknQWI5iiILrZjIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/355] net: hns3: allow configure ETS bandwidth of all TCs
Date:   Mon, 15 Nov 2021 18:04:12 +0100
Message-Id: <20211115165324.347100472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 9076605403a74..bb22d91f6e53e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -124,7 +124,7 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < hdev->tc_max; i++) {
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index d98f0e2ec7aa3..8448607742a6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -974,7 +974,6 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 
 static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 {
-#define DEFAULT_TC_WEIGHT	1
 #define DEFAULT_TC_OFFSET	14
 
 	struct hclge_ets_tc_weight_cmd *ets_weight;
@@ -987,13 +986,7 @@ static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
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



