Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1C4257C89
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgHaPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgHaP37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23132151B;
        Mon, 31 Aug 2020 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887799;
        bh=IEa2006O3n8PmfNmAyzY7CaL01uzQV8tXZR6GUr7JOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN+Z5Y7E7RxBzPS7iCSV74AMbIoFNvHuHmz/hhVI1NFnqsxYvQ9pMmK2Buwku3/ey
         BLbFccFb7OXhpw28OjjWi2gYBqlRvAh1TJ8bWTsBw+KKLMVOc9AQY72NmtDNUxcSmA
         wtQlvaqG374kHxsO7MQrw9Ua1XdLYCYXz8EXSM9k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 15/42] habanalabs: validate packet id during CB parse
Date:   Mon, 31 Aug 2020 11:29:07 -0400
Message-Id: <20200831152934.1023912-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit bc75be24fa88ef10eecaff2b2a9ada8189e5ab5d ]

During command buffer parsing, driver extracts packet id
from user buffer. Driver must validate this packet id, since it is
being used in order to extract information from internal structures.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 35 +++++++++++++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c   | 31 ++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 637a9d608707f..0261f60df5633 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -154,6 +154,29 @@ static const u16 gaudi_packet_sizes[MAX_PACKET_ID] = {
 	[PACKET_LOAD_AND_EXE]	= sizeof(struct packet_load_and_exe)
 };
 
+static inline bool validate_packet_id(enum packet_id id)
+{
+	switch (id) {
+	case PACKET_WREG_32:
+	case PACKET_WREG_BULK:
+	case PACKET_MSG_LONG:
+	case PACKET_MSG_SHORT:
+	case PACKET_CP_DMA:
+	case PACKET_REPEAT:
+	case PACKET_MSG_PROT:
+	case PACKET_FENCE:
+	case PACKET_LIN_DMA:
+	case PACKET_NOP:
+	case PACKET_STOP:
+	case PACKET_ARB_POINT:
+	case PACKET_WAIT:
+	case PACKET_LOAD_AND_EXE:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static const char * const
 gaudi_tpc_interrupts_cause[GAUDI_NUM_OF_TPC_INTR_CAUSE] = {
 	"tpc_address_exceed_slm",
@@ -3859,6 +3882,12 @@ static int gaudi_validate_cb(struct hl_device *hdev,
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
+		if (!validate_packet_id(pkt_id)) {
+			dev_err(hdev->dev, "Invalid packet id %u\n", pkt_id);
+			rc = -EINVAL;
+			break;
+		}
+
 		pkt_size = gaudi_packet_sizes[pkt_id];
 		cb_parsed_length += pkt_size;
 		if (cb_parsed_length > parser->user_cb_size) {
@@ -4082,6 +4111,12 @@ static int gaudi_patch_cb(struct hl_device *hdev,
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
+		if (!validate_packet_id(pkt_id)) {
+			dev_err(hdev->dev, "Invalid packet id %u\n", pkt_id);
+			rc = -EINVAL;
+			break;
+		}
+
 		pkt_size = gaudi_packet_sizes[pkt_id];
 		cb_parsed_length += pkt_size;
 		if (cb_parsed_length > parser->user_cb_size) {
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 88460b2138d88..c179085ced7b8 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -139,6 +139,25 @@ static u16 goya_packet_sizes[MAX_PACKET_ID] = {
 	[PACKET_STOP]		= sizeof(struct packet_stop)
 };
 
+static inline bool validate_packet_id(enum packet_id id)
+{
+	switch (id) {
+	case PACKET_WREG_32:
+	case PACKET_WREG_BULK:
+	case PACKET_MSG_LONG:
+	case PACKET_MSG_SHORT:
+	case PACKET_CP_DMA:
+	case PACKET_MSG_PROT:
+	case PACKET_FENCE:
+	case PACKET_LIN_DMA:
+	case PACKET_NOP:
+	case PACKET_STOP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static u64 goya_mmu_regs[GOYA_MMU_REGS_NUM] = {
 	mmDMA_QM_0_GLBL_NON_SECURE_PROPS,
 	mmDMA_QM_1_GLBL_NON_SECURE_PROPS,
@@ -3381,6 +3400,12 @@ static int goya_validate_cb(struct hl_device *hdev,
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
+		if (!validate_packet_id(pkt_id)) {
+			dev_err(hdev->dev, "Invalid packet id %u\n", pkt_id);
+			rc = -EINVAL;
+			break;
+		}
+
 		pkt_size = goya_packet_sizes[pkt_id];
 		cb_parsed_length += pkt_size;
 		if (cb_parsed_length > parser->user_cb_size) {
@@ -3616,6 +3641,12 @@ static int goya_patch_cb(struct hl_device *hdev,
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
+		if (!validate_packet_id(pkt_id)) {
+			dev_err(hdev->dev, "Invalid packet id %u\n", pkt_id);
+			rc = -EINVAL;
+			break;
+		}
+
 		pkt_size = goya_packet_sizes[pkt_id];
 		cb_parsed_length += pkt_size;
 		if (cb_parsed_length > parser->user_cb_size) {
-- 
2.25.1

