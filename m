Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531C596084
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfHTNl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729937AbfHTNl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:26 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB7E22DBF;
        Tue, 20 Aug 2019 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308485;
        bh=DDCgT1Nmrt2ow0/uFfydiLLSCAIVjJjYDtTpJrHqk6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJKxA2XE83IRwxwJqGPz5F07D5ghs43AqVKLMNRrMuCM4oJC/79vzToYsR9TqPtBk
         RAWCq8IDpAbEQ/OFoiZ8goMXma0o2IOf4EAUJs/q4rKgbXcaaDY5vWoUTjQzl3J/rD
         8uBGtQwADeaLfjFWZw5Xps/YA8u2Sq6gQazFUm7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Segal <bpsegal20@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 31/44] habanalabs: fix endianness handling for packets from user
Date:   Tue, 20 Aug 2019 09:40:15 -0400
Message-Id: <20190820134028.10829-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Segal <bpsegal20@gmail.com>

[ Upstream commit 213ad5ad016a0da975b35f54e8cd236c3b04724b ]

Packets that arrive from the user and need to be parsed by the driver are
assumed to be in LE format.

This patch fix all the places where the code handles these packets and use
the correct endianness macros to handle them, as the driver handles the
packets in CPU format (LE or BE depending on the arch).

Signed-off-by: Ben Segal <bpsegal20@gmail.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/goya/goya.c           | 32 +++++++++++--------
 .../habanalabs/include/goya/goya_packets.h    | 13 ++++++++
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 02d116b01a1a2..0644fd7742057 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -3425,12 +3425,13 @@ static int goya_validate_cb(struct hl_device *hdev,
 	while (cb_parsed_length < parser->user_cb_size) {
 		enum packet_id pkt_id;
 		u16 pkt_size;
-		void *user_pkt;
+		struct goya_packet *user_pkt;
 
-		user_pkt = (void *) (uintptr_t)
+		user_pkt = (struct goya_packet *) (uintptr_t)
 			(parser->user_cb->kernel_address + cb_parsed_length);
 
-		pkt_id = (enum packet_id) (((*(u64 *) user_pkt) &
+		pkt_id = (enum packet_id) (
+				(le64_to_cpu(user_pkt->header) &
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
@@ -3450,7 +3451,8 @@ static int goya_validate_cb(struct hl_device *hdev,
 			 * need to validate here as well because patch_cb() is
 			 * not called in MMU path while this function is called
 			 */
-			rc = goya_validate_wreg32(hdev, parser, user_pkt);
+			rc = goya_validate_wreg32(hdev,
+				parser, (struct packet_wreg32 *) user_pkt);
 			break;
 
 		case PACKET_WREG_BULK:
@@ -3478,10 +3480,10 @@ static int goya_validate_cb(struct hl_device *hdev,
 		case PACKET_LIN_DMA:
 			if (is_mmu)
 				rc = goya_validate_dma_pkt_mmu(hdev, parser,
-						user_pkt);
+					(struct packet_lin_dma *) user_pkt);
 			else
 				rc = goya_validate_dma_pkt_no_mmu(hdev, parser,
-						user_pkt);
+					(struct packet_lin_dma *) user_pkt);
 			break;
 
 		case PACKET_MSG_LONG:
@@ -3654,15 +3656,16 @@ static int goya_patch_cb(struct hl_device *hdev,
 		enum packet_id pkt_id;
 		u16 pkt_size;
 		u32 new_pkt_size = 0;
-		void *user_pkt, *kernel_pkt;
+		struct goya_packet *user_pkt, *kernel_pkt;
 
-		user_pkt = (void *) (uintptr_t)
+		user_pkt = (struct goya_packet *) (uintptr_t)
 			(parser->user_cb->kernel_address + cb_parsed_length);
-		kernel_pkt = (void *) (uintptr_t)
+		kernel_pkt = (struct goya_packet *) (uintptr_t)
 			(parser->patched_cb->kernel_address +
 					cb_patched_cur_length);
 
-		pkt_id = (enum packet_id) (((*(u64 *) user_pkt) &
+		pkt_id = (enum packet_id) (
+				(le64_to_cpu(user_pkt->header) &
 				PACKET_HEADER_PACKET_ID_MASK) >>
 					PACKET_HEADER_PACKET_ID_SHIFT);
 
@@ -3677,15 +3680,18 @@ static int goya_patch_cb(struct hl_device *hdev,
 
 		switch (pkt_id) {
 		case PACKET_LIN_DMA:
-			rc = goya_patch_dma_packet(hdev, parser, user_pkt,
-						kernel_pkt, &new_pkt_size);
+			rc = goya_patch_dma_packet(hdev, parser,
+					(struct packet_lin_dma *) user_pkt,
+					(struct packet_lin_dma *) kernel_pkt,
+					&new_pkt_size);
 			cb_patched_cur_length += new_pkt_size;
 			break;
 
 		case PACKET_WREG_32:
 			memcpy(kernel_pkt, user_pkt, pkt_size);
 			cb_patched_cur_length += pkt_size;
-			rc = goya_validate_wreg32(hdev, parser, kernel_pkt);
+			rc = goya_validate_wreg32(hdev, parser,
+					(struct packet_wreg32 *) kernel_pkt);
 			break;
 
 		case PACKET_WREG_BULK:
diff --git a/drivers/misc/habanalabs/include/goya/goya_packets.h b/drivers/misc/habanalabs/include/goya/goya_packets.h
index a14407b975e4e..ef54bad205099 100644
--- a/drivers/misc/habanalabs/include/goya/goya_packets.h
+++ b/drivers/misc/habanalabs/include/goya/goya_packets.h
@@ -52,6 +52,19 @@ enum goya_dma_direction {
 #define GOYA_PKT_CTL_MB_SHIFT		31
 #define GOYA_PKT_CTL_MB_MASK		0x80000000
 
+/* All packets have, at least, an 8-byte header, which contains
+ * the packet type. The kernel driver uses the packet header for packet
+ * validation and to perform any necessary required preparation before
+ * sending them off to the hardware.
+ */
+struct goya_packet {
+	__le64 header;
+	/* The rest of the packet data follows. Use the corresponding
+	 * packet_XXX struct to deference the data, based on packet type
+	 */
+	u8 contents[0];
+};
+
 struct packet_nop {
 	__le32 reserved;
 	__le32 ctl;
-- 
2.20.1

