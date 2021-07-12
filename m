Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6383C5453
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348353AbhGLH5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352296AbhGLHyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AC5611CC;
        Mon, 12 Jul 2021 07:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076293;
        bh=xWrZFeubD/OpOmCxUaMlADscuRZ4kZSPE7bfQ0O4AuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnwvqsSjxtd2MRdaxk9ahQdmrsCBRvMVty8c0P1xiWWMYSZubqvlf2QRfTvMCJ+X0
         Y6iV+/gZHa9hIHEvcz8bfOlCosLMTrirM1u8HTW26hCPIrol9BX8DfeF4ZK7WqD106
         xxTYM05H/JspJidjoOAKeU8LcrGMzBOVcRGpNQ8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 582/800] Bluetooth: Fix Set Extended (Scan Response) Data
Date:   Mon, 12 Jul 2021 08:10:05 +0200
Message-Id: <20210712061029.232357925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c9ed0a7077306f9d41d74fb006ab5dbada8349c5 ]

These command do have variable length and the length can go up to 251,
so this changes the struct to not use a fixed size and then when
creating the PDU only the actual length of the data send to the
controller.

Fixes: a0fb3726ba551 ("Bluetooth: Use Set ext adv/scan rsp data if controller supports")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  6 ++--
 include/net/bluetooth/hci_core.h |  8 ++---
 net/bluetooth/hci_request.c      | 51 ++++++++++++++++++--------------
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ea4ae551c426..18b135dc968b 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1774,13 +1774,15 @@ struct hci_cp_ext_adv_set {
 	__u8  max_events;
 } __packed;
 
+#define HCI_MAX_EXT_AD_LENGTH	251
+
 #define HCI_OP_LE_SET_EXT_ADV_DATA		0x2037
 struct hci_cp_le_set_ext_adv_data {
 	__u8  handle;
 	__u8  operation;
 	__u8  frag_pref;
 	__u8  length;
-	__u8  data[HCI_MAX_AD_LENGTH];
+	__u8  data[];
 } __packed;
 
 #define HCI_OP_LE_SET_EXT_SCAN_RSP_DATA		0x2038
@@ -1789,7 +1791,7 @@ struct hci_cp_le_set_ext_scan_rsp_data {
 	__u8  operation;
 	__u8  frag_pref;
 	__u8  length;
-	__u8  data[HCI_MAX_AD_LENGTH];
+	__u8  data[];
 } __packed;
 
 #define LE_SET_ADV_DATA_OP_COMPLETE	0x03
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c73ac52af186..89c8406dddb4 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -228,9 +228,9 @@ struct adv_info {
 	__u16	remaining_time;
 	__u16	duration;
 	__u16	adv_data_len;
-	__u8	adv_data[HCI_MAX_AD_LENGTH];
+	__u8	adv_data[HCI_MAX_EXT_AD_LENGTH];
 	__u16	scan_rsp_len;
-	__u8	scan_rsp_data[HCI_MAX_AD_LENGTH];
+	__u8	scan_rsp_data[HCI_MAX_EXT_AD_LENGTH];
 	__s8	tx_power;
 	__u32   min_interval;
 	__u32   max_interval;
@@ -550,9 +550,9 @@ struct hci_dev {
 	DECLARE_BITMAP(dev_flags, __HCI_NUM_FLAGS);
 
 	__s8			adv_tx_power;
-	__u8			adv_data[HCI_MAX_AD_LENGTH];
+	__u8			adv_data[HCI_MAX_EXT_AD_LENGTH];
 	__u8			adv_data_len;
-	__u8			scan_rsp_data[HCI_MAX_AD_LENGTH];
+	__u8			scan_rsp_data[HCI_MAX_EXT_AD_LENGTH];
 	__u8			scan_rsp_data_len;
 
 	struct list_head	adv_instances;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index fa9125b782f8..b069f640394d 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1697,30 +1697,33 @@ void __hci_req_update_scan_rsp_data(struct hci_request *req, u8 instance)
 		return;
 
 	if (ext_adv_capable(hdev)) {
-		struct hci_cp_le_set_ext_scan_rsp_data cp;
+		struct {
+			struct hci_cp_le_set_ext_scan_rsp_data cp;
+			u8 data[HCI_MAX_EXT_AD_LENGTH];
+		} pdu;
 
-		memset(&cp, 0, sizeof(cp));
+		memset(&pdu, 0, sizeof(pdu));
 
 		if (instance)
 			len = create_instance_scan_rsp_data(hdev, instance,
-							    cp.data);
+							    pdu.data);
 		else
-			len = create_default_scan_rsp_data(hdev, cp.data);
+			len = create_default_scan_rsp_data(hdev, pdu.data);
 
 		if (hdev->scan_rsp_data_len == len &&
-		    !memcmp(cp.data, hdev->scan_rsp_data, len))
+		    !memcmp(pdu.data, hdev->scan_rsp_data, len))
 			return;
 
-		memcpy(hdev->scan_rsp_data, cp.data, sizeof(cp.data));
+		memcpy(hdev->scan_rsp_data, pdu.data, len);
 		hdev->scan_rsp_data_len = len;
 
-		cp.handle = instance;
-		cp.length = len;
-		cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
-		cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
+		pdu.cp.handle = instance;
+		pdu.cp.length = len;
+		pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
+		pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
-		hci_req_add(req, HCI_OP_LE_SET_EXT_SCAN_RSP_DATA, sizeof(cp),
-			    &cp);
+		hci_req_add(req, HCI_OP_LE_SET_EXT_SCAN_RSP_DATA,
+			    sizeof(pdu.cp) + len, &pdu.cp);
 	} else {
 		struct hci_cp_le_set_scan_rsp_data cp;
 
@@ -1843,26 +1846,30 @@ void __hci_req_update_adv_data(struct hci_request *req, u8 instance)
 		return;
 
 	if (ext_adv_capable(hdev)) {
-		struct hci_cp_le_set_ext_adv_data cp;
+		struct {
+			struct hci_cp_le_set_ext_adv_data cp;
+			u8 data[HCI_MAX_EXT_AD_LENGTH];
+		} pdu;
 
-		memset(&cp, 0, sizeof(cp));
+		memset(&pdu, 0, sizeof(pdu));
 
-		len = create_instance_adv_data(hdev, instance, cp.data);
+		len = create_instance_adv_data(hdev, instance, pdu.data);
 
 		/* There's nothing to do if the data hasn't changed */
 		if (hdev->adv_data_len == len &&
-		    memcmp(cp.data, hdev->adv_data, len) == 0)
+		    memcmp(pdu.data, hdev->adv_data, len) == 0)
 			return;
 
-		memcpy(hdev->adv_data, cp.data, sizeof(cp.data));
+		memcpy(hdev->adv_data, pdu.data, len);
 		hdev->adv_data_len = len;
 
-		cp.length = len;
-		cp.handle = instance;
-		cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
-		cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
+		pdu.cp.length = len;
+		pdu.cp.handle = instance;
+		pdu.cp.operation = LE_SET_ADV_DATA_OP_COMPLETE;
+		pdu.cp.frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
-		hci_req_add(req, HCI_OP_LE_SET_EXT_ADV_DATA, sizeof(cp), &cp);
+		hci_req_add(req, HCI_OP_LE_SET_EXT_ADV_DATA,
+			    sizeof(pdu.cp) + len, &pdu.cp);
 	} else {
 		struct hci_cp_le_set_adv_data cp;
 
-- 
2.30.2



