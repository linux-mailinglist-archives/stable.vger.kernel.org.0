Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31AB1F0B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbfIMNPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389117AbfIMNPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:14 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC2D206A5;
        Fri, 13 Sep 2019 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380513;
        bh=hDXZxdUzWyqTKIdZ2791Z/I7MoEzBAlqJFqS5zPZdZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmruDVPxxpu7K5G0xaxXK02uccXZn0naxHyjbCV/vye1HMGhuwsc6t5/H9bWYJOw9
         if0vb/qXwfyOrc8IIsy6TCHfbcBGMaRjJ4bt3rNTXYw1qFaQ2MEUi/JqTwkTMA+xQ0
         yA4OiLjPJcoD+zcijO1H107OE42sIUAbiwEkXPzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/190] scsi: megaraid_sas: Add check for reset adapter bit
Date:   Fri, 13 Sep 2019 14:05:25 +0100
Message-Id: <20190913130605.240075835@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit de93b40d98ead27ee2f7f7df93fdd4914a6c8d8d ]

For SAS3 and later controllers, FW sets the reset adapter bit indicating
the driver to perform a controller reset.  Driver needs to check if this
bit is set before doing a reset.  This reduces the driver probe failure
time to 180seconds in case there is a faulty controller connected.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 33 +++++++++++++++--------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b6fc7c6337610..749f10146f630 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5218,7 +5218,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 {
 	u32 max_sectors_1;
 	u32 max_sectors_2, tmp_sectors, msix_enable;
-	u32 scratch_pad_2, scratch_pad_3, scratch_pad_4;
+	u32 scratch_pad_2, scratch_pad_3, scratch_pad_4, status_reg;
 	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info = NULL;
@@ -5226,6 +5226,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	int i, j, loop, fw_msix_count = 0;
 	struct IOV_111 *iovPtr;
 	struct fusion_context *fusion;
+	bool do_adp_reset = true;
 
 	fusion = instance->ctrl_context;
 
@@ -5274,19 +5275,29 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	}
 
 	if (megasas_transition_to_ready(instance, 0)) {
-		atomic_set(&instance->fw_reset_no_pci_access, 1);
-		instance->instancet->adp_reset
-			(instance, instance->reg_set);
-		atomic_set(&instance->fw_reset_no_pci_access, 0);
-		dev_info(&instance->pdev->dev,
-			"FW restarted successfully from %s!\n",
-			__func__);
+		if (instance->adapter_type >= INVADER_SERIES) {
+			status_reg = instance->instancet->read_fw_status_reg(
+					instance->reg_set);
+			do_adp_reset = status_reg & MFI_RESET_ADAPTER;
+		}
 
-		/*waitting for about 30 second before retry*/
-		ssleep(30);
+		if (do_adp_reset) {
+			atomic_set(&instance->fw_reset_no_pci_access, 1);
+			instance->instancet->adp_reset
+				(instance, instance->reg_set);
+			atomic_set(&instance->fw_reset_no_pci_access, 0);
+			dev_info(&instance->pdev->dev,
+				 "FW restarted successfully from %s!\n",
+				 __func__);
+
+			/*waiting for about 30 second before retry*/
+			ssleep(30);
 
-		if (megasas_transition_to_ready(instance, 0))
+			if (megasas_transition_to_ready(instance, 0))
+				goto fail_ready_state;
+		} else {
 			goto fail_ready_state;
+		}
 	}
 
 	megasas_init_ctrl_params(instance);
-- 
2.20.1



