Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB342102F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhJDNl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237898AbhJDNjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 769386324F;
        Mon,  4 Oct 2021 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353489;
        bh=NqnKqcJrD8CIMdyshFs5P7HueF5CcLL6BZXUu7We/qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KHR56LUY2o2IKeUAEzSDFltbs4y/AKAd5tG8jXvPSs0xWGi/wyqUUgXRwJymKJXe
         wy1I/m781I7AtjzaZOpmvdNqSs8OH3JnsDExsGYZAeU47Y/ll3BzFLIVANs0wYFXce
         VOrhuJTxXf09Vmd2+g3mQ7+bCQzcCpdykNikdJlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 131/172] net: hns3: disable firmware compatible features when uninstall PF
Date:   Mon,  4 Oct 2021 14:53:01 +0200
Message-Id: <20211004125049.193594128@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 0178839ccca36dee238a57e7f4c3c252f5dbbba6 ]

Currently, the firmware compatible features are enabled in PF driver
initialization process, but they are not disabled in PF driver
deinitialization process and firmware keeps these features in enabled
status.

In this case, if load an old PF driver (for example, in VM) which not
support the firmware compatible features, firmware will still send mailbox
message to PF when link status changed and PF will print
"un-supported mailbox message, code = 201".

To fix this problem, disable these firmware compatible features in PF
driver deinitialization process.

Fixes: ed8fb4b262ae ("net: hns3: add link change event report")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index eb748aa35952..0f0bf3d503bf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -472,7 +472,7 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 	return ret;
 }
 
-static int hclge_firmware_compat_config(struct hclge_dev *hdev)
+static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
 {
 	struct hclge_firmware_compat_cmd *req;
 	struct hclge_desc desc;
@@ -480,13 +480,16 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
 
-	req = (struct hclge_firmware_compat_cmd *)desc.data;
+	if (en) {
+		req = (struct hclge_firmware_compat_cmd *)desc.data;
 
-	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
-	hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
-	if (hnae3_dev_phy_imp_supported(hdev))
-		hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
-	req->compat = cpu_to_le32(compat);
+		hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
+		if (hnae3_dev_phy_imp_supported(hdev))
+			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
+
+		req->compat = cpu_to_le32(compat);
+	}
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
@@ -543,7 +546,7 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	/* ask the firmware to enable some features, driver can work without
 	 * it.
 	 */
-	ret = hclge_firmware_compat_config(hdev);
+	ret = hclge_firmware_compat_config(hdev, true);
 	if (ret)
 		dev_warn(&hdev->pdev->dev,
 			 "Firmware compatible features not enabled(%d).\n",
@@ -573,6 +576,8 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	hclge_firmware_compat_config(hdev, false);
+
 	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	/* wait to ensure that the firmware completes the possible left
 	 * over commands.
-- 
2.33.0



