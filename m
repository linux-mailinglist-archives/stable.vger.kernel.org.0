Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9773834E1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbhEQPNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242374AbhEQPLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1171C6191B;
        Mon, 17 May 2021 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261855;
        bh=fbZsCzOi5Sbw90nfW0VZYKamOCE5mLGVigOqnw+p0Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t97E4bPUuZmt39Zatm/VI6RywmbYeuuWZXy37cHg/7GsrmY08HjybUHs9L/Jub66/
         ocyuSq/eHspyrQ5VufkoNfT9g/H/mKqEQnRmANrgxxOYu4uxHfDbehi2b1298Dc+Tm
         XWqyTA2mt4DptS7bI2ojIr8DuvnLb9UI5rOhDWl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 178/329] net: hns3: fix incorrect configuration for igu_egu_hw_err
Date:   Mon, 17 May 2021 16:01:29 +0200
Message-Id: <20210517140308.145741874@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 2867298dd49ee84214b8721521dc7a5a6382520c ]

According to the UM, the type and enable status of igu_egu_hw_err
should be configured separately. Currently, the type field is
incorrect when disable this error. So fix it by configuring these
two fields separately.

Fixes: bf1faf9415dd ("net: hns3: Add enable and process hw errors from IGU, EGU and NCSI")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 9ee55ee0487d..3226ca176155 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -753,8 +753,9 @@ static int hclge_config_igu_egu_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure IGU,EGU error interrupts */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_IGU_COMMON_INT_EN, false);
+	desc.data[0] = cpu_to_le32(HCLGE_IGU_ERR_INT_TYPE);
 	if (en)
-		desc.data[0] = cpu_to_le32(HCLGE_IGU_ERR_INT_EN);
+		desc.data[0] |= cpu_to_le32(HCLGE_IGU_ERR_INT_EN);
 
 	desc.data[1] = cpu_to_le32(HCLGE_IGU_ERR_INT_EN_MASK);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 608fe26fc3fe..d647f3c84134 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -32,7 +32,8 @@
 #define HCLGE_TQP_ECC_ERR_INT_EN_MASK	0x0FFF
 #define HCLGE_MSIX_SRAM_ECC_ERR_INT_EN_MASK	0x0F000000
 #define HCLGE_MSIX_SRAM_ECC_ERR_INT_EN	0x0F000000
-#define HCLGE_IGU_ERR_INT_EN	0x0000066F
+#define HCLGE_IGU_ERR_INT_EN	0x0000000F
+#define HCLGE_IGU_ERR_INT_TYPE	0x00000660
 #define HCLGE_IGU_ERR_INT_EN_MASK	0x000F
 #define HCLGE_IGU_TNL_ERR_INT_EN    0x0002AABF
 #define HCLGE_IGU_TNL_ERR_INT_EN_MASK  0x003F
-- 
2.30.2



