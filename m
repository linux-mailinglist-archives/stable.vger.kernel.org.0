Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F012535BFD
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349964AbiE0IvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349994AbiE0IvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A6139;
        Fri, 27 May 2022 01:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66E7161D3E;
        Fri, 27 May 2022 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB94C385A9;
        Fri, 27 May 2022 08:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641469;
        bh=BghL1surAkgirDQEAlsYzgJhE3Bu1nCy2mEUcXP8XK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aG9qFZHTokKP1Ildca7c2cCwjjsmDaYuSvrklGb/ajJUIh3iXnj1camtzU44xPhHY
         o2zCwMOvlI0G8aqGPImDPAHYQctguOTvP1BBdhM4JkfS3TPbbQdlzyb2N8rhzjewfW
         BwxSIYg5h67mp8hKpqKUiuL0CyQ5/14Fgxbdfh8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.18 02/47] HID: amd_sfh: Add support for sensor discovery
Date:   Fri, 27 May 2022 10:49:42 +0200
Message-Id: <20220527084801.537720164@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -227,6 +227,17 @@ int amd_sfh_hid_client_init(struct amd_m
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
@@ -130,6 +130,12 @@ static int amd_sfh_irq_init_v2(struct am
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
@@ -245,6 +251,7 @@ static const struct amd_mp2_ops amd_sfh_
 	.response = amd_sfh_wait_response_v2,
 	.clear_intr = amd_sfh_clear_intr_v2,
 	.init_intr = amd_sfh_irq_init_v2,
+	.discovery_status = amd_sfh_dis_sts_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -39,6 +39,9 @@
 
 #define AMD_SFH_IDLE_LOOP	200
 
+#define SENSOR_DISCOVERY_STATUS_MASK		GENMASK(5, 3)
+#define SENSOR_DISCOVERY_STATUS_SHIFT		3
+
 /* SFH Command register */
 union sfh_cmd_base {
 	u32 ul;
@@ -143,5 +146,6 @@ struct amd_mp2_ops {
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 	 void (*clear_intr)(struct amd_mp2_dev *privdata);
 	 int (*init_intr)(struct amd_mp2_dev *privdata);
+	 int (*discovery_status)(struct amd_mp2_dev *privdata);
 };
 #endif


