Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18D63FDA41
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244634AbhIAMbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244636AbhIAMay (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2253F610A2;
        Wed,  1 Sep 2021 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499397;
        bh=N2VJGS70HEoaxWZv2YwyzanrpLLRlNj3BIJ5IL3trfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo6BxqWo/yxkZno+HSH/2l9m8Iwdr1ktSlEjtrQOHfBEBLsK+/S/WIAT7tM6m8mzw
         8vzrAU1mN3To82oxDut5lRennjvoSvRP+J22GsFuQnNGjnnoc1wJHaZ5lpr8DgfGd4
         8CjYS+DVgRochGn1P5OH7u1mxhW9Musj+s6Fe8CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/33] net: hns3: fix get wrong pfc_en when query PFC configuration
Date:   Wed,  1 Sep 2021 14:28:07 +0200
Message-Id: <20210901122251.391539266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
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
index a75d7c826fc2..dd935cd1fb44 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -204,21 +204,12 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
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



