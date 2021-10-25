Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC743A252
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhJYTrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237215AbhJYTpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9558A60FDC;
        Mon, 25 Oct 2021 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190756;
        bh=lD8sNgKIZJrnHTKJsHdAYVIH0/KgNqbOB3Oh0MDWfH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfz4SGC0F+mZMg3nTfdOEXiCT7iw6fasJVWLetHoPKDCWCQ3edFPRjp9A4N+TUgtX
         ICaLcs/usg+/KriAmh9wUHpm1riYQbHZIK5lZxIpQkQliiemSze4k3GaQfC+NGUOYt
         sNaHwtztzGE8X5Ii0DNf9FsbA8oYY/XoAXCuaZGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 044/169] net: hns3: Add configuration of TM QCN error event
Date:   Mon, 25 Oct 2021 21:13:45 +0200
Message-Id: <20211025191023.350043558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit 60484103d5c387df49bd60de4b16c88022747048 ]

Add configuration of interrupt type and fifo interrupt enable of TM QCN
error event if enabled, otherwise this event will not be reported when
there is error.

Fixes: d914971df022 ("net: hns3: remove redundant query in hclge_config_tm_hw_err_int()")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 5 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 2eeafd61a07e..c63b440fd654 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -995,8 +995,11 @@ static int hclge_config_tm_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure TM QCN hw errors */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_TM_QCN_MEM_INT_CFG, false);
-	if (en)
+	desc.data[0] = cpu_to_le32(HCLGE_TM_QCN_ERR_INT_TYPE);
+	if (en) {
+		desc.data[0] |= cpu_to_le32(HCLGE_TM_QCN_FIFO_INT_EN);
 		desc.data[1] = cpu_to_le32(HCLGE_TM_QCN_MEM_ERR_INT_EN);
+	}
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 07987fb8332e..d811eeefe2c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -50,6 +50,8 @@
 #define HCLGE_PPP_MPF_ECC_ERR_INT3_EN	0x003F
 #define HCLGE_PPP_MPF_ECC_ERR_INT3_EN_MASK	0x003F
 #define HCLGE_TM_SCH_ECC_ERR_INT_EN	0x3
+#define HCLGE_TM_QCN_ERR_INT_TYPE	0x29
+#define HCLGE_TM_QCN_FIFO_INT_EN	0xFFFF00
 #define HCLGE_TM_QCN_MEM_ERR_INT_EN	0xFFFFFF
 #define HCLGE_NCSI_ERR_INT_EN	0x3
 #define HCLGE_NCSI_ERR_INT_TYPE	0x9
-- 
2.33.0



