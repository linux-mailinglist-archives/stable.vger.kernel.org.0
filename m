Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB311B72F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733274AbfLKQGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731216AbfLKPMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC422465B;
        Wed, 11 Dec 2019 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077163;
        bh=ugpmlOyr7TaG72VcGP0lAPfC8pVHr4pczswXTIfCbl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vc0EfWpcv/rtU3Z2GkxywbTXa5uLhZPbzeuYy9ys16/JewZL8kiaqedhwP2SGc/23
         daN1YtdwSAjk9NRsrhHfw5ZbDB3NdWtl9s8y6Yt5T7U/uhKIxtg5ocftJxmSxGk+w7
         KcswZOmhsqoH7Z1eEuyt8uN/JN17xb9ZxyWtTZFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 039/105] net: hns3: reallocate SSU buffer size when pfc_en changes
Date:   Wed, 11 Dec 2019 16:05:28 +0100
Message-Id: <20191211150236.251208894@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit aea8cfb35a82d6c2f3517c86694933ba766635e5 ]

When a TC's PFC is disabled or enabled, the RX private buffer for
this TC need to be changed too, otherwise this may cause packet
dropped problem.

This patch fixes it by calling hclge_buffer_alloc to reallocate
buffer when pfc_en changes.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index bac4ce13f6ae4..d9136a199d8db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -302,6 +302,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
 	u8 i, j, pfc_map, *prio_tc;
+	int ret;
 
 	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
 	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
@@ -327,7 +328,21 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 
 	hclge_tm_pfc_info_update(hdev);
 
-	return hclge_pause_setup_hw(hdev, false);
+	ret = hclge_pause_setup_hw(hdev, false);
+	if (ret)
+		return ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hclge_buffer_alloc(hdev);
+	if (ret) {
+		hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+		return ret;
+	}
+
+	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
 /* DCBX configuration */
-- 
2.20.1



