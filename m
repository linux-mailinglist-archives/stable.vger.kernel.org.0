Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1648F328B66
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhCASdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239861AbhCAS0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99EB965287;
        Mon,  1 Mar 2021 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619872;
        bh=cutZjhEcLMbvTq1DwCuchsn35l5wzQvk7LFc5mABSZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnmN4dukgfSwJdU5iAw407cNOph/byLQvXNMPNQcZNGLBYcvm2rihGjhiWy3qlZ0S
         BE8XRTjeIu9wsoEWrwu5/8+jnb8Y2V3PznSNCQJQHf154Q9QoRO1RV5KO2rV9E/Aan
         xh2u1U0g902Gi8wm0iByfRd8X/ttQZWUzokygLFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 611/663] mei: fix transfer over dma with extended header
Date:   Mon,  1 Mar 2021 17:14:19 +0100
Message-Id: <20210301161212.074573604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 1309ecc90f16ee9cc3077761e7f4474369747e6e upstream.

The size in header field for packet transferred over DMA
includes size of the extended header.
Include extended header in size check.
Add size and sanity checks on extended header.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/interrupt.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -295,12 +295,17 @@ static inline bool hdr_is_fixed(struct m
 static inline int hdr_is_valid(u32 msg_hdr)
 {
 	struct mei_msg_hdr *mei_hdr;
+	u32 expected_len = 0;
 
 	mei_hdr = (struct mei_msg_hdr *)&msg_hdr;
 	if (!msg_hdr || mei_hdr->reserved)
 		return -EBADMSG;
 
-	if (mei_hdr->dma_ring && mei_hdr->length != MEI_SLOT_SIZE)
+	if (mei_hdr->dma_ring)
+		expected_len += MEI_SLOT_SIZE;
+	if (mei_hdr->extended)
+		expected_len += MEI_SLOT_SIZE;
+	if (mei_hdr->length < expected_len)
 		return -EBADMSG;
 
 	return 0;
@@ -324,6 +329,8 @@ int mei_irq_read_handler(struct mei_devi
 	struct mei_cl *cl;
 	int ret;
 	u32 ext_meta_hdr_u32;
+	u32 hdr_size_left;
+	u32 hdr_size_ext;
 	int i;
 	int ext_hdr_end;
 
@@ -353,6 +360,7 @@ int mei_irq_read_handler(struct mei_devi
 	}
 
 	ext_hdr_end = 1;
+	hdr_size_left = mei_hdr->length;
 
 	if (mei_hdr->extended) {
 		if (!dev->rd_msg_hdr[1]) {
@@ -363,8 +371,21 @@ int mei_irq_read_handler(struct mei_devi
 			dev_dbg(dev->dev, "extended header is %08x\n",
 				ext_meta_hdr_u32);
 		}
-		meta_hdr = ((struct mei_ext_meta_hdr *)
-				dev->rd_msg_hdr + 1);
+		meta_hdr = ((struct mei_ext_meta_hdr *)dev->rd_msg_hdr + 1);
+		if (check_add_overflow((u32)sizeof(*meta_hdr),
+				       mei_slots2data(meta_hdr->size),
+				       &hdr_size_ext)) {
+			dev_err(dev->dev, "extended message size too big %d\n",
+				meta_hdr->size);
+			return -EBADMSG;
+		}
+		if (hdr_size_left < hdr_size_ext) {
+			dev_err(dev->dev, "corrupted message header len %d\n",
+				mei_hdr->length);
+			return -EBADMSG;
+		}
+		hdr_size_left -= hdr_size_ext;
+
 		ext_hdr_end = meta_hdr->size + 2;
 		for (i = dev->rd_msg_hdr_count; i < ext_hdr_end; i++) {
 			dev->rd_msg_hdr[i] = mei_read_hdr(dev);
@@ -376,6 +397,12 @@ int mei_irq_read_handler(struct mei_devi
 	}
 
 	if (mei_hdr->dma_ring) {
+		if (hdr_size_left != sizeof(dev->rd_msg_hdr[ext_hdr_end])) {
+			dev_err(dev->dev, "corrupted message header len %d\n",
+				mei_hdr->length);
+			return -EBADMSG;
+		}
+
 		dev->rd_msg_hdr[ext_hdr_end] = mei_read_hdr(dev);
 		dev->rd_msg_hdr_count++;
 		(*slots)--;


