Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576A627CDC9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgI2Mqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgI2LGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A14F8221E8;
        Tue, 29 Sep 2020 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377582;
        bh=FHP7vHm2rOOj+uv0f14eYPkjI6ZBVVAGo4UNvAVwOrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxNaXiiGql/b5mHmhCnXZCCNjJdRanF4Vm1bENC4gShiVRxL0gBNmXsVE/+SNz2Ko
         j9mJ5Ne8eNUe7YlEGPtv1aChTD6ADZ3jvxAEVwo1XUIguCprACk6s0u6a4LqZ1Gjxo
         1LXmqvypMq9luVuGm2uMtaaG24zp8EUNH86r2O6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org
Subject: [PATCH 4.4 84/85] ata: make qc_prep return ata_completion_errors
Date:   Tue, 29 Sep 2020 13:00:51 +0200
Message-Id: <20200929105932.382285822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 95364f36701e62dd50eee91e1303187fd1a9f567 upstream.

In case a driver wants to return an error from qc_prep, return enum
ata_completion_errors. sata_mv is one of those drivers -- see the next
patch. Other drivers return the newly defined AC_ERR_OK.

[v2] use enum ata_completion_errors and AC_ERR_OK.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-ide@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/DocBook/libata.tmpl |    2 +-
 drivers/ata/acard-ahci.c          |    6 ++++--
 drivers/ata/libahci.c             |    6 ++++--
 drivers/ata/libata-core.c         |    9 +++++++--
 drivers/ata/libata-sff.c          |   12 ++++++++----
 drivers/ata/pata_macio.c          |    6 ++++--
 drivers/ata/pata_pxa.c            |    8 +++++---
 drivers/ata/pdc_adma.c            |    7 ++++---
 drivers/ata/sata_fsl.c            |    4 +++-
 drivers/ata/sata_inic162x.c       |    4 +++-
 drivers/ata/sata_mv.c             |   26 +++++++++++++++-----------
 drivers/ata/sata_nv.c             |   18 +++++++++++-------
 drivers/ata/sata_promise.c        |    6 ++++--
 drivers/ata/sata_qstor.c          |    8 +++++---
 drivers/ata/sata_rcar.c           |    6 ++++--
 drivers/ata/sata_sil.c            |    8 +++++---
 drivers/ata/sata_sil24.c          |    6 ++++--
 drivers/ata/sata_sx4.c            |    6 ++++--
 include/linux/libata.h            |   12 ++++++------
 19 files changed, 101 insertions(+), 59 deletions(-)

--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -324,7 +324,7 @@ Many legacy IDE drivers use ata_bmdma_st
 
 	<sect2><title>High-level taskfile hooks</title>
 	<programlisting>
-void (*qc_prep) (struct ata_queued_cmd *qc);
+enum ata_completion_errors (*qc_prep) (struct ata_queued_cmd *qc);
 int (*qc_issue) (struct ata_queued_cmd *qc);
 	</programlisting>
 
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -72,7 +72,7 @@ struct acard_sg {
 	__le32			size;	 /* bit 31 (EOT) max==0x10000 (64k) */
 };
 
-static void acard_ahci_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors acard_ahci_qc_prep(struct ata_queued_cmd *qc);
 static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int acard_ahci_port_start(struct ata_port *ap);
 static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -257,7 +257,7 @@ static unsigned int acard_ahci_fill_sg(s
 	return si;
 }
 
-static void acard_ahci_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors acard_ahci_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -295,6 +295,8 @@ static void acard_ahci_qc_prep(struct at
 		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
 
 	ahci_fill_cmd_slot(pp, qc->tag, opts);
+
+	return AC_ERR_OK;
 }
 
 static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -71,7 +71,7 @@ static int ahci_scr_write(struct ata_lin
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
-static void ahci_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors ahci_qc_prep(struct ata_queued_cmd *qc);
 static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc);
 static void ahci_freeze(struct ata_port *ap);
 static void ahci_thaw(struct ata_port *ap);
@@ -1535,7 +1535,7 @@ static int ahci_pmp_qc_defer(struct ata_
 		return sata_pmp_qc_defer_cmd_switch(qc);
 }
 
-static void ahci_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors ahci_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1571,6 +1571,8 @@ static void ahci_qc_prep(struct ata_queu
 		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
 
 	ahci_fill_cmd_slot(pp, qc->tag, opts);
+
+	return AC_ERR_OK;
 }
 
 static void ahci_fbs_dec_intr(struct ata_port *ap)
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4713,7 +4713,10 @@ int ata_std_qc_defer(struct ata_queued_c
 	return ATA_DEFER_LINK;
 }
 
-void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
+enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc)
+{
+	return AC_ERR_OK;
+}
 
 /**
  *	ata_sg_init - Associate command with scatter-gather table.
@@ -5126,7 +5129,9 @@ void ata_qc_issue(struct ata_queued_cmd
 		return;
 	}
 
-	ap->ops->qc_prep(qc);
+	qc->err_mask |= ap->ops->qc_prep(qc);
+	if (unlikely(qc->err_mask))
+		goto err;
 	trace_ata_qc_issue(qc);
 	qc->err_mask |= ap->ops->qc_issue(qc);
 	if (unlikely(qc->err_mask))
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2741,12 +2741,14 @@ static void ata_bmdma_fill_sg_dumb(struc
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void ata_bmdma_qc_prep(struct ata_queued_cmd *qc)
+enum ata_completion_errors ata_bmdma_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	ata_bmdma_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
 
@@ -2759,12 +2761,14 @@ EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc)
+enum ata_completion_errors ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	ata_bmdma_fill_sg_dumb(qc);
+
+	return AC_ERR_OK;
 }
 EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
 
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -507,7 +507,7 @@ static int pata_macio_cable_detect(struc
 	return ATA_CBL_PATA40;
 }
 
-static void pata_macio_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
 {
 	unsigned int write = (qc->tf.flags & ATA_TFLAG_WRITE);
 	struct ata_port *ap = qc->ap;
@@ -520,7 +520,7 @@ static void pata_macio_qc_prep(struct at
 		   __func__, qc, qc->flags, write, qc->dev->devno);
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	table = (struct dbdma_cmd *) priv->dma_table_cpu;
 
@@ -565,6 +565,8 @@ static void pata_macio_qc_prep(struct at
 	table->command = cpu_to_le16(DBDMA_STOP);
 
 	dev_dbgdma(priv->dev, "%s: %d DMA list entries\n", __func__, pi);
+
+	return AC_ERR_OK;
 }
 
 
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -59,25 +59,27 @@ static void pxa_ata_dma_irq(void *d)
 /*
  * Prepare taskfile for submission.
  */
-static void pxa_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors pxa_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct pata_pxa_data *pd = qc->ap->private_data;
 	struct dma_async_tx_descriptor *tx;
 	enum dma_transfer_direction dir;
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	dir = (qc->dma_dir == DMA_TO_DEVICE ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
 	tx = dmaengine_prep_slave_sg(pd->dma_chan, qc->sg, qc->n_elem, dir,
 				     DMA_PREP_INTERRUPT);
 	if (!tx) {
 		ata_dev_err(qc->dev, "prep_slave_sg() failed\n");
-		return;
+		return AC_ERR_OK;
 	}
 	tx->callback = pxa_ata_dma_irq;
 	tx->callback_param = pd;
 	pd->dma_cookie = dmaengine_submit(tx);
+
+	return AC_ERR_OK;
 }
 
 /*
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -132,7 +132,7 @@ static int adma_ata_init_one(struct pci_
 				const struct pci_device_id *ent);
 static int adma_port_start(struct ata_port *ap);
 static void adma_port_stop(struct ata_port *ap);
-static void adma_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int adma_qc_issue(struct ata_queued_cmd *qc);
 static int adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void adma_freeze(struct ata_port *ap);
@@ -311,7 +311,7 @@ static int adma_fill_sg(struct ata_queue
 	return i;
 }
 
-static void adma_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors adma_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct adma_port_priv *pp = qc->ap->private_data;
 	u8  *buf = pp->pkt;
@@ -322,7 +322,7 @@ static void adma_qc_prep(struct ata_queu
 
 	adma_enter_reg_mode(qc->ap);
 	if (qc->tf.protocol != ATA_PROT_DMA)
-		return;
+		return AC_ERR_OK;
 
 	buf[i++] = 0;	/* Response flags */
 	buf[i++] = 0;	/* reserved */
@@ -387,6 +387,7 @@ static void adma_qc_prep(struct ata_queu
 			printk("%s\n", obuf);
 	}
 #endif
+	return AC_ERR_OK;
 }
 
 static inline void adma_packet_start(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -513,7 +513,7 @@ static unsigned int sata_fsl_fill_sg(str
 	return num_prde;
 }
 
-static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct sata_fsl_port_priv *pp = ap->private_data;
@@ -559,6 +559,8 @@ static void sata_fsl_qc_prep(struct ata_
 
 	VPRINTK("SATA FSL : xx_qc_prep, di = 0x%x, ttl = %d, num_prde = %d\n",
 		desc_info, ttl_dwords, num_prde);
+
+	return AC_ERR_OK;
 }
 
 static unsigned int sata_fsl_qc_issue(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -472,7 +472,7 @@ static void inic_fill_sg(struct inic_prd
 	prd[-1].flags |= PRD_END;
 }
 
-static void inic_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors inic_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct inic_port_priv *pp = qc->ap->private_data;
 	struct inic_pkt *pkt = pp->pkt;
@@ -532,6 +532,8 @@ static void inic_qc_prep(struct ata_queu
 		inic_fill_sg(prd, qc);
 
 	pp->cpb_tbl[0] = pp->pkt_dma;
+
+	return AC_ERR_OK;
 }
 
 static unsigned int inic_qc_issue(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -605,8 +605,8 @@ static int mv5_scr_write(struct ata_link
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static int mv_qc_defer(struct ata_queued_cmd *qc);
-static void mv_qc_prep(struct ata_queued_cmd *qc);
-static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
+static enum ata_completion_errors mv_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
 static int mv_hardreset(struct ata_link *link, unsigned int *class,
 			unsigned long deadline);
@@ -2046,7 +2046,7 @@ static void mv_rw_multi_errata_sata24(st
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors mv_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct mv_port_priv *pp = ap->private_data;
@@ -2058,15 +2058,15 @@ static void mv_qc_prep(struct ata_queued
 	switch (tf->protocol) {
 	case ATA_PROT_DMA:
 		if (tf->command == ATA_CMD_DSM)
-			return;
+			return AC_ERR_OK;
 		/* fall-thru */
 	case ATA_PROT_NCQ:
 		break;	/* continue below */
 	case ATA_PROT_PIO:
 		mv_rw_multi_errata_sata24(qc);
-		return;
+		return AC_ERR_OK;
 	default:
-		return;
+		return AC_ERR_OK;
 	}
 
 	/* Fill in command request block
@@ -2131,8 +2131,10 @@ static void mv_qc_prep(struct ata_queued
 	mv_crqb_pack_cmd(cw++, tf->command, ATA_REG_CMD, 1);	/* last */
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 	mv_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 
 /**
@@ -2147,7 +2149,7 @@ static void mv_qc_prep(struct ata_queued
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
+static enum ata_completion_errors mv_qc_prep_iie(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct mv_port_priv *pp = ap->private_data;
@@ -2158,9 +2160,9 @@ static void mv_qc_prep_iie(struct ata_qu
 
 	if ((tf->protocol != ATA_PROT_DMA) &&
 	    (tf->protocol != ATA_PROT_NCQ))
-		return;
+		return AC_ERR_OK;
 	if (tf->command == ATA_CMD_DSM)
-		return;  /* use bmdma for this */
+		return AC_ERR_OK;  /* use bmdma for this */
 
 	/* Fill in Gen IIE command request block */
 	if (!(tf->flags & ATA_TFLAG_WRITE))
@@ -2201,8 +2203,10 @@ static void mv_qc_prep_iie(struct ata_qu
 		);
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 	mv_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 
 /**
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -313,7 +313,7 @@ static void nv_ck804_freeze(struct ata_p
 static void nv_ck804_thaw(struct ata_port *ap);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
-static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors nv_adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc);
 static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance);
 static void nv_adma_irq_clear(struct ata_port *ap);
@@ -335,7 +335,7 @@ static void nv_mcp55_freeze(struct ata_p
 static void nv_swncq_error_handler(struct ata_port *ap);
 static int nv_swncq_slave_config(struct scsi_device *sdev);
 static int nv_swncq_port_start(struct ata_port *ap);
-static void nv_swncq_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors nv_swncq_qc_prep(struct ata_queued_cmd *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
 static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc);
 static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis);
@@ -1382,7 +1382,7 @@ static int nv_adma_use_reg_mode(struct a
 	return 1;
 }
 
-static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors nv_adma_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	struct nv_adma_cpb *cpb = &pp->cpb[qc->tag];
@@ -1394,7 +1394,7 @@ static void nv_adma_qc_prep(struct ata_q
 			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		ata_bmdma_qc_prep(qc);
-		return;
+		return AC_ERR_OK;
 	}
 
 	cpb->resp_flags = NV_CPB_RESP_DONE;
@@ -1426,6 +1426,8 @@ static void nv_adma_qc_prep(struct ata_q
 	cpb->ctl_flags = ctl_flags;
 	wmb();
 	cpb->resp_flags = 0;
+
+	return AC_ERR_OK;
 }
 
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
@@ -1989,17 +1991,19 @@ static int nv_swncq_port_start(struct at
 	return 0;
 }
 
-static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors nv_swncq_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (qc->tf.protocol != ATA_PROT_NCQ) {
 		ata_bmdma_qc_prep(qc);
-		return;
+		return AC_ERR_OK;
 	}
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	nv_swncq_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -155,7 +155,7 @@ static int pdc_sata_scr_write(struct ata
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int pdc_common_port_start(struct ata_port *ap);
 static int pdc_sata_port_start(struct ata_port *ap);
-static void pdc_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors pdc_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
 static int pdc_check_atapi_dma(struct ata_queued_cmd *qc);
@@ -649,7 +649,7 @@ static void pdc_fill_sg(struct ata_queue
 	prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
-static void pdc_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors pdc_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct pdc_port_priv *pp = qc->ap->private_data;
 	unsigned int i;
@@ -681,6 +681,8 @@ static void pdc_qc_prep(struct ata_queue
 	default:
 		break;
 	}
+
+	return AC_ERR_OK;
 }
 
 static int pdc_is_sataii_tx4(unsigned long flags)
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -116,7 +116,7 @@ static int qs_scr_write(struct ata_link
 static int qs_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
-static void qs_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors qs_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int qs_qc_issue(struct ata_queued_cmd *qc);
 static int qs_check_atapi_dma(struct ata_queued_cmd *qc);
 static void qs_freeze(struct ata_port *ap);
@@ -276,7 +276,7 @@ static unsigned int qs_fill_sg(struct at
 	return si;
 }
 
-static void qs_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors qs_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct qs_port_priv *pp = qc->ap->private_data;
 	u8 dflags = QS_DF_PORD, *buf = pp->pkt;
@@ -288,7 +288,7 @@ static void qs_qc_prep(struct ata_queued
 
 	qs_enter_reg_mode(qc->ap);
 	if (qc->tf.protocol != ATA_PROT_DMA)
-		return;
+		return AC_ERR_OK;
 
 	nelem = qs_fill_sg(qc);
 
@@ -311,6 +311,8 @@ static void qs_qc_prep(struct ata_queued
 
 	/* frame information structure (FIS) */
 	ata_tf_to_fis(&qc->tf, 0, 1, &buf[32]);
+
+	return AC_ERR_OK;
 }
 
 static inline void qs_packet_start(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -551,12 +551,14 @@ static void sata_rcar_bmdma_fill_sg(stru
 	prd[si - 1].addr |= cpu_to_le32(SATA_RCAR_DTEND);
 }
 
-static void sata_rcar_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors sata_rcar_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	sata_rcar_bmdma_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 
 static void sata_rcar_bmdma_setup(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -119,7 +119,7 @@ static void sil_dev_config(struct ata_de
 static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed);
-static void sil_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors sil_qc_prep(struct ata_queued_cmd *qc);
 static void sil_bmdma_setup(struct ata_queued_cmd *qc);
 static void sil_bmdma_start(struct ata_queued_cmd *qc);
 static void sil_bmdma_stop(struct ata_queued_cmd *qc);
@@ -333,12 +333,14 @@ static void sil_fill_sg(struct ata_queue
 		last_prd->flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
-static void sil_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors sil_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
+		return AC_ERR_OK;
 
 	sil_fill_sg(qc);
+
+	return AC_ERR_OK;
 }
 
 static unsigned char sil_get_device_cache_line(struct pci_dev *pdev)
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -336,7 +336,7 @@ static void sil24_dev_config(struct ata_
 static int sil24_scr_read(struct ata_link *link, unsigned sc_reg, u32 *val);
 static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val);
 static int sil24_qc_defer(struct ata_queued_cmd *qc);
-static void sil24_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors sil24_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc);
 static bool sil24_qc_fill_rtf(struct ata_queued_cmd *qc);
 static void sil24_pmp_attach(struct ata_port *ap);
@@ -840,7 +840,7 @@ static int sil24_qc_defer(struct ata_que
 	return ata_std_qc_defer(qc);
 }
 
-static void sil24_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors sil24_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct sil24_port_priv *pp = ap->private_data;
@@ -884,6 +884,8 @@ static void sil24_qc_prep(struct ata_que
 
 	if (qc->flags & ATA_QCFLAG_DMAMAP)
 		sil24_fill_sg(qc, sge);
+
+	return AC_ERR_OK;
 }
 
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -218,7 +218,7 @@ static void pdc_error_handler(struct ata
 static void pdc_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
-static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
+static enum ata_completion_errors pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
 static unsigned int pdc20621_dimm_init(struct ata_host *host);
@@ -546,7 +546,7 @@ static void pdc20621_nodata_prep(struct
 	VPRINTK("ata pkt buf ofs %u, mmio copied\n", i);
 }
 
-static void pdc20621_qc_prep(struct ata_queued_cmd *qc)
+static enum ata_completion_errors pdc20621_qc_prep(struct ata_queued_cmd *qc)
 {
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
@@ -558,6 +558,8 @@ static void pdc20621_qc_prep(struct ata_
 	default:
 		break;
 	}
+
+	return AC_ERR_OK;
 }
 
 static void __pdc20621_push_hdma(struct ata_queued_cmd *qc,
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -897,9 +897,9 @@ struct ata_port_operations {
 	/*
 	 * Command execution
 	 */
-	int  (*qc_defer)(struct ata_queued_cmd *qc);
-	int  (*check_atapi_dma)(struct ata_queued_cmd *qc);
-	void (*qc_prep)(struct ata_queued_cmd *qc);
+	int (*qc_defer)(struct ata_queued_cmd *qc);
+	int (*check_atapi_dma)(struct ata_queued_cmd *qc);
+	enum ata_completion_errors (*qc_prep)(struct ata_queued_cmd *qc);
 	unsigned int (*qc_issue)(struct ata_queued_cmd *qc);
 	bool (*qc_fill_rtf)(struct ata_queued_cmd *qc);
 
@@ -1191,7 +1191,7 @@ extern int ata_xfer_mode2shift(unsigned
 extern const char *ata_mode_string(unsigned long xfer_mask);
 extern unsigned long ata_id_xfermask(const u16 *id);
 extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
-extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
+extern enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
@@ -1882,9 +1882,9 @@ extern const struct ata_port_operations
 	.sg_tablesize		= LIBATA_MAX_PRD,		\
 	.dma_boundary		= ATA_DMA_BOUNDARY
 
-extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
+extern enum ata_completion_errors ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
-extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
+extern enum ata_completion_errors ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_bmdma_port_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_bmdma_interrupt(int irq, void *dev_instance);


