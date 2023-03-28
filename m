Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891C06CCC36
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 23:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjC1Vl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 17:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjC1Vl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 17:41:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733EA8F;
        Tue, 28 Mar 2023 14:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680039686; x=1711575686;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XZVVwirwxpEmCstgNMpKoIXVQKJ+apmgMwC/2o6WYOw=;
  b=Ac80GwHgD39lTGPz3DWEYvWCTNBlPLB8bVQ+D6KZhRwV4fJfGTC8I/A8
   yqHOScNUfcYkOL6ehMvPh6n1JPslMe9d33fG5d3e9Mn9W+0rENkkPjSjN
   XEcezwHWr1p2txUXkBQOpMZ9T/Ehf0aNddeLIqKnFeq4c0nd0JzZ7S80Y
   wziOkvhUmBEYHTCQFUY7zxq2VYJCjjXK1KBd36WUrrfAOGB373hd/0u7v
   eAft2/wSTKsVn9cdhnwhmOu6CNAIWIq0Uf54/KaC5HO2jY3k2baIgKtJw
   SRxprWhjW81upNJJGZWHeS5r4NGNO6jQiKBPNkcLEO1r9POvg5C/cO3GU
   g==;
X-IronPort-AV: E=Sophos;i="5.98,297,1673938800"; 
   d="scan'208";a="218413207"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2023 14:41:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 14:41:25 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 28 Mar 2023 14:41:25 -0700
From:   Sagar Biradar <sagar.biradar@microchip.com>
To:     Don Brace <don.brace@microchip.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, Tom White <tom.white@microchip.com>
Subject: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ affinity
Date:   Tue, 28 Mar 2023 14:41:24 -0700
Message-ID: <20230328214124.26419-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the IO hang that arises because of MSIx vector not
having a mapped online CPU upon receiving completion.
This patch sets up a reply queue mapping to CPUs based on the
IRQ affinity retrieved using pci_irq_get_affinity() API.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/comminit.c | 25 +++++++++++++++++++++++++
 drivers/scsi/aacraid/linit.c    | 11 +++++++++++
 drivers/scsi/aacraid/src.c      |  2 +-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 5e115e8b2ba4..4a23f9fab61f 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1678,6 +1678,7 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+	unsigned int *reply_map;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index bd99c5492b7d..6fc323844a31 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -33,6 +33,8 @@
 
 #include "aacraid.h"
 
+void aac_setup_reply_map(struct aac_dev *dev);
+
 struct aac_common aac_config = {
 	.irq_mod = 1
 };
@@ -630,6 +632,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_is_src(dev))
 		aac_define_int_mode(dev);
+
+	aac_setup_reply_map(dev);
+
 	/*
 	 *	Ok now init the communication subsystem
 	 */
@@ -658,3 +663,23 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	return dev;
 }
 
+void aac_setup_reply_map(struct aac_dev *dev)
+{
+	const struct cpumask *mask;
+	unsigned int i, cpu = 1;
+
+	for (i = 1; i < dev->max_msix; i++) {
+		mask = pci_irq_get_affinity(dev->pdev, i);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask) {
+			dev->reply_map[cpu] = i;
+		}
+	}
+	return;
+
+fallback:
+	for_each_possible_cpu(cpu)
+		dev->reply_map[cpu] = 0;
+}
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5ba5c18b77b4..af60c7d26407 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1668,6 +1668,14 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_host;
 	}
 
+	aac->reply_map = kzalloc(sizeof(unsigned int) * nr_cpu_ids,
+				GFP_KERNEL);
+	if (!aac->reply_map) {
+		error = -ENOMEM;
+		dev_err(&pdev->dev, "reply_map allocation failed\n");
+		goto out_free_host;
+	}
+
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
@@ -1797,6 +1805,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				  aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
+	/* By now we should have configured the reply_map */
+	kfree(aac->reply_map);
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
  out_free_host:
@@ -1918,6 +1928,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 
 	aac_adapter_ioremap(aac, 0);
 
+	kfree(aac->reply_map);
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..e84ec60a655b 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -506,7 +506,7 @@ static int aac_src_deliver_message(struct fib *fib)
 			&& dev->sa_firmware)
 			vector_no = aac_get_vector(dev);
 		else
-			vector_no = fib->vector_no;
+			vector_no = dev->reply_map[raw_smp_processor_id()];
 
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
-- 
2.29.0

