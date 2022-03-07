Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4AE4CF63F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiCGJed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbiCGJde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:33:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7686D180;
        Mon,  7 Mar 2022 01:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 029A6B810BD;
        Mon,  7 Mar 2022 09:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263AFC340E9;
        Mon,  7 Mar 2022 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645433;
        bh=U0NBSGGAAiB5RuM+ha/CczSgoW4P8pJ0p++3T5GdVUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBJlxc2io+asrpTNvwDiGDQ2zMRHVzuNe5YKZWTTezH7C5mTuyHzc5n58cKIMeYdG
         1Xk2pJ7jxJaONCWvYVT1AGYysMa2+eXvg4sB9bpSF4CjOQ59zrKHTKps7Z+wcc+xvl
         BInyyu3Zu/QcBuYr9WSjlmzuWE5xuadZNPjcubrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Buytenhek <buytenh@arista.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 030/105] iommu/amd: Recover from event log overflow
Date:   Mon,  7 Mar 2022 10:18:33 +0100
Message-Id: <20220307091645.031593223@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>

commit 5ce97f4ec5e0f8726a5dda1710727b1ee9badcac upstream.

The AMD IOMMU logs I/O page faults and such to a ring buffer in
system memory, and this ring buffer can overflow.  The AMD IOMMU
spec has the following to say about the interrupt status bit that
signals this overflow condition:

	EventOverflow: Event log overflow. RW1C. Reset 0b. 1 = IOMMU
	event log overflow has occurred. This bit is set when a new
	event is to be written to the event log and there is no usable
	entry in the event log, causing the new event information to
	be discarded. An interrupt is generated when EventOverflow = 1b
	and MMIO Offset 0018h[EventIntEn] = 1b. No new event log
	entries are written while this bit is set. Software Note: To
	resume logging, clear EventOverflow (W1C), and write a 1 to
	MMIO Offset 0018h[EventLogEn].

The AMD IOMMU driver doesn't currently implement this recovery
sequence, meaning that if a ring buffer overflow occurs, logging
of EVT/PPR/GA events will cease entirely.

This patch implements the spec-mandated reset sequence, with the
minor tweak that the hardware seems to want to have a 0 written to
MMIO Offset 0018h[EventLogEn] first, before writing an 1 into this
field, or the IOMMU won't actually resume logging events.

Signed-off-by: Lennert Buytenhek <buytenh@arista.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/YVrSXEdW2rzEfOvk@wantstofly.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/amd_iommu.h       |    1 +
 drivers/iommu/amd/amd_iommu_types.h |    1 +
 drivers/iommu/amd/init.c            |   10 ++++++++++
 drivers/iommu/amd/iommu.c           |   10 ++++++++--
 4 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -17,6 +17,7 @@ extern int amd_iommu_init_passthrough(vo
 extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(u16 devid);
+extern void amd_iommu_restart_event_logging(struct amd_iommu *iommu);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -109,6 +109,7 @@
 #define PASID_MASK		0x0000ffff
 
 /* MMIO status bits */
+#define MMIO_STATUS_EVT_OVERFLOW_INT_MASK	(1 << 0)
 #define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -657,6 +657,16 @@ static int __init alloc_command_buffer(s
 }
 
 /*
+ * This function restarts event logging in case the IOMMU experienced
+ * an event log buffer overflow.
+ */
+void amd_iommu_restart_event_logging(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_EVT_LOG_EN);
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+}
+
+/*
  * This function resets the command buffer if the IOMMU stopped fetching
  * commands from it.
  */
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -813,7 +813,8 @@ amd_iommu_set_pci_msi_domain(struct devi
 #endif /* !CONFIG_IRQ_REMAP */
 
 #define AMD_IOMMU_INT_MASK	\
-	(MMIO_STATUS_EVT_INT_MASK | \
+	(MMIO_STATUS_EVT_OVERFLOW_INT_MASK | \
+	 MMIO_STATUS_EVT_INT_MASK | \
 	 MMIO_STATUS_PPR_INT_MASK | \
 	 MMIO_STATUS_GALOG_INT_MASK)
 
@@ -823,7 +824,7 @@ irqreturn_t amd_iommu_int_thread(int irq
 	u32 status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 
 	while (status & AMD_IOMMU_INT_MASK) {
-		/* Enable EVT and PPR and GA interrupts again */
+		/* Enable interrupt sources again */
 		writel(AMD_IOMMU_INT_MASK,
 			iommu->mmio_base + MMIO_STATUS_OFFSET);
 
@@ -844,6 +845,11 @@ irqreturn_t amd_iommu_int_thread(int irq
 		}
 #endif
 
+		if (status & MMIO_STATUS_EVT_OVERFLOW_INT_MASK) {
+			pr_info_ratelimited("IOMMU event log overflow\n");
+			amd_iommu_restart_event_logging(iommu);
+		}
+
 		/*
 		 * Hardware bug: ERBT1312
 		 * When re-enabling interrupt (by writing 1


