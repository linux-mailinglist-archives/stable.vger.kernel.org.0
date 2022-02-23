Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4C34C0864
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbiBWCcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbiBWCbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771CC46B2C;
        Tue, 22 Feb 2022 18:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E59B81E11;
        Wed, 23 Feb 2022 02:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493ECC340F0;
        Wed, 23 Feb 2022 02:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583402;
        bh=i31bb2zXZyW/vuS38W8Wvwm4SJ7azgYszVUN/0707IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7lwcg8yFkiIn/efFSmCaIe0PcaqwqJesKwihx7B8/YfJkqZXw+WWs3RSEE/rX63f
         i7MdaYluKRRcdPKazRjjAcyigtYD+DYEX3FWZUn3PEPmyd8tykV0LJg9pM/ozySxoK
         9w0gRuSrAJpVkOfdUa9qYGX6t3phHPV1I8/BU4lulYI3HzGSinhINzfaZtBB7i+XZ2
         VHawOhKO/6si3vv00tNDpZg9oU8bij9urQatH6pieSp8t0Z3sblyTMOE0+PO0PckbR
         j9nugDyR93i0MKSdJfzv7KzoEBNodLI5H0CAXF1kciVa7XMv07Pg4AKC5JHrgw1DHS
         6jSYdHjcjwQYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        nehal-bakulchandra.shah@amd.com, basavaraj.natikar@amd.com,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/28] HID: amd_sfh: Add interrupt handler to process interrupts
Date:   Tue, 22 Feb 2022 21:29:18 -0500
Message-Id: <20220223022929.241127-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 7f016b35ca7623c71b31facdde080e8ce171a697 ]

On newer AMD platforms with SFH, it is observed that random interrupts
get generated on the SFH hardware and until this is cleared the firmware
sensor processing is stalled, resulting in no data been received to
driver side.

Add routines to handle these interrupts, so that firmware operations are
not stalled.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 40 ++++++++++++++++++++++++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h |  1 +
 2 files changed, 41 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 205827ecf4b8f..fef25dd32ace8 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -102,6 +102,30 @@ static void amd_sfh_clear_intr(struct amd_mp2_dev *privdata)
 		privdata->mp2_ops->clear_intr(privdata);
 }
 
+static irqreturn_t amd_sfh_irq_handler(int irq, void *data)
+{
+	amd_sfh_clear_intr(data);
+
+	return IRQ_HANDLED;
+}
+
+static int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
+{
+	int rc;
+
+	pci_intx(privdata->pdev, true);
+
+	rc = devm_request_irq(&privdata->pdev->dev, privdata->pdev->irq,
+			      amd_sfh_irq_handler, 0, DRIVER_NAME, privdata);
+	if (rc) {
+		dev_err(&privdata->pdev->dev, "failed to request irq %d err=%d\n",
+			privdata->pdev->irq, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -206,6 +230,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	pci_intx(mp2->pdev, false);
 	amd_sfh_clear_intr(mp2);
 }
 
@@ -215,6 +240,7 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
 	.clear_intr = amd_sfh_clear_intr_v2,
+	.init_intr = amd_sfh_irq_init_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -240,6 +266,14 @@ static void mp2_select_ops(struct amd_mp2_dev *privdata)
 	}
 }
 
+static int amd_sfh_irq_init(struct amd_mp2_dev *privdata)
+{
+	if (privdata->mp2_ops->init_intr)
+		return privdata->mp2_ops->init_intr(privdata);
+
+	return 0;
+}
+
 static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct amd_mp2_dev *privdata;
@@ -273,6 +307,12 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
 	mp2_select_ops(privdata);
 
+	rc = amd_sfh_irq_init(privdata);
+	if (rc) {
+		dev_err(&pdev->dev, "amd_sfh_irq_init failed\n");
+		return rc;
+	}
+
 	rc = amd_sfh_hid_client_init(privdata);
 	if (rc) {
 		amd_sfh_clear_intr(privdata);
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 0e7a2f22e1426..3a272d9c51169 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -141,5 +141,6 @@ struct amd_mp2_ops {
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 	 void (*clear_intr)(struct amd_mp2_dev *privdata);
+	 int (*init_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
-- 
2.34.1

