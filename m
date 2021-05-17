Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078143833A1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241389AbhEQPAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241736AbhEQO6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666BC619C4;
        Mon, 17 May 2021 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261569;
        bh=VKeAXufu+JKwURS07EgCNsjOOr56TVTihAdZ+HK1ZI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOVLrj5mgAsdBKCh5katEXHPeEVSMZzY+wfNkhoyjDOmZaxYaw0DUfV+T/gQVbF8+
         YpaJgj8VGR+UY7RgeQytEXtZVNUSNpmqHjNBntocw9KEqMdxIs8VZMS4rh/JoPV+nq
         qmpy09SpA+k6SMcF/1h8n3fRnxkxrhXHoZSbowjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/289] net: hns3: remediate a potential overflow risk of bd_num_list
Date:   Mon, 17 May 2021 15:59:19 +0200
Message-Id: <20210517140306.337462126@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index b856dbe4db73..98190aa90781 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10845,7 +10845,6 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 #define REG_LEN_PER_LINE	(REG_NUM_PER_LINE * sizeof(u32))
 #define REG_SEPARATOR_LINE	1
 #define REG_NUM_REMAIN_MASK	3
-#define BD_LIST_MAX_NUM		30
 
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 {
@@ -10939,15 +10938,19 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
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
@@ -10958,6 +10961,8 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 		*len += (data_len / REG_LEN_PER_LINE + 1) * REG_LEN_PER_LINE;
 	}
 
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
@@ -10965,16 +10970,20 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
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
@@ -10983,8 +10992,10 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 
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
@@ -11000,6 +11011,8 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 	}
 
 	kfree(desc_src);
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
-- 
2.30.2



