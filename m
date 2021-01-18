Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F182FA30D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392945AbhARObY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389186AbhARLnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE782223E;
        Mon, 18 Jan 2021 11:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970161;
        bh=kAeYGyxjJHr6PJUf3V2kvHwuqdbVpOB+4IXFVhgsRB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WswtUZRSqzIPTs2f/KFcSITxqx4cBnFRxa+IsFLKlrDA/BeHEUNwDKus1yeByitF0
         gqyzZ/dr5Dx0q2isQdXl8CTRTcj4akSqYvopQg/7ZaCcIEcaQ/2KDcz718T865lma/
         oe/NTQDxUT9Brxj9EtY1AfKtiBAaM/WDUAf2JqPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/152] ath11k: qmi: try to allocate a big block of DMA memory first
Date:   Mon, 18 Jan 2021 12:33:57 +0100
Message-Id: <20210118113355.766127270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit f6f92968e1e5a7a9d211faaebefc26ebe408dad7 ]

Not all firmware versions support allocating DMA memory in smaller blocks so
first try to allocate big block of DMA memory for QMI. If the allocation fails,
let firmware request multiple blocks of DMA memory with smaller size.

This also fixes an unnecessary error message seen during ath11k probe on
QCA6390:

ath11k_pci 0000:06:00.0: Respond mem req failed, result: 1, err: 0
ath11k_pci 0000:06:00.0: qmi failed to respond fw mem req:-22

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1608127593-15192-1-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 24 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath11k/qmi.h |  1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 99a88ca83deaa..2ae7c6bf091e9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1654,6 +1654,7 @@ static int ath11k_qmi_respond_fw_mem_request(struct ath11k_base *ab)
 	struct qmi_wlanfw_respond_mem_resp_msg_v01 resp;
 	struct qmi_txn txn = {};
 	int ret = 0, i;
+	bool delayed;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
@@ -1666,11 +1667,13 @@ static int ath11k_qmi_respond_fw_mem_request(struct ath11k_base *ab)
 	 * failure to FW and FW will then request mulitple blocks of small
 	 * chunk size memory.
 	 */
-	if (!ab->bus_params.fixed_mem_region && ab->qmi.mem_seg_count <= 2) {
+	if (!ab->bus_params.fixed_mem_region && ab->qmi.target_mem_delayed) {
+		delayed = true;
 		ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi delays mem_request %d\n",
 			   ab->qmi.mem_seg_count);
 		memset(req, 0, sizeof(*req));
 	} else {
+		delayed = false;
 		req->mem_seg_len = ab->qmi.mem_seg_count;
 
 		for (i = 0; i < req->mem_seg_len ; i++) {
@@ -1702,6 +1705,12 @@ static int ath11k_qmi_respond_fw_mem_request(struct ath11k_base *ab)
 	}
 
 	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		/* the error response is expected when
+		 * target_mem_delayed is true.
+		 */
+		if (delayed && resp.resp.error == 0)
+			goto out;
+
 		ath11k_warn(ab, "Respond mem req failed, result: %d, err: %d\n",
 			    resp.resp.result, resp.resp.error);
 		ret = -EINVAL;
@@ -1736,6 +1745,8 @@ static int ath11k_qmi_alloc_target_mem_chunk(struct ath11k_base *ab)
 	int i;
 	struct target_mem_chunk *chunk;
 
+	ab->qmi.target_mem_delayed = false;
+
 	for (i = 0; i < ab->qmi.mem_seg_count; i++) {
 		chunk = &ab->qmi.target_mem[i];
 		chunk->vaddr = dma_alloc_coherent(ab->dev,
@@ -1743,6 +1754,15 @@ static int ath11k_qmi_alloc_target_mem_chunk(struct ath11k_base *ab)
 						  &chunk->paddr,
 						  GFP_KERNEL);
 		if (!chunk->vaddr) {
+			if (ab->qmi.mem_seg_count <= 2) {
+				ath11k_dbg(ab, ATH11K_DBG_QMI,
+					   "qmi dma allocation failed (%d B type %u), will try later with small size\n",
+					    chunk->size,
+					    chunk->type);
+				ath11k_qmi_free_target_mem_chunk(ab);
+				ab->qmi.target_mem_delayed = true;
+				return 0;
+			}
 			ath11k_err(ab, "failed to alloc memory, size: 0x%x, type: %u\n",
 				   chunk->size,
 				   chunk->type);
@@ -2467,7 +2487,7 @@ static void ath11k_qmi_msg_mem_request_cb(struct qmi_handle *qmi_hdl,
 				    ret);
 			return;
 		}
-	} else if (msg->mem_seg_len > 2) {
+	} else {
 		ret = ath11k_qmi_alloc_target_mem_chunk(ab);
 		if (ret) {
 			ath11k_warn(ab, "qmi failed to alloc target memory: %d\n",
diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index b0a818f0401b9..59f1452b3544c 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -121,6 +121,7 @@ struct ath11k_qmi {
 	struct target_mem_chunk target_mem[ATH11K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01];
 	u32 mem_seg_count;
 	u32 target_mem_mode;
+	bool target_mem_delayed;
 	u8 cal_done;
 	struct target_info target;
 	struct m3_mem_region m3_mem;
-- 
2.27.0



