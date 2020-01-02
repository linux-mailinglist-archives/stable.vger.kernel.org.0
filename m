Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E788112F0F7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgABWRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727523AbgABWRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CFE22314;
        Thu,  2 Jan 2020 22:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003435;
        bh=JtLYn0MtFvBnueObwatmpR2LIRFiEG+lTAFO9J5RQyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZI+8sYJCq/LlVYZAHRP83PZJeMX1oSkUPRtOdtl41srGOQK9/MyW4SegSJ/EuSOG
         HsuCsgdVQMUyXJ//0tpCjDE0H4H2lP399iON84wM/aVocRG1OdqJQLRidB6Tcs+V+e
         1H1U5xoDwCNOjL79eFVdbNjrS7nnqJn1H0H5kOUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 160/191] bnxt_en: Return error if FW returns more data than dump length
Date:   Thu,  2 Jan 2020 23:07:22 +0100
Message-Id: <20200102215846.529500465@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit c74751f4c39232c31214ec6a3bc1c7e62f5c728b ]

If any change happened in the configuration of VF in VM while
collecting live dump, there could be a race and firmware can return
more data than allocated dump length. Fix it by keeping track of
the accumulated core dump length copied so far and abort the copy
with error code if the next chunk of core dump will exceed the
original dump length.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   38 +++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |    4 ++
 2 files changed, 34 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3064,8 +3064,15 @@ static int bnxt_hwrm_dbg_dma_data(struct
 			}
 		}
 
-		if (info->dest_buf)
-			memcpy(info->dest_buf + off, dma_buf, len);
+		if (info->dest_buf) {
+			if ((info->seg_start + off + len) <=
+			    BNXT_COREDUMP_BUF_LEN(info->buf_len)) {
+				memcpy(info->dest_buf + off, dma_buf, len);
+			} else {
+				rc = -ENOBUFS;
+				break;
+			}
+		}
 
 		if (cmn_req->req_type ==
 				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
@@ -3119,7 +3126,7 @@ static int bnxt_hwrm_dbg_coredump_initia
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
 					   u16 segment_id, u32 *seg_len,
-					   void *buf, u32 offset)
+					   void *buf, u32 buf_len, u32 offset)
 {
 	struct hwrm_dbg_coredump_retrieve_input req = {0};
 	struct bnxt_hwrm_dbg_dma_info info = {NULL};
@@ -3134,8 +3141,11 @@ static int bnxt_hwrm_dbg_coredump_retrie
 				seq_no);
 	info.data_len_off = offsetof(struct hwrm_dbg_coredump_retrieve_output,
 				     data_len);
-	if (buf)
+	if (buf) {
 		info.dest_buf = buf + offset;
+		info.buf_len = buf_len;
+		info.seg_start = offset;
+	}
 
 	rc = bnxt_hwrm_dbg_dma_data(bp, &req, sizeof(req), &info);
 	if (!rc)
@@ -3225,14 +3235,17 @@ bnxt_fill_coredump_record(struct bnxt *b
 static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 {
 	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
+	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
 	struct coredump_segment_record *seg_record = NULL;
-	u32 offset = 0, seg_hdr_len, seg_record_len;
 	struct bnxt_coredump_segment_hdr seg_hdr;
 	struct bnxt_coredump coredump = {NULL};
 	time64_t start_time;
 	u16 start_utc;
 	int rc = 0, i;
 
+	if (buf)
+		buf_len = *dump_len;
+
 	start_time = ktime_get_real_seconds();
 	start_utc = sys_tz.tz_minuteswest * 60;
 	seg_hdr_len = sizeof(seg_hdr);
@@ -3265,6 +3278,12 @@ static int bnxt_get_coredump(struct bnxt
 		u32 duration = 0, seg_len = 0;
 		unsigned long start, end;
 
+		if (buf && ((offset + seg_hdr_len) >
+			    BNXT_COREDUMP_BUF_LEN(buf_len))) {
+			rc = -ENOBUFS;
+			goto err;
+		}
+
 		start = jiffies;
 
 		rc = bnxt_hwrm_dbg_coredump_initiate(bp, comp_id, seg_id);
@@ -3277,9 +3296,11 @@ static int bnxt_get_coredump(struct bnxt
 
 		/* Write segment data into the buffer */
 		rc = bnxt_hwrm_dbg_coredump_retrieve(bp, comp_id, seg_id,
-						     &seg_len, buf,
+						     &seg_len, buf, buf_len,
 						     offset + seg_hdr_len);
-		if (rc)
+		if (rc && rc == -ENOBUFS)
+			goto err;
+		else if (rc)
 			netdev_err(bp->dev,
 				   "Failed to retrieve coredump for seg = %d\n",
 				   seg_record->segment_id);
@@ -3309,7 +3330,8 @@ err:
 					  rc);
 	kfree(coredump.data);
 	*dump_len += sizeof(struct bnxt_coredump_record);
-
+	if (rc == -ENOBUFS)
+		netdev_err(bp->dev, "Firmware returned large coredump buffer");
 	return rc;
 }
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -31,6 +31,8 @@ struct bnxt_coredump {
 	u16		total_segs;
 };
 
+#define BNXT_COREDUMP_BUF_LEN(len) ((len) - sizeof(struct bnxt_coredump_record))
+
 struct bnxt_hwrm_dbg_dma_info {
 	void *dest_buf;
 	int dest_buf_size;
@@ -38,6 +40,8 @@ struct bnxt_hwrm_dbg_dma_info {
 	u16 seq_off;
 	u16 data_len_off;
 	u16 segs;
+	u32 seg_start;
+	u32 buf_len;
 };
 
 struct hwrm_dbg_cmn_input {


