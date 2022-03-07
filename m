Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE72F4CF732
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbiCGJo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbiCGJkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B626374DE3;
        Mon,  7 Mar 2022 01:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47EADB810D1;
        Mon,  7 Mar 2022 09:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B5DC36AF7;
        Mon,  7 Mar 2022 09:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645718;
        bh=wtrHf0DEt28ZtCuvZ3yqQpW63WsACzFgMtatO3d91GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzjB10wNxIuNqZpYkJvfyT0E8WqAkuPrI9SKRB4TwtlDkw7z++oUPVge24sh3Se3A
         nztcf8szdUtAOlcT2bkJQJwDmg5+pLv5n3r/Vih+PlsB2EbYYrIgjs4wpnSwitM9LO
         W8QoaSrYsXiTjYCeRl0sbtLdWOmIuzpCMoVvaKnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/262] HID: amd_sfh: Add functionality to clear interrupts
Date:   Mon,  7 Mar 2022 10:15:59 +0100
Message-Id: <20220307091702.806610384@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4198a8a786c8a..f1efeeaa465a2 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -88,6 +88,20 @@ static void amd_stop_all_sensor_v2(struct amd_mp2_dev *privdata)
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
@@ -192,6 +206,7 @@ static void amd_mp2_pci_remove(void *privdata)
 	struct amd_mp2_dev *mp2 = privdata;
 	amd_sfh_hid_client_deinit(privdata);
 	mp2->mp2_ops->stop_all(mp2);
+	amd_sfh_clear_intr(mp2);
 }
 
 static const struct amd_mp2_ops amd_sfh_ops_v2 = {
@@ -199,6 +214,7 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.stop = amd_stop_sensor_v2,
 	.stop_all = amd_stop_all_sensor_v2,
 	.response = amd_sfh_wait_response_v2,
+	.clear_intr = amd_sfh_clear_intr_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
@@ -258,8 +274,13 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
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
@@ -288,6 +309,7 @@ static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 	}
 
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
+	amd_sfh_clear_intr(mp2);
 
 	return 0;
 }
@@ -313,6 +335,7 @@ static int __maybe_unused amd_mp2_pci_suspend(struct device *dev)
 	}
 
 	cancel_delayed_work_sync(&cl_data->work_buffer);
+	amd_sfh_clear_intr(mp2);
 
 	return 0;
 }
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 9c9119227135e..ee9818d3082e3 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -140,5 +140,6 @@ struct amd_mp2_ops {
 	 void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
 	 void (*stop_all)(struct amd_mp2_dev *privdata);
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
+	 void (*clear_intr)(struct amd_mp2_dev *privdata);
 };
 #endif
-- 
2.34.1



