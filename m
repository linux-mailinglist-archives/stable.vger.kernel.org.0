Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F532A9085
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbfIDSKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389710AbfIDSKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D941822CEA;
        Wed,  4 Sep 2019 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620609;
        bh=6XRE8xbU++txFaG36O0sRiPHIXRWPe7hhb+INkjwXXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ba3/XzmjmJ7i7ky2Q3j3U0MoJdqmj+lExT3VfO9gOP+Vu5wKhS09FYX97rYTuYQdB
         XwtOCj7CQbV/hOoNCIEbRA2URFEFGYtG1CUE31JLF8aAV7gRGreQWdTpExMPPgZRoJ
         Ys7R1zbNNykw6tQ3fJ+Zn1F4J0/FxeEg0SR5YWOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segal <bpsegal20@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 029/143] habanalabs: fix endianness handling for packets from user
Date:   Wed,  4 Sep 2019 19:52:52 +0200
Message-Id: <20190904175315.197511495@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



