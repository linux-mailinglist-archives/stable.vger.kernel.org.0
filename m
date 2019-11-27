Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A2D10BC3A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732272AbfK0VJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbfK0VJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FC02154A;
        Wed, 27 Nov 2019 21:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888986;
        bh=L+jYQkLDbz7jdGIFvd7QPd5vlf8ZtyBtC/ptRMlOHZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHO8MNRz7HxQS5oZBLxHSPe8iYX8Mhil0qqMwOpFj5mcpBEsd4fpIYxw6TwKh8Mt9
         gyOGs9PF3lAQNkPp9hI8ToPlvhh+a6BdzSTVjhY8WXGsoSndSGdG34I9p0PAo2Fe0L
         ordUByjdoGuh3Ox0CShjyKyqVeCQ3quRPLMKSz/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 38/95] ath10k: Fix HOST capability QMI incompatibility
Date:   Wed, 27 Nov 2019 21:31:55 +0100
Message-Id: <20191127202903.182812979@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 7165ef890a4c44cf16db66b82fd78448f4bde6ba upstream.

The introduction of 768ec4c012ac ("ath10k: update HOST capability QMI
message") served the purpose of supporting the new and extended HOST
capability QMI message.

But while the new message adds a slew of optional members it changes the
data type of the "daemon_support" member, which means that older
versions of the firmware will fail to decode the incoming request
message.

There is no way to detect this breakage from Linux and there's no way to
recover from sending the wrong message (i.e. we can't just try one
format and then fallback to the other), so a quirk is introduced in
DeviceTree to indicate to the driver that the firmware requires the 8bit
version of this message.

Cc: stable@vger.kernel.org
Fixes: 768ec4c012ac ("ath10k: update HOST capability qmi message")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt |    6 ++
 drivers/net/wireless/ath/ath10k/qmi.c                          |   13 ++++-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c                 |   22 ++++++++++
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h                 |    1 
 drivers/net/wireless/ath/ath10k/snoc.c                         |   11 +++++
 drivers/net/wireless/ath/ath10k/snoc.h                         |    1 
 6 files changed, 51 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -81,6 +81,12 @@ Optional properties:
 	Definition: Name of external front end module used. Some valid FEM names
 		    for example: "microsemi-lx5586", "sky85703-11"
 		    and "sky85803" etc.
+- qcom,snoc-host-cap-8bit-quirk:
+	Usage: Optional
+	Value type: <empty>
+	Definition: Quirk specifying that the firmware expects the 8bit version
+		    of the host capability QMI request
+
 
 Example (to supply PCI based wifi block details):
 
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -581,22 +581,29 @@ static int ath10k_qmi_host_cap_send_sync
 {
 	struct wlfw_host_cap_resp_msg_v01 resp = {};
 	struct wlfw_host_cap_req_msg_v01 req = {};
+	struct qmi_elem_info *req_ei;
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
 	int ret;
 
 	req.daemon_support_valid = 1;
 	req.daemon_support = 0;
 
-	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
-			   wlfw_host_cap_resp_msg_v01_ei, &resp);
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_host_cap_resp_msg_v01_ei,
+			   &resp);
 	if (ret < 0)
 		goto out;
 
+	if (test_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags))
+		req_ei = wlfw_host_cap_8bit_req_msg_v01_ei;
+	else
+		req_ei = wlfw_host_cap_req_msg_v01_ei;
+
 	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
 			       QMI_WLFW_HOST_CAP_REQ_V01,
 			       WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN,
-			       wlfw_host_cap_req_msg_v01_ei, &req);
+			       req_ei, &req);
 	if (ret < 0) {
 		qmi_txn_cancel(&txn);
 		ath10k_err(ar, "failed to send host capability request: %d\n", ret);
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
@@ -1988,6 +1988,28 @@ struct qmi_elem_info wlfw_host_cap_req_m
 	{}
 };
 
+struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[] = {
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x10,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   daemon_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x10,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   daemon_support),
+	},
+	{}
+};
+
 struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
@@ -575,6 +575,7 @@ struct wlfw_host_cap_req_msg_v01 {
 
 #define WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN 189
 extern struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[];
+extern struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[];
 
 struct wlfw_host_cap_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1261,6 +1261,15 @@ out:
 	return ret;
 }
 
+static void ath10k_snoc_quirks_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct device *dev = &ar_snoc->dev->dev;
+
+	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-8bit-quirk"))
+		set_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags);
+}
+
 int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -1678,6 +1687,8 @@ static int ath10k_snoc_probe(struct plat
 	ar->ce_priv = &ar_snoc->ce;
 	msa_size = drv_data->msa_size;
 
+	ath10k_snoc_quirks_init(ar);
+
 	ret = ath10k_snoc_resource_init(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to initialize resource: %d\n", ret);
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -63,6 +63,7 @@ enum ath10k_snoc_flags {
 	ATH10K_SNOC_FLAG_REGISTERED,
 	ATH10K_SNOC_FLAG_UNREGISTERING,
 	ATH10K_SNOC_FLAG_RECOVERY,
+	ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK,
 };
 
 struct ath10k_snoc {


