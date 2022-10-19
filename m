Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED601603CF3
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiJSIzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiJSIxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6E1900F3;
        Wed, 19 Oct 2022 01:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 252BA6185A;
        Wed, 19 Oct 2022 08:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B4FC433C1;
        Wed, 19 Oct 2022 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169381;
        bh=dpmfuil9lNxXifQSERoW/TzZX+NjtUzA3eqhEsAnYsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DPziJ7WQfx0ktEnMi1Mx9HPzNrlMClNnu9JjP/MgwfaYKyXY6o06DZGX4oIVCG53
         B2xXETMur5w7ULUuoFPazhexWsmvh4AttcSuEzwzYdQ1GjUf2g7H0bsJh/YXLMtJ15
         siwFyi4Qu/ix/H/kvti8OEWUjSrr4WmbppQmKsfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 255/862] wifi: ath11k: Fix incorrect QMI message ID mappings
Date:   Wed, 19 Oct 2022 10:25:42 +0200
Message-Id: <20221019083301.325933874@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

[ Upstream commit b3ca32308e46b6384fdcb7e64b3fca4f61aff14b ]

QMI message IDs for some of the QMI messages were incorrectly
defined in the original implementation. These have to be corrected
to enable cold boot support on WCN6750. These corrections are
applicable for all chipsets and will not impact them. Refactor the
code accordingly.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220720134909.15626-2-quic_mpubbise@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 38 ++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/qmi.h | 10 +++++--
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 00136601cb7d..e6ced8597e1d 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1696,6 +1696,13 @@ static struct qmi_elem_info qmi_wlanfw_wlan_ini_resp_msg_v01_ei[] = {
 	},
 };
 
+static struct qmi_elem_info qmi_wlfw_fw_init_done_ind_msg_v01_ei[] = {
+	{
+		.data_type = QMI_EOTI,
+		.array_type = NO_ARRAY,
+	},
+};
+
 static int ath11k_qmi_host_cap_send(struct ath11k_base *ab)
 {
 	struct qmi_wlanfw_host_cap_req_msg_v01 req;
@@ -3006,6 +3013,10 @@ static void ath11k_qmi_msg_fw_ready_cb(struct qmi_handle *qmi_hdl,
 	struct ath11k_base *ab = qmi->ab;
 
 	ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi firmware ready\n");
+
+	ab->qmi.cal_done = 1;
+	wake_up(&ab->qmi.cold_boot_waitq);
+
 	ath11k_qmi_driver_event_post(qmi, ATH11K_QMI_EVENT_FW_READY, NULL);
 }
 
@@ -3018,11 +3029,22 @@ static void ath11k_qmi_msg_cold_boot_cal_done_cb(struct qmi_handle *qmi_hdl,
 					      struct ath11k_qmi, handle);
 	struct ath11k_base *ab = qmi->ab;
 
-	ab->qmi.cal_done = 1;
-	wake_up(&ab->qmi.cold_boot_waitq);
 	ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi cold boot calibration done\n");
 }
 
+static void ath11k_qmi_msg_fw_init_done_cb(struct qmi_handle *qmi_hdl,
+					   struct sockaddr_qrtr *sq,
+					   struct qmi_txn *txn,
+					   const void *decoded)
+{
+	struct ath11k_qmi *qmi = container_of(qmi_hdl,
+					      struct ath11k_qmi, handle);
+	struct ath11k_base *ab = qmi->ab;
+
+	ath11k_qmi_driver_event_post(qmi, ATH11K_QMI_EVENT_FW_INIT_DONE, NULL);
+	ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi firmware init done\n");
+}
+
 static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
 	{
 		.type = QMI_INDICATION,
@@ -3053,6 +3075,14 @@ static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
 			sizeof(struct qmi_wlanfw_fw_cold_cal_done_ind_msg_v01),
 		.fn = ath11k_qmi_msg_cold_boot_cal_done_cb,
 	},
+	{
+		.type = QMI_INDICATION,
+		.msg_id = QMI_WLFW_FW_INIT_DONE_IND_V01,
+		.ei = qmi_wlfw_fw_init_done_ind_msg_v01_ei,
+		.decoded_size =
+			sizeof(struct qmi_wlfw_fw_init_done_ind_msg_v01),
+		.fn = ath11k_qmi_msg_fw_init_done_cb,
+	},
 };
 
 static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
@@ -3145,7 +3175,7 @@ static void ath11k_qmi_driver_event_work(struct work_struct *work)
 			}
 
 			break;
-		case ATH11K_QMI_EVENT_FW_READY:
+		case ATH11K_QMI_EVENT_FW_INIT_DONE:
 			clear_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags);
 			if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
 				ath11k_hal_dump_srng_stats(ab);
@@ -3168,6 +3198,8 @@ static void ath11k_qmi_driver_event_work(struct work_struct *work)
 				set_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags);
 			}
 
+			break;
+		case ATH11K_QMI_EVENT_FW_READY:
 			break;
 		case ATH11K_QMI_EVENT_COLD_BOOT_CAL_DONE:
 			break;
diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index c83cf822be81..2ec56a34fa81 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -31,8 +31,9 @@
 
 #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
 #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
-#define QMI_WLFW_COLD_BOOT_CAL_DONE_IND_V01	0x0021
-#define QMI_WLFW_FW_READY_IND_V01		0x0038
+#define QMI_WLFW_COLD_BOOT_CAL_DONE_IND_V01	0x003E
+#define QMI_WLFW_FW_READY_IND_V01		0x0021
+#define QMI_WLFW_FW_INIT_DONE_IND_V01		0x0038
 
 #define QMI_WLANFW_MAX_DATA_SIZE_V01		6144
 #define ATH11K_FIRMWARE_MODE_OFF		4
@@ -69,6 +70,7 @@ enum ath11k_qmi_event_type {
 	ATH11K_QMI_EVENT_FORCE_FW_ASSERT,
 	ATH11K_QMI_EVENT_POWER_UP,
 	ATH11K_QMI_EVENT_POWER_DOWN,
+	ATH11K_QMI_EVENT_FW_INIT_DONE,
 	ATH11K_QMI_EVENT_MAX,
 };
 
@@ -291,6 +293,10 @@ struct qmi_wlanfw_fw_cold_cal_done_ind_msg_v01 {
 	char placeholder;
 };
 
+struct qmi_wlfw_fw_init_done_ind_msg_v01 {
+	char placeholder;
+};
+
 #define QMI_WLANFW_CAP_REQ_MSG_V01_MAX_LEN		0
 #define QMI_WLANFW_CAP_RESP_MSG_V01_MAX_LEN		235
 #define QMI_WLANFW_CAP_REQ_V01				0x0024
-- 
2.35.1



