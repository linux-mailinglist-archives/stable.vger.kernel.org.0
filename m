Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDB157680F
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 22:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiGOURd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 16:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiGOURc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 16:17:32 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B95018C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657916252; x=1689452252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBzBfDuwlw+XvFGaMmHTcR09J30Lvc9uwz0MffzObUk=;
  b=Q4eq53yTnN6pQTVgWNcvNmr4DLqJAnmf73zkDKeQ9p9bITgbWyrFLS0G
   IPhcbIuRm8McPidY+zVFPEKZSBP+jwR4neitiPzLG8/4OhaYNW2vHX18U
   LOKYNXpHOYni/ZCtBE8T1OZUk7H9SG+/0MCyS3L/H5YmcsXMhMnaOxxgB
   w=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 15 Jul 2022 13:17:31 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:17:30 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:17:30 -0700
Received: from ubuntuvm.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:17:29 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Jeffrey Hugo <quic_jhugo@quicinc.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <wei.liu@microsoft.com>, <decui@microsoft.com>,
        <lorenzo.pieralisi@arm.com>, <robh@kernel.org>, <kw@linux.com>,
        <bhelgaas@google.com>, Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.4 3/4] PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
Date:   Fri, 15 Jul 2022 20:16:46 +0000
Message-ID: <20220715201647.18145-4-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715201647.18145-1-quic_carlv@quicinc.com>
References: <20220715201647.18145-1-quic_carlv@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

commit b4b77778ecc5bfbd4e77de1b2fd5c1dd3c655f1f upstream.

Currently if compose_msi_msg() is called multiple times, it will free any
previous IRTE allocation, and generate a new allocation.  While nothing
prevents this from occurring, it is extraneous when Linux could just reuse
the existing allocation and avoid a bunch of overhead.

However, when future IRTE allocations operate on blocks of MSIs instead of
a single line, freeing the allocation will impact all of the lines.  This
could cause an issue where an allocation of N MSIs occurs, then some of
the lines are retargeted, and finally the allocation is freed/reallocated.
The freeing of the allocation removes all of the configuration for the
entire block, which requires all the lines to be retargeted, which might
not happen since some lines might already be unmasked/active.

Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1652282582-21595-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
---
 drivers/pci/controller/pci-hyperv.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index bc87376562da..43082c3d1d60 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1387,6 +1387,15 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	u32 size;
 	int ret;
 
+	/* Reuse the previous allocation */
+	if (data->chip_data) {
+		int_desc = data->chip_data;
+		msg->address_hi = int_desc->address >> 32;
+		msg->address_lo = int_desc->address & 0xffffffff;
+		msg->data = int_desc->data;
+		return;
+	}
+
 	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
@@ -1395,13 +1404,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	if (!hpdev)
 		goto return_null_message;
 
-	/* Free any previous message that might have already been composed. */
-	if (data->chip_data) {
-		int_desc = data->chip_data;
-		data->chip_data = NULL;
-		hv_int_desc_free(hpdev, int_desc);
-	}
-
 	int_desc = kzalloc(sizeof(*int_desc), GFP_ATOMIC);
 	if (!int_desc)
 		goto drop_reference;
-- 
2.25.1

