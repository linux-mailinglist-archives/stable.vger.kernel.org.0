Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3F2F26B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfE3EVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfE3DPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ACA624590;
        Thu, 30 May 2019 03:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186112;
        bh=MW5D2uh7zRmh+cMkEfpL0WmmlnseGbkq8Ewuoau7USw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUXK9bCrv96zu2lV8sOOZ78P8C1K90qPxDnJv5MOoKwNe28Plf5S3FxO2OQFNzTm0
         d/x8s70P+eYHj6Ulq+hl/p8AcuCNcuRmaitLaxoAOHb6fkPq2Zw4qxvXDzYHh0NKSE
         DMOvuMWJ2CzwkyNvFEg8kQt09IzIVyhrEvkFj9GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 205/346] net: hns3: add error handler for initializing command queue
Date:   Wed, 29 May 2019 20:04:38 -0700
Message-Id: <20190530030551.539697911@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index e483a6e730e64..87fa4787bb761 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -359,21 +359,26 @@ int hclge_cmd_init(struct hclge_dev *hdev)
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
 
 static void hclge_destroy_queue(struct hclge_cmq_ring *ring)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index b39ff5555a30e..1e7df81c95ade 100644
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
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
-- 
2.20.1



