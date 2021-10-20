Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06627434C3A
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJTNko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 09:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhJTNko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 09:40:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EF5C061746
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 06:38:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g79-20020a1c2052000000b00323023159e1so1830099wmg.2
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 06:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=D7S7r9FECONNPF1Z5UgVqVgPsfoniOE/HTO607xVpzo=;
        b=Id3rGnL3hEDWcIKfWcZiYDXL+Qg3NqOPhRa07bj/a5CUCZ95qFMxVpqvIfdDQWUB1/
         5UUx/Ipvx8RgH3SiyaxbUKNGQsdBF69ELWl84thNtfK1VZB0WP5DxAF5axldOu4Zj0uZ
         u4E6fqkuVmF9lZXE9IL56tULE0pv44S9FStY8v8sNPA2c/xl/YkQmDXnzOe+UvYJWX23
         mkVSeQmfWyffEkPREiE76Rt7DLgIdR96jqpq4x8FJJ9SDS0T4e4KVNaqgrslBQGGxcor
         p90IC7Kz+sv662+BiJq3X1Y3/qSE6VyIX8Z2ueF2zYGoof4gHAjaO1BHSDtvbDd5F+vC
         2Vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D7S7r9FECONNPF1Z5UgVqVgPsfoniOE/HTO607xVpzo=;
        b=s+ZIrKwb+e5vDSs5n5FSG6X7+LJ6luWmBIoNH2iEWFDRv13aq/WUAzZ3TJG030W8Kc
         aIBiRuQPj3LM8FFvJ17QotKGd4On9g7DcZyjSWhAP3uNg9TYQt2rvdDRCPPKAmNc+Uxi
         xJpscHbPPWAE4ow84GTL+EnK7zhCPaajx11QYaIeHp2vUMkRUleR+fabwlCaqqvINQBx
         FtjrETI8aq+RIvqHMw2xxN8bNjY3ClAnHO7M1fnmghXX1IqgkhsIqBh7E+LJextxKmGD
         mGYOkGmdpk7utbmidTZWc9BGY4YYmV+LOuVC6m5R0Fr1g4tO9zOsajYmwo+AwmqPX4hN
         i3/g==
X-Gm-Message-State: AOAM532EC07Stc8vMnAJI7fFXu5xnQROIUumNZ9h/wzDssggUVR4hpGq
        1pDUVcYsvzcDNGWx1VS9PwhO8g==
X-Google-Smtp-Source: ABdhPJxhRE0rlWdkAKcju+GjeOTDwiwk/ik5rjv9/TMAhUjJ8e97ZBcMgN7+H+hCLgCLX0EInrIs+A==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr51964082wrw.86.1634737108362;
        Wed, 20 Oct 2021 06:38:28 -0700 (PDT)
Received: from localhost.localdomain ([88.160.176.23])
        by smtp.gmail.com with ESMTPSA id z1sm2126579wre.21.2021.10.20.06.38.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 06:38:27 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] wcn36xx: Channel list update before hardware scan
Date:   Wed, 20 Oct 2021 15:50:01 +0200
Message-Id: <1634737801-26071-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The channel scan list must be updated before triggering a hardware scan
so that firmware takes into account the regulatory info for each single
channel such as active/passive config, power, DFS, etc... Without this
the firmware uses its own internal default channel configuration, which
is not aligned with mac80211 regulatory rules, and misses several
channels (e.g. 144).

Cc: stable@vger.kernel.org
Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h  | 27 +++++++++
 drivers/net/wireless/ath/wcn36xx/main.c |  1 +
 drivers/net/wireless/ath/wcn36xx/smd.c  | 98 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h  |  1 +
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 5f1f248..229a1c3 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -359,6 +359,8 @@ enum wcn36xx_hal_host_msg_type {
 	WCN36XX_HAL_START_SCAN_OFFLOAD_RSP = 205,
 	WCN36XX_HAL_STOP_SCAN_OFFLOAD_REQ = 206,
 	WCN36XX_HAL_STOP_SCAN_OFFLOAD_RSP = 207,
+	WCN36XX_HAL_UPDATE_CHANNEL_LIST_REQ = 208,
+	WCN36XX_HAL_UPDATE_CHANNEL_LIST_RSP = 209,
 	WCN36XX_HAL_SCAN_OFFLOAD_IND = 210,
 
 	WCN36XX_HAL_AVOID_FREQ_RANGE_IND = 233,
@@ -1353,6 +1355,31 @@ struct wcn36xx_hal_stop_scan_offload_rsp_msg {
 	u32 status;
 } __packed;
 
+#define WCN36XX_HAL_CHAN_FLAG_PASSIVE   BIT(7)
+#define WCN36XX_HAL_CHAN_FLAG_DFS       BIT(10)
+#define WCN36XX_HAL_CHAN_FLAG_HT        BIT(11)
+#define WCN36XX_HAL_CHAN_FLAG_VHT       BIT(12)
+#define WCN36XX_HAL_CHAN_PHY_MODE_11A   0
+#define WCN36XX_HAL_CHAN_PHY_MODE_11BG  1
+#define WCN36XX_HAL_DEFAULT_ANT_GAIN    6
+#define WCN36XX_HAL_DEFAULT_MIN_POWER   6
+
+struct wcn36xx_hal_channel_param {
+	u32 mhz;
+	u32 band_center_freq1;
+	u32 band_center_freq2;
+	u32 channel_info;
+	u32 reg_info_1;
+	u32 reg_info_2;
+} __packed;
+
+struct wcn36xx_hal_update_channel_list_req_msg {
+	struct wcn36xx_hal_msg_header header;
+
+	u8 num_channel;
+	struct wcn36xx_hal_channel_param channels[80];
+} __packed;
+
 enum wcn36xx_hal_rate_index {
 	HW_RATE_INDEX_1MBPS	= 0x82,
 	HW_RATE_INDEX_2MBPS	= 0x84,
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 4f139d9..a42eae6 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -689,6 +689,7 @@ static int wcn36xx_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_unlock(&wcn->scan_lock);
 
+	wcn36xx_smd_update_channel_list(wcn, &hw_req->req);
 	return wcn36xx_smd_start_hw_scan(wcn, vif, &hw_req->req);
 }
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 3cecc8f..608d4cc 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -928,6 +928,103 @@ int wcn36xx_smd_stop_hw_scan(struct wcn36xx *wcn)
 	return ret;
 }
 
+static void wcn36xx_channel_set_max_power(struct wcn36xx_hal_channel_param *p, u32 max)
+{
+	u32 min = WCN36XX_HAL_DEFAULT_MIN_POWER;
+
+	if (min > max)
+		min = max;
+
+	p->reg_info_1 &= 0xffff0000;
+	p->reg_info_1 |= (min & 0xff) + ((max & 0xff) << 8);
+}
+
+static void wcn36xx_channel_set_reg_power(struct wcn36xx_hal_channel_param *p, u32 power)
+{
+	p->reg_info_1 &= 0xff00ffff;
+	p->reg_info_1 |= (power & 0xff) << 16;
+}
+
+static void wcn36xx_channel_set_class_id(struct wcn36xx_hal_channel_param *p, u32 id)
+{
+	p->reg_info_1 &= 0x00ffffff;
+	p->reg_info_1 |= (id & 0xff) << 24;
+}
+
+static void wcn36xx_channel_set_antenna_gain(struct wcn36xx_hal_channel_param *p, u32 gain)
+{
+	if (!gain)
+		gain = WCN36XX_HAL_DEFAULT_ANT_GAIN;
+
+	p->reg_info_2 = gain;
+}
+
+int wcn36xx_smd_update_channel_list(struct wcn36xx *wcn, struct cfg80211_scan_request *req)
+{
+	struct wcn36xx_hal_update_channel_list_req_msg *msg_body;
+	int ret, i;
+
+	msg_body = kzalloc(sizeof(*msg_body), GFP_KERNEL);
+	if (!msg_body)
+		return -ENOMEM;
+
+	INIT_HAL_MSG((*msg_body), WCN36XX_HAL_UPDATE_CHANNEL_LIST_REQ);
+
+	msg_body->num_channel = min_t(u8, req->n_channels, sizeof(msg_body->channels));
+	for (i = 0; i < msg_body->num_channel; i++) {
+		struct wcn36xx_hal_channel_param *param = &msg_body->channels[i];
+
+		param->mhz = req->channels[i]->center_freq;
+		param->band_center_freq1 = req->channels[i]->center_freq;
+		param->band_center_freq2 = 0;
+
+		if (req->channels[i]->flags & IEEE80211_CHAN_NO_IR)
+			param->channel_info |= WCN36XX_HAL_CHAN_FLAG_PASSIVE;
+
+		if (req->channels[i]->flags & IEEE80211_CHAN_RADAR)
+			param->channel_info |= WCN36XX_HAL_CHAN_FLAG_DFS;
+
+		if (req->channels[i]->band == NL80211_BAND_5GHZ) {
+			param->channel_info |= WCN36XX_HAL_CHAN_FLAG_HT;
+			param->channel_info |= WCN36XX_HAL_CHAN_FLAG_VHT;
+			param->channel_info |= WCN36XX_HAL_CHAN_PHY_MODE_11A;
+		} else {
+			param->channel_info |= WCN36XX_HAL_CHAN_PHY_MODE_11BG;
+		}
+
+		wcn36xx_channel_set_max_power(param, req->channels[i]->max_power);
+		wcn36xx_channel_set_reg_power(param, req->channels[i]->max_reg_power);
+		wcn36xx_channel_set_antenna_gain(param, req->channels[i]->max_antenna_gain);
+		wcn36xx_channel_set_class_id(param, 0); /* don't care ? */
+
+		wcn36xx_dbg(WCN36XX_DBG_HAL,
+			    "%s: freq=%u, channel_info=%08x, reg_info1=%08x, reg_info2=%08x\n",
+			    __func__, param->mhz, param->channel_info, param->reg_info_1,
+			    param->reg_info_2);
+	}
+
+	mutex_lock(&wcn->hal_mutex);
+
+	PREPARE_HAL_BUF(wcn->hal_buf, (*msg_body));
+
+	ret = wcn36xx_smd_send_and_wait(wcn, msg_body->header.len);
+	if (ret) {
+		wcn36xx_err("Sending hal_update_channel_list failed\n");
+		goto out;
+	}
+
+	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
+	if (ret) {
+		wcn36xx_err("hal_update_channel_list response failed err=%d\n", ret);
+		goto out;
+	}
+
+out:
+	kfree(msg_body);
+	mutex_unlock(&wcn->hal_mutex);
+	return ret;
+}
+
 static int wcn36xx_smd_switch_channel_rsp(void *buf, size_t len)
 {
 	struct wcn36xx_hal_switch_channel_rsp_msg *rsp;
@@ -3138,6 +3235,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_HOST_RESUME_RSP:
 	case WCN36XX_HAL_ENTER_IMPS_RSP:
 	case WCN36XX_HAL_EXIT_IMPS_RSP:
+	case WCN36XX_HAL_UPDATE_CHANNEL_LIST_RSP:
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index 5f98c1d..88e045d 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -70,6 +70,7 @@ int wcn36xx_smd_update_scan_params(struct wcn36xx *wcn, u8 *channels, size_t cha
 int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 			      struct cfg80211_scan_request *req);
 int wcn36xx_smd_stop_hw_scan(struct wcn36xx *wcn);
+int wcn36xx_smd_update_channel_list(struct wcn36xx *wcn, struct cfg80211_scan_request *req);
 int wcn36xx_smd_add_sta_self(struct wcn36xx *wcn, struct ieee80211_vif *vif);
 int wcn36xx_smd_delete_sta_self(struct wcn36xx *wcn, u8 *addr);
 int wcn36xx_smd_delete_sta(struct wcn36xx *wcn, u8 sta_index);
-- 
2.7.4

