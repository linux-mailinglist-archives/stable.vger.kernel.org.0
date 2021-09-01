Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588B73FDB46
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbhIAMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343527AbhIAMiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CB961154;
        Wed,  1 Sep 2021 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499674;
        bh=BCRPzUdcRgOyj7E18VJNsK60AH2SENmo/sSKXniewlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaO6QfXqcVPRKV5A13B3ExXOP2bzqWmTrZlnh+4TUEVFOv0AuyNOG4g3pX/Ucy5Ib
         h1DyD46QZ/ZAZRktOwziCHmzh3KbXtCamaGaGzhUl+231NcCWIMmVAG1Ee7vTGvxQA
         pbsmig9vi0dslGZ9Chv0QpqrKk3Uen+MtggpiQmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/103] net: hns3: clear hardware resource when loading driver
Date:   Wed,  1 Sep 2021 14:27:52 +0200
Message-Id: <20210901122301.988032975@linuxfoundation.org>
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

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 1a6d281946c330cee2855f6d0cd796616e54601f ]

If a PF is bonded to a virtual machine and the virtual machine exits
unexpectedly, some hardware resource cannot be cleared. In this case,
loading driver may cause exceptions. Therefore, the hardware resource
needs to be cleared when the driver is loaded.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  3 +++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 26 +++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 36690fc5c1af..b38b48b9f0b1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -262,6 +262,9 @@ enum hclge_opcode_type {
 	/* Led command */
 	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
 
+	/* clear hardware resource command */
+	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
+
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 98190aa90781..c48c845472ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10030,6 +10030,28 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 	}
 }
 
+static int hclge_clear_hw_resource(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CLEAR_HW_RESOURCE, false);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	/* This new command is only supported by new firmware, it will
+	 * fail with older firmware. Error value -EOPNOSUPP can only be
+	 * returned by older firmware running this command, to keep code
+	 * backward compatible we will override this value and return
+	 * success.
+	 */
+	if (ret && ret != -EOPNOTSUPP) {
+		dev_err(&hdev->pdev->dev,
+			"failed to clear hw resource, ret = %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -10067,6 +10089,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_cmd_uninit;
 
+	ret  = hclge_clear_hw_resource(hdev);
+	if (ret)
+		goto err_cmd_uninit;
+
 	ret = hclge_get_cap(hdev);
 	if (ret)
 		goto err_cmd_uninit;
-- 
2.30.2



