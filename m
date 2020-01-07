Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91895133203
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgAGVGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgAGVGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D25F2077B;
        Tue,  7 Jan 2020 21:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431177;
        bh=6cINxvTP6QSz4uyMqxVtECPAzA2Zif7Y7dgohk5Yq88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmpvrA3W6gesB9Zdz92KtTw0VQnx9ueBBh10biXkh4jc6f+42ElS+N2HmDa6m+SkP
         8IFQeDzfsX5LuH3Jo662JMEtBxPWJCidu5KFyR7VweQ0K54WkueIaLRRTQJg5rH/CW
         yZDhed/jtXmqjN2QDV3Wjcsm6PJYl4oWOQEGWIq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 065/115] libata: Fix retrieving of active qcs
Date:   Tue,  7 Jan 2020 21:54:35 +0100
Message-Id: <20200107205303.563843437@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 8385d756e114f2df8568e508902d5f9850817ffb upstream.

ata_qc_complete_multiple() is called with a mask of the still active
tags.

mv_sata doesn't have this information directly and instead calculates
the still active tags from the started tags (ap->qc_active) and the
finished tags as (ap->qc_active ^ done_mask)

Since 28361c40368 the hw_tag and tag are no longer the same and the
equation is no longer valid. In ata_exec_internal_sg() ap->qc_active is
initialized as 1ULL << ATA_TAG_INTERNAL, but in hardware tag 0 is
started and this will be in done_mask on completion. ap->qc_active ^
done_mask becomes 0x100000000 ^ 0x1 = 0x100000001 and thus tag 0 used as
the internal tag will never be reported as completed.

This is fixed by introducing ata_qc_get_active() which returns the
active hardware tags and calling it where appropriate.

This is tested on mv_sata, but sata_fsl and sata_nv suffer from the same
problem. There is another case in sata_nv that most likely needs fixing
as well, but this looks a little different, so I wasn't confident enough
to change that.

Fixes: 28361c403683 ("libata: add extra internal command")
Cc: stable@vger.kernel.org
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Add missing export of ata_qc_get_active(), as per Pali.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 drivers/ata/libata-core.c |   24 ++++++++++++++++++++++++
 drivers/ata/sata_fsl.c    |    2 +-
 drivers/ata/sata_mv.c     |    2 +-
 drivers/ata/sata_nv.c     |    2 +-
 include/linux/libata.h    |    1 +
 5 files changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5344,6 +5344,30 @@ void ata_qc_complete(struct ata_queued_c
 }
 
 /**
+ *	ata_qc_get_active - get bitmask of active qcs
+ *	@ap: port in question
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Bitmask of active qcs
+ */
+u64 ata_qc_get_active(struct ata_port *ap)
+{
+	u64 qc_active = ap->qc_active;
+
+	/* ATA_TAG_INTERNAL is sent to hw as tag 0 */
+	if (qc_active & (1ULL << ATA_TAG_INTERNAL)) {
+		qc_active |= (1 << 0);
+		qc_active &= ~(1ULL << ATA_TAG_INTERNAL);
+	}
+
+	return qc_active;
+}
+EXPORT_SYMBOL_GPL(ata_qc_get_active);
+
+/**
  *	ata_qc_complete_multiple - Complete multiple qcs successfully
  *	@ap: port in question
  *	@qc_active: new qc_active mask
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1283,7 +1283,7 @@ static void sata_fsl_host_intr(struct at
 				     i, ioread32(hcr_base + CC),
 				     ioread32(hcr_base + CA));
 		}
-		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+		ata_qc_complete_multiple(ap, ata_qc_get_active(ap) ^ done_mask);
 		return;
 
 	} else if ((ap->qc_active & (1ULL << ATA_TAG_INTERNAL))) {
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2840,7 +2840,7 @@ static void mv_process_crpb_entries(stru
 	}
 
 	if (work_done) {
-		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+		ata_qc_complete_multiple(ap, ata_qc_get_active(ap) ^ done_mask);
 
 		/* Update the software queue position index in hardware */
 		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1000,7 +1000,7 @@ static irqreturn_t nv_adma_interrupt(int
 					check_commands = 0;
 				check_commands &= ~(1 << pos);
 			}
-			ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+			ata_qc_complete_multiple(ap, ata_qc_get_active(ap) ^ done_mask);
 		}
 	}
 
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1190,6 +1190,7 @@ extern unsigned int ata_do_dev_read_id(s
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u64 qc_active);
+extern u64 ata_qc_get_active(struct ata_port *ap);
 extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd);
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,


