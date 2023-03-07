Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12536AED0A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCGSAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjCGSAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9437B4A6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC40CB819C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B40BC433EF;
        Tue,  7 Mar 2023 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211659;
        bh=XiBngLPm0sTkZGrpgalvbiWmOGeMLl/W4nCs4fI+Cz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGVIdN1lb6JdlANLjLCKN80M+aYCeIK5Gl2dAmHhRCy4WVcVfI6yevb+3/UM0odgR
         NcjP1lyvFhV1hJ4dnK5R2uoP0mRu8yARtlZq32RbrLcxpH96OD4bam7zQBvAlA3Ynw
         yRawkeiRKUN6O3RChW/pVH5EmpJE1u34k9xAFub8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.2 0935/1001] genirq/msi, platform-msi: Ensure that MSI descriptors are unreferenced
Date:   Tue,  7 Mar 2023 18:01:47 +0100
Message-Id: <20230307170102.674982114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 0fb7fb713461e44b12e72c292bf90ee300f40710 upstream.

Miquel reported a warning in the MSI core which is triggered when
interrupts are freed via platform_msi_device_domain_free().

This code got reworked to use core functions for freeing the MSI
descriptors, but nothing took care to clear the msi_desc->irq entry, which
then triggers the warning in msi_free_msi_desc() which uses desc->irq to
validate that the descriptor has been torn down. The same issue exists in
msi_domain_populate_irqs().

Up to the point that msi_free_msi_descs() grew a warning for this case,
this went un-noticed.

Provide the counterpart of msi_domain_populate_irqs() and invoke it in
platform_msi_device_domain_free() before freeing the interrupts and MSI
descriptors and also in the error path of msi_domain_populate_irqs().

Fixes: 2f2940d16823 ("genirq/msi: Remove filter from msi_free_descs_free_range()")
Reported-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87mt4wkwnv.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform-msi.c |  1 +
 include/linux/msi.h         |  2 ++
 kernel/irq/msi.c            | 23 ++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 5883e7634a2b..f37ad34c80ec 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -324,6 +324,7 @@ void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int vir
 	struct platform_msi_priv_data *data = domain->host_data;
 
 	msi_lock_descs(data->dev);
+	msi_domain_depopulate_descs(data->dev, virq, nr_irqs);
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 	msi_free_msi_descs_range(data->dev, virq, virq + nr_irqs - 1);
 	msi_unlock_descs(data->dev);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index a112b913fff9..15dd71817996 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -631,6 +631,8 @@ int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
 			    int nvec, msi_alloc_info_t *args);
 int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 			     int virq, int nvec, msi_alloc_info_t *args);
+void msi_domain_depopulate_descs(struct device *dev, int virq, int nvec);
+
 struct irq_domain *
 __platform_msi_create_device_domain(struct device *dev,
 				    unsigned int nvec,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index efd21b79bf32..d169ee0c1799 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1109,14 +1109,35 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 	return 0;
 
 fail:
-	for (--virq; virq >= virq_base; virq--)
+	for (--virq; virq >= virq_base; virq--) {
+		msi_domain_depopulate_descs(dev, virq, 1);
 		irq_domain_free_irqs_common(domain, virq, 1);
+	}
 	msi_domain_free_descs(dev, &ctrl);
 unlock:
 	msi_unlock_descs(dev);
 	return ret;
 }
 
+void msi_domain_depopulate_descs(struct device *dev, int virq_base, int nvec)
+{
+	struct msi_ctrl ctrl = {
+		.domid	= MSI_DEFAULT_DOMAIN,
+		.first  = virq_base,
+		.last	= virq_base + nvec - 1,
+	};
+	struct msi_desc *desc;
+	struct xarray *xa;
+	unsigned long idx;
+
+	if (!msi_ctrl_valid(dev, &ctrl))
+		return;
+
+	xa = &dev->msi.data->__domains[ctrl.domid].store;
+	xa_for_each_range(xa, idx, desc, ctrl.first, ctrl.last)
+		desc->irq = 0;
+}
+
 /*
  * Carefully check whether the device can use reservation mode. If
  * reservation mode is enabled then the early activation will assign a
-- 
2.39.2



