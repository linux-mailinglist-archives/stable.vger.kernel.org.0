Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED957396D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbfGXTkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389370AbfGXTkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A063214AF;
        Wed, 24 Jul 2019 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997204;
        bh=E51GYOwPKD78E5Rz4qO3qTq1AsoJ10JnuVV5OkMrsbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djn9kmI6e+UomV6nQcbTO4d0KxH8BXkUjzCXXlNVFE1siR6VW/YLl4RL0U34WeC4m
         GE1fUzOJeQ2PG1NbIXZ03LsNWChme37woL93Ojbbpz78tNNxB83HSqJMqf2tQDDy4t
         zKsT4qX+g8I4qddFfn5NJHdoPGNOpFX3C6l9sGuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Rodriguez <andresx7@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: [PATCH 5.2 358/413] drm/edid: parse CEA blocks embedded in DisplayID
Date:   Wed, 24 Jul 2019 21:20:49 +0200
Message-Id: <20190724191801.251997727@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Rodriguez <andresx7@gmail.com>

commit e28ad544f462231d3fd081a7316339359efbb481 upstream.

DisplayID blocks allow embedding of CEA blocks. The payloads are
identical to traditional top level CEA extension blocks, but the header
is slightly different.

This change allows the CEA parser to find a CEA block inside a DisplayID
block. Additionally, it adds support for parsing the embedded CTA
header. No further changes are necessary due to payload parity.

This change fixes audio support for the Valve Index HMD.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.15
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190619180901.17901-1-andresx7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c  |   81 ++++++++++++++++++++++++++++++++++++++------
 include/drm/drm_displayid.h |   10 +++++
 2 files changed, 80 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1339,6 +1339,7 @@ MODULE_PARM_DESC(edid_fixup,
 
 static void drm_get_displayid(struct drm_connector *connector,
 			      struct edid *edid);
+static int validate_displayid(u8 *displayid, int length, int idx);
 
 static int drm_edid_block_checksum(const u8 *raw_edid)
 {
@@ -2922,16 +2923,46 @@ static u8 *drm_find_edid_extension(const
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
@@ -3655,13 +3686,38 @@ cea_revision(const u8 *cea)
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
+	} else {
+		return -ENOTSUPP;
+	}
+
 	return 0;
 }
 
@@ -5279,6 +5335,9 @@ static int drm_parse_display_id(struct d
 		case DATA_BLOCK_TYPE_1_DETAILED_TIMING:
 			/* handled in mode gathering code. */
 			break;
+		case DATA_BLOCK_CTA:
+			/* handled in the cea parser code. */
+			break;
 		default:
 			DRM_DEBUG_KMS("found DisplayID tag 0x%x, unhandled\n", block->tag);
 			break;
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


