Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012B615B0F
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfEGFjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbfEGFjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B78D20578;
        Tue,  7 May 2019 05:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207593;
        bh=H3dWrCyGMHt6/kIAA/p0j5jcMdF3+J6wuk9C3kpEW4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1URkmRTRI59pRPjMZJnVdqn9Azxy8kCB0KfZzy+ufXRejiR15iD9004febJl6d45o
         3soFBUUJTrRnD6rAszSpKAqmROlEK55sr1yQ2G/hXE/4mlCyS8Td3T3ehRgdjueyiR
         6QTUs7QVgqg74+8uRz6vEUdBP5ELv/RZdT/AuKdE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 43/95] media: cec: make cec_get_edid_spa_location() an inline function
Date:   Tue,  7 May 2019 01:37:32 -0400
Message-Id: <20190507053826.31622-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit b915bf575d5b7774d0f22d57d6c143e07dcaade2 ]

This function is needed by both V4L2 and CEC, so move this to
cec.h as a static inline since there are no obvious shared
modules between the two subsystems.

This patch, together with the following ones, fixes a
dependency bug: if CEC_CORE is disabled, then building adv7604
(and other HDMI receivers) will fail because an essential
function is now stubbed out.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.17 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/cec/cec-edid.c | 60 -------------------------------
 include/media/cec.h          | 70 ++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
index 38e3fec6152b..19a31d4c8603 100644
--- a/drivers/media/cec/cec-edid.c
+++ b/drivers/media/cec/cec-edid.c
@@ -22,66 +22,6 @@
 #include <linux/types.h>
 #include <media/cec.h>
 
-/*
- * This EDID is expected to be a CEA-861 compliant, which means that there are
- * at least two blocks and one or more of the extensions blocks are CEA-861
- * blocks.
- *
- * The returned location is guaranteed to be < size - 1.
- */
-static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
-{
-	unsigned int blocks = size / 128;
-	unsigned int block;
-	u8 d;
-
-	/* Sanity check: at least 2 blocks and a multiple of the block size */
-	if (blocks < 2 || size % 128)
-		return 0;
-
-	/*
-	 * If there are fewer extension blocks than the size, then update
-	 * 'blocks'. It is allowed to have more extension blocks than the size,
-	 * since some hardware can only read e.g. 256 bytes of the EDID, even
-	 * though more blocks are present. The first CEA-861 extension block
-	 * should normally be in block 1 anyway.
-	 */
-	if (edid[0x7e] + 1 < blocks)
-		blocks = edid[0x7e] + 1;
-
-	for (block = 1; block < blocks; block++) {
-		unsigned int offset = block * 128;
-
-		/* Skip any non-CEA-861 extension blocks */
-		if (edid[offset] != 0x02 || edid[offset + 1] != 0x03)
-			continue;
-
-		/* search Vendor Specific Data Block (tag 3) */
-		d = edid[offset + 2] & 0x7f;
-		/* Check if there are Data Blocks */
-		if (d <= 4)
-			continue;
-		if (d > 4) {
-			unsigned int i = offset + 4;
-			unsigned int end = offset + d;
-
-			/* Note: 'end' is always < 'size' */
-			do {
-				u8 tag = edid[i] >> 5;
-				u8 len = edid[i] & 0x1f;
-
-				if (tag == 3 && len >= 5 && i + len <= end &&
-				    edid[i + 1] == 0x03 &&
-				    edid[i + 2] == 0x0c &&
-				    edid[i + 3] == 0x00)
-					return i + 4;
-				i += len + 1;
-			} while (i < end);
-		}
-	}
-	return 0;
-}
-
 u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 			   unsigned int *offset)
 {
diff --git a/include/media/cec.h b/include/media/cec.h
index df6b3bd31284..b7339cc6fd3d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -435,4 +435,74 @@ static inline void cec_phys_addr_invalidate(struct cec_adapter *adap)
 	cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
 }
 
+/**
+ * cec_get_edid_spa_location() - find location of the Source Physical Address
+ *
+ * @edid: the EDID
+ * @size: the size of the EDID
+ *
+ * This EDID is expected to be a CEA-861 compliant, which means that there are
+ * at least two blocks and one or more of the extensions blocks are CEA-861
+ * blocks.
+ *
+ * The returned location is guaranteed to be <= size-2.
+ *
+ * This is an inline function since it is used by both CEC and V4L2.
+ * Ideally this would go in a module shared by both, but it is overkill to do
+ * that for just a single function.
+ */
+static inline unsigned int cec_get_edid_spa_location(const u8 *edid,
+						     unsigned int size)
+{
+	unsigned int blocks = size / 128;
+	unsigned int block;
+	u8 d;
+
+	/* Sanity check: at least 2 blocks and a multiple of the block size */
+	if (blocks < 2 || size % 128)
+		return 0;
+
+	/*
+	 * If there are fewer extension blocks than the size, then update
+	 * 'blocks'. It is allowed to have more extension blocks than the size,
+	 * since some hardware can only read e.g. 256 bytes of the EDID, even
+	 * though more blocks are present. The first CEA-861 extension block
+	 * should normally be in block 1 anyway.
+	 */
+	if (edid[0x7e] + 1 < blocks)
+		blocks = edid[0x7e] + 1;
+
+	for (block = 1; block < blocks; block++) {
+		unsigned int offset = block * 128;
+
+		/* Skip any non-CEA-861 extension blocks */
+		if (edid[offset] != 0x02 || edid[offset + 1] != 0x03)
+			continue;
+
+		/* search Vendor Specific Data Block (tag 3) */
+		d = edid[offset + 2] & 0x7f;
+		/* Check if there are Data Blocks */
+		if (d <= 4)
+			continue;
+		if (d > 4) {
+			unsigned int i = offset + 4;
+			unsigned int end = offset + d;
+
+			/* Note: 'end' is always < 'size' */
+			do {
+				u8 tag = edid[i] >> 5;
+				u8 len = edid[i] & 0x1f;
+
+				if (tag == 3 && len >= 5 && i + len <= end &&
+				    edid[i + 1] == 0x03 &&
+				    edid[i + 2] == 0x0c &&
+				    edid[i + 3] == 0x00)
+					return i + 4;
+				i += len + 1;
+			} while (i < end);
+		}
+	}
+	return 0;
+}
+
 #endif /* _MEDIA_CEC_H */
-- 
2.20.1

