Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE1524D3B
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353782AbiELMlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 08:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345760AbiELMlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 08:41:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F41A66FAA;
        Thu, 12 May 2022 05:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652359311; x=1683895311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yOrdlfVLVDmA6gksD7XY8LCyv5yWpNFOHRyzUmFyygk=;
  b=Crp1NX2S5Zj/9j31d4R02uX0l2jWz+k4+yqf291vn4xYOudIoegyJYX6
   wuxRjmh3dFtNBiqdztv5PVlJW7FrABFhPDMtDHmdlGQdnfLrJ3v2Xpxc6
   gtoolIzXyDml5b3a2HD0uQO7nVjOs6hkYDsT5SkD0M0IXTj2grFb5uldV
   wq8FBSty/PVwf4b+dwpqzFscfPJnphJDdz7LeI601cxGc1xfLWMpw4Nze
   7t8Yk7qfurFdqqeKkAuQqhtJhrZFTDKtNGcm8e5UZMdOfodFK0gLbYPaC
   ykQNTPkzoU/97NgVtTcq4Gi2OKs0OWFo7wSVBpOrOGEYamlwa13D7iYsU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="250512330"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="250512330"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 05:41:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="542754610"
Received: from mylly.fi.intel.com (HELO mylly.fi.intel.com.) ([10.237.72.150])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2022 05:41:47 -0700
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
Date:   Thu, 12 May 2022 15:41:43 +0300
Message-Id: <20220512124144.536850-1-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.

Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
Elkhart Lake") broke the test case using bitrate switching.

	ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
	ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
	candump can0 &
	cangen can1 -I 0x800 -L 64 -e -fb -D 11223344deadbeef55667788feedf00daabbccdd44332211 -n 1 -v -v

Above commit does everything correctly according to the datasheet.
However datasheet wasn't correct.

I got confirmation from hardware engineers that the actual CAN hardware
on Intel Elkhart Lake is based on M_CAN version v3.2.0. Datasheet was
mirroring values from an another specification which was based on earlier
M_CAN version leading to wrong bit timings.

Therefore revert the commit and switch back to common bit timings.

Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
Reported-by: Aman Kumar <aman.kumar@intel.com>
Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
---
 drivers/net/can/m_can/m_can_pci.c | 48 +++----------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index b56a54d6c5a9..8f184a852a0a 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,14 +18,9 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
-struct m_can_pci_config {
-	const struct can_bittiming_const *bit_timing;
-	const struct can_bittiming_const *data_timing;
-	unsigned int clock_freq;
-};
-
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -89,40 +84,9 @@ static struct m_can_ops m_can_pci_ops = {
 	.read_fifo = iomap_read_fifo,
 };
 
-static const struct can_bittiming_const m_can_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 64,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 128,
-	.sjw_max = 128,
-	.brp_min = 1,
-	.brp_max = 512,
-	.brp_inc = 1,
-};
-
-static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 16,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 8,
-	.sjw_max = 4,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
-static const struct m_can_pci_config m_can_pci_ehl = {
-	.bit_timing = &m_can_bittiming_const_ehl,
-	.data_timing = &m_can_data_bittiming_const_ehl,
-	.clock_freq = 200000000,
-};
-
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
-	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -150,8 +114,6 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
-	cfg = (const struct m_can_pci_config *)id->driver_data;
-
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -163,9 +125,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->bit_timing = cfg->bit_timing;
-	mcan_class->data_timing = cfg->data_timing;
-	mcan_class->can.clock.freq = cfg->clock_freq;
+	mcan_class->can.clock.freq = id->driver_data;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -218,8 +178,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
-- 
2.35.1

