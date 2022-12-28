Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96316578A4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiL1OxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiL1Owc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C00FCA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B0B3B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DACC433EF;
        Wed, 28 Dec 2022 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239148;
        bh=ouwah44BN0UIKcy79knVsITn2nrEfVqjT8N/5u/P0Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE22KBU2AXRxPn/goLXaLIqu+Nqe6fsgxa3MPcGoBdiNj86hXJb8mIO/uNm1tZbtS
         ukUGy2SgZBRTgBSzqiTAZiMJByqmwV8WIJFXnfkEuk1TPy25H2k7tRXiMit5DjR0lF
         WSUybI4q0cfEU5eqaxQZzkmTdlIQ1gB9DDHudcmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/731] ata: libata: move ata_{port,link,dev}_dbg to standard pr_XXX() macros
Date:   Wed, 28 Dec 2022 15:34:14 +0100
Message-Id: <20221228144300.816970447@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 742bef476ca5352b16063161fb73a56629a6d995 ]

Use standard pr_{debug,info,notice,warn,err} macros instead of the
hand-crafted printk helpers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 7390896b3484 ("ata: libata: fix NCQ autosense logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-acpi.c    | 48 +++++++++++++------------
 drivers/ata/libata-core.c    | 61 -------------------------------
 drivers/ata/pata_ixp4xx_cf.c |  6 ++--
 include/linux/libata.h       | 69 ++++++++++++++++++++----------------
 4 files changed, 67 insertions(+), 117 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 7a7d6642edcc..7007377880ce 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -650,9 +650,7 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 	struct ata_taskfile *pptf = NULL;
 	struct ata_taskfile tf, ptf, rtf;
 	unsigned int err_mask;
-	const char *level;
 	const char *descr;
-	char msg[60];
 	int rc;
 
 	if ((gtf->tf[0] == 0) && (gtf->tf[1] == 0) && (gtf->tf[2] == 0)
@@ -666,6 +664,10 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 		pptf = &ptf;
 	}
 
+	descr = ata_get_cmd_descript(tf.command);
+	if (!descr)
+		descr = "unknown";
+
 	if (!ata_acpi_filter_tf(dev, &tf, pptf)) {
 		rtf = tf;
 		err_mask = ata_exec_internal(dev, &rtf, NULL,
@@ -673,40 +675,42 @@ static int ata_acpi_run_tf(struct ata_device *dev,
 
 		switch (err_mask) {
 		case 0:
-			level = KERN_DEBUG;
-			snprintf(msg, sizeof(msg), "succeeded");
+			ata_dev_dbg(dev,
+				"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x"
+				"(%s) succeeded\n",
+				tf.command, tf.feature, tf.nsect, tf.lbal,
+				tf.lbam, tf.lbah, tf.device, descr);
 			rc = 1;
 			break;
 
 		case AC_ERR_DEV:
-			level = KERN_INFO;
-			snprintf(msg, sizeof(msg),
-				 "rejected by device (Stat=0x%02x Err=0x%02x)",
-				 rtf.command, rtf.feature);
+			ata_dev_info(dev,
+				"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x"
+				"(%s) rejected by device (Stat=0x%02x Err=0x%02x)",
+				tf.command, tf.feature, tf.nsect, tf.lbal,
+				tf.lbam, tf.lbah, tf.device, descr,
+				rtf.command, rtf.feature);
 			rc = 0;
 			break;
 
 		default:
-			level = KERN_ERR;
-			snprintf(msg, sizeof(msg),
-				 "failed (Emask=0x%x Stat=0x%02x Err=0x%02x)",
-				 err_mask, rtf.command, rtf.feature);
+			ata_dev_err(dev,
+				"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x"
+				"(%s) failed (Emask=0x%x Stat=0x%02x Err=0x%02x)",
+				tf.command, tf.feature, tf.nsect, tf.lbal,
+				tf.lbam, tf.lbah, tf.device, descr,
+				err_mask, rtf.command, rtf.feature);
 			rc = -EIO;
 			break;
 		}
 	} else {
-		level = KERN_INFO;
-		snprintf(msg, sizeof(msg), "filtered out");
+		ata_dev_info(dev,
+			"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x"
+			"(%s) filtered out\n",
+			tf.command, tf.feature, tf.nsect, tf.lbal,
+			tf.lbam, tf.lbah, tf.device, descr);
 		rc = 0;
 	}
-	descr = ata_get_cmd_descript(tf.command);
-
-	ata_dev_printk(dev, level,
-		       "ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x (%s) %s\n",
-		       tf.command, tf.feature, tf.nsect, tf.lbal,
-		       tf.lbam, tf.lbah, tf.device,
-		       (descr ? descr : "unknown"), msg);
-
 	return rc;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4d308e3163c3..1c9ad3045606 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6497,67 +6497,6 @@ const struct ata_port_info ata_dummy_port_info = {
 };
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
 
-/*
- * Utility print functions
- */
-void ata_port_printk(const struct ata_port *ap, const char *level,
-		     const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk("%sata%u: %pV", level, ap->print_id, &vaf);
-
-	va_end(args);
-}
-EXPORT_SYMBOL(ata_port_printk);
-
-void ata_link_printk(const struct ata_link *link, const char *level,
-		     const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	if (sata_pmp_attached(link->ap) || link->ap->slave_link)
-		printk("%sata%u.%02u: %pV",
-		       level, link->ap->print_id, link->pmp, &vaf);
-	else
-		printk("%sata%u: %pV",
-		       level, link->ap->print_id, &vaf);
-
-	va_end(args);
-}
-EXPORT_SYMBOL(ata_link_printk);
-
-void ata_dev_printk(const struct ata_device *dev, const char *level,
-		    const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	printk("%sata%u.%02u: %pV",
-	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
-	       &vaf);
-
-	va_end(args);
-}
-EXPORT_SYMBOL(ata_dev_printk);
-
 void ata_print_version(const struct device *dev, const char *version)
 {
 	dev_printk(KERN_DEBUG, dev, "version %s\n", version);
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 99c63087c8ae..17b557c91e1c 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -114,7 +114,7 @@ static void ixp4xx_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ixp4xx_pata *ixpp = ap->host->private_data;
 
-	ata_dev_printk(adev, KERN_INFO, "configured for PIO%d 8bit\n",
+	ata_dev_info(adev, "configured for PIO%d 8bit\n",
 		       adev->pio_mode - XFER_PIO_0);
 	ixp4xx_set_8bit_timing(ixpp, adev->pio_mode);
 }
@@ -132,8 +132,8 @@ static unsigned int ixp4xx_mmio_data_xfer(struct ata_queued_cmd *qc,
 	struct ixp4xx_pata *ixpp = ap->host->private_data;
 	unsigned long flags;
 
-	ata_dev_printk(adev, KERN_DEBUG, "%s %d bytes\n", (rw == READ) ? "READ" : "WRITE",
-		       buflen);
+	ata_dev_dbg(adev, "%s %d bytes\n", (rw == READ) ? "READ" : "WRITE",
+		    buflen);
 	spin_lock_irqsave(ap->lock, flags);
 
 	/* set the expansion bus in 16bit mode and restore
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a64e12605d31..e9c79a72f5e6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1471,51 +1471,61 @@ static inline int sata_srst_pmp(struct ata_link *link)
 	return link->pmp;
 }
 
-/*
- * printk helpers
- */
-__printf(3, 4)
-void ata_port_printk(const struct ata_port *ap, const char *level,
-		     const char *fmt, ...);
-__printf(3, 4)
-void ata_link_printk(const struct ata_link *link, const char *level,
-		     const char *fmt, ...);
-__printf(3, 4)
-void ata_dev_printk(const struct ata_device *dev, const char *level,
-		    const char *fmt, ...);
+#define ata_port_printk(level, ap, fmt, ...)			\
+	pr_ ## level ("ata%u: " fmt, (ap)->print_id, ##__VA_ARGS__)
 
 #define ata_port_err(ap, fmt, ...)				\
-	ata_port_printk(ap, KERN_ERR, fmt, ##__VA_ARGS__)
+	ata_port_printk(err, ap, fmt, ##__VA_ARGS__)
 #define ata_port_warn(ap, fmt, ...)				\
-	ata_port_printk(ap, KERN_WARNING, fmt, ##__VA_ARGS__)
+	ata_port_printk(warn, ap, fmt, ##__VA_ARGS__)
 #define ata_port_notice(ap, fmt, ...)				\
-	ata_port_printk(ap, KERN_NOTICE, fmt, ##__VA_ARGS__)
+	ata_port_printk(notice, ap, fmt, ##__VA_ARGS__)
 #define ata_port_info(ap, fmt, ...)				\
-	ata_port_printk(ap, KERN_INFO, fmt, ##__VA_ARGS__)
+	ata_port_printk(info, ap, fmt, ##__VA_ARGS__)
 #define ata_port_dbg(ap, fmt, ...)				\
-	ata_port_printk(ap, KERN_DEBUG, fmt, ##__VA_ARGS__)
+	ata_port_printk(debug, ap, fmt, ##__VA_ARGS__)
+
+#define ata_link_printk(level, link, fmt, ...)			\
+do {								\
+	if (sata_pmp_attached((link)->ap) ||			\
+	    (link)->ap->slave_link)				\
+		pr_ ## level ("ata%u.%02u: " fmt,		\
+			      (link)->ap->print_id,		\
+			      (link)->pmp,			\
+			      ##__VA_ARGS__);			\
+        else							\
+		pr_ ## level ("ata%u: " fmt,			\
+			      (link)->ap->print_id,		\
+			      ##__VA_ARGS__);			\
+} while (0)
 
 #define ata_link_err(link, fmt, ...)				\
-	ata_link_printk(link, KERN_ERR, fmt, ##__VA_ARGS__)
+	ata_link_printk(err, link, fmt, ##__VA_ARGS__)
 #define ata_link_warn(link, fmt, ...)				\
-	ata_link_printk(link, KERN_WARNING, fmt, ##__VA_ARGS__)
+	ata_link_printk(warn, link, fmt, ##__VA_ARGS__)
 #define ata_link_notice(link, fmt, ...)				\
-	ata_link_printk(link, KERN_NOTICE, fmt, ##__VA_ARGS__)
+	ata_link_printk(notice, link, fmt, ##__VA_ARGS__)
 #define ata_link_info(link, fmt, ...)				\
-	ata_link_printk(link, KERN_INFO, fmt, ##__VA_ARGS__)
+	ata_link_printk(info, link, fmt, ##__VA_ARGS__)
 #define ata_link_dbg(link, fmt, ...)				\
-	ata_link_printk(link, KERN_DEBUG, fmt, ##__VA_ARGS__)
+	ata_link_printk(debug, link, fmt, ##__VA_ARGS__)
+
+#define ata_dev_printk(level, dev, fmt, ...)			\
+        pr_ ## level("ata%u.%02u: " fmt,			\
+               (dev)->link->ap->print_id,			\
+	       (dev)->link->pmp + (dev)->devno,			\
+	       ##__VA_ARGS__)
 
 #define ata_dev_err(dev, fmt, ...)				\
-	ata_dev_printk(dev, KERN_ERR, fmt, ##__VA_ARGS__)
+	ata_dev_printk(err, dev, fmt, ##__VA_ARGS__)
 #define ata_dev_warn(dev, fmt, ...)				\
-	ata_dev_printk(dev, KERN_WARNING, fmt, ##__VA_ARGS__)
+	ata_dev_printk(warn, dev, fmt, ##__VA_ARGS__)
 #define ata_dev_notice(dev, fmt, ...)				\
-	ata_dev_printk(dev, KERN_NOTICE, fmt, ##__VA_ARGS__)
+	ata_dev_printk(notice, dev, fmt, ##__VA_ARGS__)
 #define ata_dev_info(dev, fmt, ...)				\
-	ata_dev_printk(dev, KERN_INFO, fmt, ##__VA_ARGS__)
+	ata_dev_printk(info, dev, fmt, ##__VA_ARGS__)
 #define ata_dev_dbg(dev, fmt, ...)				\
-	ata_dev_printk(dev, KERN_DEBUG, fmt, ##__VA_ARGS__)
+	ata_dev_printk(debug, dev, fmt, ##__VA_ARGS__)
 
 void ata_print_version(const struct device *dev, const char *version);
 
@@ -2049,11 +2059,8 @@ static inline u8 ata_wait_idle(struct ata_port *ap)
 {
 	u8 status = ata_sff_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
 
-#ifdef ATA_DEBUG
 	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ)))
-		ata_port_printk(ap, KERN_DEBUG, "abnormal Status 0x%X\n",
-				status);
-#endif
+		ata_port_dbg(ap, "abnormal Status 0x%X\n", status);
 
 	return status;
 }
-- 
2.35.1



