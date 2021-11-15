Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90154512A4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbhKOTii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244939AbhKOTSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC70634DE;
        Mon, 15 Nov 2021 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000752;
        bh=uko3wy88vVatPWmLmQkYOdSbG58/6mNzIlJKw6MY2eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXeZxUQyKOziE5IODzzNRC31qWNSo2K85tkMiJAf4KVawkhrhg1qK55yKnCKHq2uo
         FqDOvMwsYqgdyr3Rv+2reHtT5gaFQmNW47XLvCmsWQ0b1ZgrqzM6ZZNbjrDqMMPn8b
         O56X4vPQ5ExicrAD4jT5MplQU5Dr3aE7eFGgf+bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 777/849] net: hns3: allow configure ETS bandwidth of all TCs
Date:   Mon, 15 Nov 2021 18:04:20 +0100
Message-Id: <20211115165446.528863409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 64cc019cb67ca..f517cc334ebed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -125,7 +125,7 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < hdev->tc_max; i++) {
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 5ff2c98a55427..e948b6558de59 100644
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



