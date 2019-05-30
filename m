Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4FF2F59F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfE3Esr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbfE3DLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:18 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B3A244B0;
        Thu, 30 May 2019 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185877;
        bh=T+vGrf3RvbzG7P4iTgiRGSVNNHZqkLdV/nNoR5UX7dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfL+oOICgD9Q5f/SnShRqtZLdAnGB1OFNCUpoDb4zILoozI1DdGPVvjr7PhcZNbNh
         f26E+WUIOR9AmskZjcPkkEFdzXDbty86DSVGiqI3kqiFMhHP5w9Ba5rJpaZRaOXX6X
         lJR08jmCu5U5GNeI1l6eHJ9yWtK6PP9ucGl4gUSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 224/405] net: hns3: add error handler for initializing command queue
Date:   Wed, 29 May 2019 20:03:42 -0700
Message-Id: <20190530030552.386055830@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4339ef396ab65a61f7f22f36d7ba94b6e9e0939b ]

This patch adds error handler for the failure of command queue
initialization both PF and VF.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    | 11 ++++++++---
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  | 11 ++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 3a093a92eac51..d92e4af11b1fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -373,21 +373,26 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	 * reset may happen when lower level reset is being processed.
 	 */
 	if ((hclge_is_reset_pending(hdev))) {
-		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_cmd_init;
 	}
 
 	ret = hclge_cmd_query_firmware_version(&hdev->hw, &version);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"firmware version query failed %d\n", ret);
-		return ret;
+		goto err_cmd_init;
 	}
 	hdev->fw_version = version;
 
 	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
 
 	return 0;
+
+err_cmd_init:
+	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
+
+	return ret;
 }
 
 static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 9a0a501908aec..382ecb15e7435 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -344,8 +344,8 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	 * reset may happen when lower level reset is being processed.
 	 */
 	if (hclgevf_is_reset_pending(hdev)) {
-		set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_cmd_init;
 	}
 
 	/* get firmware version */
@@ -353,13 +353,18 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed(%d) to query firmware version\n", ret);
-		return ret;
+		goto err_cmd_init;
 	}
 	hdev->fw_version = version;
 
 	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
 
 	return 0;
+
+err_cmd_init:
+	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+
+	return ret;
 }
 
 static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
-- 
2.20.1



