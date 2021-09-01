Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814213FDC90
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345361AbhIAMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346416AbhIAMuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D89F61106;
        Wed,  1 Sep 2021 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500101;
        bh=1uAM4oyddlyqze2viOyYQfACk759w7xICWV+IDwCTRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDF68RfKXQwVTKfORGZr9uXLNCGs+l0tGmcECxd7bDcxrJrm2DspfERt3qARtJ0NZ
         0eddjtTUwGTCZzV6mNDovP9aMLpoxKwm7RmFBxpMfrvX2XCfQMWp38SuG6aCYP/GKk
         iagQHyQVsrIzxZYMqWR+cW5eX72w3kRr3f44+u/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 060/113] net: hns3: clear hardware resource when loading driver
Date:   Wed,  1 Sep 2021 14:28:15 +0200
Message-Id: <20210901122303.969987082@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
index c6fc22e29581..8e055e1ce793 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -264,6 +264,9 @@ enum hclge_opcode_type {
 	/* Led command */
 	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
 
+	/* clear hardware resource command */
+	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
+
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6304aed49f22..9ea4007dbac9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11167,6 +11167,28 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
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
@@ -11204,6 +11226,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
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



