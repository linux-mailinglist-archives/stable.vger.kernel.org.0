Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8496578A3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiL1OxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiL1Owd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF8A10064
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D2CA61552
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66358C433D2;
        Wed, 28 Dec 2022 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239150;
        bh=+vEjGMTtaSZB8ytog46ROql4CCdfqMphKPjhQ547eSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwFv91XH9R8XDJyEA00QuM/7/G5NXorJlIcs3JiaFFDRsK2E7mBT9x9K+7mv0WCVv
         APVtSVlLcyzJjqDVCK12HSTMG/cIoGGRc3Jyk+lA85LftTM0s5wBbCjA/cXAeKd1hB
         isyCfKcNjKV1aYHJf6QhtR8jzo0ZjwrAr+S88srY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/731] ata: add/use ata_taskfile::{error|status} fields
Date:   Wed, 28 Dec 2022 15:34:15 +0100
Message-Id: <20221228144300.845920687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit efcef265fd83d9a68a68926abecb3e1dd3e260a8 ]

Add the explicit error and status register fields to 'struct ata_taskfile'
using the anonymous *union*s ('struct ide_taskfile' had that for ages!) and
update the libata taskfile code accordingly. There should be no object code
changes resulting from that...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 7390896b3484 ("ata: libata: fix NCQ autosense logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/acard-ahci.c      |  2 +-
 drivers/ata/ahci.c            |  4 ++--
 drivers/ata/ahci_qoriq.c      |  2 +-
 drivers/ata/ahci_xgene.c      |  2 +-
 drivers/ata/libahci.c         |  4 ++--
 drivers/ata/libata-acpi.c     |  8 +++----
 drivers/ata/libata-core.c     | 12 +++++-----
 drivers/ata/libata-eh.c       | 42 +++++++++++++++++------------------
 drivers/ata/libata-sata.c     | 10 ++++-----
 drivers/ata/libata-scsi.c     | 22 +++++++++---------
 drivers/ata/libata-sff.c      |  6 ++---
 drivers/ata/pata_ep93xx.c     |  4 ++--
 drivers/ata/pata_ns87415.c    |  4 ++--
 drivers/ata/pata_octeon_cf.c  |  4 ++--
 drivers/ata/pata_samsung_cf.c |  2 +-
 drivers/ata/sata_highbank.c   |  2 +-
 drivers/ata/sata_inic162x.c   | 10 ++++-----
 drivers/ata/sata_rcar.c       |  4 ++--
 drivers/ata/sata_svw.c        | 10 ++++-----
 drivers/ata/sata_vsc.c        | 10 ++++-----
 include/linux/libata.h        | 10 +++++++--
 21 files changed, 90 insertions(+), 84 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 2a04e8abd397..26e0eb537b4f 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -267,7 +267,7 @@ static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
 	    !(qc->flags & ATA_QCFLAG_FAILED)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
-		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
+		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
 	} else
 		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 812731e80f8e..c1bf7117a9ff 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -735,7 +735,7 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
+	tf.status = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	rc = sata_link_hardreset(link, sata_ehc_deb_timing(&link->eh_context),
@@ -806,7 +806,7 @@ static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
 
 		/* clear D2H reception area to properly wait for D2H FIS */
 		ata_tf_init(link->device, &tf);
-		tf.command = ATA_BUSY;
+		tf.status = ATA_BUSY;
 		ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 		rc = sata_link_hardreset(link, timing, deadline, &online,
diff --git a/drivers/ata/ahci_qoriq.c b/drivers/ata/ahci_qoriq.c
index 5b46fc9aeb4a..e5ac3d1c214c 100644
--- a/drivers/ata/ahci_qoriq.c
+++ b/drivers/ata/ahci_qoriq.c
@@ -125,7 +125,7 @@ static int ahci_qoriq_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
+	tf.status = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	rc = sata_link_hardreset(link, timing, deadline, &online,
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index dffc432b9d54..292099410cf6 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -365,7 +365,7 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
 	do {
 		/* clear D2H reception area to properly wait for D2H FIS */
 		ata_tf_init(link->device, &tf);
-		tf.command = ATA_BUSY;
+		tf.status = ATA_BUSY;
 		ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 		rc = sata_link_hardreset(link, timing, deadline, online,
 				 ahci_check_ready);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 395772fa3943..192115a45dd7 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1552,7 +1552,7 @@ int ahci_do_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
+	tf.status = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	rc = sata_link_hardreset(link, timing, deadline, online,
@@ -2038,7 +2038,7 @@ static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
 	    !(qc->flags & ATA_QCFLAG_FAILED)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
-		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
+		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
 	} else
 		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
 
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 7007377880ce..d15f3e908ea4 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -554,13 +554,13 @@ static void ata_acpi_gtf_to_tf(struct ata_device *dev,
 
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->protocol = ATA_PROT_NODATA;
-	tf->feature = gtf->tf[0];	/* 0x1f1 */
+	tf->error   = gtf->tf[0];	/* 0x1f1 */
 	tf->nsect   = gtf->tf[1];	/* 0x1f2 */
 	tf->lbal    = gtf->tf[2];	/* 0x1f3 */
 	tf->lbam    = gtf->tf[3];	/* 0x1f4 */
 	tf->lbah    = gtf->tf[4];	/* 0x1f5 */
 	tf->device  = gtf->tf[5];	/* 0x1f6 */
-	tf->command = gtf->tf[6];	/* 0x1f7 */
+	tf->status  = gtf->tf[6];	/* 0x1f7 */
 }
 
 static int ata_acpi_filter_tf(struct ata_device *dev,
@@ -689,7 +689,7 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 				"(%s) rejected by device (Stat=0x%02x Err=0x%02x)",
 				tf.command, tf.feature, tf.nsect, tf.lbal,
 				tf.lbam, tf.lbah, tf.device, descr,
-				rtf.command, rtf.feature);
+				rtf.status, rtf.error);
 			rc = 0;
 			break;
 
@@ -699,7 +699,7 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 				"(%s) failed (Emask=0x%x Stat=0x%02x Err=0x%02x)",
 				tf.command, tf.feature, tf.nsect, tf.lbal,
 				tf.lbam, tf.lbah, tf.device, descr,
-				err_mask, rtf.command, rtf.feature);
+				err_mask, rtf.status, rtf.error);
 			rc = -EIO;
 			break;
 		}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1c9ad3045606..c430cd3cfa17 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1185,7 +1185,7 @@ static int ata_read_native_max_address(struct ata_device *dev, u64 *max_sectors)
 		ata_dev_warn(dev,
 			     "failed to read native max address (err_mask=0x%x)\n",
 			     err_mask);
-		if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
+		if (err_mask == AC_ERR_DEV && (tf.error & ATA_ABORTED))
 			return -EACCES;
 		return -EIO;
 	}
@@ -1249,7 +1249,7 @@ static int ata_set_max_sectors(struct ata_device *dev, u64 new_sectors)
 			     "failed to set max address (err_mask=0x%x)\n",
 			     err_mask);
 		if (err_mask == AC_ERR_DEV &&
-		    (tf.feature & (ATA_ABORTED | ATA_IDNF)))
+		    (tf.error & (ATA_ABORTED | ATA_IDNF)))
 			return -EACCES;
 		return -EIO;
 	}
@@ -1616,7 +1616,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	/* perform minimal error analysis */
 	if (qc->flags & ATA_QCFLAG_FAILED) {
-		if (qc->result_tf.command & (ATA_ERR | ATA_DF))
+		if (qc->result_tf.status & (ATA_ERR | ATA_DF))
 			qc->err_mask |= AC_ERR_DEV;
 
 		if (!qc->err_mask)
@@ -1625,7 +1625,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 		if (qc->err_mask & ~AC_ERR_OTHER)
 			qc->err_mask &= ~AC_ERR_OTHER;
 	} else if (qc->tf.command == ATA_CMD_REQ_SENSE_DATA) {
-		qc->result_tf.command |= ATA_SENSE;
+		qc->result_tf.status |= ATA_SENSE;
 	}
 
 	/* finish up */
@@ -1848,7 +1848,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			return 0;
 		}
 
-		if ((err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
+		if ((err_mask == AC_ERR_DEV) && (tf.error & ATA_ABORTED)) {
 			/* Device or controller might have reported
 			 * the wrong device class.  Give a shot at the
 			 * other IDENTIFY if the current one is
@@ -4371,7 +4371,7 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 	/* A clean abort indicates an original or just out of spec drive
 	   and we should continue as we issue the setup based on the
 	   drive reported working geometry */
-	if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
+	if (err_mask == AC_ERR_DEV && (tf.error & ATA_ABORTED))
 		err_mask = 0;
 
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7aea631edb27..8350abc17290 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1386,7 +1386,7 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 
 	err_mask = ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
 	if (err_mask == AC_ERR_DEV)
-		*r_sense_key = tf.feature >> 4;
+		*r_sense_key = tf.error >> 4;
 	return err_mask;
 }
 
@@ -1431,12 +1431,12 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc,
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	/* Ignore err_mask; ATA_ERR might be set */
-	if (tf.command & ATA_SENSE) {
+	if (tf.status & ATA_SENSE) {
 		ata_scsi_set_sense(dev, cmd, tf.lbah, tf.lbam, tf.lbal);
 		qc->flags |= ATA_QCFLAG_SENSE_VALID;
 	} else {
 		ata_dev_warn(dev, "request sense failed stat %02x emask %x\n",
-			     tf.command, err_mask);
+			     tf.status, err_mask);
 	}
 }
 
@@ -1561,7 +1561,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 				      const struct ata_taskfile *tf)
 {
 	unsigned int tmp, action = 0;
-	u8 stat = tf->command, err = tf->feature;
+	u8 stat = tf->status, err = tf->error;
 
 	if ((stat & (ATA_BUSY | ATA_DRQ | ATA_DRDY)) != ATA_DRDY) {
 		qc->err_mask |= AC_ERR_HSM;
@@ -1598,7 +1598,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
 			tmp = atapi_eh_request_sense(qc->dev,
 						qc->scsicmd->sense_buffer,
-						qc->result_tf.feature >> 4);
+						qc->result_tf.error >> 4);
 			if (!tmp)
 				qc->flags |= ATA_QCFLAG_SENSE_VALID;
 			else
@@ -2372,7 +2372,7 @@ static void ata_eh_link_report(struct ata_link *link)
 			cmd->hob_feature, cmd->hob_nsect,
 			cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
 			cmd->device, qc->tag, data_buf, cdb_buf,
-			res->command, res->feature, res->nsect,
+			res->status, res->error, res->nsect,
 			res->lbal, res->lbam, res->lbah,
 			res->hob_feature, res->hob_nsect,
 			res->hob_lbal, res->hob_lbam, res->hob_lbah,
@@ -2380,28 +2380,28 @@ static void ata_eh_link_report(struct ata_link *link)
 			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
 
 #ifdef CONFIG_ATA_VERBOSE_ERROR
-		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
-				    ATA_SENSE | ATA_ERR)) {
-			if (res->command & ATA_BUSY)
+		if (res->status & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
+				   ATA_SENSE | ATA_ERR)) {
+			if (res->status & ATA_BUSY)
 				ata_dev_err(qc->dev, "status: { Busy }\n");
 			else
 				ata_dev_err(qc->dev, "status: { %s%s%s%s%s}\n",
-				  res->command & ATA_DRDY ? "DRDY " : "",
-				  res->command & ATA_DF ? "DF " : "",
-				  res->command & ATA_DRQ ? "DRQ " : "",
-				  res->command & ATA_SENSE ? "SENSE " : "",
-				  res->command & ATA_ERR ? "ERR " : "");
+				  res->status & ATA_DRDY ? "DRDY " : "",
+				  res->status & ATA_DF ? "DF " : "",
+				  res->status & ATA_DRQ ? "DRQ " : "",
+				  res->status & ATA_SENSE ? "SENSE " : "",
+				  res->status & ATA_ERR ? "ERR " : "");
 		}
 
 		if (cmd->command != ATA_CMD_PACKET &&
-		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_AMNF |
-				     ATA_IDNF | ATA_ABORTED)))
+		    (res->error & (ATA_ICRC | ATA_UNC | ATA_AMNF | ATA_IDNF |
+				   ATA_ABORTED)))
 			ata_dev_err(qc->dev, "error: { %s%s%s%s%s}\n",
-			  res->feature & ATA_ICRC ? "ICRC " : "",
-			  res->feature & ATA_UNC ? "UNC " : "",
-			  res->feature & ATA_AMNF ? "AMNF " : "",
-			  res->feature & ATA_IDNF ? "IDNF " : "",
-			  res->feature & ATA_ABORTED ? "ABRT " : "");
+				    res->error & ATA_ICRC ? "ICRC " : "",
+				    res->error & ATA_UNC ? "UNC " : "",
+				    res->error & ATA_AMNF ? "AMNF " : "",
+				    res->error & ATA_IDNF ? "IDNF " : "",
+				    res->error & ATA_ABORTED ? "ABRT " : "");
 #endif
 	}
 }
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 8f3ff830ab0c..1e59e5b6b047 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -191,8 +191,8 @@ EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 
 void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
 {
-	tf->command	= fis[2];	/* status */
-	tf->feature	= fis[3];	/* error */
+	tf->status	= fis[2];
+	tf->error	= fis[3];
 
 	tf->lbal	= fis[4];
 	tf->lbam	= fis[5];
@@ -1402,8 +1402,8 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 
 	*tag = buf[0] & 0x1f;
 
-	tf->command = buf[2];
-	tf->feature = buf[3];
+	tf->status = buf[2];
+	tf->error = buf[3];
 	tf->lbal = buf[4];
 	tf->lbam = buf[5];
 	tf->lbah = buf[6];
@@ -1478,7 +1478,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
 	if (dev->class == ATA_DEV_ZAC &&
-	    ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary)) {
+	    ((qc->result_tf.status & ATA_SENSE) || qc->result_tf.auxiliary)) {
 		char sense_key, asc, ascq;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 061d2f8feeb5..4d8129640d60 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -671,7 +671,7 @@ static void ata_qc_set_pc_nbytes(struct ata_queued_cmd *qc)
  */
 static void ata_dump_status(unsigned id, struct ata_taskfile *tf)
 {
-	u8 stat = tf->command, err = tf->feature;
+	u8 stat = tf->status, err = tf->error;
 
 	pr_warn("ata%u: status=0x%02x { ", id, stat);
 	if (stat & ATA_BUSY) {
@@ -867,8 +867,8 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	 * onto sense key, asc & ascq.
 	 */
 	if (qc->err_mask ||
-	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
-		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
+	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
+		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
 				   &sense_key, &asc, &ascq, verbose);
 		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
 	} else {
@@ -897,13 +897,13 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		 * Copy registers into sense buffer.
 		 */
 		desc[2] = 0x00;
-		desc[3] = tf->feature;	/* == error reg */
+		desc[3] = tf->error;
 		desc[5] = tf->nsect;
 		desc[7] = tf->lbal;
 		desc[9] = tf->lbam;
 		desc[11] = tf->lbah;
 		desc[12] = tf->device;
-		desc[13] = tf->command; /* == status reg */
+		desc[13] = tf->status;
 
 		/*
 		 * Fill in Extend bit, and the high order bytes
@@ -918,8 +918,8 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		}
 	} else {
 		/* Fixed sense format */
-		desc[0] = tf->feature;
-		desc[1] = tf->command; /* status */
+		desc[0] = tf->error;
+		desc[1] = tf->status;
 		desc[2] = tf->device;
 		desc[3] = tf->nsect;
 		desc[7] = 0;
@@ -968,14 +968,14 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	 * onto sense key, asc & ascq.
 	 */
 	if (qc->err_mask ||
-	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
-		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
+	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
+		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
 				   &sense_key, &asc, &ascq, verbose);
 		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
 	} else {
 		/* Could not decode error */
 		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
-			     tf->command, qc->err_mask);
+			     tf->status, qc->err_mask);
 		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
 		return;
 	}
@@ -2490,7 +2490,7 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	/* fill these in, for the case where they are -not- overwritten */
 	cmd->sense_buffer[0] = 0x70;
-	cmd->sense_buffer[2] = qc->tf.feature >> 4;
+	cmd->sense_buffer[2] = qc->tf.error >> 4;
 
 	ata_qc_reinit(qc);
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b71ea4a680b0..8409e53b7b7a 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -457,8 +457,8 @@ void ata_sff_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = ata_sff_check_status(ap);
-	tf->feature = ioread8(ioaddr->error_addr);
+	tf->status = ata_sff_check_status(ap);
+	tf->error = ioread8(ioaddr->error_addr);
 	tf->nsect = ioread8(ioaddr->nsect_addr);
 	tf->lbal = ioread8(ioaddr->lbal_addr);
 	tf->lbam = ioread8(ioaddr->lbam_addr);
@@ -1837,7 +1837,7 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 	memset(&tf, 0, sizeof(tf));
 
 	ap->ops->sff_tf_read(ap, &tf);
-	err = tf.feature;
+	err = tf.error;
 	if (r_err)
 		*r_err = err;
 
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 46208ececbb6..3fc26026014e 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -416,8 +416,8 @@ static void ep93xx_pata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ep93xx_pata_data *drv_data = ap->host->private_data;
 
-	tf->command = ep93xx_pata_check_status(ap);
-	tf->feature = ep93xx_pata_read_reg(drv_data, IDECTRL_ADDR_FEATURE);
+	tf->status = ep93xx_pata_check_status(ap);
+	tf->error = ep93xx_pata_read_reg(drv_data, IDECTRL_ADDR_FEATURE);
 	tf->nsect = ep93xx_pata_read_reg(drv_data, IDECTRL_ADDR_NSECT);
 	tf->lbal = ep93xx_pata_read_reg(drv_data, IDECTRL_ADDR_LBAL);
 	tf->lbam = ep93xx_pata_read_reg(drv_data, IDECTRL_ADDR_LBAM);
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index f4949e704356..9dd6bffefb48 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -264,8 +264,8 @@ void ns87560_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = ns87560_check_status(ap);
-	tf->feature = ioread8(ioaddr->error_addr);
+	tf->status = ns87560_check_status(ap);
+	tf->error = ioread8(ioaddr->error_addr);
 	tf->nsect = ioread8(ioaddr->nsect_addr);
 	tf->lbal = ioread8(ioaddr->lbal_addr);
 	tf->lbam = ioread8(ioaddr->lbam_addr);
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 4cc8a1027888..6c9f2efcedc1 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -386,7 +386,7 @@ static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
 	void __iomem *base = ap->ioaddr.data_addr;
 
 	blob = __raw_readw(base + 0xc);
-	tf->feature = blob >> 8;
+	tf->error = blob >> 8;
 
 	blob = __raw_readw(base + 2);
 	tf->nsect = blob & 0xff;
@@ -398,7 +398,7 @@ static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
 
 	blob = __raw_readw(base + 6);
 	tf->device = blob & 0xff;
-	tf->command = blob >> 8;
+	tf->status = blob >> 8;
 
 	if (tf->flags & ATA_TFLAG_LBA48) {
 		if (likely(ap->ioaddr.ctl_addr)) {
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 3da0e8e30286..149d771c61d6 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -213,7 +213,7 @@ static void pata_s3c_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->feature = ata_inb(ap->host, ioaddr->error_addr);
+	tf->error = ata_inb(ap->host, ioaddr->error_addr);
 	tf->nsect = ata_inb(ap->host, ioaddr->nsect_addr);
 	tf->lbal = ata_inb(ap->host, ioaddr->lbal_addr);
 	tf->lbam = ata_inb(ap->host, ioaddr->lbam_addr);
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 8440203e835e..f9bb3be4b939 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -400,7 +400,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
+	tf.status = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	do {
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index e517bd8822a5..659f1a903298 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -559,13 +559,13 @@ static void inic_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	void __iomem *port_base = inic_port_base(ap);
 
-	tf->feature	= readb(port_base + PORT_TF_FEATURE);
+	tf->error	= readb(port_base + PORT_TF_FEATURE);
 	tf->nsect	= readb(port_base + PORT_TF_NSECT);
 	tf->lbal	= readb(port_base + PORT_TF_LBAL);
 	tf->lbam	= readb(port_base + PORT_TF_LBAM);
 	tf->lbah	= readb(port_base + PORT_TF_LBAH);
 	tf->device	= readb(port_base + PORT_TF_DEVICE);
-	tf->command	= readb(port_base + PORT_TF_COMMAND);
+	tf->status	= readb(port_base + PORT_TF_COMMAND);
 }
 
 static bool inic_qc_fill_rtf(struct ata_queued_cmd *qc)
@@ -582,11 +582,11 @@ static bool inic_qc_fill_rtf(struct ata_queued_cmd *qc)
 	 */
 	inic_tf_read(qc->ap, &tf);
 
-	if (!(tf.command & ATA_ERR))
+	if (!(tf.status & ATA_ERR))
 		return false;
 
-	rtf->command = tf.command;
-	rtf->feature = tf.feature;
+	rtf->status = tf.status;
+	rtf->error = tf.error;
 	return true;
 }
 
diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 44b0ed8f6bb8..9759e24f718f 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -417,8 +417,8 @@ static void sata_rcar_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = sata_rcar_check_status(ap);
-	tf->feature = ioread32(ioaddr->error_addr);
+	tf->status = sata_rcar_check_status(ap);
+	tf->error = ioread32(ioaddr->error_addr);
 	tf->nsect = ioread32(ioaddr->nsect_addr);
 	tf->lbal = ioread32(ioaddr->lbal_addr);
 	tf->lbam = ioread32(ioaddr->lbam_addr);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index f8552559db7f..2e3418a82b44 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -194,24 +194,24 @@ static void k2_sata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 static void k2_sata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
-	u16 nsect, lbal, lbam, lbah, feature;
+	u16 nsect, lbal, lbam, lbah, error;
 
-	tf->command = k2_stat_check_status(ap);
+	tf->status = k2_stat_check_status(ap);
 	tf->device = readw(ioaddr->device_addr);
-	feature = readw(ioaddr->error_addr);
+	error = readw(ioaddr->error_addr);
 	nsect = readw(ioaddr->nsect_addr);
 	lbal = readw(ioaddr->lbal_addr);
 	lbam = readw(ioaddr->lbam_addr);
 	lbah = readw(ioaddr->lbah_addr);
 
-	tf->feature = feature;
+	tf->error = error;
 	tf->nsect = nsect;
 	tf->lbal = lbal;
 	tf->lbam = lbam;
 	tf->lbah = lbah;
 
 	if (tf->flags & ATA_TFLAG_LBA48) {
-		tf->hob_feature = feature >> 8;
+		tf->hob_feature = error >> 8;
 		tf->hob_nsect = nsect >> 8;
 		tf->hob_lbal = lbal >> 8;
 		tf->hob_lbam = lbam >> 8;
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 8fa952cb9f7f..87e4ed66b306 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -183,24 +183,24 @@ static void vsc_sata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 static void vsc_sata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
-	u16 nsect, lbal, lbam, lbah, feature;
+	u16 nsect, lbal, lbam, lbah, error;
 
-	tf->command = ata_sff_check_status(ap);
+	tf->status = ata_sff_check_status(ap);
 	tf->device = readw(ioaddr->device_addr);
-	feature = readw(ioaddr->error_addr);
+	error = readw(ioaddr->error_addr);
 	nsect = readw(ioaddr->nsect_addr);
 	lbal = readw(ioaddr->lbal_addr);
 	lbam = readw(ioaddr->lbam_addr);
 	lbah = readw(ioaddr->lbah_addr);
 
-	tf->feature = feature;
+	tf->error = error;
 	tf->nsect = nsect;
 	tf->lbal = lbal;
 	tf->lbam = lbam;
 	tf->lbah = lbah;
 
 	if (tf->flags & ATA_TFLAG_LBA48) {
-		tf->hob_feature = feature >> 8;
+		tf->hob_feature = error >> 8;
 		tf->hob_nsect = nsect >> 8;
 		tf->hob_lbal = lbal >> 8;
 		tf->hob_lbam = lbam >> 8;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e9c79a72f5e6..d890c43cff14 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -565,7 +565,10 @@ struct ata_taskfile {
 	u8			hob_lbam;
 	u8			hob_lbah;
 
-	u8			feature;
+	union {
+		u8		error;
+		u8		feature;
+	};
 	u8			nsect;
 	u8			lbal;
 	u8			lbam;
@@ -573,7 +576,10 @@ struct ata_taskfile {
 
 	u8			device;
 
-	u8			command;	/* IO operation */
+	union {
+		u8		status;
+		u8		command;
+	};
 
 	u32			auxiliary;	/* auxiliary field */
 						/* from SATA 3.1 and */
-- 
2.35.1



