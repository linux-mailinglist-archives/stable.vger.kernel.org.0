Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F3259A94
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgIAQvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgIAP0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C9F2137B;
        Tue,  1 Sep 2020 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973959;
        bh=FxowLbusYDR2zymEY5adH/FZFuXmtPQBFqYb2bvSphw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLiUE8miXGq6t8MsCXiNW9FJWvJfJK8JHUC4Dq1QLf7lQmmHAoCe4/DboJl7SSTQz
         D0iKi+srsBmXJc7Z212mbhPG+bOqlcGzfWjgmgSvihnIPyv0ryshBJQBozcDOlJLey
         zRgBvmUPU42NzKocj9qf5XpDLdn0XmEnSgUTH+FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Brooke Basile <brookebasile@gmail.com>,
        Felipe Balbi <balbi@kernel.org>, stable <stable@kernel.org>
Subject: [PATCH 4.19 115/125] USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()
Date:   Tue,  1 Sep 2020 17:11:10 +0200
Message-Id: <20200901150940.250736616@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brooke Basile <brookebasile@gmail.com>

commit 2b74b0a04d3e9f9f08ff026e5663dce88ff94e52 upstream.

Some values extracted by ncm_unwrap_ntb() could possibly lead to several
different out of bounds reads of memory.  Specifically the values passed
to netdev_alloc_skb_ip_align() need to be checked so that memory is not
overflowed.

Resolve this by applying bounds checking to a number of different
indexes and lengths of the structure parsing logic.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Brooke Basile <brookebasile@gmail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_ncm.c |   81 ++++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 12 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1184,12 +1184,15 @@ static int ncm_unwrap_ntb(struct gether
 	int		ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
+	unsigned	block_len;
 	struct sk_buff	*skb2;
 	int		ret = -EINVAL;
-	unsigned	max_size = le32_to_cpu(ntb_parameters.dwNtbOutMaxSize);
+	unsigned	ntb_max = le32_to_cpu(ntb_parameters.dwNtbOutMaxSize);
+	unsigned	frame_max = le16_to_cpu(ecm_desc.wMaxSegmentSize);
 	const struct ndp_parser_opts *opts = ncm->parser_opts;
 	unsigned	crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
 	int		dgram_counter;
+	bool		ndp_after_header;
 
 	/* dwSignature */
 	if (get_unaligned_le32(tmp) != opts->nth_sign) {
@@ -1208,25 +1211,37 @@ static int ncm_unwrap_ntb(struct gether
 	}
 	tmp++; /* skip wSequence */
 
+	block_len = get_ncm(&tmp, opts->block_length);
 	/* (d)wBlockLength */
-	if (get_ncm(&tmp, opts->block_length) > max_size) {
+	if (block_len > ntb_max) {
 		INFO(port->func.config->cdev, "OUT size exceeded\n");
 		goto err;
 	}
 
 	ndp_index = get_ncm(&tmp, opts->ndp_index);
+	ndp_after_header = false;
 
 	/* Run through all the NDP's in the NTB */
 	do {
-		/* NCM 3.2 */
-		if (((ndp_index % 4) != 0) &&
-				(ndp_index < opts->nth_size)) {
+		/*
+		 * NCM 3.2
+		 * dwNdpIndex
+		 */
+		if (((ndp_index % 4) != 0) ||
+				(ndp_index < opts->nth_size) ||
+				(ndp_index > (block_len -
+					      opts->ndp_size))) {
 			INFO(port->func.config->cdev, "Bad index: %#X\n",
 			     ndp_index);
 			goto err;
 		}
+		if (ndp_index == opts->nth_size)
+			ndp_after_header = true;
 
-		/* walk through NDP */
+		/*
+		 * walk through NDP
+		 * dwSignature
+		 */
 		tmp = (void *)(skb->data + ndp_index);
 		if (get_unaligned_le32(tmp) != ncm->ndp_sign) {
 			INFO(port->func.config->cdev, "Wrong NDP SIGN\n");
@@ -1237,14 +1252,15 @@ static int ncm_unwrap_ntb(struct gether
 		ndp_len = get_unaligned_le16(tmp++);
 		/*
 		 * NCM 3.3.1
+		 * wLength
 		 * entry is 2 items
 		 * item size is 16/32 bits, opts->dgram_item_len * 2 bytes
 		 * minimal: struct usb_cdc_ncm_ndpX + normal entry + zero entry
 		 * Each entry is a dgram index and a dgram length.
 		 */
 		if ((ndp_len < opts->ndp_size
-				+ 2 * 2 * (opts->dgram_item_len * 2))
-				|| (ndp_len % opts->ndplen_align != 0)) {
+				+ 2 * 2 * (opts->dgram_item_len * 2)) ||
+				(ndp_len % opts->ndplen_align != 0)) {
 			INFO(port->func.config->cdev, "Bad NDP length: %#X\n",
 			     ndp_len);
 			goto err;
@@ -1261,8 +1277,21 @@ static int ncm_unwrap_ntb(struct gether
 
 		do {
 			index = index2;
+			/* wDatagramIndex[0] */
+			if ((index < opts->nth_size) ||
+					(index > block_len - opts->dpe_size)) {
+				INFO(port->func.config->cdev,
+				     "Bad index: %#X\n", index);
+				goto err;
+			}
+
 			dg_len = dg_len2;
-			if (dg_len < 14 + crc_len) { /* ethernet hdr + crc */
+			/*
+			 * wDatagramLength[0]
+			 * ethernet hdr + crc or larger than max frame size
+			 */
+			if ((dg_len < 14 + crc_len) ||
+					(dg_len > frame_max)) {
 				INFO(port->func.config->cdev,
 				     "Bad dgram length: %#X\n", dg_len);
 				goto err;
@@ -1286,6 +1315,37 @@ static int ncm_unwrap_ntb(struct gether
 			index2 = get_ncm(&tmp, opts->dgram_item_len);
 			dg_len2 = get_ncm(&tmp, opts->dgram_item_len);
 
+			if (index2 == 0 || dg_len2 == 0)
+				break;
+
+			/* wDatagramIndex[1] */
+			if (ndp_after_header) {
+				if (index2 < opts->nth_size + opts->ndp_size) {
+					INFO(port->func.config->cdev,
+					     "Bad index: %#X\n", index2);
+					goto err;
+				}
+			} else {
+				if (index2 < opts->nth_size + opts->dpe_size) {
+					INFO(port->func.config->cdev,
+					     "Bad index: %#X\n", index2);
+					goto err;
+				}
+			}
+			if (index2 > block_len - opts->dpe_size) {
+				INFO(port->func.config->cdev,
+				     "Bad index: %#X\n", index2);
+				goto err;
+			}
+
+			/* wDatagramLength[1] */
+			if ((dg_len2 < 14 + crc_len) ||
+					(dg_len2 > frame_max)) {
+				INFO(port->func.config->cdev,
+				     "Bad dgram length: %#X\n", dg_len);
+				goto err;
+			}
+
 			/*
 			 * Copy the data into a new skb.
 			 * This ensures the truesize is correct
@@ -1302,9 +1362,6 @@ static int ncm_unwrap_ntb(struct gether
 			ndp_len -= 2 * (opts->dgram_item_len * 2);
 
 			dgram_counter++;
-
-			if (index2 == 0 || dg_len2 == 0)
-				break;
 		} while (ndp_len > 2 * (opts->dgram_item_len * 2));
 	} while (ndp_index);
 


