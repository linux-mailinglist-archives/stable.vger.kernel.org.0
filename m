Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4D1566A1
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBHSf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33928 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727818AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dG-ID; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CN1-Hd; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Hannes Reinecke" <hare@suse.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Sat, 08 Feb 2020 18:19:56 +0000
Message-ID: <lsq.1581185940.738162851@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 057/148] scsi: tracing: Fix handling of TRANSFER
 LENGTH == 0 for READ(6) and WRITE(6)
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

commit f6b8540f40201bff91062dd64db8e29e4ddaaa9d upstream.

According to SBC-2 a TRANSFER LENGTH field of zero means that 256 logical
blocks must be transferred. Make the SCSI tracing code follow SBC-2.

Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Link: https://lore.kernel.org/r/20191105215553.185018-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_trace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -30,15 +30,18 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = p->buffer + p->len;
-	sector_t lba = 0, txlen = 0;
+	u32 lba = 0, txlen;
 
 	lba |= ((cdb[1] & 0x1F) << 16);
 	lba |=  (cdb[2] << 8);
 	lba |=   cdb[3];
-	txlen = cdb[4];
+	/*
+	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
+	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
+	 */
+	txlen = cdb[4] ? cdb[4] : 256;
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%u txlen=%u", lba, txlen);
 	trace_seq_putc(p, 0);
 
 	return ret;

