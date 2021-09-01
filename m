Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B703FDB4F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbhIAMkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343846AbhIAMiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EAC361175;
        Wed,  1 Sep 2021 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499684;
        bh=+L0WRp4son9I/Zmxd7wASBPBN0HVpvAnkcxA0+29urU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNemfNMTBWhh7Neg3C9EYkaIqsZ2R49nYKURztKvTir/D7o5wK2F96BDpyebJtAHw
         TVBffQTsKkp6S0nh8KFMVD7rQZlXcnw2bUlPEWpz+xdgUPjWbzULuL8/bpm3DLwtTG
         pt6MXzH4XJ6dyEzSiNvco3ArTCQcaCKV1434JwM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/103] net: hns3: fix get wrong pfc_en when query PFC configuration
Date:   Wed,  1 Sep 2021 14:27:55 +0200
Message-Id: <20210901122302.092048897@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 8c1671e0d13d4a0ba4fb3a0da932bf3736d7ff73 ]

Currently, when query PFC configuration by dcbtool, driver will return
PFC enable status based on TC. As all priorities are mapped to TC0 by
default, if TC0 is enabled, then all priorities mapped to TC0 will be
shown as enabled status when query PFC setting, even though some
priorities have never been set.

for example:
$ dcb pfc show dev eth0
pfc-cap 4 macsec-bypass off delay 0
prio-pfc 0:off 1:off 2:off 3:off 4:off 5:off 6:off 7:off
$ dcb pfc set dev eth0 prio-pfc 0:on 1:on 2:on 3:on
$ dcb pfc show dev eth0
pfc-cap 4 macsec-bypass off delay 0
prio-pfc 0:on 1:on 2:on 3:on 4:on 5:on 6:on 7:on

To fix this problem, just returns user's PFC config parameter saved in
driver.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 3606240025a8..a93c7eb4e7cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -283,21 +283,12 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u64 requests[HNAE3_MAX_TC], indications[HNAE3_MAX_TC];
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
-	u8 i, j, pfc_map, *prio_tc;
 	int ret;
+	u8 i;
 
 	memset(pfc, 0, sizeof(*pfc));
 	pfc->pfc_cap = hdev->pfc_max;
-	prio_tc = hdev->tm_info.prio_tc;
-	pfc_map = hdev->tm_info.hw_pfc_map;
-
-	/* Pfc setting is based on TC */
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
-		for (j = 0; j < HNAE3_MAX_USER_PRIO; j++) {
-			if ((prio_tc[j] == i) && (pfc_map & BIT(i)))
-				pfc->pfc_en |= BIT(j);
-		}
-	}
+	pfc->pfc_en = hdev->tm_info.pfc_en;
 
 	ret = hclge_pfc_tx_stats_get(hdev, requests);
 	if (ret)
-- 
2.30.2



