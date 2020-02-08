Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4241566A3
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgBHSgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33922 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003db-Nq; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CLy-5Y; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Hannes Reinecke" <hare@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Colin Ian King" <colin.king@canonical.com>
Date:   Sat, 08 Feb 2020 18:19:43 +0000
Message-ID: <lsq.1581185940.443147064@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 044/148] scsi: core: scsi_trace: Use get_unaligned_be*()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b1335f5b0486f61fb66b123b40f8e7a98e49605d upstream.

This patch fixes an unintended sign extension on left shifts. From Colin
King: "Shifting a u8 left will cause the value to be promoted to an
integer. If the top bit of the u8 is set then the following conversion to
an u64 will sign extend the value causing the upper 32 bits to be set in
the result."

Fix this by using get_unaligned_be*() instead.

Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Link: https://lore.kernel.org/r/20191101211447.187151-1-bvanassche@acm.org
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_trace.c | 114 ++++++++++++--------------------------
 1 file changed, 34 insertions(+), 80 deletions(-)

--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -17,10 +17,11 @@
  */
 #include <linux/kernel.h>
 #include <linux/trace_seq.h>
+#include <asm/unaligned.h>
 #include <trace/events/scsi.h>
 
 #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
-#define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
+#define SERVICE_ACTION32(cdb) (get_unaligned_be16(&cdb[8]))
 
 static const char *
 scsi_trace_misc(struct trace_seq *, unsigned char *, int);
@@ -47,17 +48,12 @@ static const char *
 scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len;
-	sector_t lba = 0, txlen = 0;
+	u32 lba, txlen;
 
-	lba |= (cdb[2] << 24);
-	lba |= (cdb[3] << 16);
-	lba |= (cdb[4] << 8);
-	lba |=  cdb[5];
-	txlen |= (cdb[7] << 8);
-	txlen |=  cdb[8];
+	lba = get_unaligned_be32(&cdb[2]);
+	txlen = get_unaligned_be16(&cdb[7]);
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	trace_seq_printf(p, "lba=%u txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME)
@@ -72,19 +68,12 @@ static const char *
 scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len;
-	sector_t lba = 0, txlen = 0;
+	u32 lba, txlen;
 
-	lba |= (cdb[2] << 24);
-	lba |= (cdb[3] << 16);
-	lba |= (cdb[4] << 8);
-	lba |=  cdb[5];
-	txlen |= (cdb[6] << 24);
-	txlen |= (cdb[7] << 16);
-	txlen |= (cdb[8] << 8);
-	txlen |=  cdb[9];
+	lba = get_unaligned_be32(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[6]);
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	trace_seq_printf(p, "lba=%u txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
 
@@ -95,23 +84,13 @@ static const char *
 scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len;
-	sector_t lba = 0, txlen = 0;
+	u64 lba;
+	u32 txlen;
 
-	lba |= ((u64)cdb[2] << 56);
-	lba |= ((u64)cdb[3] << 48);
-	lba |= ((u64)cdb[4] << 40);
-	lba |= ((u64)cdb[5] << 32);
-	lba |= (cdb[6] << 24);
-	lba |= (cdb[7] << 16);
-	lba |= (cdb[8] << 8);
-	lba |=  cdb[9];
-	txlen |= (cdb[10] << 24);
-	txlen |= (cdb[11] << 16);
-	txlen |= (cdb[12] << 8);
-	txlen |=  cdb[13];
+	lba = get_unaligned_be64(&cdb[2]);
+	txlen = get_unaligned_be32(&cdb[10]);
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
-			 (unsigned long long)lba, (unsigned long long)txlen,
+	trace_seq_printf(p, "lba=%llu txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
 	if (cdb[0] == WRITE_SAME_16)
@@ -126,8 +105,8 @@ static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len, *cmd;
-	sector_t lba = 0, txlen = 0;
-	u32 ei_lbrt = 0;
+	u64 lba;
+	u32 ei_lbrt, txlen;
 
 	switch (SERVICE_ACTION32(cdb)) {
 	case READ_32:
@@ -147,26 +126,12 @@ scsi_trace_rw32(struct trace_seq *p, uns
 		goto out;
 	}
 
-	lba |= ((u64)cdb[12] << 56);
-	lba |= ((u64)cdb[13] << 48);
-	lba |= ((u64)cdb[14] << 40);
-	lba |= ((u64)cdb[15] << 32);
-	lba |= (cdb[16] << 24);
-	lba |= (cdb[17] << 16);
-	lba |= (cdb[18] << 8);
-	lba |=  cdb[19];
-	ei_lbrt |= (cdb[20] << 24);
-	ei_lbrt |= (cdb[21] << 16);
-	ei_lbrt |= (cdb[22] << 8);
-	ei_lbrt |=  cdb[23];
-	txlen |= (cdb[28] << 24);
-	txlen |= (cdb[29] << 16);
-	txlen |= (cdb[30] << 8);
-	txlen |=  cdb[31];
-
-	trace_seq_printf(p, "%s_32 lba=%llu txlen=%llu protect=%u ei_lbrt=%u",
-			 cmd, (unsigned long long)lba,
-			 (unsigned long long)txlen, cdb[10] >> 5, ei_lbrt);
+	lba = get_unaligned_be64(&cdb[12]);
+	ei_lbrt = get_unaligned_be32(&cdb[20]);
+	txlen = get_unaligned_be32(&cdb[28]);
+
+	trace_seq_printf(p, "%s_32 lba=%llu txlen=%u protect=%u ei_lbrt=%u",
+			 cmd, lba, txlen, cdb[10] >> 5, ei_lbrt);
 
 	if (SERVICE_ACTION32(cdb) == WRITE_SAME_32)
 		trace_seq_printf(p, " unmap=%u", cdb[10] >> 3 & 1);
@@ -181,7 +146,7 @@ static const char *
 scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len;
-	unsigned int regions = cdb[7] << 8 | cdb[8];
+	unsigned int regions = get_unaligned_be16(&cdb[7]);
 
 	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
 	trace_seq_putc(p, 0);
@@ -193,8 +158,8 @@ static const char *
 scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len, *cmd;
-	sector_t lba = 0;
-	u32 alloc_len = 0;
+	u64 lba;
+	u32 alloc_len;
 
 	switch (SERVICE_ACTION16(cdb)) {
 	case SAI_READ_CAPACITY_16:
@@ -208,21 +173,10 @@ scsi_trace_service_action_in(struct trac
 		goto out;
 	}
 
-	lba |= ((u64)cdb[2] << 56);
-	lba |= ((u64)cdb[3] << 48);
-	lba |= ((u64)cdb[4] << 40);
-	lba |= ((u64)cdb[5] << 32);
-	lba |= (cdb[6] << 24);
-	lba |= (cdb[7] << 16);
-	lba |= (cdb[8] << 8);
-	lba |=  cdb[9];
-	alloc_len |= (cdb[10] << 24);
-	alloc_len |= (cdb[11] << 16);
-	alloc_len |= (cdb[12] << 8);
-	alloc_len |=  cdb[13];
+	lba = get_unaligned_be64(&cdb[2]);
+	alloc_len = get_unaligned_be32(&cdb[10]);
 
-	trace_seq_printf(p, "%s lba=%llu alloc_len=%u", cmd,
-			 (unsigned long long)lba, alloc_len);
+	trace_seq_printf(p, "%s lba=%llu alloc_len=%u", cmd, lba, alloc_len);
 
 out:
 	trace_seq_putc(p, 0);

