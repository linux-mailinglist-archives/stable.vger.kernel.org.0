Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8496F12EDCF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgABWcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:32:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbgABWcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:32:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B4D21835;
        Thu,  2 Jan 2020 22:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004328;
        bh=yzxD6HKKw68W+50LlaU+rd6VsjAH0kcFO5/v4j3i8bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9co1EAi8RY6Etq6NXBIzj9tb/ll9X5MB7+HeMmn4kasF7UKhGDAX44nhairPmrPH
         k3rPJe75y2E855Eg/duRwKKf1+Vy2CCfBYc/Qo9EJV3AVhjrQtvvDtPr0e1YDLP1mi
         3eECX9cVH7JvJHt7OyFOotYkLtyLSh3rBQA25kSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 125/171] scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)
Date:   Thu,  2 Jan 2020 23:07:36 +0100
Message-Id: <20200102220604.429135969@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f6b8540f40201bff91062dd64db8e29e4ddaaa9d ]

According to SBC-2 a TRANSFER LENGTH field of zero means that 256 logical
blocks must be transferred. Make the SCSI tracing code follow SBC-2.

Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Link: https://lore.kernel.org/r/20191105215553.185018-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_trace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 0ff083bbf5b1..617a60737590 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -30,15 +30,18 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
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
-- 
2.20.1



