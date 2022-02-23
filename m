Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7164C082E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbiBWCaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbiBWC3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:29:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0E446165;
        Tue, 22 Feb 2022 18:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3044AB81E0F;
        Wed, 23 Feb 2022 02:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE4C340E8;
        Wed, 23 Feb 2022 02:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583336;
        bh=CBtmbMSN8Ud6f1S/BhmZQISLY6FZF8krH7Q/lRFQIxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KU1k/NjS+jo6Mi8V61Yqd//ubJ/hZYpup0bDMDcODCTy+dK3fHUVJAvic5viS6Gg/
         bvlhrAu6HKrC3hp7+3Z7gz6yxpJYqFO+nCDHq054Ps/HMt0nLDz15WK4mteXYn1HH9
         fvYdzetS1YKodZ6uuL562izRA02fn8NR8jEPYjOVzW+moLBcxN3yjknah2m9WqIGCz
         r4gRWFn8QDttYFGF7b0lU8M4pFdGnKck7DnMAdRawPkJibRF177qlERaGuxVMUnfXc
         2RdtlrnNJwfj5rv90OYgwsULHUdXJl6nowQUWcf5vNK2DpFx+fV4rdsDHuzxG14Csj
         pdIMEuNu0JdIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        nehal-bakulchandra.shah@amd.com, basavaraj.natikar@amd.com,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 18/30] HID: amd_sfh: Add functionality to clear interrupts
Date:   Tue, 22 Feb 2022 21:28:07 -0500
Message-Id: <20220223022820.240649-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
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

[ Upstream commit fb75a3791a8032848c987db29b622878d8fe2b1c ]

Newer AMD platforms with SFH may generate interrupts on some events
which are unwarranted. Until this is cleared the actual MP2 data
processing maybe stalled in some cases.

Add a mechanism to clear the pending interrupts (if any) during the
driver initialization and sensor command operations.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 25 ++++++++++++++++++++++++-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h |  1 +
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 98cc50995c1ec..f146b0f0ab353 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -89,6 +89,20 @@ static void amd_stop_all_sensor_v2(struct amd_mp2_dev *privdata)
 	writel(cmd_base.ul, privdata->mmio + AMD_C2P_MSG0);
 }
 
+static void amd_sfh_clear_intr_v2(struct amd_mp2_dev *privdata)
+{
+	if (readl(privdata->mmio + AMD_P2C_MSG(4))) {
+		writel(0, privdata->mmio + AMD_P2C_MSG(4));
+		writel(0xf, privdata->mmio + AMD_P2C_MSG(5));
+	}
+}
+
+static void amd_sfh_clear_intr(struct amd_mp2_dev *privdata)
+{
+	if (privdata->mp2_ops->clear_intr)
+		privdata->mp2_ops->clear_intr(privdata);
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -193,6 +207,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	amd_sfh_clear_intr(mp2);
 }
 
 static const struct amd_mp2_ops amd_sfh_ops_v2 = {
@@ -200,6 +215,7 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop = amd_stop_sensor_v2,
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
+	.clear_intr = amd_sfh_clear_intr_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -262,8 +278,13 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	mp2_select_ops(privdata);
 
 	rc = amd_sfh_hid_client_init(privdata);
-	if (rc)
+	if (rc) {
+		amd_sfh_clear_intr(privdata);
+		dev_err(&pdev->dev, "amd_sfh_hid_client_init failed\n");
 		return rc;
+	}
+
+	amd_sfh_clear_intr(privdata);
 
 	return devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
 }
@@ -291,6 +312,7 @@ static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 	}
 
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
+	amd_sfh_clear_intr(mp2);
 
 	return 0;
 }
@@ -315,6 +337,7 @@ static int __maybe_unused amd_mp2_pci_suspend(struct device *dev)
 	}
 
 	cancel_delayed_work_sync(&cl_data->work_buffer);
+	amd_sfh_clear_intr(mp2);
 
 	return 0;
 }
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index ae30e059f8475..3ad7204b52b1e 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -141,5 +141,6 @@ struct amd_mp2_ops {
 	 void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
+	 void (*clear_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
-- 
2.34.1

