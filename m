Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6B64C087
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSSJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 14:09:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46170 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfFSSJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 14:09:07 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so512532iol.13
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 11:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVf+vCq01byOzlpiOr5Kncawr+eURbpHKJ7BG2u/e+s=;
        b=iKwFZLKWyG5Fvxjl9KoJeoPE4zpaSG8bRCedqNUptUdD1dRZj29d2cWt2jvFD6X6in
         uQCO4JyojeUtfmou7U69hpRKlV4Aru2/aYlXEP7Rbu/uixlU8zBrfpMq2WPPzHbS+8F3
         lwUsqdrwOmRoXvaucLky7sko2yM07yOR/KmLTI/BcwK6n0Q3GqjG+ICnYV3istBjRIwD
         zBCPlCIXR0l6UET8+EjZ7t4ttPtXs0iWkO8kajilGvhgTV7JBzTqOU3dMSpXM7fTKlq2
         MiNtplBh6u63YVg+uYxQ3QunV/FjCGuigHcnQhKepKvynhtuN/WrXjtg4fw35tuRvmLp
         ZMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVf+vCq01byOzlpiOr5Kncawr+eURbpHKJ7BG2u/e+s=;
        b=T4qb35pKh5nHcswnsgAFfVL531X0FoDdaJ2pRGy5H9+u8JNAcLrBynhBV7XL1io4Kl
         9geatyo0lz0cTGrvT/VcpxiZuFNhITNXISVc4tMoBjJo7GAYI/PLhf6/bSn9pC4qV+Tq
         KU7c8lMWhmHPYNM73FlbFvwyucSII49t9REzSLwnrKwL70st/XWJaVBwpm8N9LOoNiF2
         +Ca3kVGeynO1CqQ/GrWSRamVbDA8mYi13prqIrDHeJNjsCCVg14c72Ur93+1TklvqLdi
         ji914p7K5/qbJm4cqVgsvcksZI778wCu0vaPeNdjXxqfjs2gAPCs/nvwMJ2o/EAzkKgV
         7AfQ==
X-Gm-Message-State: APjAAAWhXsX4FAz1x57nvGFKtQGLJWMykgp3cl8oLtctO+ctNufmsFO/
        LpSsi06vIaGU18+zrlZkRhwh4fON1w8=
X-Google-Smtp-Source: APXvYqwlSJmr1lnHEMC1VrCGI3k31Uc9dj56ST6zuEwpwk42X7oX30GeJR8KTFgm40DHTGZD6H3kXQ==
X-Received: by 2002:a6b:6d07:: with SMTP id a7mr8246390iod.254.1560967746435;
        Wed, 19 Jun 2019 11:09:06 -0700 (PDT)
Received: from andres-vr.valvesoftware.com (135-23-65-40.cpe.pppoe.ca. [135.23.65.40])
        by smtp.gmail.com with ESMTPSA id j1sm16064651iop.14.2019.06.19.11.09.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 11:09:05 -0700 (PDT)
From:   Andres Rodriguez <andresx7@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Andres Rodriguez <andresx7@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/edid: parse CEA blocks embedded in DisplayID
Date:   Wed, 19 Jun 2019 14:09:01 -0400
Message-Id: <20190619180901.17901-1-andresx7@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DisplayID blocks allow embedding of CEA blocks. The payloads are
identical to traditional top level CEA extension blocks, but the header
is slightly different.

This change allows the CEA parser to find a CEA block inside a DisplayID
block. Additionally, it adds support for parsing the embedded CTA
header. No further changes are necessary due to payload parity.

This change fixes audio support for the Valve Index HMD.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.15
---
 drivers/gpu/drm/drm_edid.c  | 81 ++++++++++++++++++++++++++++++++-----
 include/drm/drm_displayid.h | 10 +++++
 2 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 649cfd8b4200..a4e3f6b22dbb 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1339,6 +1339,7 @@ MODULE_PARM_DESC(edid_fixup,
 
 static void drm_get_displayid(struct drm_connector *connector,
 			      struct edid *edid);
+static int validate_displayid(u8 *displayid, int length, int idx);
 
 static int drm_edid_block_checksum(const u8 *raw_edid)
 {
@@ -2883,16 +2884,46 @@ static u8 *drm_find_edid_extension(const struct edid *edid, int ext_id)
 	return edid_ext;
 }
 
-static u8 *drm_find_cea_extension(const struct edid *edid)
-{
-	return drm_find_edid_extension(edid, CEA_EXT);
-}
 
 static u8 *drm_find_displayid_extension(const struct edid *edid)
 {
 	return drm_find_edid_extension(edid, DISPLAYID_EXT);
 }
 
+static u8 *drm_find_cea_extension(const struct edid *edid)
+{
+	int ret;
+	int idx = 1;
+	int length = EDID_LENGTH;
+	struct displayid_block *block;
+	u8 *cea;
+	u8 *displayid;
+
+	/* Look for a top level CEA extension block */
+	cea = drm_find_edid_extension(edid, CEA_EXT);
+	if (cea)
+		return cea;
+
+	/* CEA blocks can also be found embedded in a DisplayID block */
+	displayid = drm_find_displayid_extension(edid);
+	if (!displayid)
+		return NULL;
+
+	ret = validate_displayid(displayid, length, idx);
+	if (ret)
+		return NULL;
+
+	idx += sizeof(struct displayid_hdr);
+	for_each_displayid_db(displayid, block, idx, length) {
+		if (block->tag == DATA_BLOCK_CTA) {
+			cea = (u8 *)block;
+			break;
+		}
+	}
+
+	return cea;
+}
+
 /*
  * Calculate the alternate clock for the CEA mode
  * (60Hz vs. 59.94Hz etc.)
@@ -3616,13 +3647,38 @@ cea_revision(const u8 *cea)
 static int
 cea_db_offsets(const u8 *cea, int *start, int *end)
 {
-	/* Data block offset in CEA extension block */
-	*start = 4;
-	*end = cea[2];
-	if (*end == 0)
-		*end = 127;
-	if (*end < 4 || *end > 127)
-		return -ERANGE;
+
+	/* DisplayID CTA extension blocks and top-level CEA EDID
+	 * block header definitions differ in the following bytes:
+	 *   1) Byte 2 of the header specifies length differently,
+	 *   2) Byte 3 is only present in the CEA top level block.
+	 *
+	 * The different definitions for byte 2 follow.
+	 *
+	 * DisplayID CTA extension block defines byte 2 as:
+	 *   Number of payload bytes
+	 *
+	 * CEA EDID block defines byte 2 as:
+	 *   Byte number (decimal) within this block where the 18-byte
+	 *   DTDs begin. If no non-DTD data is present in this extension
+	 *   block, the value should be set to 04h (the byte after next).
+	 *   If set to 00h, there are no DTDs present in this block and
+	 *   no non-DTD data.
+	 */
+	if (cea[0] == DATA_BLOCK_CTA) {
+		*start = 3;
+		*end = *start + cea[2];
+	} else if (cea[0] == CEA_EXT) {
+		/* Data block offset in CEA extension block */
+		*start = 4;
+		*end = cea[2];
+		if (*end == 0)
+			*end = 127;
+		if (*end < 4 || *end > 127)
+			return -ERANGE;
+	} else
+		return -ENOTSUPP;
+
 	return 0;
 }
 
@@ -5240,6 +5296,9 @@ static int drm_parse_display_id(struct drm_connector *connector,
 		case DATA_BLOCK_TYPE_1_DETAILED_TIMING:
 			/* handled in mode gathering code. */
 			break;
+		case DATA_BLOCK_CTA:
+			/* handled in the cea parser code. */
+			break;
 		default:
 			DRM_DEBUG_KMS("found DisplayID tag 0x%x, unhandled\n", block->tag);
 			break;
diff --git a/include/drm/drm_displayid.h b/include/drm/drm_displayid.h
index c0d4df6a606f..9d3b745c3107 100644
--- a/include/drm/drm_displayid.h
+++ b/include/drm/drm_displayid.h
@@ -40,6 +40,7 @@
 #define DATA_BLOCK_DISPLAY_INTERFACE 0x0f
 #define DATA_BLOCK_STEREO_DISPLAY_INTERFACE 0x10
 #define DATA_BLOCK_TILED_DISPLAY 0x12
+#define DATA_BLOCK_CTA 0x81
 
 #define DATA_BLOCK_VENDOR_SPECIFIC 0x7f
 
@@ -90,4 +91,13 @@ struct displayid_detailed_timing_block {
 	struct displayid_block base;
 	struct displayid_detailed_timings_1 timings[0];
 };
+
+#define for_each_displayid_db(displayid, block, idx, length) \
+	for ((block) = (struct displayid_block *)&(displayid)[idx]; \
+	     (idx) + sizeof(struct displayid_block) <= (length) && \
+	     (idx) + sizeof(struct displayid_block) + (block)->num_bytes <= (length) && \
+	     (block)->num_bytes > 0; \
+	     (idx) += (block)->num_bytes + sizeof(struct displayid_block), \
+	     (block) = (struct displayid_block *)&(displayid)[idx])
+
 #endif
-- 
2.19.1

