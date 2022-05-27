Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19B4535C10
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349951AbiE0IwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350049AbiE0Ivs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:51:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7359E4E382;
        Fri, 27 May 2022 01:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6CF8CE2380;
        Fri, 27 May 2022 08:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD185C385A9;
        Fri, 27 May 2022 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641489;
        bh=JFZlDmksJuy0p/OxKgX958KXH1pZHkd3DYTch83zLbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asvRRCioP4k8+fDtvSxyV0VfJamazfcgMoAjNvAUmAy9F8pQNwTBrIL9SMEM3rQxu
         62UsZa/yalJwPevi0zyibxRFZ7/wwqLVVhtraKoToyHRHZrpwfASHn5znxXoFFKe+9
         rKx8eVMZOqxskQo1e3w5znSieguT0dCJ4Fm/dFUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 001/145] HID: amd_sfh: Add support for sensor discovery
Date:   Fri, 27 May 2022 10:48:22 +0200
Message-Id: <20220527084850.590972756@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit b5d7f43e97dabfa04a4be5ff027ce7da119332be upstream.

Sensor discovery status fails in case of broken sensors or
platform not supported. Hence disable driver on failure
of sensor discovery.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c |   11 +++++++++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c   |    7 +++++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h   |    4 ++++
 3 files changed, 22 insertions(+)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -226,6 +226,17 @@ int amd_sfh_hid_client_init(struct amd_m
 		dev_dbg(dev, "sid 0x%x status 0x%x\n",
 			cl_data->sensor_idx[i], cl_data->sensor_sts[i]);
 	}
+	if (privdata->mp2_ops->discovery_status &&
+	    privdata->mp2_ops->discovery_status(privdata) == 0) {
+		amd_sfh_hid_client_deinit(privdata);
+		for (i = 0; i < cl_data->num_hid_devices; i++) {
+			devm_kfree(dev, cl_data->feature_report[i]);
+			devm_kfree(dev, in_data->input_report[i]);
+			devm_kfree(dev, cl_data->report_descr[i]);
+		}
+		dev_warn(dev, "Failed to discover, sensors not enabled\n");
+		return -EOPNOTSUPP;
+	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
 	return 0;
 
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -126,6 +126,12 @@ static int amd_sfh_irq_init_v2(struct am
 	return 0;
 }
 
+static int amd_sfh_dis_sts_v2(struct amd_mp2_dev *privdata)
+{
+	return (readl(privdata->mmio + AMD_P2C_MSG(1)) &
+		      SENSOR_DISCOVERY_STATUS_MASK) >> SENSOR_DISCOVERY_STATUS_SHIFT;
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -241,6 +247,7 @@ static const struct amd_mp2_ops amd_sfh_
 	.response = amd_sfh_wait_response_v2,
 	.clear_intr = amd_sfh_clear_intr_v2,
 	.init_intr = amd_sfh_irq_init_v2,
+	.discovery_status = amd_sfh_dis_sts_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -38,6 +38,9 @@
 
 #define AMD_SFH_IDLE_LOOP	200
 
+#define SENSOR_DISCOVERY_STATUS_MASK		GENMASK(5, 3)
+#define SENSOR_DISCOVERY_STATUS_SHIFT		3
+
 /* SFH Command register */
 union sfh_cmd_base {
 	u32 ul;
@@ -142,5 +145,6 @@ struct amd_mp2_ops {
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 	 void (*clear_intr)(struct amd_mp2_dev *privdata);
 	 int (*init_intr)(struct amd_mp2_dev *privdata);
+	 int (*discovery_status)(struct amd_mp2_dev *privdata);
 };
 #endif


