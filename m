Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA36F6948DC
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBMOyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjBMOx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE779113F2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75900B81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95F9C4339C;
        Mon, 13 Feb 2023 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300026;
        bh=1llLMwtq/nFFNr7x4mcJ8VB2OxVCixEDxRFdsIPb3mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSBH0VIYHHwK66hPEmL62+0VlEqJK71sKAWvNfEpqgoz4nX8NTnuJiLafyLe4Y1Sp
         yawrtFWT0XQcKx5zOT1DVLFFU+HDGLpj75HqjWQZNPueQaB/+4juiUUKrfzCeNpD7T
         z4jeRiWUSaSl678Of7t4w+D/JCtmwVg62ezqbC10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xaver Hugl <xaver.hugl@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/114] HID: amd_sfh: if no sensors are enabled, clean up
Date:   Mon, 13 Feb 2023 15:47:50 +0100
Message-Id: <20230213144743.961562101@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7bcfdab3f0c6672ca52be3cb65a0550d8b99554b ]

It was reported that commit b300667b33b2 ("HID: amd_sfh: Disable the
interrupt for all command") had caused increased resume time on HP Envy
x360.

Before this commit 3 sensors were reported, but they were not actually
functional.  After this commit the sensors are no longer reported, but
also the resume time increased.

To avoid this problem explicitly look for the number of disabled sensors.
If all the sensors are disabled, clean everything up.

Fixes: b300667b33b2 ("HID: amd_sfh: Disable the interrupt for all command")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://lore.kernel.org/r/20230203220850.13924-1-mario.limonciello@amd.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 13 +++++++++++--
 drivers/hid/amd-sfh-hid/amd_sfh_hid.h    |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 1fb0f7105fb21..c751d12f5df89 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -227,6 +227,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 	cl_data->num_hid_devices = amd_mp2_get_sensor_num(privdata, &cl_data->sensor_idx[0]);
 	if (cl_data->num_hid_devices == 0)
 		return -ENODEV;
+	cl_data->is_any_sensor_enabled = false;
 
 	INIT_DELAYED_WORK(&cl_data->work, amd_sfh_work);
 	INIT_DELAYED_WORK(&cl_data->work_buffer, amd_sfh_work_buffer);
@@ -287,6 +288,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		status = amd_sfh_wait_for_response
 				(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
 		if (status == SENSOR_ENABLED) {
+			cl_data->is_any_sensor_enabled = true;
 			cl_data->sensor_sts[i] = SENSOR_ENABLED;
 			rc = amdtp_hid_probe(cl_data->cur_hid_dev, cl_data);
 			if (rc) {
@@ -301,19 +303,26 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 					cl_data->sensor_sts[i]);
 				goto cleanup;
 			}
+		} else {
+			cl_data->sensor_sts[i] = SENSOR_DISABLED;
+			dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
+				cl_data->sensor_idx[i],
+				get_sensor_name(cl_data->sensor_idx[i]),
+				cl_data->sensor_sts[i]);
 		}
 		dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
 			cl_data->sensor_idx[i], get_sensor_name(cl_data->sensor_idx[i]),
 			cl_data->sensor_sts[i]);
 	}
-	if (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0) {
+	if (!cl_data->is_any_sensor_enabled ||
+	   (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
 		amd_sfh_hid_client_deinit(privdata);
 		for (i = 0; i < cl_data->num_hid_devices; i++) {
 			devm_kfree(dev, cl_data->feature_report[i]);
 			devm_kfree(dev, in_data->input_report[i]);
 			devm_kfree(dev, cl_data->report_descr[i]);
 		}
-		dev_warn(dev, "Failed to discover, sensors not enabled\n");
+		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n", cl_data->is_any_sensor_enabled);
 		return -EOPNOTSUPP;
 	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
index 3754fb423e3ae..528036892c9d2 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
@@ -32,6 +32,7 @@ struct amd_input_data {
 struct amdtp_cl_data {
 	u8 init_done;
 	u32 cur_hid_dev;
+	bool is_any_sensor_enabled;
 	u32 hid_dev_count;
 	u32 num_hid_devices;
 	struct device_info *hid_devices;
-- 
2.39.0



