Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D938310C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhEQOdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235741AbhEQObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C36B1613ED;
        Mon, 17 May 2021 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260946;
        bh=0WFPPBJ9mm4YAuImocx6Z48TEVG4TPd96yLMMVLY/Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgQxJMWyDfu3r+deCgfpV0ipgacgmnaQGcrbePIixA/mTC917peBV8yelH5vcDior
         WQIw4vGlMJDrbw63fjkTdX14Fqu48EYrr+3H3LbwnlhkhiM5kA+ER28ZvZFGL634DS
         vG4jVUVU5OscYzwLT3fNy14Lz1FsKNoBtc8/dbdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 040/329] net: hns3: remediate a potential overflow risk of bd_num_list
Date:   Mon, 17 May 2021 15:59:11 +0200
Message-Id: <20210517140303.401899315@linuxfoundation.org>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit a2ee6fd28a190588e142ad8ea9d40069cd3c9f98 ]

The array size of bd_num_list is a fixed value, it may have potential
overflow risk when array size of hclge_dfx_bd_offset_list is greater
than that fixed value. So modify bd_num_list as a pointer and allocate
memory for it according to array size of hclge_dfx_bd_offset_list.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 67764d930435..1c13cf34ae9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11284,7 +11284,6 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 #define REG_LEN_PER_LINE	(REG_NUM_PER_LINE * sizeof(u32))
 #define REG_SEPARATOR_LINE	1
 #define REG_NUM_REMAIN_MASK	3
-#define BD_LIST_MAX_NUM		30
 
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 {
@@ -11378,15 +11377,19 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
 	int data_len_per_desc, bd_num, i;
-	int bd_num_list[BD_LIST_MAX_NUM];
+	int *bd_num_list;
 	u32 data_len;
 	int ret;
 
+	bd_num_list = kcalloc(dfx_reg_type_num, sizeof(int), GFP_KERNEL);
+	if (!bd_num_list)
+		return -ENOMEM;
+
 	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get dfx reg bd num fail, status is %d.\n", ret);
-		return ret;
+		goto out;
 	}
 
 	data_len_per_desc = sizeof_field(struct hclge_desc, data);
@@ -11397,6 +11400,8 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 		*len += (data_len / REG_LEN_PER_LINE + 1) * REG_LEN_PER_LINE;
 	}
 
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
@@ -11404,16 +11409,20 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
 	int bd_num, bd_num_max, buf_len, i;
-	int bd_num_list[BD_LIST_MAX_NUM];
 	struct hclge_desc *desc_src;
+	int *bd_num_list;
 	u32 *reg = data;
 	int ret;
 
+	bd_num_list = kcalloc(dfx_reg_type_num, sizeof(int), GFP_KERNEL);
+	if (!bd_num_list)
+		return -ENOMEM;
+
 	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get dfx reg bd num fail, status is %d.\n", ret);
-		return ret;
+		goto out;
 	}
 
 	bd_num_max = bd_num_list[0];
@@ -11422,8 +11431,10 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 
 	buf_len = sizeof(*desc_src) * bd_num_max;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
-	if (!desc_src)
-		return -ENOMEM;
+	if (!desc_src) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < dfx_reg_type_num; i++) {
 		bd_num = bd_num_list[i];
@@ -11439,6 +11450,8 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 	}
 
 	kfree(desc_src);
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
-- 
2.30.2



