Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398502F7C0B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbhAONI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732183AbhAOMaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D2A2336F;
        Fri, 15 Jan 2021 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713784;
        bh=b9YfGTgYyliS3/FnKPRwNsEpWwlz0UbgdvYqXuRKa0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnsCuaAOOom3JO/9FBOKBKk/h/KL8A3smJMr5EXKhtjqvFll19zuTNKDFb57w1wzC
         W9VRkW3e1jb9JWTibm0hUl1DuG/woMpz8AL2ur+0gu0qqKxIBBc1UKellt5Ys1I+CH
         +fcGtCKTbPwh+9jFV7pwHleTCukVrfjNvMEbv1hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/18] target: use XCOPY segment descriptor CSCD IDs
Date:   Fri, 15 Jan 2021 13:27:32 +0100
Message-Id: <20210115121955.323261011@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 66640d35c1e4ef3c96ba5edb3c5e2ff8ab812e7a ]

The XCOPY specification in SPC4r37 states that the XCOPY source and
destination device(s) should be derived from the copy source and copy
destination (CSCD) descriptor IDs in the XCOPY segment descriptor.

The CSCD IDs are generally (for block -> block copies), indexes into
the corresponding CSCD descriptor list, e.g.
=================================
EXTENDED COPY Header
=================================
CSCD Descriptor List
- entry 0
  + LU ID <--------------<------------------\
- entry 1                                   |
  + LU ID <______________<_____________     |
=================================      |    |
Segment Descriptor List                |    |
- segment 0                            |    |
  + src CSCD ID = 0 --------->---------+----/
  + dest CSCD ID = 1 ___________>______|
  + len
  + src lba
  + dest lba
=================================

Currently LIO completely ignores the src and dest CSCD IDs in the
Segment Descriptor List, and instead assumes that the first entry in the
CSCD list corresponds to the source, and the second to the destination.

This commit removes this assumption, by ensuring that the Segment
Descriptor List is parsed prior to processing the CSCD Descriptor List.
CSCD Descriptor List processing is modified to compare the current list
index with the previously obtained src and dest CSCD IDs.

Additionally, XCOPY requests where the src and dest CSCD IDs refer to
the CSCD Descriptor List entry can now be successfully processed.

Fixes: cbf031f ("target: Add support for EXTENDED_COPY copy offload")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=191381
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_xcopy.c | 79 ++++++++++++++++++------------
 1 file changed, 48 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index c7bd27bfe3d8c..32db9180820e7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -97,7 +97,7 @@ static int target_xcopy_locate_se_dev_e4(const unsigned char *dev_wwn,
 }
 
 static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op *xop,
-				unsigned char *p, bool src)
+				unsigned char *p, unsigned short cscd_index)
 {
 	unsigned char *desc = p;
 	unsigned short ript;
@@ -142,7 +142,13 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 		return -EINVAL;
 	}
 
-	if (src) {
+	if (cscd_index != xop->stdi && cscd_index != xop->dtdi) {
+		pr_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor "
+			 "dest\n", cscd_index);
+		return 0;
+	}
+
+	if (cscd_index == xop->stdi) {
 		memcpy(&xop->src_tid_wwn[0], &desc[8], XCOPY_NAA_IEEE_REGEX_LEN);
 		/*
 		 * Determine if the source designator matches the local device
@@ -154,10 +160,15 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 			pr_debug("XCOPY 0xe4: Set xop->src_dev %p from source"
 					" received xop\n", xop->src_dev);
 		}
-	} else {
+	}
+
+	if (cscd_index == xop->dtdi) {
 		memcpy(&xop->dst_tid_wwn[0], &desc[8], XCOPY_NAA_IEEE_REGEX_LEN);
 		/*
-		 * Determine if the destination designator matches the local device
+		 * Determine if the destination designator matches the local
+		 * device. If @cscd_index corresponds to both source (stdi) and
+		 * destination (dtdi), or dtdi comes after stdi, then
+		 * XCOL_DEST_RECV_OP wins.
 		 */
 		if (!memcmp(&xop->local_dev_wwn[0], &xop->dst_tid_wwn[0],
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
@@ -177,9 +188,9 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 {
 	struct se_device *local_dev = se_cmd->se_dev;
 	unsigned char *desc = p;
-	int offset = tdll % XCOPY_TARGET_DESC_LEN, rc, ret = 0;
+	int offset = tdll % XCOPY_TARGET_DESC_LEN, rc;
+	unsigned short cscd_index = 0;
 	unsigned short start = 0;
-	bool src = true;
 
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
@@ -202,25 +213,19 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 
 	while (start < tdll) {
 		/*
-		 * Check target descriptor identification with 0xE4 type with
-		 * use VPD 0x83 WWPN matching ..
+		 * Check target descriptor identification with 0xE4 type, and
+		 * compare the current index with the CSCD descriptor IDs in
+		 * the segment descriptor. Use VPD 0x83 WWPN matching ..
 		 */
 		switch (desc[0]) {
 		case 0xe4:
 			rc = target_xcopy_parse_tiddesc_e4(se_cmd, xop,
-							&desc[0], src);
+							&desc[0], cscd_index);
 			if (rc != 0)
 				goto out;
-			/*
-			 * Assume target descriptors are in source -> destination order..
-			 */
-			if (src)
-				src = false;
-			else
-				src = true;
 			start += XCOPY_TARGET_DESC_LEN;
 			desc += XCOPY_TARGET_DESC_LEN;
-			ret++;
+			cscd_index++;
 			break;
 		default:
 			pr_err("XCOPY unsupported descriptor type code:"
@@ -229,12 +234,21 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 		}
 	}
 
-	if (xop->op_origin == XCOL_SOURCE_RECV_OP)
+	switch (xop->op_origin) {
+	case XCOL_SOURCE_RECV_OP:
 		rc = target_xcopy_locate_se_dev_e4(xop->dst_tid_wwn,
 						&xop->dst_dev);
-	else
+		break;
+	case XCOL_DEST_RECV_OP:
 		rc = target_xcopy_locate_se_dev_e4(xop->src_tid_wwn,
 						&xop->src_dev);
+		break;
+	default:
+		pr_err("XCOPY CSCD descriptor IDs not found in CSCD list - "
+			"stdi: %hu dtdi: %hu\n", xop->stdi, xop->dtdi);
+		rc = -EINVAL;
+		break;
+	}
 	/*
 	 * If a matching IEEE NAA 0x83 descriptor for the requested device
 	 * is not located on this node, return COPY_ABORTED with ASQ/ASQC
@@ -251,7 +265,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	pr_debug("XCOPY TGT desc: Dest dev: %p NAA IEEE WWN: 0x%16phN\n",
 		 xop->dst_dev, &xop->dst_tid_wwn[0]);
 
-	return ret;
+	return cscd_index;
 
 out:
 	return -EINVAL;
@@ -892,6 +906,20 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		" tdll: %hu sdll: %u inline_dl: %u\n", list_id, list_id_usage,
 		tdll, sdll, inline_dl);
 
+	/*
+	 * skip over the target descriptors until segment descriptors
+	 * have been passed - CSCD ids are needed to determine src and dest.
+	 */
+	seg_desc = &p[16] + tdll;
+
+	rc = target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc,
+						    sdll, &ret);
+	if (rc <= 0)
+		goto out;
+
+	pr_debug("XCOPY: Processed %d segment descriptors, length: %u\n", rc,
+				rc * XCOPY_SEGMENT_DESC_LEN);
+
 	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll, &ret);
 	if (rc <= 0)
 		goto out;
@@ -909,19 +937,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 
 	pr_debug("XCOPY: Processed %d target descriptors, length: %u\n", rc,
 				rc * XCOPY_TARGET_DESC_LEN);
-	seg_desc = &p[16];
-	seg_desc += (rc * XCOPY_TARGET_DESC_LEN);
-
-	rc = target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc,
-						    sdll, &ret);
-	if (rc <= 0) {
-		xcopy_pt_undepend_remotedev(xop);
-		goto out;
-	}
 	transport_kunmap_data_sg(se_cmd);
 
-	pr_debug("XCOPY: Processed %d segment descriptors, length: %u\n", rc,
-				rc * XCOPY_SEGMENT_DESC_LEN);
 	INIT_WORK(&xop->xop_work, target_xcopy_do_work);
 	queue_work(xcopy_wq, &xop->xop_work);
 	return TCM_NO_SENSE;
-- 
2.27.0



