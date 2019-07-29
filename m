Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014E07941C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfG2T2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbfG2T2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:28:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE79C217D4;
        Mon, 29 Jul 2019 19:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428485;
        bh=juKBMjz2oE2R3XxbmMl1+0utoP+sfYheUsaNQ6FnA0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgrg8gl0rjT1+1C8dkx5vh6Z/5YPpAcf6oQZjtjWzHyV4IzqZE7YDzCVCtUlOi+jg
         kI85l0/GEya3oFcNIgoyPjVv3hPyuJt1iHXGfLnxEfX0JDSwLK4OqgX1dgtn6e4rNW
         YDZLigkVYjzwtnvYlkBGGCoIOHo47blS4UREYRis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/293] net: hns3: add some error checking in hclge_tm module
Date:   Mon, 29 Jul 2019 21:19:41 +0200
Message-Id: <20190729190831.491798276@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 04f25edb48c441fc278ecc154c270f16966cbb90 ]

When hdev->tx_sch_mode is HCLGE_FLAG_VNET_BASE_SCH_MODE, the
hclge_tm_schd_mode_vnet_base_cfg calls hclge_tm_pri_schd_mode_cfg
with vport->vport_id as pri_id, which is used as index for
hdev->tm_info.tc_info, it will cause out of bound access issue
if vport_id is equal to or larger than HNAE3_MAX_TC.

Also hardware only support maximum speed of HCLGE_ETHER_MAX_RATE.

So this patch adds two checks for above cases.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 73a75d7cc551..55228b91d80b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -57,7 +57,8 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	u32 tick;
 
 	/* Calc tick */
-	if (shaper_level >= HCLGE_SHAPER_LVL_CNT)
+	if (shaper_level >= HCLGE_SHAPER_LVL_CNT ||
+	    ir > HCLGE_ETHER_MAX_RATE)
 		return -EINVAL;
 
 	tick = tick_array[shaper_level];
@@ -893,6 +894,9 @@ static int hclge_tm_schd_mode_vnet_base_cfg(struct hclge_vport *vport)
 	int ret;
 	u8 i;
 
+	if (vport->vport_id >= HNAE3_MAX_TC)
+		return -EINVAL;
+
 	ret = hclge_tm_pri_schd_mode_cfg(hdev, vport->vport_id);
 	if (ret)
 		return ret;
-- 
2.20.1



