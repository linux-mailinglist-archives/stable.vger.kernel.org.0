Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8413092F0
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhA3JKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhA3JJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 04:09:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 472A764E0B;
        Sat, 30 Jan 2021 09:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611997754;
        bh=dXm/4E8T/66GiCa2+ORpJ3enzBA8bduZa1cwDBHAP5I=;
        h=Subject:To:From:Date:From;
        b=e8zD9FakE4PKkGqfbm61t3OPW/ylC0rmAtFnZ3fZnX1y8hIC0Ej7JGC+zNBcFkXw2
         uWgQnlisK+2WKR5ljbEelkRV9O/5qmI1az+ZlMkDIqMp68UVEcmaU4RBkXqsUpcQbo
         Xj05j+jvRkKZrT5OWy5/GYEuioxP2FKAIEKhZixY=
Subject: patch "mei: fix transfer over dma with extended header" added to char-misc-next
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 10:09:08 +0100
Message-ID: <1611997748214207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: fix transfer over dma with extended header

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1309ecc90f16ee9cc3077761e7f4474369747e6e Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Fri, 29 Jan 2021 14:07:46 +0200
Subject: mei: fix transfer over dma with extended header

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
 drivers/misc/mei/interrupt.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 326955b04fda..2161c1234ad7 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -295,12 +295,17 @@ static inline bool hdr_is_fixed(struct mei_msg_hdr *mei_hdr)
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
@@ -324,6 +329,8 @@ int mei_irq_read_handler(struct mei_device *dev,
 	struct mei_cl *cl;
 	int ret;
 	u32 ext_meta_hdr_u32;
+	u32 hdr_size_left;
+	u32 hdr_size_ext;
 	int i;
 	int ext_hdr_end;
 
@@ -353,6 +360,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 	}
 
 	ext_hdr_end = 1;
+	hdr_size_left = mei_hdr->length;
 
 	if (mei_hdr->extended) {
 		if (!dev->rd_msg_hdr[1]) {
@@ -363,8 +371,21 @@ int mei_irq_read_handler(struct mei_device *dev,
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
@@ -376,6 +397,12 @@ int mei_irq_read_handler(struct mei_device *dev,
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
-- 
2.30.0


