Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34E466CA90
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbjAPREL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbjAPRDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F74166C1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC8F761084
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFAC433D2;
        Mon, 16 Jan 2023 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887558;
        bh=DUtOD3qjG7K2iCwBhgZ+pBYXb8V+jhNEH+bSONqKsA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4q1Y3o7sRZrAy4CXkxgfG5zFfI33sqpB+m06cMRnbMdYCU2sAHuBvdT6ZN1WCuMO
         RtA3bPgfTj+xpjrx6Tss+Mo8YWenLkE1IJ0Gp92AjM+UVFQmDn0Tkx6ppt1vCbA7y0
         ktb7SmmxUi4B3l1YpuWZK6O1B7Y8jQYw4i3bApwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joe Perches <joe@perches.com>,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/521] scsi: mpt3sas: Convert uses of pr_<level> with MPT3SAS_FMT to ioc_<level>
Date:   Mon, 16 Jan 2023 16:47:36 +0100
Message-Id: <20230116154855.749403669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Joe Perches <joe@perches.com>

[ Upstream commit 919d8a3f3fef9910fda7e0549004cbd4243cf744 ]

Use a more common logging style.

Done using the perl script below and some typing

$ git grep --name-only -w MPT3SAS_FMT -- "*.c" | \
  xargs perl -i -e 'local $/; while (<>) { s/\bpr_(info|err|notice|warn)\s*\(\s*MPT3SAS_FMT\s*("[^"]+"(?:\s*\\?\s*"[^"]+"\s*){0,5}\s*),\s*ioc->name\s*/ioc_\1(ioc, \2/g; print;}'

Miscellanea for these conversions:

o Coalesce formats
o Realign arguments
o Remove unnecessary parentheses
o Use casts to u64 instead of unsigned long long where appropriate
o Convert broken pr_info uses to pr_cont
o Fix broken format string concatenation with line continuations and
  excess whitespace

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 78316e9dfc24 ("scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 1065 ++++++--------
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   48 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  493 +++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 1425 ++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  313 ++--
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  101 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c    |   70 +-
 7 files changed, 1533 insertions(+), 1982 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 447ac667f4b2..27ddc128af99 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -122,8 +122,8 @@ mpt3sas_base_check_cmd_timeout(struct MPT3SAS_ADAPTER *ioc,
 	if (!(status & MPT3_CMD_RESET))
 		issue_reset = 1;
 
-	pr_err(MPT3SAS_FMT "Command %s\n", ioc->name,
-	    ((issue_reset == 0) ? "terminated due to Host Reset" : "Timeout"));
+	ioc_err(ioc, "Command %s\n",
+		issue_reset == 0 ? "terminated due to Host Reset" : "Timeout");
 	_debug_dump_mf(mpi_request, sz);
 
 	return issue_reset;
@@ -336,9 +336,7 @@ _base_get_chain_buffer_dma_to_chain_buffer(struct MPT3SAS_ADAPTER *ioc,
 				return ct->chain_buffer;
 		}
 	}
-	pr_info(MPT3SAS_FMT
-	    "Provided chain_buffer_dma address is not in the lookup list\n",
-	    ioc->name);
+	ioc_info(ioc, "Provided chain_buffer_dma address is not in the lookup list\n");
 	return NULL;
 }
 
@@ -394,7 +392,7 @@ static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
 		/* Get scsi_cmd using smid */
 		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (scmd == NULL) {
-			pr_err(MPT3SAS_FMT "scmd is NULL\n", ioc->name);
+			ioc_err(ioc, "scmd is NULL\n");
 			return;
 		}
 
@@ -566,8 +564,7 @@ _base_fault_reset_work(struct work_struct *work)
 
 	doorbell = mpt3sas_base_get_iocstate(ioc, 0);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_MASK) {
-		pr_err(MPT3SAS_FMT "SAS host is non-operational !!!!\n",
-		    ioc->name);
+		ioc_err(ioc, "SAS host is non-operational !!!!\n");
 
 		/* It may be possible that EEH recovery can resolve some of
 		 * pci bus failure issues rather removing the dead ioc function
@@ -600,13 +597,11 @@ _base_fault_reset_work(struct work_struct *work)
 		p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
 		    "%s_dead_ioc_%d", ioc->driver_name, ioc->id);
 		if (IS_ERR(p))
-			pr_err(MPT3SAS_FMT
-			"%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
-			ioc->name, __func__);
+			ioc_err(ioc, "%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
+				__func__);
 		else
-			pr_err(MPT3SAS_FMT
-			"%s: Running mpt3sas_dead_ioc thread success !!!!\n",
-			ioc->name, __func__);
+			ioc_err(ioc, "%s: Running mpt3sas_dead_ioc thread success !!!!\n",
+				__func__);
 		return; /* don't rearm timer */
 	}
 
@@ -614,8 +609,8 @@ _base_fault_reset_work(struct work_struct *work)
 
 	if ((doorbell & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL) {
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
-		pr_warn(MPT3SAS_FMT "%s: hard reset: %s\n", ioc->name,
-		    __func__, (rc == 0) ? "success" : "failed");
+		ioc_warn(ioc, "%s: hard reset: %s\n",
+			 __func__, rc == 0 ? "success" : "failed");
 		doorbell = mpt3sas_base_get_iocstate(ioc, 0);
 		if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
 			mpt3sas_base_fault_info(ioc, doorbell &
@@ -657,8 +652,7 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
 	ioc->fault_reset_work_q =
 		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
 	if (!ioc->fault_reset_work_q) {
-		pr_err(MPT3SAS_FMT "%s: failed (line=%d)\n",
-		    ioc->name, __func__, __LINE__);
+		ioc_err(ioc, "%s: failed (line=%d)\n", __func__, __LINE__);
 		return;
 	}
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
@@ -700,8 +694,7 @@ mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc , u16 fault_code)
 {
-	pr_err(MPT3SAS_FMT "fault_state(0x%04x)!\n",
-	    ioc->name, fault_code);
+	ioc_err(ioc, "fault_state(0x%04x)!\n", fault_code);
 }
 
 /**
@@ -728,8 +721,7 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
 		mpt3sas_base_fault_info(ioc , doorbell);
 	else {
 		writel(0xC0FFEE00, &ioc->chip->Doorbell);
-		pr_err(MPT3SAS_FMT "Firmware is halted due to command timeout\n",
-			ioc->name);
+		ioc_err(ioc, "Firmware is halted due to command timeout\n");
 	}
 
 	if (ioc->fwfault_debug == 2)
@@ -956,8 +948,8 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 		break;
 	}
 
-	pr_warn(MPT3SAS_FMT "ioc_status: %s(0x%04x), request(0x%p),(%s)\n",
-		ioc->name, desc, ioc_status, request_hdr, func_str);
+	ioc_warn(ioc, "ioc_status: %s(0x%04x), request(0x%p),(%s)\n",
+		 desc, ioc_status, request_hdr, func_str);
 
 	_debug_dump_mf(request_hdr, frame_sz/4);
 }
@@ -1003,9 +995,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	{
 		Mpi2EventDataSasDiscovery_t *event_data =
 		    (Mpi2EventDataSasDiscovery_t *)mpi_reply->EventData;
-		pr_info(MPT3SAS_FMT "Discovery: (%s)", ioc->name,
-		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
-		    "start" : "stop");
+		ioc_info(ioc, "Discovery: (%s)",
+			 event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED ?
+			 "start" : "stop");
 		if (event_data->DiscoveryStatus)
 			pr_cont(" discovery_status(0x%08x)",
 			    le32_to_cpu(event_data->DiscoveryStatus));
@@ -1059,14 +1051,13 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	{
 		Mpi26EventDataPCIeEnumeration_t *event_data =
 			(Mpi26EventDataPCIeEnumeration_t *)mpi_reply->EventData;
-		pr_info(MPT3SAS_FMT "PCIE Enumeration: (%s)", ioc->name,
-			   (event_data->ReasonCode ==
-				MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
-				"start" : "stop");
+		ioc_info(ioc, "PCIE Enumeration: (%s)",
+			 event_data->ReasonCode == MPI26_EVENT_PCIE_ENUM_RC_STARTED ?
+			 "start" : "stop");
 		if (event_data->EnumerationStatus)
-			pr_info("enumeration_status(0x%08x)",
-				   le32_to_cpu(event_data->EnumerationStatus));
-		pr_info("\n");
+			pr_cont("enumeration_status(0x%08x)",
+				le32_to_cpu(event_data->EnumerationStatus));
+		pr_cont("\n");
 		return;
 	}
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
@@ -1077,7 +1068,7 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	if (!desc)
 		return;
 
-	pr_info(MPT3SAS_FMT "%s\n", ioc->name, desc);
+	ioc_info(ioc, "%s\n", desc);
 }
 
 /**
@@ -1128,11 +1119,9 @@ _base_sas_log_info(struct MPT3SAS_ADAPTER *ioc , u32 log_info)
 		break;
 	}
 
-	pr_warn(MPT3SAS_FMT
-		"log_info(0x%08x): originator(%s), code(0x%02x), sub_code(0x%04x)\n",
-		ioc->name, log_info,
-	     originator_str, sas_loginfo.dw.code,
-	     sas_loginfo.dw.subcode);
+	ioc_warn(ioc, "log_info(0x%08x): originator(%s), code(0x%02x), sub_code(0x%04x)\n",
+		 log_info,
+		 originator_str, sas_loginfo.dw.code, sas_loginfo.dw.subcode);
 }
 
 /**
@@ -1152,8 +1141,8 @@ _base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (unlikely(!mpi_reply)) {
-		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
@@ -1249,9 +1238,9 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 		delayed_event_ack->EventContext = mpi_reply->EventContext;
 		list_add_tail(&delayed_event_ack->list,
 				&ioc->delayed_event_ack_list);
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				"DELAYED: EVENT ACK: event (0x%04x)\n",
-				ioc->name, le16_to_cpu(mpi_reply->Event)));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "DELAYED: EVENT ACK: event (0x%04x)\n",
+				    le16_to_cpu(mpi_reply->Event)));
 		goto out;
 	}
 
@@ -2600,9 +2589,8 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 
  out:
 	si_meminfo(&s);
-	pr_info(MPT3SAS_FMT
-		"%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
-		ioc->name, ioc->dma_mask, convert_to_kb(s.totalram));
+	ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
+		 ioc->dma_mask, convert_to_kb(s.totalram));
 
 	return 0;
 }
@@ -2641,8 +2629,7 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT "msix not supported\n",
-			ioc->name));
+		dfailprintk(ioc, ioc_info(ioc, "msix not supported\n"));
 		return -EINVAL;
 	}
 
@@ -2660,9 +2647,8 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 		pci_read_config_word(ioc->pdev, base + 2, &message_control);
 		ioc->msix_vector_count = (message_control & 0x3FF) + 1;
 	}
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"msix is supported, vector_count(%d)\n",
-		ioc->name, ioc->msix_vector_count));
+	dinitprintk(ioc, ioc_info(ioc, "msix is supported, vector_count(%d)\n",
+				  ioc->msix_vector_count));
 	return 0;
 }
 
@@ -2704,8 +2690,8 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 
 	reply_q =  kzalloc(sizeof(struct adapter_reply_queue), GFP_KERNEL);
 	if (!reply_q) {
-		pr_err(MPT3SAS_FMT "unable to allocate memory %d!\n",
-		    ioc->name, (int)sizeof(struct adapter_reply_queue));
+		ioc_err(ioc, "unable to allocate memory %zu!\n",
+			sizeof(struct adapter_reply_queue));
 		return -ENOMEM;
 	}
 	reply_q->ioc = ioc;
@@ -2763,8 +2749,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 			const cpumask_t *mask = pci_irq_get_affinity(ioc->pdev,
 							reply_q->msix_index);
 			if (!mask) {
-				pr_warn(MPT3SAS_FMT "no affinity for msi %x\n",
-					ioc->name, reply_q->msix_index);
+				ioc_warn(ioc, "no affinity for msi %x\n",
+					 reply_q->msix_index);
 				continue;
 			}
 
@@ -2859,9 +2845,9 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	r = pci_alloc_irq_vectors(ioc->pdev, 1, ioc->reply_queue_count,
 				  irq_flags);
 	if (r < 0) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"pci_alloc_irq_vectors failed (r=%d) !!!\n",
-			ioc->name, r));
+		dfailprintk(ioc,
+			    ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n",
+				     r));
 		goto try_ioapic;
 	}
 
@@ -2884,9 +2870,9 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	ioc->reply_queue_count = 1;
 	r = pci_alloc_irq_vectors(ioc->pdev, 1, 1, PCI_IRQ_LEGACY);
 	if (r < 0) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
-			ioc->name, r));
+		dfailprintk(ioc,
+			    ioc_info(ioc, "pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
+				     r));
 	} else
 		r = _base_request_irq(ioc, 0);
 
@@ -2941,13 +2927,11 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	phys_addr_t chip_phys = 0;
 	struct adapter_reply_queue *reply_q;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n",
-	    ioc->name, __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	if (pci_enable_device_mem(pdev)) {
-		pr_warn(MPT3SAS_FMT "pci_enable_device_mem: failed\n",
-			ioc->name);
+		ioc_warn(ioc, "pci_enable_device_mem: failed\n");
 		ioc->bars = 0;
 		return -ENODEV;
 	}
@@ -2955,8 +2939,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	if (pci_request_selected_regions(pdev, ioc->bars,
 	    ioc->driver_name)) {
-		pr_warn(MPT3SAS_FMT "pci_request_selected_regions: failed\n",
-			ioc->name);
+		ioc_warn(ioc, "pci_request_selected_regions: failed\n");
 		ioc->bars = 0;
 		r = -ENODEV;
 		goto out_fail;
@@ -2969,8 +2952,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 
 	if (_base_config_dma_addressing(ioc, pdev) != 0) {
-		pr_warn(MPT3SAS_FMT "no suitable DMA mask for %s\n",
-		    ioc->name, pci_name(pdev));
+		ioc_warn(ioc, "no suitable DMA mask for %s\n", pci_name(pdev));
 		r = -ENODEV;
 		goto out_fail;
 	}
@@ -2993,8 +2975,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->chip == NULL) {
-		pr_err(MPT3SAS_FMT "unable to map adapter memory! "
-			" or resource not found\n", ioc->name);
+		ioc_err(ioc, "unable to map adapter memory! or resource not found\n");
 		r = -EINVAL;
 		goto out_fail;
 	}
@@ -3060,10 +3041,10 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		    "IO-APIC enabled"),
 		    pci_irq_vector(ioc->pdev, reply_q->msix_index));
 
-	pr_info(MPT3SAS_FMT "iomem(%pap), mapped(0x%p), size(%d)\n",
-	    ioc->name, &chip_phys, ioc->chip, memap_sz);
-	pr_info(MPT3SAS_FMT "ioport(0x%016llx), size(%d)\n",
-	    ioc->name, (unsigned long long)pio_chip, pio_sz);
+	ioc_info(ioc, "iomem(%pap), mapped(0x%p), size(%d)\n",
+		 &chip_phys, ioc->chip, memap_sz);
+	ioc_info(ioc, "ioport(0x%016llx), size(%d)\n",
+		 (unsigned long long)pio_chip, pio_sz);
 
 	/* Save PCI configuration state for recovery from PCI AER/EEH errors */
 	pci_save_state(pdev);
@@ -3178,8 +3159,7 @@ mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->internal_free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		pr_err(MPT3SAS_FMT "%s: smid not available\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: smid not available\n", __func__);
 		return 0;
 	}
 
@@ -3554,89 +3534,85 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_INTEL_RMS2LL080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS2LL080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS2LL080_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS2LL040_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS2LL040_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS2LL040_BRANDING);
 				break;
 			case MPT2SAS_INTEL_SSD910_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_SSD910_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_SSD910_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
-				 ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_INTEL_RS25GB008_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RS25GB008_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RS25GB008_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25JB080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25JB080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25JB080_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25JB040_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25JB040_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25JB040_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25KB080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25KB080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25KB080_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25KB040_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25KB040_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25KB040_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25LB040_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25LB040_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25LB040_BRANDING);
 				break;
 			case MPT2SAS_INTEL_RMS25LB080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_INTEL_RMS25LB080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_INTEL_RMS25LB080_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
-				 ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_INTEL_RMS3JC080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_INTEL_RMS3JC080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_INTEL_RMS3JC080_BRANDING);
 				break;
 
 			case MPT3SAS_INTEL_RS3GC008_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_INTEL_RS3GC008_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_INTEL_RS3GC008_BRANDING);
 				break;
 			case MPT3SAS_INTEL_RS3FC044_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_INTEL_RS3FC044_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_INTEL_RS3FC044_BRANDING);
 				break;
 			case MPT3SAS_INTEL_RS3UC080_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_INTEL_RS3UC080_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_INTEL_RS3UC080_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				 "Intel(R) Controller: Subsystem ID: 0x%X\n",
-				 ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 			break;
 		default:
-			pr_info(MPT3SAS_FMT
-			 "Intel(R) Controller: Subsystem ID: 0x%X\n",
-			 ioc->name, ioc->pdev->subsystem_device);
+			ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
+				 ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
@@ -3645,57 +3621,54 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
 				break;
 			case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
 				break;
 			case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
 				break;
 			case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
 				break;
 			case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
 				break;
 			case MPT2SAS_DELL_PERC_H200_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_PERC_H200_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_PERC_H200_BRANDING);
 				break;
 			case MPT2SAS_DELL_6GBPS_SAS_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_DELL_6GBPS_SAS_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_DELL_6GBPS_SAS_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				   "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
-				   ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 			break;
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_DELL_12G_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_DELL_12G_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_DELL_12G_HBA_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				   "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
-				   ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 			break;
 		default:
-			pr_info(MPT3SAS_FMT
-			   "Dell HBA: Subsystem ID: 0x%X\n", ioc->name,
-			   ioc->pdev->subsystem_device);
+			ioc_info(ioc, "Dell HBA: Subsystem ID: 0x%X\n",
+				 ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
@@ -3704,46 +3677,42 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
 				break;
 			case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
 				break;
 			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-					MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				  "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-				  ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 			break;
 		case MPI25_MFGPAGE_DEVID_SAS3108_1:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
 				break;
 			case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING
-				);
+				ioc_info(ioc, "%s\n",
+					 MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				 "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-				 ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 			break;
 		default:
-			pr_info(MPT3SAS_FMT
-			   "Cisco SAS HBA: Subsystem ID: 0x%X\n",
-			   ioc->name, ioc->pdev->subsystem_device);
+			ioc_info(ioc, "Cisco SAS HBA: Subsystem ID: 0x%X\n",
+				 ioc->pdev->subsystem_device);
 			break;
 		}
 		break;
@@ -3752,43 +3721,40 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2004:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				   "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
-				   ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_HP_2_4_INTERNAL_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_HP_2_4_INTERNAL_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_HP_2_4_INTERNAL_BRANDING);
 				break;
 			case MPT2SAS_HP_2_4_EXTERNAL_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
 				break;
 			case MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				 MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
 				break;
 			case MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID:
-				pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				    MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
+				ioc_info(ioc, "%s\n",
+					 MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
 				break;
 			default:
-				pr_info(MPT3SAS_FMT
-				   "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
-				   ioc->name, ioc->pdev->subsystem_device);
+				ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
+					 ioc->pdev->subsystem_device);
 				break;
 			}
 		default:
-			pr_info(MPT3SAS_FMT
-			   "HP SAS HBA: Subsystem ID: 0x%X\n",
-			   ioc->name, ioc->pdev->subsystem_device);
+			ioc_info(ioc, "HP SAS HBA: Subsystem ID: 0x%X\n",
+				 ioc->pdev->subsystem_device);
 			break;
 		}
 	default:
@@ -3815,12 +3781,10 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 	u16 smid, ioc_status;
 	size_t data_length;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-				__func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	if (ioc->base_cmds.status & MPT3_CMD_PENDING) {
-		pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
-				ioc->name, __func__);
+		ioc_err(ioc, "%s: internal command already in use\n", __func__);
 		return -EAGAIN;
 	}
 
@@ -3828,15 +3792,14 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 	fwpkg_data = pci_alloc_consistent(ioc->pdev, data_length,
 			&fwpkg_data_dma);
 	if (!fwpkg_data) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-				ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -ENOMEM;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-				ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		r = -EAGAIN;
 		goto out;
 	}
@@ -3855,11 +3818,9 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 	/* Wait for 15 seconds */
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 			FW_IMG_HDR_READ_TIMEOUT*HZ);
-	pr_info(MPT3SAS_FMT "%s: complete\n",
-			ioc->name, __func__);
+	ioc_info(ioc, "%s: complete\n", __func__);
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-				ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 				sizeof(Mpi25FWUploadRequest_t)/4);
 		r = -ETIME;
@@ -3873,13 +3834,11 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 			if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 				FWImgHdr = (Mpi2FWImageHeader_t *)fwpkg_data;
 				if (FWImgHdr->PackageVersion.Word) {
-					pr_info(MPT3SAS_FMT "FW Package Version"
-					"(%02d.%02d.%02d.%02d)\n",
-					ioc->name,
-					FWImgHdr->PackageVersion.Struct.Major,
-					FWImgHdr->PackageVersion.Struct.Minor,
-					FWImgHdr->PackageVersion.Struct.Unit,
-					FWImgHdr->PackageVersion.Struct.Dev);
+					ioc_info(ioc, "FW Package Version (%02d.%02d.%02d.%02d)\n",
+						 FWImgHdr->PackageVersion.Struct.Major,
+						 FWImgHdr->PackageVersion.Struct.Minor,
+						 FWImgHdr->PackageVersion.Struct.Unit,
+						 FWImgHdr->PackageVersion.Struct.Dev);
 				}
 			} else {
 				_debug_dump_mf(&mpi_reply,
@@ -3909,18 +3868,17 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 
 	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 	strncpy(desc, ioc->manu_pg0.ChipName, 16);
-	pr_info(MPT3SAS_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "\
-	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
-	    ioc->name, desc,
-	   (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
-	   (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
-	   (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
-	   ioc->facts.FWVersion.Word & 0x000000FF,
-	   ioc->pdev->revision,
-	   (bios_version & 0xFF000000) >> 24,
-	   (bios_version & 0x00FF0000) >> 16,
-	   (bios_version & 0x0000FF00) >> 8,
-	    bios_version & 0x000000FF);
+	ioc_info(ioc, "%s: FWVersion(%02d.%02d.%02d.%02d), ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
+		 desc,
+		 (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
+		 (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
+		 (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
+		 ioc->facts.FWVersion.Word & 0x000000FF,
+		 ioc->pdev->revision,
+		 (bios_version & 0xFF000000) >> 24,
+		 (bios_version & 0x00FF0000) >> 16,
+		 (bios_version & 0x0000FF00) >> 8,
+		 bios_version & 0x000000FF);
 
 	_base_display_OEMs_branding(ioc);
 
@@ -3929,82 +3887,81 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 		i++;
 	}
 
-	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
+	ioc_info(ioc, "Protocol=(");
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
-		pr_info("Initiator");
+		pr_cont("Initiator");
 		i++;
 	}
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_TARGET) {
-		pr_info("%sTarget", i ? "," : "");
+		pr_cont("%sTarget", i ? "," : "");
 		i++;
 	}
 
 	i = 0;
-	pr_info("), ");
-	pr_info("Capabilities=(");
+	pr_cont("), Capabilities=(");
 
 	if (!ioc->hide_ir_msg) {
 		if (ioc->facts.IOCCapabilities &
 		    MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
-			pr_info("Raid");
+			pr_cont("Raid");
 			i++;
 		}
 	}
 
 	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR) {
-		pr_info("%sTLR", i ? "," : "");
+		pr_cont("%sTLR", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_MULTICAST) {
-		pr_info("%sMulticast", i ? "," : "");
+		pr_cont("%sMulticast", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities &
 	    MPI2_IOCFACTS_CAPABILITY_BIDIRECTIONAL_TARGET) {
-		pr_info("%sBIDI Target", i ? "," : "");
+		pr_cont("%sBIDI Target", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_EEDP) {
-		pr_info("%sEEDP", i ? "," : "");
+		pr_cont("%sEEDP", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities &
 	    MPI2_IOCFACTS_CAPABILITY_SNAPSHOT_BUFFER) {
-		pr_info("%sSnapshot Buffer", i ? "," : "");
+		pr_cont("%sSnapshot Buffer", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities &
 	    MPI2_IOCFACTS_CAPABILITY_DIAG_TRACE_BUFFER) {
-		pr_info("%sDiag Trace Buffer", i ? "," : "");
+		pr_cont("%sDiag Trace Buffer", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities &
 	    MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER) {
-		pr_info("%sDiag Extended Buffer", i ? "," : "");
+		pr_cont("%sDiag Extended Buffer", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->facts.IOCCapabilities &
 	    MPI2_IOCFACTS_CAPABILITY_TASK_SET_FULL_HANDLING) {
-		pr_info("%sTask Set Full", i ? "," : "");
+		pr_cont("%sTask Set Full", i ? "," : "");
 		i++;
 	}
 
 	iounit_pg1_flags = le32_to_cpu(ioc->iounit_pg1.Flags);
 	if (!(iounit_pg1_flags & MPI2_IOUNITPAGE1_NATIVE_COMMAND_Q_DISABLE)) {
-		pr_info("%sNCQ", i ? "," : "");
+		pr_cont("%sNCQ", i ? "," : "");
 		i++;
 	}
 
-	pr_info(")\n");
+	pr_cont(")\n");
 }
 
 /**
@@ -4037,21 +3994,21 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 	    sizeof(Mpi2SasIOUnit1PhyData_t));
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
 	    sas_iounit_pg1, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 
@@ -4083,11 +4040,11 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 		else
 			dmd_new =
 		    dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
-		pr_info(MPT3SAS_FMT "device_missing_delay: old(%d), new(%d)\n",
-			ioc->name, dmd_orignal, dmd_new);
-		pr_info(MPT3SAS_FMT "ioc_missing_delay: old(%d), new(%d)\n",
-			ioc->name, io_missing_delay_original,
-		    io_missing_delay);
+		ioc_info(ioc, "device_missing_delay: old(%d), new(%d)\n",
+			 dmd_orignal, dmd_new);
+		ioc_info(ioc, "ioc_missing_delay: old(%d), new(%d)\n",
+			 io_missing_delay_original,
+			 io_missing_delay);
 		ioc->device_missing_delay = dmd_new;
 		ioc->io_missing_delay = io_missing_delay;
 	}
@@ -4198,33 +4155,32 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	struct chain_tracker *ct;
 	struct reply_post_struct *rps;
 
-	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	if (ioc->request) {
 		pci_free_consistent(ioc->pdev, ioc->request_dma_sz,
 		    ioc->request,  ioc->request_dma);
-		dexitprintk(ioc, pr_info(MPT3SAS_FMT
-			"request_pool(0x%p): free\n",
-			ioc->name, ioc->request));
+		dexitprintk(ioc,
+			    ioc_info(ioc, "request_pool(0x%p): free\n",
+				     ioc->request));
 		ioc->request = NULL;
 	}
 
 	if (ioc->sense) {
 		dma_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
 		dma_pool_destroy(ioc->sense_dma_pool);
-		dexitprintk(ioc, pr_info(MPT3SAS_FMT
-			"sense_pool(0x%p): free\n",
-			ioc->name, ioc->sense));
+		dexitprintk(ioc,
+			    ioc_info(ioc, "sense_pool(0x%p): free\n",
+				     ioc->sense));
 		ioc->sense = NULL;
 	}
 
 	if (ioc->reply) {
 		dma_pool_free(ioc->reply_dma_pool, ioc->reply, ioc->reply_dma);
 		dma_pool_destroy(ioc->reply_dma_pool);
-		dexitprintk(ioc, pr_info(MPT3SAS_FMT
-			"reply_pool(0x%p): free\n",
-			ioc->name, ioc->reply));
+		dexitprintk(ioc,
+			    ioc_info(ioc, "reply_pool(0x%p): free\n",
+				     ioc->reply));
 		ioc->reply = NULL;
 	}
 
@@ -4232,9 +4188,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		dma_pool_free(ioc->reply_free_dma_pool, ioc->reply_free,
 		    ioc->reply_free_dma);
 		dma_pool_destroy(ioc->reply_free_dma_pool);
-		dexitprintk(ioc, pr_info(MPT3SAS_FMT
-			"reply_free_pool(0x%p): free\n",
-			ioc->name, ioc->reply_free));
+		dexitprintk(ioc,
+			    ioc_info(ioc, "reply_free_pool(0x%p): free\n",
+				     ioc->reply_free));
 		ioc->reply_free = NULL;
 	}
 
@@ -4246,9 +4202,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				    ioc->reply_post_free_dma_pool,
 				    rps->reply_post_free,
 				    rps->reply_post_free_dma);
-				dexitprintk(ioc, pr_info(MPT3SAS_FMT
-				    "reply_post_free_pool(0x%p): free\n",
-				    ioc->name, rps->reply_post_free));
+				dexitprintk(ioc,
+					    ioc_info(ioc, "reply_post_free_pool(0x%p): free\n",
+						     rps->reply_post_free));
 				rps->reply_post_free = NULL;
 			}
 		} while (ioc->rdpq_array_enable &&
@@ -4276,9 +4232,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->config_page) {
-		dexitprintk(ioc, pr_info(MPT3SAS_FMT
-		    "config_page(0x%p): free\n", ioc->name,
-		    ioc->config_page));
+		dexitprintk(ioc,
+			    ioc_info(ioc, "config_page(0x%p): free\n",
+				     ioc->config_page));
 		pci_free_consistent(ioc->pdev, ioc->config_page_sz,
 		    ioc->config_page, ioc->config_page_dma);
 	}
@@ -4349,8 +4305,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	int i, j;
 	struct chain_tracker *ct;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 
 	retry_sz = 0;
@@ -4379,10 +4334,8 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
 			sg_tablesize = min_t(unsigned short, sg_tablesize,
 					SG_MAX_SEGMENTS);
-			pr_warn(MPT3SAS_FMT
-				"sg_tablesize(%u) is bigger than kernel "
-				"defined SG_CHUNK_SIZE(%u)\n", ioc->name,
-				sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
+			ioc_warn(ioc, "sg_tablesize(%u) is bigger than kernel defined SG_CHUNK_SIZE(%u)\n",
+				 sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
 		}
 		ioc->shost->sg_tablesize = sg_tablesize;
 	}
@@ -4392,9 +4345,8 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->internal_depth < INTERNAL_CMDS_COUNT) {
 		if (facts->RequestCredit <= (INTERNAL_CMDS_COUNT +
 				INTERNAL_SCSIIO_CMDS_COUNT)) {
-			pr_err(MPT3SAS_FMT "IOC doesn't have enough Request \
-			    Credits, it has just %d number of credits\n",
-			    ioc->name, facts->RequestCredit);
+			ioc_err(ioc, "IOC doesn't have enough Request Credits, it has just %d number of credits\n",
+				facts->RequestCredit);
 			return -ENOMEM;
 		}
 		ioc->internal_depth = 10;
@@ -4493,11 +4445,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 	}
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "scatter gather: " \
-	    "sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), "
-	    "chains_per_io(%d)\n", ioc->name, ioc->max_sges_in_main_message,
-	    ioc->max_sges_in_chain_message, ioc->shost->sg_tablesize,
-	    ioc->chains_needed_per_io));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "scatter gather: sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), chains_per_io(%d)\n",
+			     ioc->max_sges_in_main_message,
+			     ioc->max_sges_in_chain_message,
+			     ioc->shost->sg_tablesize,
+			     ioc->chains_needed_per_io));
 
 	/* reply post queue, 16 byte align */
 	reply_post_free_sz = ioc->reply_post_queue_depth *
@@ -4512,16 +4465,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	    sizeof(struct reply_post_struct), GFP_KERNEL);
 
 	if (!ioc->reply_post) {
-		pr_err(MPT3SAS_FMT "reply_post_free pool: kcalloc failed\n",
-			ioc->name);
+		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
 		goto out;
 	}
 	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
 	    &ioc->pdev->dev, sz, 16, 0);
 	if (!ioc->reply_post_free_dma_pool) {
-		pr_err(MPT3SAS_FMT
-		 "reply_post_free pool: dma_pool_create failed\n",
-		 ioc->name);
+		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
 		goto out;
 	}
 	i = 0;
@@ -4531,29 +4481,25 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    GFP_KERNEL,
 		    &ioc->reply_post[i].reply_post_free_dma);
 		if (!ioc->reply_post[i].reply_post_free) {
-			pr_err(MPT3SAS_FMT
-			"reply_post_free pool: dma_pool_alloc failed\n",
-			ioc->name);
+			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
 			goto out;
 		}
 		memset(ioc->reply_post[i].reply_post_free, 0, sz);
-		dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		    "reply post free pool (0x%p): depth(%d),"
-		    "element_size(%d), pool_size(%d kB)\n", ioc->name,
-		    ioc->reply_post[i].reply_post_free,
-		    ioc->reply_post_queue_depth, 8, sz/1024));
-		dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		    "reply_post_free_dma = (0x%llx)\n", ioc->name,
-		    (unsigned long long)
-		    ioc->reply_post[i].reply_post_free_dma));
+		dinitprintk(ioc,
+			    ioc_info(ioc, "reply post free pool (0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
+				     ioc->reply_post[i].reply_post_free,
+				     ioc->reply_post_queue_depth,
+				     8, sz / 1024));
+		dinitprintk(ioc,
+			    ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
+				     (u64)ioc->reply_post[i].reply_post_free_dma));
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
 	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
-			pr_warn(MPT3SAS_FMT
-			    "no suitable consistent DMA mask for %s\n",
-			    ioc->name, pci_name(ioc->pdev));
+			ioc_warn(ioc, "no suitable consistent DMA mask for %s\n",
+				 pci_name(ioc->pdev));
 			goto out;
 		}
 	}
@@ -4565,9 +4511,9 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	 * with some internal commands that could be outstanding
 	 */
 	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"scsi host: can_queue depth (%d)\n",
-		ioc->name, ioc->shost->can_queue));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "scsi host: can_queue depth (%d)\n",
+			     ioc->shost->can_queue));
 
 
 	/* contiguous pool for request and chains, 16 byte align, one extra "
@@ -4585,10 +4531,9 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->request_dma_sz = sz;
 	ioc->request = pci_alloc_consistent(ioc->pdev, sz, &ioc->request_dma);
 	if (!ioc->request) {
-		pr_err(MPT3SAS_FMT "request pool: pci_alloc_consistent " \
-		    "failed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kB)\n", ioc->name, ioc->hba_queue_depth,
-		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
+		ioc_err(ioc, "request pool: pci_alloc_consistent failed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kB)\n",
+			ioc->hba_queue_depth, ioc->chains_needed_per_io,
+			ioc->request_sz, sz / 1024);
 		if (ioc->scsiio_depth < MPT3SAS_SAS_QUEUE_DEPTH)
 			goto out;
 		retry_sz = 64;
@@ -4598,10 +4543,9 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (retry_sz)
-		pr_err(MPT3SAS_FMT "request pool: pci_alloc_consistent " \
-		    "succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kb)\n", ioc->name, ioc->hba_queue_depth,
-		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
+		ioc_err(ioc, "request pool: pci_alloc_consistent succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kb)\n",
+			ioc->hba_queue_depth, ioc->chains_needed_per_io,
+			ioc->request_sz, sz / 1024);
 
 	/* hi-priority queue */
 	ioc->hi_priority = ioc->request + ((ioc->scsiio_depth + 1) *
@@ -4615,24 +4559,26 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->internal_dma = ioc->hi_priority_dma + (ioc->hi_priority_depth *
 	    ioc->request_sz);
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"request pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
-		ioc->name, ioc->request, ioc->hba_queue_depth, ioc->request_sz,
-	    (ioc->hba_queue_depth * ioc->request_sz)/1024));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "request pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
+			     ioc->request, ioc->hba_queue_depth,
+			     ioc->request_sz,
+			     (ioc->hba_queue_depth * ioc->request_sz) / 1024));
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "request pool: dma(0x%llx)\n",
-	    ioc->name, (unsigned long long) ioc->request_dma));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "request pool: dma(0x%llx)\n",
+			     (unsigned long long)ioc->request_dma));
 	total_sz += sz;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "scsiio(0x%p): depth(%d)\n",
-		ioc->name, ioc->request, ioc->scsiio_depth));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "scsiio(0x%p): depth(%d)\n",
+			     ioc->request, ioc->scsiio_depth));
 
 	ioc->chain_depth = min_t(u32, ioc->chain_depth, MAX_CHAIN_DEPTH);
 	sz = ioc->scsiio_depth * sizeof(struct chain_lookup);
 	ioc->chain_lookup = kzalloc(sz, GFP_KERNEL);
 	if (!ioc->chain_lookup) {
-		pr_err(MPT3SAS_FMT "chain_lookup: __get_free_pages "
-				"failed\n", ioc->name);
+		ioc_err(ioc, "chain_lookup: __get_free_pages failed\n");
 		goto out;
 	}
 
@@ -4640,8 +4586,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0; i < ioc->scsiio_depth; i++) {
 		ioc->chain_lookup[i].chains_per_smid = kzalloc(sz, GFP_KERNEL);
 		if (!ioc->chain_lookup[i].chains_per_smid) {
-			pr_err(MPT3SAS_FMT "chain_lookup: "
-					" kzalloc failed\n", ioc->name);
+			ioc_err(ioc, "chain_lookup: kzalloc failed\n");
 			goto out;
 		}
 	}
@@ -4650,29 +4595,27 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
 	if (!ioc->hpr_lookup) {
-		pr_err(MPT3SAS_FMT "hpr_lookup: kcalloc failed\n",
-		    ioc->name);
+		ioc_err(ioc, "hpr_lookup: kcalloc failed\n");
 		goto out;
 	}
 	ioc->hi_priority_smid = ioc->scsiio_depth + 1;
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"hi_priority(0x%p): depth(%d), start smid(%d)\n",
-		ioc->name, ioc->hi_priority,
-	    ioc->hi_priority_depth, ioc->hi_priority_smid));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "hi_priority(0x%p): depth(%d), start smid(%d)\n",
+			     ioc->hi_priority,
+			     ioc->hi_priority_depth, ioc->hi_priority_smid));
 
 	/* initialize internal queue smid's */
 	ioc->internal_lookup = kcalloc(ioc->internal_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
 	if (!ioc->internal_lookup) {
-		pr_err(MPT3SAS_FMT "internal_lookup: kcalloc failed\n",
-		    ioc->name);
+		ioc_err(ioc, "internal_lookup: kcalloc failed\n");
 		goto out;
 	}
 	ioc->internal_smid = ioc->hi_priority_smid + ioc->hi_priority_depth;
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"internal(0x%p): depth(%d), start smid(%d)\n",
-		ioc->name, ioc->internal,
-	    ioc->internal_depth, ioc->internal_smid));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "internal(0x%p): depth(%d), start smid(%d)\n",
+			     ioc->internal,
+			     ioc->internal_depth, ioc->internal_smid));
 	/*
 	 * The number of NVMe page sized blocks needed is:
 	 *     (((sg_tablesize * 8) - 1) / (page_size - 8)) + 1
@@ -4696,17 +4639,14 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		sz = sizeof(struct pcie_sg_list) * ioc->scsiio_depth;
 		ioc->pcie_sg_lookup = kzalloc(sz, GFP_KERNEL);
 		if (!ioc->pcie_sg_lookup) {
-			pr_info(MPT3SAS_FMT
-			    "PCIe SGL lookup: kzalloc failed\n", ioc->name);
+			ioc_info(ioc, "PCIe SGL lookup: kzalloc failed\n");
 			goto out;
 		}
 		sz = nvme_blocks_needed * ioc->page_size;
 		ioc->pcie_sgl_dma_pool =
 			dma_pool_create("PCIe SGL pool", &ioc->pdev->dev, sz, 16, 0);
 		if (!ioc->pcie_sgl_dma_pool) {
-			pr_info(MPT3SAS_FMT
-			    "PCIe SGL pool: dma_pool_create failed\n",
-			    ioc->name);
+			ioc_info(ioc, "PCIe SGL pool: dma_pool_create failed\n");
 			goto out;
 		}
 
@@ -4719,9 +4659,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				ioc->pcie_sgl_dma_pool, GFP_KERNEL,
 				&ioc->pcie_sg_lookup[i].pcie_sgl_dma);
 			if (!ioc->pcie_sg_lookup[i].pcie_sgl) {
-				pr_info(MPT3SAS_FMT
-				    "PCIe SGL pool: dma_pool_alloc failed\n",
-				    ioc->name);
+				ioc_info(ioc, "PCIe SGL pool: dma_pool_alloc failed\n");
 				goto out;
 			}
 			for (j = 0; j < ioc->chains_per_prp_buffer; j++) {
@@ -4735,20 +4673,20 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			}
 		}
 
-		dinitprintk(ioc, pr_info(MPT3SAS_FMT "PCIe sgl pool depth(%d), "
-			"element_size(%d), pool_size(%d kB)\n", ioc->name,
-			ioc->scsiio_depth, sz, (sz * ioc->scsiio_depth)/1024));
-		dinitprintk(ioc, pr_info(MPT3SAS_FMT "Number of chains can "
-		    "fit in a PRP page(%d)\n", ioc->name,
-		    ioc->chains_per_prp_buffer));
+		dinitprintk(ioc,
+			    ioc_info(ioc, "PCIe sgl pool depth(%d), element_size(%d), pool_size(%d kB)\n",
+				     ioc->scsiio_depth, sz,
+				     (sz * ioc->scsiio_depth) / 1024));
+		dinitprintk(ioc,
+			    ioc_info(ioc, "Number of chains can fit in a PRP page(%d)\n",
+				     ioc->chains_per_prp_buffer));
 		total_sz += sz * ioc->scsiio_depth;
 	}
 
 	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
 	    ioc->chain_segment_sz, 16, 0);
 	if (!ioc->chain_dma_pool) {
-		pr_err(MPT3SAS_FMT "chain_dma_pool: dma_pool_create failed\n",
-			ioc->name);
+		ioc_err(ioc, "chain_dma_pool: dma_pool_create failed\n");
 		goto out;
 	}
 	for (i = 0; i < ioc->scsiio_depth; i++) {
@@ -4759,8 +4697,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 					ioc->chain_dma_pool, GFP_KERNEL,
 					&ct->chain_buffer_dma);
 			if (!ct->chain_buffer) {
-				pr_err(MPT3SAS_FMT "chain_lookup: "
-				" pci_pool_alloc failed\n", ioc->name);
+				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
 				_base_release_memory_pools(ioc);
 				goto out;
 			}
@@ -4768,25 +4705,23 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		total_sz += ioc->chain_segment_sz;
 	}
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
-		ioc->name, ioc->chain_depth, ioc->chain_segment_sz,
-		((ioc->chain_depth *  ioc->chain_segment_sz))/1024));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
+			     ioc->chain_depth, ioc->chain_segment_sz,
+			     (ioc->chain_depth * ioc->chain_segment_sz) / 1024));
 
 	/* sense buffers, 4 byte align */
 	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
 	ioc->sense_dma_pool = dma_pool_create("sense pool", &ioc->pdev->dev, sz,
 					      4, 0);
 	if (!ioc->sense_dma_pool) {
-		pr_err(MPT3SAS_FMT "sense pool: dma_pool_create failed\n",
-		    ioc->name);
+		ioc_err(ioc, "sense pool: dma_pool_create failed\n");
 		goto out;
 	}
 	ioc->sense = dma_pool_alloc(ioc->sense_dma_pool, GFP_KERNEL,
 	    &ioc->sense_dma);
 	if (!ioc->sense) {
-		pr_err(MPT3SAS_FMT "sense pool: dma_pool_alloc failed\n",
-		    ioc->name);
+		ioc_err(ioc, "sense pool: dma_pool_alloc failed\n");
 		goto out;
 	}
 	/* sense buffer requires to be in same 4 gb region.
@@ -4808,24 +4743,23 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			dma_pool_create("sense pool", &ioc->pdev->dev, sz,
 						roundup_pow_of_two(sz), 0);
 		if (!ioc->sense_dma_pool) {
-			pr_err(MPT3SAS_FMT "sense pool: pci_pool_create failed\n",
-					ioc->name);
+			ioc_err(ioc, "sense pool: pci_pool_create failed\n");
 			goto out;
 		}
 		ioc->sense = dma_pool_alloc(ioc->sense_dma_pool, GFP_KERNEL,
 				&ioc->sense_dma);
 		if (!ioc->sense) {
-			pr_err(MPT3SAS_FMT "sense pool: pci_pool_alloc failed\n",
-					ioc->name);
+			ioc_err(ioc, "sense pool: pci_pool_alloc failed\n");
 			goto out;
 		}
 	}
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-	    "sense pool(0x%p): depth(%d), element_size(%d), pool_size"
-	    "(%d kB)\n", ioc->name, ioc->sense, ioc->scsiio_depth,
-	    SCSI_SENSE_BUFFERSIZE, sz/1024));
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "sense_dma(0x%llx)\n",
-	    ioc->name, (unsigned long long)ioc->sense_dma));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "sense pool(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
+			     ioc->sense, ioc->scsiio_depth,
+			     SCSI_SENSE_BUFFERSIZE, sz / 1024));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "sense_dma(0x%llx)\n",
+			     (unsigned long long)ioc->sense_dma));
 	total_sz += sz;
 
 	/* reply pool, 4 byte align */
@@ -4833,25 +4767,24 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->reply_dma_pool = dma_pool_create("reply pool", &ioc->pdev->dev, sz,
 					      4, 0);
 	if (!ioc->reply_dma_pool) {
-		pr_err(MPT3SAS_FMT "reply pool: dma_pool_create failed\n",
-		    ioc->name);
+		ioc_err(ioc, "reply pool: dma_pool_create failed\n");
 		goto out;
 	}
 	ioc->reply = dma_pool_alloc(ioc->reply_dma_pool, GFP_KERNEL,
 	    &ioc->reply_dma);
 	if (!ioc->reply) {
-		pr_err(MPT3SAS_FMT "reply pool: dma_pool_alloc failed\n",
-		    ioc->name);
+		ioc_err(ioc, "reply pool: dma_pool_alloc failed\n");
 		goto out;
 	}
 	ioc->reply_dma_min_address = (u32)(ioc->reply_dma);
 	ioc->reply_dma_max_address = (u32)(ioc->reply_dma) + sz;
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"reply pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
-		ioc->name, ioc->reply,
-	    ioc->reply_free_queue_depth, ioc->reply_sz, sz/1024));
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "reply_dma(0x%llx)\n",
-	    ioc->name, (unsigned long long)ioc->reply_dma));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "reply pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
+			     ioc->reply, ioc->reply_free_queue_depth,
+			     ioc->reply_sz, sz / 1024));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "reply_dma(0x%llx)\n",
+			     (unsigned long long)ioc->reply_dma));
 	total_sz += sz;
 
 	/* reply free queue, 16 byte align */
@@ -4859,24 +4792,23 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->reply_free_dma_pool = dma_pool_create("reply_free pool",
 	    &ioc->pdev->dev, sz, 16, 0);
 	if (!ioc->reply_free_dma_pool) {
-		pr_err(MPT3SAS_FMT "reply_free pool: dma_pool_create failed\n",
-			ioc->name);
+		ioc_err(ioc, "reply_free pool: dma_pool_create failed\n");
 		goto out;
 	}
 	ioc->reply_free = dma_pool_alloc(ioc->reply_free_dma_pool, GFP_KERNEL,
 	    &ioc->reply_free_dma);
 	if (!ioc->reply_free) {
-		pr_err(MPT3SAS_FMT "reply_free pool: dma_pool_alloc failed\n",
-			ioc->name);
+		ioc_err(ioc, "reply_free pool: dma_pool_alloc failed\n");
 		goto out;
 	}
 	memset(ioc->reply_free, 0, sz);
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "reply_free pool(0x%p): " \
-	    "depth(%d), element_size(%d), pool_size(%d kB)\n", ioc->name,
-	    ioc->reply_free, ioc->reply_free_queue_depth, 4, sz/1024));
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"reply_free_dma (0x%llx)\n",
-		ioc->name, (unsigned long long)ioc->reply_free_dma));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "reply_free pool(0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
+			     ioc->reply_free, ioc->reply_free_queue_depth,
+			     4, sz / 1024));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "reply_free_dma (0x%llx)\n",
+			     (unsigned long long)ioc->reply_free_dma));
 	total_sz += sz;
 
 	if (ioc->rdpq_array_enable) {
@@ -4887,8 +4819,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    &ioc->pdev->dev, reply_post_free_array_sz, 16, 0);
 		if (!ioc->reply_post_free_array_dma_pool) {
 			dinitprintk(ioc,
-			    pr_info(MPT3SAS_FMT "reply_post_free_array pool: "
-			    "dma_pool_create failed\n", ioc->name));
+				    ioc_info(ioc, "reply_post_free_array pool: dma_pool_create failed\n"));
 			goto out;
 		}
 		ioc->reply_post_free_array =
@@ -4896,8 +4827,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    GFP_KERNEL, &ioc->reply_post_free_array_dma);
 		if (!ioc->reply_post_free_array) {
 			dinitprintk(ioc,
-			    pr_info(MPT3SAS_FMT "reply_post_free_array pool: "
-			    "dma_pool_alloc failed\n", ioc->name));
+				    ioc_info(ioc, "reply_post_free_array pool: dma_pool_alloc failed\n"));
 			goto out;
 		}
 	}
@@ -4905,25 +4835,23 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->config_page = pci_alloc_consistent(ioc->pdev,
 	    ioc->config_page_sz, &ioc->config_page_dma);
 	if (!ioc->config_page) {
-		pr_err(MPT3SAS_FMT
-			"config page: dma_pool_alloc failed\n",
-			ioc->name);
+		ioc_err(ioc, "config page: dma_pool_alloc failed\n");
 		goto out;
 	}
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"config page(0x%p): size(%d)\n",
-		ioc->name, ioc->config_page, ioc->config_page_sz));
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "config_page_dma(0x%llx)\n",
-		ioc->name, (unsigned long long)ioc->config_page_dma));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "config page(0x%p): size(%d)\n",
+			     ioc->config_page, ioc->config_page_sz));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "config_page_dma(0x%llx)\n",
+			     (unsigned long long)ioc->config_page_dma));
 	total_sz += ioc->config_page_sz;
 
-	pr_info(MPT3SAS_FMT "Allocated physical memory: size(%d kB)\n",
-	    ioc->name, total_sz/1024);
-	pr_info(MPT3SAS_FMT
-		"Current Controller Queue Depth(%d),Max Controller Queue Depth(%d)\n",
-	    ioc->name, ioc->shost->can_queue, facts->RequestCredit);
-	pr_info(MPT3SAS_FMT "Scatter Gather Elements per IO(%d)\n",
-	    ioc->name, ioc->shost->sg_tablesize);
+	ioc_info(ioc, "Allocated physical memory: size(%d kB)\n",
+		 total_sz / 1024);
+	ioc_info(ioc, "Current Controller Queue Depth(%d),Max Controller Queue Depth(%d)\n",
+		 ioc->shost->can_queue, facts->RequestCredit);
+	ioc_info(ioc, "Scatter Gather Elements per IO(%d)\n",
+		 ioc->shost->sg_tablesize);
 	return 0;
 
  out:
@@ -5001,9 +4929,9 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
-			dhsprintk(ioc, pr_info(MPT3SAS_FMT
-				"%s: successful count(%d), timeout(%d)\n",
-				ioc->name, __func__, count, timeout));
+			dhsprintk(ioc,
+				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
+					   __func__, count, timeout));
 			return 0;
 		}
 
@@ -5011,9 +4939,8 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 		count++;
 	} while (--cntdn);
 
-	pr_err(MPT3SAS_FMT
-		"%s: failed due to timeout count(%d), int_status(%x)!\n",
-		ioc->name, __func__, count, int_status);
+	ioc_err(ioc, "%s: failed due to timeout count(%d), int_status(%x)!\n",
+		__func__, count, int_status);
 	return -EFAULT;
 }
 
@@ -5028,9 +4955,9 @@ _base_spin_on_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
-			dhsprintk(ioc, pr_info(MPT3SAS_FMT
-				"%s: successful count(%d), timeout(%d)\n",
-				ioc->name, __func__, count, timeout));
+			dhsprintk(ioc,
+				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
+					   __func__, count, timeout));
 			return 0;
 		}
 
@@ -5038,9 +4965,8 @@ _base_spin_on_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 		count++;
 	} while (--cntdn);
 
-	pr_err(MPT3SAS_FMT
-		"%s: failed due to timeout count(%d), int_status(%x)!\n",
-		ioc->name, __func__, count, int_status);
+	ioc_err(ioc, "%s: failed due to timeout count(%d), int_status(%x)!\n",
+		__func__, count, int_status);
 	return -EFAULT;
 
 }
@@ -5067,9 +4993,9 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
-			dhsprintk(ioc, pr_info(MPT3SAS_FMT
-				"%s: successful count(%d), timeout(%d)\n",
-				ioc->name, __func__, count, timeout));
+			dhsprintk(ioc,
+				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
+					   __func__, count, timeout));
 			return 0;
 		} else if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
 			doorbell = readl(&ioc->chip->Doorbell);
@@ -5086,9 +5012,8 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	} while (--cntdn);
 
  out:
-	pr_err(MPT3SAS_FMT
-	 "%s: failed due to timeout count(%d), int_status(%x)!\n",
-	 ioc->name, __func__, count, int_status);
+	ioc_err(ioc, "%s: failed due to timeout count(%d), int_status(%x)!\n",
+		__func__, count, int_status);
 	return -EFAULT;
 }
 
@@ -5110,9 +5035,9 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	do {
 		doorbell_reg = readl(&ioc->chip->Doorbell);
 		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
-			dhsprintk(ioc, pr_info(MPT3SAS_FMT
-				"%s: successful count(%d), timeout(%d)\n",
-				ioc->name, __func__, count, timeout));
+			dhsprintk(ioc,
+				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
+					   __func__, count, timeout));
 			return 0;
 		}
 
@@ -5120,9 +5045,8 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int timeout)
 		count++;
 	} while (--cntdn);
 
-	pr_err(MPT3SAS_FMT
-		"%s: failed due to timeout count(%d), doorbell_reg(%x)!\n",
-		ioc->name, __func__, count, doorbell_reg);
+	ioc_err(ioc, "%s: failed due to timeout count(%d), doorbell_reg(%x)!\n",
+		__func__, count, doorbell_reg);
 	return -EFAULT;
 }
 
@@ -5141,8 +5065,7 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 	int r = 0;
 
 	if (reset_type != MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET) {
-		pr_err(MPT3SAS_FMT "%s: unknown reset_type\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: unknown reset_type\n", __func__);
 		return -EFAULT;
 	}
 
@@ -5150,7 +5073,7 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 	   MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY))
 		return -EFAULT;
 
-	pr_info(MPT3SAS_FMT "sending message unit reset !!\n", ioc->name);
+	ioc_info(ioc, "sending message unit reset !!\n");
 
 	writel(reset_type << MPI2_DOORBELL_FUNCTION_SHIFT,
 	    &ioc->chip->Doorbell);
@@ -5160,15 +5083,14 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 	}
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, timeout);
 	if (ioc_state) {
-		pr_err(MPT3SAS_FMT
-			"%s: failed going to ready state (ioc_state=0x%x)\n",
-			ioc->name, __func__, ioc_state);
+		ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
+			__func__, ioc_state);
 		r = -EFAULT;
 		goto out;
 	}
  out:
-	pr_info(MPT3SAS_FMT "message unit reset: %s\n",
-	    ioc->name, ((r == 0) ? "SUCCESS" : "FAILED"));
+	ioc_info(ioc, "message unit reset: %s\n",
+		 r == 0 ? "SUCCESS" : "FAILED");
 	return r;
 }
 
@@ -5194,9 +5116,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 
 	/* make sure doorbell is not in use */
 	if ((readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
-		pr_err(MPT3SAS_FMT
-			"doorbell is in use (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
 		return -EFAULT;
 	}
 
@@ -5211,17 +5131,15 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	    &ioc->chip->Doorbell);
 
 	if ((_base_spin_on_doorbell_int(ioc, 5))) {
-		pr_err(MPT3SAS_FMT
-			"doorbell handshake int failed (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell handshake int failed (line=%d)\n",
+			__LINE__);
 		return -EFAULT;
 	}
 	writel(0, &ioc->chip->HostInterruptStatus);
 
 	if ((_base_wait_for_doorbell_ack(ioc, 5))) {
-		pr_err(MPT3SAS_FMT
-			"doorbell handshake ack failed (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell handshake ack failed (line=%d)\n",
+			__LINE__);
 		return -EFAULT;
 	}
 
@@ -5233,17 +5151,15 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	}
 
 	if (failed) {
-		pr_err(MPT3SAS_FMT
-			"doorbell handshake sending request failed (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell handshake sending request failed (line=%d)\n",
+			__LINE__);
 		return -EFAULT;
 	}
 
 	/* now wait for the reply */
 	if ((_base_wait_for_doorbell_int(ioc, timeout))) {
-		pr_err(MPT3SAS_FMT
-			"doorbell handshake int failed (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell handshake int failed (line=%d)\n",
+			__LINE__);
 		return -EFAULT;
 	}
 
@@ -5252,9 +5168,8 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
-		pr_err(MPT3SAS_FMT
-			"doorbell handshake int failed (line=%d)\n",
-			ioc->name, __LINE__);
+		ioc_err(ioc, "doorbell handshake int failed (line=%d)\n",
+			__LINE__);
 		return -EFAULT;
 	}
 	reply[1] = le16_to_cpu(readl(&ioc->chip->Doorbell)
@@ -5263,9 +5178,8 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 
 	for (i = 2; i < default_reply->MsgLength * 2; i++)  {
 		if ((_base_wait_for_doorbell_int(ioc, 5))) {
-			pr_err(MPT3SAS_FMT
-				"doorbell handshake int failed (line=%d)\n",
-				ioc->name, __LINE__);
+			ioc_err(ioc, "doorbell handshake int failed (line=%d)\n",
+				__LINE__);
 			return -EFAULT;
 		}
 		if (i >=  reply_bytes/2) /* overflow case */
@@ -5278,8 +5192,9 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 
 	_base_wait_for_doorbell_int(ioc, 5);
 	if (_base_wait_for_doorbell_not_used(ioc, 5) != 0) {
-		dhsprintk(ioc, pr_info(MPT3SAS_FMT
-			"doorbell is in use (line=%d)\n", ioc->name, __LINE__));
+		dhsprintk(ioc,
+			  ioc_info(ioc, "doorbell is in use (line=%d)\n",
+				   __LINE__));
 	}
 	writel(0, &ioc->chip->HostInterruptStatus);
 
@@ -5319,14 +5234,12 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	void *request;
 	u16 wait_state_count;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	mutex_lock(&ioc->base_cmds.mutex);
 
 	if (ioc->base_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: base_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: base_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -5335,23 +5248,20 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -5419,14 +5329,12 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	void *request;
 	u16 wait_state_count;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	mutex_lock(&ioc->base_cmds.mutex);
 
 	if (ioc->base_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: base_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: base_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -5435,24 +5343,20 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name,
-		    __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -5506,8 +5410,7 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port)
 	struct mpt3sas_port_facts *pfacts;
 	int mpi_reply_sz, mpi_request_sz, r;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	mpi_reply_sz = sizeof(Mpi2PortFactsReply_t);
 	mpi_request_sz = sizeof(Mpi2PortFactsRequest_t);
@@ -5518,8 +5421,7 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port)
 	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5);
 
 	if (r != 0) {
-		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-		    ioc->name, __func__, r);
+		ioc_err(ioc, "%s: handshake failed (r=%d)\n", __func__, r);
 		return r;
 	}
 
@@ -5603,8 +5505,7 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	struct mpt3sas_facts *facts;
 	int mpi_reply_sz, mpi_request_sz, r;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	r = _base_wait_for_iocstate(ioc, 10);
 	if (r) {
@@ -5621,8 +5522,7 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	    (u32 *)&mpi_request, mpi_reply_sz, (u16 *)&mpi_reply, 5);
 
 	if (r != 0) {
-		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-		    ioc->name, __func__, r);
+		ioc_err(ioc, "%s: handshake failed (r=%d)\n", __func__, r);
 		return r;
 	}
 
@@ -5674,20 +5574,20 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	 */
 	ioc->page_size = 1 << facts->CurrentHostPageSize;
 	if (ioc->page_size == 1) {
-		pr_info(MPT3SAS_FMT "CurrentHostPageSize is 0: Setting "
-			"default host page size to 4k\n", ioc->name);
+		ioc_info(ioc, "CurrentHostPageSize is 0: Setting default host page size to 4k\n");
 		ioc->page_size = 1 << MPT3SAS_HOST_PAGE_SIZE_4K;
 	}
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "CurrentHostPageSize(%d)\n",
-		ioc->name, facts->CurrentHostPageSize));
-
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"hba queue depth(%d), max chains per io(%d)\n",
-		ioc->name, facts->RequestCredit,
-	    facts->MaxChainDepth));
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"request frame size(%d), reply frame size(%d)\n", ioc->name,
-	    facts->IOCRequestFrameSize * 4, facts->ReplyFrameSize * 4));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "CurrentHostPageSize(%d)\n",
+			     facts->CurrentHostPageSize));
+
+	dinitprintk(ioc,
+		    ioc_info(ioc, "hba queue depth(%d), max chains per io(%d)\n",
+			     facts->RequestCredit, facts->MaxChainDepth));
+	dinitprintk(ioc,
+		    ioc_info(ioc, "request frame size(%d), reply frame size(%d)\n",
+			     facts->IOCRequestFrameSize * 4,
+			     facts->ReplyFrameSize * 4));
 	return 0;
 }
 
@@ -5707,8 +5607,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 	u16 ioc_status;
 	u32 reply_post_free_array_sz = 0;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	memset(&mpi_request, 0, sizeof(Mpi2IOCInitRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_IOC_INIT;
@@ -5774,15 +5673,14 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
-		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-		    ioc->name, __func__, r);
+		ioc_err(ioc, "%s: handshake failed (r=%d)\n", __func__, r);
 		return r;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS ||
 	    mpi_reply.IOCLogInfo) {
-		pr_err(MPT3SAS_FMT "%s: failed\n", ioc->name, __func__);
+		ioc_err(ioc, "%s: failed\n", __func__);
 		r = -EIO;
 	}
 
@@ -5853,18 +5751,16 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	u16 smid;
 	u16 ioc_status;
 
-	pr_info(MPT3SAS_FMT "sending port enable !!\n", ioc->name);
+	ioc_info(ioc, "sending port enable !!\n");
 
 	if (ioc->port_enable_cmds.status & MPT3_CMD_PENDING) {
-		pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: internal command already in use\n", __func__);
 		return -EAGAIN;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->port_enable_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		return -EAGAIN;
 	}
 
@@ -5878,8 +5774,7 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->port_enable_cmds.done, 300*HZ);
 	if (!(ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2PortEnableRequest_t)/4);
 		if (ioc->port_enable_cmds.status & MPT3_CMD_RESET)
@@ -5892,16 +5787,15 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	mpi_reply = ioc->port_enable_cmds.reply;
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "%s: failed with (ioc_status=0x%08x)\n",
-		    ioc->name, __func__, ioc_status);
+		ioc_err(ioc, "%s: failed with (ioc_status=0x%08x)\n",
+			__func__, ioc_status);
 		r = -EFAULT;
 		goto out;
 	}
 
  out:
 	ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
-	pr_info(MPT3SAS_FMT "port enable: %s\n", ioc->name, ((r == 0) ?
-	    "SUCCESS" : "FAILED"));
+	ioc_info(ioc, "port enable: %s\n", r == 0 ? "SUCCESS" : "FAILED");
 	return r;
 }
 
@@ -5917,18 +5811,16 @@ mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2PortEnableRequest_t *mpi_request;
 	u16 smid;
 
-	pr_info(MPT3SAS_FMT "sending port enable !!\n", ioc->name);
+	ioc_info(ioc, "sending port enable !!\n");
 
 	if (ioc->port_enable_cmds.status & MPT3_CMD_PENDING) {
-		pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: internal command already in use\n", __func__);
 		return -EAGAIN;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->port_enable_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		return -EAGAIN;
 	}
 
@@ -6031,19 +5923,16 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 	int r = 0;
 	int i;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	if (ioc->base_cmds.status & MPT3_CMD_PENDING) {
-		pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: internal command already in use\n", __func__);
 		return -EAGAIN;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		return -EAGAIN;
 	}
 	ioc->base_cmds.status = MPT3_CMD_PENDING;
@@ -6060,8 +5949,7 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2EventNotificationRequest_t)/4);
 		if (ioc->base_cmds.status & MPT3_CMD_RESET)
@@ -6069,8 +5957,7 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 		else
 			r = -ETIME;
 	} else
-		dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s: complete\n",
-		    ioc->name, __func__));
+		dinitprintk(ioc, ioc_info(ioc, "%s: complete\n", __func__));
 	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
 	return r;
 }
@@ -6126,18 +6013,16 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 	u32 count;
 	u32 hcb_size;
 
-	pr_info(MPT3SAS_FMT "sending diag reset !!\n", ioc->name);
+	ioc_info(ioc, "sending diag reset !!\n");
 
-	drsprintk(ioc, pr_info(MPT3SAS_FMT "clear interrupts\n",
-	    ioc->name));
+	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
 
 	count = 0;
 	do {
 		/* Write magic sequence to WriteSequence register
 		 * Loop until in diagnostic mode
 		 */
-		drsprintk(ioc, pr_info(MPT3SAS_FMT
-			"write magic sequence\n", ioc->name));
+		drsprintk(ioc, ioc_info(ioc, "write magic sequence\n"));
 		writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
 		writel(MPI2_WRSEQ_1ST_KEY_VALUE, &ioc->chip->WriteSequence);
 		writel(MPI2_WRSEQ_2ND_KEY_VALUE, &ioc->chip->WriteSequence);
@@ -6153,16 +6038,15 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 			goto out;
 
 		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
-		drsprintk(ioc, pr_info(MPT3SAS_FMT
-			"wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
-		    ioc->name, count, host_diagnostic));
+		drsprintk(ioc,
+			  ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
+				   count, host_diagnostic));
 
 	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
 
 	hcb_size = readl(&ioc->chip->HCBSize);
 
-	drsprintk(ioc, pr_info(MPT3SAS_FMT "diag reset: issued\n",
-	    ioc->name));
+	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
 	     &ioc->chip->HostDiagnostic);
 
@@ -6185,43 +6069,38 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 
 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
 
-		drsprintk(ioc, pr_info(MPT3SAS_FMT
-		"restart the adapter assuming the HCB Address points to good F/W\n",
-		    ioc->name));
+		drsprintk(ioc,
+			  ioc_info(ioc, "restart the adapter assuming the HCB Address points to good F/W\n"));
 		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
 		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
 		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
 
-		drsprintk(ioc, pr_info(MPT3SAS_FMT
-		    "re-enable the HCDW\n", ioc->name));
+		drsprintk(ioc, ioc_info(ioc, "re-enable the HCDW\n"));
 		writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
 		    &ioc->chip->HCBSize);
 	}
 
-	drsprintk(ioc, pr_info(MPT3SAS_FMT "restart the adapter\n",
-	    ioc->name));
+	drsprintk(ioc, ioc_info(ioc, "restart the adapter\n"));
 	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
 	    &ioc->chip->HostDiagnostic);
 
-	drsprintk(ioc, pr_info(MPT3SAS_FMT
-		"disable writes to the diagnostic register\n", ioc->name));
+	drsprintk(ioc,
+		  ioc_info(ioc, "disable writes to the diagnostic register\n"));
 	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
 
-	drsprintk(ioc, pr_info(MPT3SAS_FMT
-		"Wait for FW to go to the READY state\n", ioc->name));
+	drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
 	if (ioc_state) {
-		pr_err(MPT3SAS_FMT
-			"%s: failed going to ready state (ioc_state=0x%x)\n",
-			ioc->name, __func__, ioc_state);
+		ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
+			__func__, ioc_state);
 		goto out;
 	}
 
-	pr_info(MPT3SAS_FMT "diag reset: SUCCESS\n", ioc->name);
+	ioc_info(ioc, "diag reset: SUCCESS\n");
 	return 0;
 
  out:
-	pr_err(MPT3SAS_FMT "diag reset: FAILED\n", ioc->name);
+	ioc_err(ioc, "diag reset: FAILED\n");
 	return -EFAULT;
 }
 
@@ -6239,15 +6118,15 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 	int rc;
 	int count;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	if (ioc->pci_error_recovery)
 		return 0;
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
-	dhsprintk(ioc, pr_info(MPT3SAS_FMT "%s: ioc_state(0x%08x)\n",
-	    ioc->name, __func__, ioc_state));
+	dhsprintk(ioc,
+		  ioc_info(ioc, "%s: ioc_state(0x%08x)\n",
+			   __func__, ioc_state));
 
 	/* if in RESET state, it should move to READY state shortly */
 	count = 0;
@@ -6255,9 +6134,8 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 		while ((ioc_state & MPI2_IOC_STATE_MASK) !=
 		    MPI2_IOC_STATE_READY) {
 			if (count++ == 10) {
-				pr_err(MPT3SAS_FMT
-					"%s: failed going to ready state (ioc_state=0x%x)\n",
-				    ioc->name, __func__, ioc_state);
+				ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
+					__func__, ioc_state);
 				return -EFAULT;
 			}
 			ssleep(1);
@@ -6269,9 +6147,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 		return 0;
 
 	if (ioc_state & MPI2_DOORBELL_USED) {
-		dhsprintk(ioc, pr_info(MPT3SAS_FMT
-			"unexpected doorbell active!\n",
-			ioc->name));
+		dhsprintk(ioc, ioc_info(ioc, "unexpected doorbell active!\n"));
 		goto issue_diag_reset;
 	}
 
@@ -6315,8 +6191,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 	struct adapter_reply_queue *reply_q;
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free_contig;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	/* clean the delayed target reset list */
 	list_for_each_entry_safe(delayed_tr, delayed_tr_next,
@@ -6476,8 +6351,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 {
-	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	/* synchronizing freeing resource with pci_access_mutex lock */
 	mutex_lock(&ioc->pci_access_mutex);
@@ -6505,8 +6379,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	int r, i;
 	int cpu_id, last_cpu_id = 0;
 
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	/* setup cpu_msix_table */
 	ioc->cpu_count = num_online_cpus();
@@ -6516,9 +6389,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->cpu_msix_table = kzalloc(ioc->cpu_msix_table_sz, GFP_KERNEL);
 	ioc->reply_queue_count = 1;
 	if (!ioc->cpu_msix_table) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"allocation for cpu_msix_table failed!!!\n",
-			ioc->name));
+		dfailprintk(ioc,
+			    ioc_info(ioc, "allocation for cpu_msix_table failed!!!\n"));
 		r = -ENOMEM;
 		goto out_free_resources;
 	}
@@ -6527,9 +6399,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		ioc->reply_post_host_index = kcalloc(ioc->cpu_msix_table_sz,
 		    sizeof(resource_size_t *), GFP_KERNEL);
 		if (!ioc->reply_post_host_index) {
-			dfailprintk(ioc, pr_info(MPT3SAS_FMT "allocation "
-				"for reply_post_host_index failed!!!\n",
-				ioc->name));
+			dfailprintk(ioc,
+				    ioc_info(ioc, "allocation for reply_post_host_index failed!!!\n"));
 			r = -ENOMEM;
 			goto out_free_resources;
 		}
@@ -6762,8 +6633,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc)
 {
-	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
 	mpt3sas_base_stop_watchdog(ioc);
 	mpt3sas_base_free_resources(ioc);
@@ -6796,8 +6666,7 @@ static void _base_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 {
 	mpt3sas_scsih_pre_reset_handler(ioc);
 	mpt3sas_ctl_pre_reset_handler(ioc);
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_PRE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_PRE_RESET\n", __func__));
 }
 
 /**
@@ -6808,8 +6677,7 @@ static void _base_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 {
 	mpt3sas_scsih_after_reset_handler(ioc);
 	mpt3sas_ctl_after_reset_handler(ioc);
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_AFTER_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
 	if (ioc->transport_cmds.status & MPT3_CMD_PENDING) {
 		ioc->transport_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->transport_cmds.smid);
@@ -6850,8 +6718,7 @@ static void _base_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 {
 	mpt3sas_scsih_reset_done_handler(ioc);
 	mpt3sas_ctl_reset_done_handler(ioc);
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_DONE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
 }
 
 /**
@@ -6898,12 +6765,10 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	u32 ioc_state;
 	u8 is_fault = 0, is_trigger = 0;
 
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
 
 	if (ioc->pci_error_recovery) {
-		pr_err(MPT3SAS_FMT "%s: pci error recovery reset\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: pci error recovery reset\n", __func__);
 		r = 0;
 		goto out_unlocked;
 	}
@@ -6957,8 +6822,9 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 		_base_reset_done_handler(ioc);
 
  out:
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT "%s: %s\n",
-	    ioc->name, __func__, ((r == 0) ? "SUCCESS" : "FAILED")));
+	dtmprintk(ioc,
+		  ioc_info(ioc, "%s: %s\n",
+			   __func__, r == 0 ? "SUCCESS" : "FAILED"));
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->shost_recovery = 0;
@@ -6974,7 +6840,6 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 			mpt3sas_trigger_master(ioc,
 			    MASTER_TRIGGER_ADAPTER_RESET);
 	}
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: exit\n", __func__));
 	return r;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 9b01c5a7aebd..fff7d5cd266d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -175,20 +175,18 @@ _config_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	if (!desc)
 		return;
 
-	pr_info(MPT3SAS_FMT
-		"%s: %s(%d), action(%d), form(0x%08x), smid(%d)\n",
-		ioc->name, calling_function_name, desc,
-	    mpi_request->Header.PageNumber, mpi_request->Action,
-	    le32_to_cpu(mpi_request->PageAddress), smid);
+	ioc_info(ioc, "%s: %s(%d), action(%d), form(0x%08x), smid(%d)\n",
+		 calling_function_name, desc,
+		 mpi_request->Header.PageNumber, mpi_request->Action,
+		 le32_to_cpu(mpi_request->PageAddress), smid);
 
 	if (!mpi_reply)
 		return;
 
 	if (mpi_reply->IOCStatus || mpi_reply->IOCLogInfo)
-		pr_info(MPT3SAS_FMT
-		    "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
-		    le32_to_cpu(mpi_reply->IOCLogInfo));
+		ioc_info(ioc, "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
+			 le16_to_cpu(mpi_reply->IOCStatus),
+			 le32_to_cpu(mpi_reply->IOCLogInfo));
 }
 
 /**
@@ -210,9 +208,8 @@ _config_alloc_config_dma_memory(struct MPT3SAS_ADAPTER *ioc,
 		mem->page = dma_alloc_coherent(&ioc->pdev->dev, mem->sz,
 		    &mem->page_dma, GFP_KERNEL);
 		if (!mem->page) {
-			pr_err(MPT3SAS_FMT
-				"%s: dma_alloc_coherent failed asking for (%d) bytes!!\n",
-			    ioc->name, __func__, mem->sz);
+			ioc_err(ioc, "%s: dma_alloc_coherent failed asking for (%d) bytes!!\n",
+				__func__, mem->sz);
 			r = -ENOMEM;
 		}
 	} else { /* use tmp buffer if less than 512 bytes */
@@ -313,8 +310,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 
 	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: config_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: config_cmd in use\n", __func__);
 		mutex_unlock(&ioc->config_cmds.mutex);
 		return -EAGAIN;
 	}
@@ -362,34 +358,30 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 			r = -EFAULT;
 			goto free_mem;
 		}
-		pr_info(MPT3SAS_FMT "%s: attempting retry (%d)\n",
-		    ioc->name, __func__, retry_count);
+		ioc_info(ioc, "%s: attempting retry (%d)\n",
+			 __func__, retry_count);
 	}
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			ioc->config_cmds.status = MPT3_CMD_NOT_USED;
 			r = -EFAULT;
 			goto free_mem;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->config_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		ioc->config_cmds.status = MPT3_CMD_NOT_USED;
 		r = -EAGAIN;
 		goto free_mem;
@@ -453,8 +445,8 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	}
 
 	if (retry_count)
-		pr_info(MPT3SAS_FMT "%s: retry (%d) completed!!\n", \
-		    ioc->name, __func__, retry_count);
+		ioc_info(ioc, "%s: retry (%d) completed!!\n",
+			 __func__, retry_count);
 
 	if ((ioc_status == MPI2_IOCSTATUS_SUCCESS) &&
 	    config_page && mpi_request->Action ==
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8cfb4f12c68c..af7f705ebecf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -185,17 +185,15 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	if (!desc)
 		return;
 
-	pr_info(MPT3SAS_FMT "%s: %s, smid(%d)\n",
-	    ioc->name, calling_function_name, desc, smid);
+	ioc_info(ioc, "%s: %s, smid(%d)\n", calling_function_name, desc, smid);
 
 	if (!mpi_reply)
 		return;
 
 	if (mpi_reply->IOCStatus || mpi_reply->IOCLogInfo)
-		pr_info(MPT3SAS_FMT
-		    "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
-		    le32_to_cpu(mpi_reply->IOCLogInfo));
+		ioc_info(ioc, "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
+			 le16_to_cpu(mpi_reply->IOCStatus),
+			 le32_to_cpu(mpi_reply->IOCLogInfo));
 
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 	    mpi_request->Function ==
@@ -208,38 +206,32 @@ _ctl_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		sas_device = mpt3sas_get_sdev_by_handle(ioc,
 		    le16_to_cpu(scsi_reply->DevHandle));
 		if (sas_device) {
-			pr_warn(MPT3SAS_FMT "\tsas_address(0x%016llx), phy(%d)\n",
-				ioc->name, (unsigned long long)
-			    sas_device->sas_address, sas_device->phy);
-			pr_warn(MPT3SAS_FMT
-			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
-			    ioc->name, (unsigned long long)
-			    sas_device->enclosure_logical_id, sas_device->slot);
+			ioc_warn(ioc, "\tsas_address(0x%016llx), phy(%d)\n",
+				 (u64)sas_device->sas_address,
+				 sas_device->phy);
+			ioc_warn(ioc, "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
+				 (u64)sas_device->enclosure_logical_id,
+				 sas_device->slot);
 			sas_device_put(sas_device);
 		}
 		if (!sas_device) {
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc,
 				le16_to_cpu(scsi_reply->DevHandle));
 			if (pcie_device) {
-				pr_warn(MPT3SAS_FMT
-				    "\tWWID(0x%016llx), port(%d)\n", ioc->name,
-				    (unsigned long long)pcie_device->wwid,
-				    pcie_device->port_num);
+				ioc_warn(ioc, "\tWWID(0x%016llx), port(%d)\n",
+					 (unsigned long long)pcie_device->wwid,
+					 pcie_device->port_num);
 				if (pcie_device->enclosure_handle != 0)
-					pr_warn(MPT3SAS_FMT
-					    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
-					    ioc->name, (unsigned long long)
-					    pcie_device->enclosure_logical_id,
-					    pcie_device->slot);
+					ioc_warn(ioc, "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
+						 (u64)pcie_device->enclosure_logical_id,
+						 pcie_device->slot);
 				pcie_device_put(pcie_device);
 			}
 		}
 		if (scsi_reply->SCSIState || scsi_reply->SCSIStatus)
-			pr_info(MPT3SAS_FMT
-			    "\tscsi_state(0x%02x), scsi_status"
-			    "(0x%02x)\n", ioc->name,
-			    scsi_reply->SCSIState,
-			    scsi_reply->SCSIStatus);
+			ioc_info(ioc, "\tscsi_state(0x%02x), scsi_status(0x%02x)\n",
+				 scsi_reply->SCSIState,
+				 scsi_reply->SCSIStatus);
 	}
 }
 
@@ -466,8 +458,7 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 	int i;
 	u8 issue_reset;
 
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_PRE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_PRE_RESET\n", __func__));
 	for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
 		if (!(ioc->diag_buffer_status[i] &
 		      MPT3_DIAG_BUFFER_IS_REGISTERED))
@@ -487,8 +478,7 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
  */
 void mpt3sas_ctl_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_AFTER_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
 	if (ioc->ctl_cmds.status & MPT3_CMD_PENDING) {
 		ioc->ctl_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->ctl_cmds.smid);
@@ -506,8 +496,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i;
 
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_DONE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
 
 	for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
 		if (!(ioc->diag_buffer_status[i] &
@@ -612,10 +601,10 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 	}
 
 	if (!found) {
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: handle(0x%04x), lun(%d), no active mid!!\n",
-			ioc->name,
-		    desc, le16_to_cpu(tm_request->DevHandle), lun));
+		dctlprintk(ioc,
+			   ioc_info(ioc, "%s: handle(0x%04x), lun(%d), no active mid!!\n",
+				    desc, le16_to_cpu(tm_request->DevHandle),
+				    lun));
 		tm_reply = ioc->ctl_cmds.reply;
 		tm_reply->DevHandle = tm_request->DevHandle;
 		tm_reply->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
@@ -631,10 +620,10 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 		return 1;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
-	    desc, le16_to_cpu(tm_request->DevHandle), lun,
-	     le16_to_cpu(tm_request->TaskMID)));
+	dctlprintk(ioc,
+		   ioc_info(ioc, "%s: handle(0x%04x), lun(%d), task_mid(%d)\n",
+			    desc, le16_to_cpu(tm_request->DevHandle), lun,
+			    le16_to_cpu(tm_request->TaskMID)));
 	return 0;
 }
 
@@ -672,8 +661,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	issue_reset = 0;
 
 	if (ioc->ctl_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: ctl_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: ctl_cmd in use\n", __func__);
 		ret = -EAGAIN;
 		goto out;
 	}
@@ -682,28 +670,23 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			ret = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name,
-		    __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	mpi_request = kzalloc(ioc->request_sz, GFP_KERNEL);
 	if (!mpi_request) {
-		pr_err(MPT3SAS_FMT
-			"%s: failed obtaining a memory for mpi_request\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a memory for mpi_request\n",
+			__func__);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -726,8 +709,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
 		smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
 		if (!smid) {
-			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 			ret = -EAGAIN;
 			goto out;
 		}
@@ -823,9 +805,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		ioc->build_nvme_prp(ioc, smid, nvme_encap_request,
 		    data_out_dma, data_out_sz, data_in_dma, data_in_sz);
 		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
-			dtmprintk(ioc, pr_info(MPT3SAS_FMT "handle(0x%04x) :"
-			    "ioctl failed due to device removal in progress\n",
-			    ioc->name, device_handle));
+			dtmprintk(ioc,
+				  ioc_info(ioc, "handle(0x%04x): ioctl failed due to device removal in progress\n",
+					   device_handle));
 			mpt3sas_base_free_smid(ioc, smid);
 			ret = -EINVAL;
 			goto out;
@@ -843,9 +825,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		    mpt3sas_base_get_sense_buffer_dma(ioc, smid);
 		memset(ioc->ctl_cmds.sense, 0, SCSI_SENSE_BUFFERSIZE);
 		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
-			dtmprintk(ioc, pr_info(MPT3SAS_FMT
-				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
-				ioc->name, device_handle));
+			dtmprintk(ioc,
+				  ioc_info(ioc, "handle(0x%04x) :ioctl failed due to device removal in progress\n",
+					   device_handle));
 			mpt3sas_base_free_smid(ioc, smid);
 			ret = -EINVAL;
 			goto out;
@@ -863,10 +845,10 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		Mpi2SCSITaskManagementRequest_t *tm_request =
 		    (Mpi2SCSITaskManagementRequest_t *)request;
 
-		dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"TASK_MGMT: handle(0x%04x), task_type(0x%02x)\n",
-			ioc->name,
-		    le16_to_cpu(tm_request->DevHandle), tm_request->TaskType));
+		dtmprintk(ioc,
+			  ioc_info(ioc, "TASK_MGMT: handle(0x%04x), task_type(0x%02x)\n",
+				   le16_to_cpu(tm_request->DevHandle),
+				   tm_request->TaskType));
 		ioc->got_task_abort_from_ioctl = 1;
 		if (tm_request->TaskType ==
 		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK ||
@@ -881,9 +863,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		ioc->got_task_abort_from_ioctl = 0;
 
 		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
-			dtmprintk(ioc, pr_info(MPT3SAS_FMT
-				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
-				ioc->name, device_handle));
+			dtmprintk(ioc,
+				  ioc_info(ioc, "handle(0x%04x) :ioctl failed due to device removal in progress\n",
+					   device_handle));
 			mpt3sas_base_free_smid(ioc, smid);
 			ret = -EINVAL;
 			goto out;
@@ -929,9 +911,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	case MPI2_FUNCTION_SATA_PASSTHROUGH:
 	{
 		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
-			dtmprintk(ioc, pr_info(MPT3SAS_FMT
-				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
-				ioc->name, device_handle));
+			dtmprintk(ioc,
+				  ioc_info(ioc, "handle(0x%04x) :ioctl failed due to device removal in progress\n",
+					   device_handle));
 			mpt3sas_base_free_smid(ioc, smid);
 			ret = -EINVAL;
 			goto out;
@@ -1017,12 +999,10 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		Mpi2SCSITaskManagementReply_t *tm_reply =
 		    (Mpi2SCSITaskManagementReply_t *)mpi_reply;
 
-		pr_info(MPT3SAS_FMT "TASK_MGMT: " \
-		    "IOCStatus(0x%04x), IOCLogInfo(0x%08x), "
-		    "TerminationCount(0x%08x)\n", ioc->name,
-		    le16_to_cpu(tm_reply->IOCStatus),
-		    le32_to_cpu(tm_reply->IOCLogInfo),
-		    le32_to_cpu(tm_reply->TerminationCount));
+		ioc_info(ioc, "TASK_MGMT: IOCStatus(0x%04x), IOCLogInfo(0x%08x), TerminationCount(0x%08x)\n",
+			 le16_to_cpu(tm_reply->IOCStatus),
+			 le32_to_cpu(tm_reply->IOCLogInfo),
+			 le32_to_cpu(tm_reply->TerminationCount));
 	}
 
 	/* copy out xdata to user */
@@ -1054,9 +1034,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH || mpi_request->Function ==
 	    MPI2_FUNCTION_NVME_ENCAPSULATED)) {
 		if (karg.sense_data_ptr == NULL) {
-			pr_info(MPT3SAS_FMT "Response buffer provided"
-			    " by application is NULL; Response data will"
-			    " not be returned.\n", ioc->name);
+			ioc_info(ioc, "Response buffer provided by application is NULL; Response data will not be returned\n");
 			goto out;
 		}
 		sz_arg = (mpi_request->Function ==
@@ -1079,9 +1057,8 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		    mpi_request->Function ==
 		    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
 		    mpi_request->Function == MPI2_FUNCTION_SATA_PASSTHROUGH)) {
-			pr_info(MPT3SAS_FMT "issue target reset: handle = (0x%04x)\n",
-				ioc->name,
-				le16_to_cpu(mpi_request->FunctionDependent1));
+			ioc_info(ioc, "issue target reset: handle = (0x%04x)\n",
+				 le16_to_cpu(mpi_request->FunctionDependent1));
 			mpt3sas_halt_firmware(ioc);
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc,
 				le16_to_cpu(mpi_request->FunctionDependent1));
@@ -1128,8 +1105,8 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 {
 	struct mpt3_ioctl_iocinfo karg;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
+				 __func__));
 
 	memset(&karg, 0 , sizeof(karg));
 	if (ioc->pfacts)
@@ -1188,8 +1165,8 @@ _ctl_eventquery(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
+				 __func__));
 
 	karg.event_entries = MPT3SAS_CTL_EVENT_LOG_SIZE;
 	memcpy(karg.event_types, ioc->event_type,
@@ -1219,8 +1196,8 @@ _ctl_eventenable(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
+				 __func__));
 
 	memcpy(ioc->event_type, karg.event_types,
 	    MPI2_EVENT_NOTIFY_EVENTMASK_WORDS * sizeof(u32));
@@ -1259,8 +1236,8 @@ _ctl_eventreport(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
+				 __func__));
 
 	number_bytes = karg.hdr.max_data_size -
 	    sizeof(struct mpt3_ioctl_header);
@@ -1306,12 +1283,11 @@ _ctl_do_reset(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    ioc->is_driver_loading)
 		return -EAGAIN;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
+				 __func__));
 
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
-	pr_info(MPT3SAS_FMT "host reset: %s\n",
-	    ioc->name, ((!retval) ? "SUCCESS" : "FAILED"));
+	ioc_info(ioc, "host reset: %s\n", ((!retval) ? "SUCCESS" : "FAILED"));
 	return 0;
 }
 
@@ -1440,8 +1416,8 @@ _ctl_btdh_mapping(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	rc = _ctl_btdh_search_sas_device(ioc, &karg);
 	if (!rc)
@@ -1512,53 +1488,46 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	u32 ioc_state;
 	u8 issue_reset = 0;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		pr_err(MPT3SAS_FMT
-		    "%s: failed due to ioc not operational\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed due to ioc not operational\n",
+			__func__);
 		rc = -EAGAIN;
 		goto out;
 	}
 
 	if (ioc->ctl_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: ctl_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: ctl_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
 
 	buffer_type = diag_register->buffer_type;
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have capability for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EPERM;
 	}
 
 	if (ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) {
-		pr_err(MPT3SAS_FMT
-			"%s: already has a registered buffer for buffer_type(0x%02x)\n",
-			ioc->name, __func__,
-		    buffer_type);
+		ioc_err(ioc, "%s: already has a registered buffer for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EINVAL;
 	}
 
 	if (diag_register->requested_buffer_size % 4)  {
-		pr_err(MPT3SAS_FMT
-			"%s: the requested_buffer_size is not 4 byte aligned\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: the requested_buffer_size is not 4 byte aligned\n",
+			__func__);
 		return -EINVAL;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->ctl_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1593,9 +1562,8 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 		request_data = pci_alloc_consistent(
 			ioc->pdev, request_data_sz, &request_data_dma);
 		if (request_data == NULL) {
-			pr_err(MPT3SAS_FMT "%s: failed allocating memory" \
-			    " for diag buffers, requested size(%d)\n",
-			    ioc->name, __func__, request_data_sz);
+			ioc_err(ioc, "%s: failed allocating memory for diag buffers, requested size(%d)\n",
+				__func__, request_data_sz);
 			mpt3sas_base_free_smid(ioc, smid);
 			rc = -ENOMEM;
 			goto out;
@@ -1613,11 +1581,11 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: diag_buffer(0x%p), dma(0x%llx), sz(%d)\n",
-		ioc->name, __func__, request_data,
-	    (unsigned long long)request_data_dma,
-	    le32_to_cpu(mpi_request->BufferLength)));
+	dctlprintk(ioc,
+		   ioc_info(ioc, "%s: diag_buffer(0x%p), dma(0x%llx), sz(%d)\n",
+			    __func__, request_data,
+			    (unsigned long long)request_data_dma,
+			    le32_to_cpu(mpi_request->BufferLength)));
 
 	for (i = 0; i < MPT3_PRODUCT_SPECIFIC_DWORDS; i++)
 		mpi_request->ProductSpecific[i] =
@@ -1638,8 +1606,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 
 	/* process the completed Reply Message Frame */
 	if ((ioc->ctl_cmds.status & MPT3_CMD_REPLY_VALID) == 0) {
-		pr_err(MPT3SAS_FMT "%s: no reply message\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: no reply message\n", __func__);
 		rc = -EFAULT;
 		goto out;
 	}
@@ -1650,13 +1617,11 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 			MPT3_DIAG_BUFFER_IS_REGISTERED;
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: success\n",
-		    ioc->name, __func__));
+		dctlprintk(ioc, ioc_info(ioc, "%s: success\n", __func__));
 	} else {
-		pr_info(MPT3SAS_FMT
-			"%s: ioc_status(0x%04x) log_info(0x%08x)\n",
-			ioc->name, __func__,
-		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
+		ioc_info(ioc, "%s: ioc_status(0x%04x) log_info(0x%08x)\n",
+			 __func__,
+			 ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
@@ -1690,8 +1655,7 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 	memset(&diag_register, 0, sizeof(struct mpt3_diag_register));
 
 	if (bits_to_register & 1) {
-		pr_info(MPT3SAS_FMT "registering trace buffer support\n",
-		    ioc->name);
+		ioc_info(ioc, "registering trace buffer support\n");
 		ioc->diag_trigger_master.MasterData =
 		    (MASTER_TRIGGER_FW_FAULT + MASTER_TRIGGER_ADAPTER_RESET);
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
@@ -1702,8 +1666,7 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 	}
 
 	if (bits_to_register & 2) {
-		pr_info(MPT3SAS_FMT "registering snapshot buffer support\n",
-		    ioc->name);
+		ioc_info(ioc, "registering snapshot buffer support\n");
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_SNAPSHOT;
 		/* register for 2MB buffers  */
 		diag_register.requested_buffer_size = 2 * (1024 * 1024);
@@ -1712,8 +1675,7 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 	}
 
 	if (bits_to_register & 4) {
-		pr_info(MPT3SAS_FMT "registering extended buffer support\n",
-		    ioc->name);
+		ioc_info(ioc, "registering extended buffer support\n");
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_EXTENDED;
 		/* register for 2MB buffers  */
 		diag_register.requested_buffer_size = 2 * (1024 * 1024);
@@ -1769,44 +1731,39 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have capability for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EPERM;
 	}
 
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) is not registered\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) is not registered\n",
+			__func__, buffer_type);
 		return -EINVAL;
 	}
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) has not been released\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) has not been released\n",
+			__func__, buffer_type);
 		return -EINVAL;
 	}
 
 	if (karg.unique_id != ioc->unique_id[buffer_type]) {
-		pr_err(MPT3SAS_FMT
-			"%s: unique_id(0x%08x) is not registered\n",
-			ioc->name, __func__, karg.unique_id);
+		ioc_err(ioc, "%s: unique_id(0x%08x) is not registered\n",
+			__func__, karg.unique_id);
 		return -EINVAL;
 	}
 
 	request_data = ioc->diag_buffer[buffer_type];
 	if (!request_data) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have memory allocated for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have memory allocated for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -ENOMEM;
 	}
 
@@ -1842,41 +1799,37 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	karg.application_flags = 0;
 	buffer_type = karg.buffer_type;
 
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have capability for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EPERM;
 	}
 
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) is not registered\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) is not registered\n",
+			__func__, buffer_type);
 		return -EINVAL;
 	}
 
 	if (karg.unique_id & 0xffffff00) {
 		if (karg.unique_id != ioc->unique_id[buffer_type]) {
-			pr_err(MPT3SAS_FMT
-				"%s: unique_id(0x%08x) is not registered\n",
-				ioc->name, __func__, karg.unique_id);
+			ioc_err(ioc, "%s: unique_id(0x%08x) is not registered\n",
+				__func__, karg.unique_id);
 			return -EINVAL;
 		}
 	}
 
 	request_data = ioc->diag_buffer[buffer_type];
 	if (!request_data) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have buffer for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have buffer for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -ENOMEM;
 	}
 
@@ -1898,9 +1851,8 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	karg.diagnostic_flags = ioc->diagnostic_flags[buffer_type];
 
 	if (copy_to_user(arg, &karg, sizeof(struct mpt3_diag_query))) {
-		pr_err(MPT3SAS_FMT
-			"%s: unable to write mpt3_diag_query data @ %p\n",
-			ioc->name, __func__, arg);
+		ioc_err(ioc, "%s: unable to write mpt3_diag_query data @ %p\n",
+			__func__, arg);
 		return -EFAULT;
 	}
 	return 0;
@@ -1924,8 +1876,8 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u32 ioc_state;
 	int rc;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	rc = 0;
 	*issue_reset = 0;
@@ -1936,24 +1888,22 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 		    MPT3_DIAG_BUFFER_IS_REGISTERED)
 			ioc->diag_buffer_status[buffer_type] |=
 			    MPT3_DIAG_BUFFER_IS_RELEASED;
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: skipping due to FAULT state\n", ioc->name,
-		    __func__));
+		dctlprintk(ioc,
+			   ioc_info(ioc, "%s: skipping due to FAULT state\n",
+				    __func__));
 		rc = -EAGAIN;
 		goto out;
 	}
 
 	if (ioc->ctl_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: ctl_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: ctl_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->ctl_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1983,8 +1933,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 
 	/* process the completed Reply Message Frame */
 	if ((ioc->ctl_cmds.status & MPT3_CMD_REPLY_VALID) == 0) {
-		pr_err(MPT3SAS_FMT "%s: no reply message\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: no reply message\n", __func__);
 		rc = -EFAULT;
 		goto out;
 	}
@@ -1995,13 +1944,11 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 		    MPT3_DIAG_BUFFER_IS_RELEASED;
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: success\n",
-		    ioc->name, __func__));
+		dctlprintk(ioc, ioc_info(ioc, "%s: success\n", __func__));
 	} else {
-		pr_info(MPT3SAS_FMT
-			"%s: ioc_status(0x%04x) log_info(0x%08x)\n",
-			ioc->name, __func__,
-		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
+		ioc_info(ioc, "%s: ioc_status(0x%04x) log_info(0x%08x)\n",
+			 __func__,
+			 ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
@@ -2034,47 +1981,41 @@ _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have capability for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EPERM;
 	}
 
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) is not registered\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) is not registered\n",
+			__func__, buffer_type);
 		return -EINVAL;
 	}
 
 	if (karg.unique_id != ioc->unique_id[buffer_type]) {
-		pr_err(MPT3SAS_FMT
-			"%s: unique_id(0x%08x) is not registered\n",
-			ioc->name, __func__, karg.unique_id);
+		ioc_err(ioc, "%s: unique_id(0x%08x) is not registered\n",
+			__func__, karg.unique_id);
 		return -EINVAL;
 	}
 
 	if (ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) {
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) is already released\n",
-			ioc->name, __func__,
-		    buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) is already released\n",
+			__func__, buffer_type);
 		return 0;
 	}
 
 	request_data = ioc->diag_buffer[buffer_type];
 
 	if (!request_data) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have memory allocated for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have memory allocated for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -ENOMEM;
 	}
 
@@ -2085,9 +2026,8 @@ _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		    MPT3_DIAG_BUFFER_IS_RELEASED;
 		ioc->diag_buffer_status[buffer_type] &=
 		    ~MPT3_DIAG_BUFFER_IS_DIAG_RESET;
-		pr_err(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) was released due to host reset\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: buffer_type(0x%02x) was released due to host reset\n",
+			__func__, buffer_type);
 		return 0;
 	}
 
@@ -2125,38 +2065,34 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EFAULT;
 	}
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
-	    __func__));
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",
+				 __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have capability for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -EPERM;
 	}
 
 	if (karg.unique_id != ioc->unique_id[buffer_type]) {
-		pr_err(MPT3SAS_FMT
-			"%s: unique_id(0x%08x) is not registered\n",
-			ioc->name, __func__, karg.unique_id);
+		ioc_err(ioc, "%s: unique_id(0x%08x) is not registered\n",
+			__func__, karg.unique_id);
 		return -EINVAL;
 	}
 
 	request_data = ioc->diag_buffer[buffer_type];
 	if (!request_data) {
-		pr_err(MPT3SAS_FMT
-			"%s: doesn't have buffer for buffer_type(0x%02x)\n",
-			ioc->name, __func__, buffer_type);
+		ioc_err(ioc, "%s: doesn't have buffer for buffer_type(0x%02x)\n",
+			__func__, buffer_type);
 		return -ENOMEM;
 	}
 
 	request_size = ioc->diag_buffer_sz[buffer_type];
 
 	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
-		pr_err(MPT3SAS_FMT "%s: either the starting_offset " \
-		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
-		    __func__);
+		ioc_err(ioc, "%s: either the starting_offset or bytes_to_read are not 4 byte aligned\n",
+			__func__);
 		return -EINVAL;
 	}
 
@@ -2164,10 +2100,10 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EINVAL;
 
 	diag_data = (void *)(request_data + karg.starting_offset);
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: diag_buffer(%p), offset(%d), sz(%d)\n",
-		ioc->name, __func__,
-	    diag_data, karg.starting_offset, karg.bytes_to_read));
+	dctlprintk(ioc,
+		   ioc_info(ioc, "%s: diag_buffer(%p), offset(%d), sz(%d)\n",
+			    __func__, diag_data, karg.starting_offset,
+			    karg.bytes_to_read));
 
 	/* Truncate data on requests that are too large */
 	if ((diag_data + karg.bytes_to_read < diag_data) ||
@@ -2178,39 +2114,36 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
 	    diag_data, copy_size)) {
-		pr_err(MPT3SAS_FMT
-			"%s: Unable to write mpt_diag_read_buffer_t data @ %p\n",
-			ioc->name, __func__, diag_data);
+		ioc_err(ioc, "%s: Unable to write mpt_diag_read_buffer_t data @ %p\n",
+			__func__, diag_data);
 		return -EFAULT;
 	}
 
 	if ((karg.flags & MPT3_FLAGS_REREGISTER) == 0)
 		return 0;
 
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: Reregister buffer_type(0x%02x)\n",
-		ioc->name, __func__, buffer_type));
+	dctlprintk(ioc,
+		   ioc_info(ioc, "%s: Reregister buffer_type(0x%02x)\n",
+			    __func__, buffer_type));
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: buffer_type(0x%02x) is still registered\n",
-			ioc->name, __func__, buffer_type));
+		dctlprintk(ioc,
+			   ioc_info(ioc, "%s: buffer_type(0x%02x) is still registered\n",
+				    __func__, buffer_type));
 		return 0;
 	}
 	/* Get a free request frame and save the message context.
 	*/
 
 	if (ioc->ctl_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: ctl_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: ctl_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->ctl_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -2248,8 +2181,7 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 
 	/* process the completed Reply Message Frame */
 	if ((ioc->ctl_cmds.status & MPT3_CMD_REPLY_VALID) == 0) {
-		pr_err(MPT3SAS_FMT "%s: no reply message\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: no reply message\n", __func__);
 		rc = -EFAULT;
 		goto out;
 	}
@@ -2260,13 +2192,11 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 		    MPT3_DIAG_BUFFER_IS_REGISTERED;
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: success\n",
-		    ioc->name, __func__));
+		dctlprintk(ioc, ioc_info(ioc, "%s: success\n", __func__));
 	} else {
-		pr_info(MPT3SAS_FMT
-			"%s: ioc_status(0x%04x) log_info(0x%08x)\n",
-			ioc->name, __func__,
-		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
+		ioc_info(ioc, "%s: ioc_status(0x%04x) log_info(0x%08x)\n",
+			 __func__, ioc_status,
+			 le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
 	}
 
@@ -2451,8 +2381,9 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 			ret = _ctl_diag_read_buffer(ioc, arg);
 		break;
 	default:
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		    "unsupported ioctl opcode(0x%08x)\n", ioc->name, cmd));
+		dctlprintk(ioc,
+			   ioc_info(ioc, "unsupported ioctl opcode(0x%08x)\n",
+				    cmd));
 		break;
 	}
 
@@ -2841,8 +2772,8 @@ _ctl_logging_level_store(struct device *cdev, struct device_attribute *attr,
 		return -EINVAL;
 
 	ioc->logging_level = val;
-	pr_info(MPT3SAS_FMT "logging_level=%08xh\n", ioc->name,
-	    ioc->logging_level);
+	ioc_info(ioc, "logging_level=%08xh\n",
+		 ioc->logging_level);
 	return strlen(buf);
 }
 static DEVICE_ATTR(logging_level, S_IRUGO | S_IWUSR, _ctl_logging_level_show,
@@ -2878,8 +2809,8 @@ _ctl_fwfault_debug_store(struct device *cdev, struct device_attribute *attr,
 		return -EINVAL;
 
 	ioc->fwfault_debug = val;
-	pr_info(MPT3SAS_FMT "fwfault_debug=%d\n", ioc->name,
-	    ioc->fwfault_debug);
+	ioc_info(ioc, "fwfault_debug=%d\n",
+		 ioc->fwfault_debug);
 	return strlen(buf);
 }
 static DEVICE_ATTR(fwfault_debug, S_IRUGO | S_IWUSR,
@@ -2959,8 +2890,8 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	ssize_t rc = 0;
 
 	if (!ioc->is_warpdrive) {
-		pr_err(MPT3SAS_FMT "%s: BRM attribute is only for"
-		    " warpdrive\n", ioc->name, __func__);
+		ioc_err(ioc, "%s: BRM attribute is only for warpdrive\n",
+			__func__);
 		goto out;
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
@@ -2974,30 +2905,28 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
 	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
 	if (!io_unit_pg3) {
-		pr_err(MPT3SAS_FMT "%s: failed allocating memory "
-		    "for iounit_pg3: (%d) bytes\n", ioc->name, __func__, sz);
+		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
+			__func__, sz);
 		goto out;
 	}
 
 	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
 	    0) {
-		pr_err(MPT3SAS_FMT
-		    "%s: failed reading iounit_pg3\n", ioc->name,
-		    __func__);
+		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
+			__func__);
 		goto out;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "%s: iounit_pg3 failed with "
-		    "ioc_status(0x%04x)\n", ioc->name, __func__, ioc_status);
+		ioc_err(ioc, "%s: iounit_pg3 failed with ioc_status(0x%04x)\n",
+			__func__, ioc_status);
 		goto out;
 	}
 
 	if (io_unit_pg3->GPIOCount < 25) {
-		pr_err(MPT3SAS_FMT "%s: iounit_pg3->GPIOCount less than "
-		     "25 entries, detected (%d) entries\n", ioc->name, __func__,
-		    io_unit_pg3->GPIOCount);
+		ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
+			__func__, io_unit_pg3->GPIOCount);
 		goto out;
 	}
 
@@ -3040,17 +2969,15 @@ _ctl_host_trace_buffer_size_show(struct device *cdev,
 	struct DIAG_BUFFER_START *request_data;
 
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
-		pr_err(MPT3SAS_FMT
-			"%s: host_trace_buffer is not registered\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
+			__func__);
 		return 0;
 	}
 
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: host_trace_buffer is not registered\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
+			__func__);
 		return 0;
 	}
 
@@ -3090,17 +3017,15 @@ _ctl_host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
 	u32 size;
 
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
-		pr_err(MPT3SAS_FMT
-			"%s: host_trace_buffer is not registered\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
+			__func__);
 		return 0;
 	}
 
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
-			"%s: host_trace_buffer is not registered\n",
-			ioc->name, __func__);
+		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
+			__func__);
 		return 0;
 	}
 
@@ -3189,8 +3114,7 @@ _ctl_host_trace_buffer_enable_store(struct device *cdev,
 		    MPT3_DIAG_BUFFER_IS_RELEASED) == 0))
 			goto out;
 		memset(&diag_register, 0, sizeof(struct mpt3_diag_register));
-		pr_info(MPT3SAS_FMT "posting host trace buffers\n",
-		    ioc->name);
+		ioc_info(ioc, "posting host trace buffers\n");
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
 		diag_register.requested_buffer_size = (1024 * 1024);
 		diag_register.unique_id = 0x7075900;
@@ -3206,8 +3130,7 @@ _ctl_host_trace_buffer_enable_store(struct device *cdev,
 		if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 		    MPT3_DIAG_BUFFER_IS_RELEASED))
 			goto out;
-		pr_info(MPT3SAS_FMT "releasing host trace buffer\n",
-		    ioc->name);
+		ioc_info(ioc, "releasing host trace buffer\n");
 		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
 		    &issue_reset);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c8d97dc2ca63..8ec997b4ee34 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -418,8 +418,8 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
-		__FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -ENXIO;
 	}
 
@@ -442,10 +442,8 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		return -ENXIO;
 
 	/* else error case */
-	pr_err(MPT3SAS_FMT
-		"handle(0x%04x), ioc_status(0x%04x), failure at %s:%d/%s()!\n",
-		ioc->name, handle, ioc_status,
-	     __FILE__, __LINE__, __func__);
+	ioc_err(ioc, "handle(0x%04x), ioc_status(0x%04x), failure at %s:%d/%s()!\n",
+		handle, ioc_status, __FILE__, __LINE__, __func__);
 	return -EIO;
 }
 
@@ -508,10 +506,9 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc, void *device,
 		    (ioc->bios_pg2.ReqBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.RequestedBootDevice)) {
-			dinitprintk(ioc, pr_info(MPT3SAS_FMT
-			   "%s: req_boot_device(0x%016llx)\n",
-			    ioc->name, __func__,
-			    (unsigned long long)sas_address));
+			dinitprintk(ioc,
+				    ioc_info(ioc, "%s: req_boot_device(0x%016llx)\n",
+					     __func__, (u64)sas_address));
 			ioc->req_boot_device.device = device;
 			ioc->req_boot_device.channel = channel;
 		}
@@ -523,10 +520,9 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc, void *device,
 		    (ioc->bios_pg2.ReqAltBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.RequestedAltBootDevice)) {
-			dinitprintk(ioc, pr_info(MPT3SAS_FMT
-			   "%s: req_alt_boot_device(0x%016llx)\n",
-			    ioc->name, __func__,
-			    (unsigned long long)sas_address));
+			dinitprintk(ioc,
+				    ioc_info(ioc, "%s: req_alt_boot_device(0x%016llx)\n",
+					     __func__, (u64)sas_address));
 			ioc->req_alt_boot_device.device = device;
 			ioc->req_alt_boot_device.channel = channel;
 		}
@@ -538,10 +534,9 @@ _scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc, void *device,
 		    (ioc->bios_pg2.CurrentBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.CurrentBootDevice)) {
-			dinitprintk(ioc, pr_info(MPT3SAS_FMT
-			   "%s: current_boot_device(0x%016llx)\n",
-			    ioc->name, __func__,
-			    (unsigned long long)sas_address));
+			dinitprintk(ioc,
+				    ioc_info(ioc, "%s: current_boot_device(0x%016llx)\n",
+					     __func__, (u64)sas_address));
 			ioc->current_boot_device.device = device;
 			ioc->current_boot_device.channel = channel;
 		}
@@ -752,19 +747,16 @@ _scsih_display_enclosure_chassis_info(struct MPT3SAS_ADAPTER *ioc,
 			    sas_device->chassis_slot);
 	} else {
 		if (sas_device->enclosure_handle != 0)
-			pr_info(MPT3SAS_FMT
-			    "enclosure logical id(0x%016llx), slot(%d) \n",
-			    ioc->name, (unsigned long long)
-			    sas_device->enclosure_logical_id,
-			    sas_device->slot);
+			ioc_info(ioc, "enclosure logical id(0x%016llx), slot(%d)\n",
+				 (u64)sas_device->enclosure_logical_id,
+				 sas_device->slot);
 		if (sas_device->connector_name[0] != '\0')
-			pr_info(MPT3SAS_FMT
-			    "enclosure level(0x%04x), connector name( %s)\n",
-			    ioc->name, sas_device->enclosure_level,
-			    sas_device->connector_name);
+			ioc_info(ioc, "enclosure level(0x%04x), connector name( %s)\n",
+				 sas_device->enclosure_level,
+				 sas_device->connector_name);
 		if (sas_device->is_chassis_slot_valid)
-			pr_info(MPT3SAS_FMT "chassis slot(0x%04x)\n",
-			    ioc->name, sas_device->chassis_slot);
+			ioc_info(ioc, "chassis slot(0x%04x)\n",
+				 sas_device->chassis_slot);
 	}
 }
 
@@ -784,10 +776,8 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
 
 	if (!sas_device)
 		return;
-	pr_info(MPT3SAS_FMT
-	    "removing handle(0x%04x), sas_addr(0x%016llx)\n",
-	    ioc->name, sas_device->handle,
-	    (unsigned long long) sas_device->sas_address);
+	ioc_info(ioc, "removing handle(0x%04x), sas_addr(0x%016llx)\n",
+		 sas_device->handle, (u64)sas_device->sas_address);
 
 	_scsih_display_enclosure_chassis_info(ioc, sas_device, NULL, NULL);
 
@@ -872,10 +862,10 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), sas_addr(0x%016llx)\n",
-		ioc->name, __func__, sas_device->handle,
-		(unsigned long long)sas_device->sas_address));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: handle(0x%04x), sas_addr(0x%016llx)\n",
+			    __func__, sas_device->handle,
+			    (u64)sas_device->sas_address));
 
 	dewtprintk(ioc, _scsih_display_enclosure_chassis_info(ioc, sas_device,
 	    NULL, NULL));
@@ -923,10 +913,10 @@ _scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name,
-		__func__, sas_device->handle,
-		(unsigned long long)sas_device->sas_address));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: handle(0x%04x), sas_addr(0x%016llx)\n",
+			    __func__, sas_device->handle,
+			    (u64)sas_device->sas_address));
 
 	dewtprintk(ioc, _scsih_display_enclosure_chassis_info(ioc, sas_device,
 	    NULL, NULL));
@@ -1073,21 +1063,16 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
 
 	if (!pcie_device)
 		return;
-	pr_info(MPT3SAS_FMT
-		"removing handle(0x%04x), wwid(0x%016llx)\n",
-		ioc->name, pcie_device->handle,
-		(unsigned long long) pcie_device->wwid);
+	ioc_info(ioc, "removing handle(0x%04x), wwid(0x%016llx)\n",
+		 pcie_device->handle, (u64)pcie_device->wwid);
 	if (pcie_device->enclosure_handle != 0)
-		pr_info(MPT3SAS_FMT
-			"removing enclosure logical id(0x%016llx), slot(%d)\n",
-			ioc->name,
-			(unsigned long long)pcie_device->enclosure_logical_id,
-		pcie_device->slot);
+		ioc_info(ioc, "removing enclosure logical id(0x%016llx), slot(%d)\n",
+			 (u64)pcie_device->enclosure_logical_id,
+			 pcie_device->slot);
 	if (pcie_device->connector_name[0] != '\0')
-		pr_info(MPT3SAS_FMT
-		    "removing enclosure level(0x%04x), connector name( %s)\n",
-			ioc->name, pcie_device->enclosure_level,
-			pcie_device->connector_name);
+		ioc_info(ioc, "removing enclosure level(0x%04x), connector name( %s)\n",
+			 pcie_device->enclosure_level,
+			 pcie_device->connector_name);
 
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 	if (!list_empty(&pcie_device->list)) {
@@ -1146,20 +1131,21 @@ _scsih_pcie_device_add(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle (0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
-		pcie_device->handle, (unsigned long long)pcie_device->wwid));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: handle (0x%04x), wwid(0x%016llx)\n",
+			    __func__,
+			    pcie_device->handle, (u64)pcie_device->wwid));
 	if (pcie_device->enclosure_handle != 0)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: enclosure logical id(0x%016llx), slot( %d)\n",
-			ioc->name, __func__,
-			(unsigned long long)pcie_device->enclosure_logical_id,
-			pcie_device->slot));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enclosure logical id(0x%016llx), slot( %d)\n",
+				    __func__,
+				    (u64)pcie_device->enclosure_logical_id,
+				    pcie_device->slot));
 	if (pcie_device->connector_name[0] != '\0')
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: enclosure level(0x%04x), connector name( %s)\n",
-			ioc->name, __func__, pcie_device->enclosure_level,
-			pcie_device->connector_name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enclosure level(0x%04x), connector name( %s)\n",
+				    __func__, pcie_device->enclosure_level,
+				    pcie_device->connector_name));
 
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 	pcie_device_get(pcie_device);
@@ -1191,20 +1177,21 @@ _scsih_pcie_device_init_add(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle (0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
-		pcie_device->handle, (unsigned long long)pcie_device->wwid));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: handle (0x%04x), wwid(0x%016llx)\n",
+			    __func__,
+			    pcie_device->handle, (u64)pcie_device->wwid));
 	if (pcie_device->enclosure_handle != 0)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: enclosure logical id(0x%016llx), slot( %d)\n",
-			ioc->name, __func__,
-			(unsigned long long)pcie_device->enclosure_logical_id,
-			pcie_device->slot));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enclosure logical id(0x%016llx), slot( %d)\n",
+				    __func__,
+				    (u64)pcie_device->enclosure_logical_id,
+				    pcie_device->slot));
 	if (pcie_device->connector_name[0] != '\0')
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: enclosure level(0x%04x), connector name( %s)\n",
-			ioc->name, __func__, pcie_device->enclosure_level,
-			pcie_device->connector_name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enclosure level(0x%04x), connector name( %s)\n",
+				    __func__, pcie_device->enclosure_level,
+				    pcie_device->connector_name));
 
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 	pcie_device_get(pcie_device);
@@ -1304,9 +1291,10 @@ _scsih_raid_device_add(struct MPT3SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
-	    raid_device->handle, (unsigned long long)raid_device->wwid));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: handle(0x%04x), wwid(0x%016llx)\n",
+			    __func__,
+			    raid_device->handle, (u64)raid_device->wwid));
 
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
 	list_add_tail(&raid_device->list, &ioc->raid_device_list);
@@ -1869,16 +1857,16 @@ _scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
@@ -1964,8 +1952,8 @@ scsih_get_resync(struct device *dev)
 	if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, &vol_pg0,
 	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 	     sizeof(Mpi2RaidVolPage0_t))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		percent_complete = 0;
 		goto out;
 	}
@@ -2018,8 +2006,8 @@ scsih_get_state(struct device *dev)
 	if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, &vol_pg0,
 	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 	     sizeof(Mpi2RaidVolPage0_t))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 
@@ -2115,9 +2103,9 @@ _scsih_get_volume_capabilities(struct MPT3SAS_ADAPTER *ioc,
 
 	if ((mpt3sas_config_get_number_pds(ioc, raid_device->handle,
 	    &num_pds)) || !num_pds) {
-		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
-		    __func__));
+		dfailprintk(ioc,
+			    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+				     __FILE__, __LINE__, __func__));
 		return 1;
 	}
 
@@ -2126,17 +2114,17 @@ _scsih_get_volume_capabilities(struct MPT3SAS_ADAPTER *ioc,
 	    sizeof(Mpi2RaidVol0PhysDisk_t));
 	vol_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!vol_pg0) {
-		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
-		    __func__));
+		dfailprintk(ioc,
+			    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+				     __FILE__, __LINE__, __func__));
 		return 1;
 	}
 
 	if ((mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
 	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
-		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
-		    __func__));
+		dfailprintk(ioc,
+			    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+				     __FILE__, __LINE__, __func__));
 		kfree(vol_pg0);
 		return 1;
 	}
@@ -2227,16 +2215,16 @@ scsih_slave_configure(struct scsi_device *sdev)
 		raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		if (!raid_device) {
-			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
-			    __LINE__, __func__));
+			dfailprintk(ioc,
+				    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+					     __FILE__, __LINE__, __func__));
 			return 1;
 		}
 
 		if (_scsih_get_volume_capabilities(ioc, raid_device)) {
-			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
-			    __LINE__, __func__));
+			dfailprintk(ioc,
+				    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+					     __FILE__, __LINE__, __func__));
 			return 1;
 		}
 
@@ -2320,16 +2308,16 @@ scsih_slave_configure(struct scsi_device *sdev)
 	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 		if (mpt3sas_config_get_volume_handle(ioc, handle,
 		    &volume_handle)) {
-			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name,
-			    __FILE__, __LINE__, __func__));
+			dfailprintk(ioc,
+				    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+					     __FILE__, __LINE__, __func__));
 			return 1;
 		}
 		if (volume_handle && mpt3sas_config_get_volume_wwid(ioc,
 		    volume_handle, &volume_wwid)) {
-			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name,
-			    __FILE__, __LINE__, __func__));
+			dfailprintk(ioc,
+				    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+					     __FILE__, __LINE__, __func__));
 			return 1;
 		}
 	}
@@ -2341,9 +2329,9 @@ scsih_slave_configure(struct scsi_device *sdev)
 				sas_device_priv_data->sas_target->sas_address);
 		if (!pcie_device) {
 			spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-				"failure at %s:%d/%s()!\n", ioc->name, __FILE__,
-				__LINE__, __func__));
+			dfailprintk(ioc,
+				    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+					     __FILE__, __LINE__, __func__));
 			return 1;
 		}
 
@@ -2389,9 +2377,9 @@ scsih_slave_configure(struct scsi_device *sdev)
 	   sas_device_priv_data->sas_target->sas_address);
 	if (!sas_device) {
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
-		    __func__));
+		dfailprintk(ioc,
+			    ioc_warn(ioc, "failure at %s:%d/%s()!\n",
+				     __FILE__, __LINE__, __func__));
 		return 1;
 	}
 
@@ -2527,8 +2515,7 @@ _scsih_response_code(struct MPT3SAS_ADAPTER *ioc, u8 response_code)
 		desc = "unknown";
 		break;
 	}
-	pr_warn(MPT3SAS_FMT "response_code(0x%01x): %s\n",
-		ioc->name, response_code, desc);
+	ioc_warn(ioc, "response_code(0x%01x): %s\n", response_code, desc);
 }
 
 /**
@@ -2666,8 +2653,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
 	if (ioc_state & MPI2_DOORBELL_USED) {
-		dhsprintk(ioc, pr_info(MPT3SAS_FMT
-			"unexpected doorbell active!\n", ioc->name));
+		dhsprintk(ioc, ioc_info(ioc, "unexpected doorbell active!\n"));
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
 	}
@@ -2681,14 +2667,13 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 
 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		return FAILED;
 	}
 
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d), timeout(%d), tr_method(0x%x)\n",
-		ioc->name, handle, type, smid_task, timeout, tr_method));
+	dtmprintk(ioc,
+		  ioc_info(ioc, "sending tm: handle(0x%04x), task_type(0x%02x), smid(%d), timeout(%d), tr_method(0x%x)\n",
+			   handle, type, smid_task, timeout, tr_method));
 	ioc->tm_cmds.status = MPT3_CMD_PENDING;
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->tm_cmds.smid = smid;
@@ -2721,11 +2706,11 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 	if (ioc->tm_cmds.status & MPT3_CMD_REPLY_VALID) {
 		mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
 		mpi_reply = ioc->tm_cmds.reply;
-		dtmprintk(ioc, pr_info(MPT3SAS_FMT "complete tm: " \
-		    "ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
-		    le32_to_cpu(mpi_reply->IOCLogInfo),
-		    le32_to_cpu(mpi_reply->TerminationCount)));
+		dtmprintk(ioc,
+			  ioc_info(ioc, "complete tm: ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
+				   le16_to_cpu(mpi_reply->IOCStatus),
+				   le32_to_cpu(mpi_reply->IOCLogInfo),
+				   le32_to_cpu(mpi_reply->TerminationCount)));
 		if (ioc->logging_level & MPT_DEBUG_TM) {
 			_scsih_response_code(ioc, mpi_reply->ResponseCode);
 			if (mpi_reply->IOCStatus)
@@ -3072,13 +3057,11 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	int r, retval;
 
-	pr_info(MPT3SAS_FMT "attempting host reset! scmd(%p)\n",
-	    ioc->name, scmd);
+	ioc_info(ioc, "attempting host reset! scmd(%p)\n", scmd);
 	scsi_print_command(scmd);
 
 	if (ioc->is_driver_loading || ioc->remove_host) {
-		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
-		    ioc->name);
+		ioc_info(ioc, "Blocking the host reset\n");
 		r = FAILED;
 		goto out;
 	}
@@ -3086,8 +3069,8 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 out:
-	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n",
-	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	ioc_info(ioc, "host reset: %s scmd(%p)\n",
+		 r == SUCCESS ? "SUCCESS" : "FAILED", scmd);
 
 	return r;
 }
@@ -3626,39 +3609,31 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
 	}
 	if (sas_target_priv_data) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"setting delete flag: handle(0x%04x), sas_addr(0x%016llx)\n",
-			ioc->name, handle,
-		    (unsigned long long)sas_address));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "setting delete flag: handle(0x%04x), sas_addr(0x%016llx)\n",
+				    handle, (u64)sas_address));
 		if (sas_device) {
 			if (sas_device->enclosure_handle != 0)
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				    "setting delete flag:enclosure logical "
-				    "id(0x%016llx), slot(%d)\n", ioc->name,
-				    (unsigned long long)
-				    sas_device->enclosure_logical_id,
-				    sas_device->slot));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting delete flag:enclosure logical id(0x%016llx), slot(%d)\n",
+						    (u64)sas_device->enclosure_logical_id,
+						    sas_device->slot));
 			if (sas_device->connector_name[0] != '\0')
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				    "setting delete flag: enclosure "
-				    "level(0x%04x), connector name( %s)\n",
-				    ioc->name, sas_device->enclosure_level,
-				    sas_device->connector_name));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting delete flag: enclosure level(0x%04x), connector name( %s)\n",
+						    sas_device->enclosure_level,
+						    sas_device->connector_name));
 		} else if (pcie_device) {
 			if (pcie_device->enclosure_handle != 0)
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				    "setting delete flag: logical "
-				    "id(0x%016llx), slot(%d)\n", ioc->name,
-				    (unsigned long long)
-				    pcie_device->enclosure_logical_id,
-				    pcie_device->slot));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting delete flag: logical id(0x%016llx), slot(%d)\n",
+						    (u64)pcie_device->enclosure_logical_id,
+						    pcie_device->slot));
 			if (pcie_device->connector_name[0] != '\0')
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				    "setting delete flag:, enclosure "
-				    "level(0x%04x), "
-				    "connector name( %s)\n", ioc->name,
-				    pcie_device->enclosure_level,
-				    pcie_device->connector_name));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting delete flag:, enclosure level(0x%04x), connector name( %s)\n",
+						    pcie_device->enclosure_level,
+						    pcie_device->connector_name));
 		}
 		_scsih_ublock_io_device(ioc, sas_address);
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
@@ -3672,16 +3647,15 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		INIT_LIST_HEAD(&delayed_tr->list);
 		delayed_tr->handle = handle;
 		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "DELAYED:tr:handle(0x%04x), (open)\n",
-		    ioc->name, handle));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "DELAYED:tr:handle(0x%04x), (open)\n",
+				    handle));
 		goto out;
 	}
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
-		ioc->name, handle, smid,
-	    ioc->tm_tr_cb_idx));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+			    handle, smid, ioc->tm_tr_cb_idx));
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
@@ -3729,39 +3703,39 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	struct _sc_list *delayed_sc;
 
 	if (ioc->pci_error_recovery) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: host in pci error recovery\n", __func__,
-			ioc->name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: host in pci error recovery\n",
+				    __func__));
 		return 1;
 	}
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: host is not operational\n", __func__, ioc->name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: host is not operational\n",
+				    __func__));
 		return 1;
 	}
 	if (unlikely(!mpi_reply)) {
-		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 1;
 	}
 	mpi_request_tm = mpt3sas_base_get_msg_frame(ioc, smid);
 	handle = le16_to_cpu(mpi_request_tm->DevHandle);
 	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
-		dewtprintk(ioc, pr_err(MPT3SAS_FMT
-			"spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
-			ioc->name, handle,
-		    le16_to_cpu(mpi_reply->DevHandle), smid));
+		dewtprintk(ioc,
+			   ioc_err(ioc, "spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
+				   handle,
+				   le16_to_cpu(mpi_reply->DevHandle), smid));
 		return 0;
 	}
 
 	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), "
-	    "loginfo(0x%08x), completed(%d)\n", ioc->name,
-	    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
-	    le32_to_cpu(mpi_reply->IOCLogInfo),
-	    le32_to_cpu(mpi_reply->TerminationCount)));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), loginfo(0x%08x), completed(%d)\n",
+			    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
+			    le32_to_cpu(mpi_reply->IOCLogInfo),
+			    le32_to_cpu(mpi_reply->TerminationCount)));
 
 	smid_sas_ctrl = mpt3sas_base_get_smid(ioc, ioc->tm_sas_control_cb_idx);
 	if (!smid_sas_ctrl) {
@@ -3771,16 +3745,15 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		INIT_LIST_HEAD(&delayed_sc->list);
 		delayed_sc->handle = le16_to_cpu(mpi_request_tm->DevHandle);
 		list_add_tail(&delayed_sc->list, &ioc->delayed_sc_list);
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "DELAYED:sc:handle(0x%04x), (open)\n",
-		    ioc->name, handle));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "DELAYED:sc:handle(0x%04x), (open)\n",
+				    handle));
 		return _scsih_check_for_pending_tm(ioc, smid);
 	}
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"sc_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
-		ioc->name, handle, smid_sas_ctrl,
-	    ioc->tm_sas_control_cb_idx));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "sc_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+			    handle, smid_sas_ctrl, ioc->tm_sas_control_cb_idx));
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid_sas_ctrl);
 	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
@@ -3849,20 +3822,19 @@ _scsih_sas_control_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
 	if (likely(mpi_reply)) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"sc_complete:handle(0x%04x), (open) "
-		"smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
-		ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
-		le16_to_cpu(mpi_reply->IOCStatus),
-		le32_to_cpu(mpi_reply->IOCLogInfo)));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "sc_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
+				    le16_to_cpu(mpi_reply->DevHandle), smid,
+				    le16_to_cpu(mpi_reply->IOCStatus),
+				    le32_to_cpu(mpi_reply->IOCLogInfo)));
 		if (le16_to_cpu(mpi_reply->IOCStatus) ==
 		     MPI2_IOCSTATUS_SUCCESS) {
 			clear_bit(le16_to_cpu(mpi_reply->DevHandle),
 			    ioc->device_remove_in_progress);
 		}
 	} else {
-		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 	}
 	return mpt3sas_check_for_pending_internal_cmds(ioc, smid);
 }
@@ -3899,16 +3871,15 @@ _scsih_tm_tr_volume_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		INIT_LIST_HEAD(&delayed_tr->list);
 		delayed_tr->handle = handle;
 		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_volume_list);
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "DELAYED:tr:handle(0x%04x), (open)\n",
-		    ioc->name, handle));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "DELAYED:tr:handle(0x%04x), (open)\n",
+				    handle));
 		return;
 	}
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
-		ioc->name, handle, smid,
-	    ioc->tm_tr_volume_cb_idx));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+			    handle, smid, ioc->tm_tr_volume_cb_idx));
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
@@ -3944,27 +3915,26 @@ _scsih_tm_volume_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		return 1;
 	}
 	if (unlikely(!mpi_reply)) {
-		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 1;
 	}
 
 	mpi_request_tm = mpt3sas_base_get_msg_frame(ioc, smid);
 	handle = le16_to_cpu(mpi_request_tm->DevHandle);
 	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
-		dewtprintk(ioc, pr_err(MPT3SAS_FMT
-			"spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
-			ioc->name, handle,
-		    le16_to_cpu(mpi_reply->DevHandle), smid));
+		dewtprintk(ioc,
+			   ioc_err(ioc, "spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
+				   handle, le16_to_cpu(mpi_reply->DevHandle),
+				   smid));
 		return 0;
 	}
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), "
-	    "loginfo(0x%08x), completed(%d)\n", ioc->name,
-	    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
-	    le32_to_cpu(mpi_reply->IOCLogInfo),
-	    le32_to_cpu(mpi_reply->TerminationCount)));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), loginfo(0x%08x), completed(%d)\n",
+			    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
+			    le32_to_cpu(mpi_reply->IOCLogInfo),
+			    le32_to_cpu(mpi_reply->TerminationCount)));
 
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
@@ -3994,10 +3964,9 @@ _scsih_issue_delayed_event_ack(struct MPT3SAS_ADAPTER *ioc, u16 smid, U16 event,
 	ioc->internal_lookup[i].cb_idx = ioc->base_cb_idx;
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"EVENT ACK: event(0x%04x), smid(%d), cb(%d)\n",
-		ioc->name, le16_to_cpu(event), smid,
-		ioc->base_cb_idx));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "EVENT ACK: event(0x%04x), smid(%d), cb(%d)\n",
+			    le16_to_cpu(event), smid, ioc->base_cb_idx));
 	ack_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(ack_request, 0, sizeof(Mpi2EventAckRequest_t));
 	ack_request->Function = MPI2_FUNCTION_EVENT_ACK;
@@ -4053,10 +4022,9 @@ _scsih_issue_delayed_sas_io_unit_ctrl(struct MPT3SAS_ADAPTER *ioc,
 	ioc->internal_lookup[i].cb_idx = ioc->tm_sas_control_cb_idx;
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "sc_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
-	    ioc->name, handle, smid,
-	    ioc->tm_sas_control_cb_idx));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "sc_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+			    handle, smid, ioc->tm_sas_control_cb_idx));
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
@@ -4217,8 +4185,8 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_ES_RESPONDING) {
 			if (le16_to_cpu(local_event_data->ExpanderDevHandle) ==
 			    expander_handle) {
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				    "setting ignoring flag\n", ioc->name));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting ignoring flag\n"));
 				fw_event->ignore = 1;
 			}
 		}
@@ -4289,9 +4257,8 @@ _scsih_check_pcie_topo_remove_events(struct MPT3SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_ES_RESPONDING) {
 			if (le16_to_cpu(local_event_data->SwitchDevHandle) ==
 				switch_handle) {
-				dewtprintk(ioc, pr_info(MPT3SAS_FMT
-					"setting ignoring flag for switch event\n",
-					ioc->name));
+				dewtprintk(ioc,
+					   ioc_info(ioc, "setting ignoring flag for switch event\n"));
 				fw_event->ignore = 1;
 			}
 		}
@@ -4320,10 +4287,9 @@ _scsih_set_volume_delete_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		sas_target_priv_data =
 		    raid_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "setting delete flag: handle(0x%04x), "
-		    "wwid(0x%016llx)\n", ioc->name, handle,
-		    (unsigned long long) raid_device->wwid));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "setting delete flag: handle(0x%04x), wwid(0x%016llx)\n",
+				    handle, (u64)raid_device->wwid));
 	}
 	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 }
@@ -4425,9 +4391,9 @@ _scsih_check_ir_config_unhide_events(struct MPT3SAS_ADAPTER *ioc,
 			INIT_LIST_HEAD(&delayed_tr->list);
 			delayed_tr->handle = handle;
 			list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "DELAYED:tr:handle(0x%04x), (open)\n", ioc->name,
-			    handle));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "DELAYED:tr:handle(0x%04x), (open)\n",
+					    handle));
 		} else
 			_scsih_tm_tr_send(ioc, handle);
 	}
@@ -4470,15 +4436,14 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventDataTemperature_t *event_data)
 {
 	if (ioc->temp_sensors_count >= event_data->SensorNum) {
-		pr_err(MPT3SAS_FMT "Temperature Threshold flags %s%s%s%s"
-		  " exceeded for Sensor: %d !!!\n", ioc->name,
-		  ((le16_to_cpu(event_data->Status) & 0x1) == 1) ? "0 " : " ",
-		  ((le16_to_cpu(event_data->Status) & 0x2) == 2) ? "1 " : " ",
-		  ((le16_to_cpu(event_data->Status) & 0x4) == 4) ? "2 " : " ",
-		  ((le16_to_cpu(event_data->Status) & 0x8) == 8) ? "3 " : " ",
-		  event_data->SensorNum);
-		pr_err(MPT3SAS_FMT "Current Temp In Celsius: %d\n",
-			ioc->name, event_data->CurrentTemperature);
+		ioc_err(ioc, "Temperature Threshold flags %s%s%s%s exceeded for Sensor: %d !!!\n",
+			le16_to_cpu(event_data->Status) & 0x1 ? "0 " : " ",
+			le16_to_cpu(event_data->Status) & 0x2 ? "1 " : " ",
+			le16_to_cpu(event_data->Status) & 0x4 ? "2 " : " ",
+			le16_to_cpu(event_data->Status) & 0x8 ? "3 " : " ",
+			event_data->SensorNum);
+		ioc_err(ioc, "Current Temp In Celsius: %d\n",
+			event_data->CurrentTemperature);
 	}
 }
 
@@ -4526,8 +4491,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 			scmd->result = DID_RESET << 16;
 		scmd->scsi_done(scmd);
 	}
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
-	    ioc->name, count));
+	dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
 }
 
 /**
@@ -4726,8 +4690,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		_scsih_set_satl_pending(scmd, false);
 		goto out;
 	}
@@ -4965,37 +4928,28 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	scsi_print_command(scmd);
 
 	if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
-		pr_warn(MPT3SAS_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
-		    device_str, (unsigned long long)priv_target->sas_address);
+		ioc_warn(ioc, "\t%s wwid(0x%016llx)\n",
+			 device_str, (u64)priv_target->sas_address);
 	} else if (priv_target->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
 		pcie_device = mpt3sas_get_pdev_from_target(ioc, priv_target);
 		if (pcie_device) {
-			pr_info(MPT3SAS_FMT "\twwid(0x%016llx), port(%d)\n",
-			    ioc->name,
-			    (unsigned long long)pcie_device->wwid,
-			    pcie_device->port_num);
+			ioc_info(ioc, "\twwid(0x%016llx), port(%d)\n",
+				 (u64)pcie_device->wwid, pcie_device->port_num);
 			if (pcie_device->enclosure_handle != 0)
-				pr_info(MPT3SAS_FMT
-				    "\tenclosure logical id(0x%016llx), "
-				    "slot(%d)\n", ioc->name,
-				    (unsigned long long)
-				    pcie_device->enclosure_logical_id,
-				    pcie_device->slot);
+				ioc_info(ioc, "\tenclosure logical id(0x%016llx), slot(%d)\n",
+					 (u64)pcie_device->enclosure_logical_id,
+					 pcie_device->slot);
 			if (pcie_device->connector_name[0])
-				pr_info(MPT3SAS_FMT
-				    "\tenclosure level(0x%04x),"
-				    "connector name( %s)\n",
-				    ioc->name, pcie_device->enclosure_level,
-				    pcie_device->connector_name);
+				ioc_info(ioc, "\tenclosure level(0x%04x), connector name( %s)\n",
+					 pcie_device->enclosure_level,
+					 pcie_device->connector_name);
 			pcie_device_put(pcie_device);
 		}
 	} else {
 		sas_device = mpt3sas_get_sdev_from_target(ioc, priv_target);
 		if (sas_device) {
-			pr_warn(MPT3SAS_FMT
-				"\tsas_address(0x%016llx), phy(%d)\n",
-				ioc->name, (unsigned long long)
-			    sas_device->sas_address, sas_device->phy);
+			ioc_warn(ioc, "\tsas_address(0x%016llx), phy(%d)\n",
+				 (u64)sas_device->sas_address, sas_device->phy);
 
 			_scsih_display_enclosure_chassis_info(ioc, sas_device,
 			    NULL, NULL);
@@ -5004,30 +4958,23 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		}
 	}
 
-	pr_warn(MPT3SAS_FMT
-		"\thandle(0x%04x), ioc_status(%s)(0x%04x), smid(%d)\n",
-		ioc->name, le16_to_cpu(mpi_reply->DevHandle),
-	    desc_ioc_state, ioc_status, smid);
-	pr_warn(MPT3SAS_FMT
-		"\trequest_len(%d), underflow(%d), resid(%d)\n",
-		ioc->name, scsi_bufflen(scmd), scmd->underflow,
-	    scsi_get_resid(scmd));
-	pr_warn(MPT3SAS_FMT
-		"\ttag(%d), transfer_count(%d), sc->result(0x%08x)\n",
-		ioc->name, le16_to_cpu(mpi_reply->TaskTag),
-	    le32_to_cpu(mpi_reply->TransferCount), scmd->result);
-	pr_warn(MPT3SAS_FMT
-		"\tscsi_status(%s)(0x%02x), scsi_state(%s)(0x%02x)\n",
-		ioc->name, desc_scsi_status,
-	    scsi_status, desc_scsi_state, scsi_state);
+	ioc_warn(ioc, "\thandle(0x%04x), ioc_status(%s)(0x%04x), smid(%d)\n",
+		 le16_to_cpu(mpi_reply->DevHandle),
+		 desc_ioc_state, ioc_status, smid);
+	ioc_warn(ioc, "\trequest_len(%d), underflow(%d), resid(%d)\n",
+		 scsi_bufflen(scmd), scmd->underflow, scsi_get_resid(scmd));
+	ioc_warn(ioc, "\ttag(%d), transfer_count(%d), sc->result(0x%08x)\n",
+		 le16_to_cpu(mpi_reply->TaskTag),
+		 le32_to_cpu(mpi_reply->TransferCount), scmd->result);
+	ioc_warn(ioc, "\tscsi_status(%s)(0x%02x), scsi_state(%s)(0x%02x)\n",
+		 desc_scsi_status, scsi_status, desc_scsi_state, scsi_state);
 
 	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) {
 		struct sense_info data;
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
-		pr_warn(MPT3SAS_FMT
-		  "\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], count(%d)\n",
-		  ioc->name, data.skey,
-		  data.asc, data.ascq, le32_to_cpu(mpi_reply->SenseCount));
+		ioc_warn(ioc, "\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], count(%d)\n",
+			 data.skey, data.asc, data.ascq,
+			 le32_to_cpu(mpi_reply->SenseCount));
 	}
 	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
 		response_info = le32_to_cpu(mpi_reply->ResponseInfo);
@@ -5062,17 +5009,17 @@ _scsih_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	mpi_request.Flags = MPI2_SEP_REQ_FLAGS_DEVHANDLE_ADDRESS;
 	if ((mpt3sas_base_scsi_enclosure_processor(ioc, &mpi_reply,
 	    &mpi_request)) != 0) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
-		__FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	sas_device->pfa_led_on = 1;
 
 	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
-			ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
-		    le32_to_cpu(mpi_reply.IOCLogInfo)));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
+				    le16_to_cpu(mpi_reply.IOCStatus),
+				    le32_to_cpu(mpi_reply.IOCLogInfo)));
 		goto out;
 	}
 out:
@@ -5179,8 +5126,8 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
 	event_reply = kzalloc(sz, GFP_KERNEL);
 	if (!event_reply) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 
@@ -5470,16 +5417,16 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 	u16 attached_handle;
 	u8 link_rate;
 
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-	    "updating handles for sas_host(0x%016llx)\n",
-	    ioc->name, (unsigned long long)ioc->sas_hba.sas_address));
+	dtmprintk(ioc,
+		  ioc_info(ioc, "updating handles for sas_host(0x%016llx)\n",
+			   (u64)ioc->sas_hba.sas_address));
 
 	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys
 	    * sizeof(Mpi2SasIOUnit0PhyData_t));
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
@@ -5529,15 +5476,15 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 
 	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
 	if (!num_phys) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 	ioc->sas_hba.phy = kcalloc(num_phys,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!ioc->sas_hba.phy) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	ioc->sas_hba.num_phys = num_phys;
@@ -5547,21 +5494,21 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	    sizeof(Mpi2SasIOUnit0PhyData_t));
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
 	    sas_iounit_pg0, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 
@@ -5570,21 +5517,21 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	    sizeof(Mpi2SasIOUnit1PhyData_t));
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
 	    sas_iounit_pg1, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 
@@ -5603,15 +5550,15 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
 		if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply, &phy_pg0,
 		    i))) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			goto out;
 		}
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			goto out;
 		}
 
@@ -5625,18 +5572,17 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	}
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, ioc->sas_hba.handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out;
 	}
 	ioc->sas_hba.enclosure_handle =
 	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
 	ioc->sas_hba.sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
-	pr_info(MPT3SAS_FMT
-		"host_add: handle(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
-		ioc->name, ioc->sas_hba.handle,
-	    (unsigned long long) ioc->sas_hba.sas_address,
-	    ioc->sas_hba.num_phys) ;
+	ioc_info(ioc, "host_add: handle(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
+		 ioc->sas_hba.handle,
+		 (u64)ioc->sas_hba.sas_address,
+		 ioc->sas_hba.num_phys);
 
 	if (ioc->sas_hba.enclosure_handle) {
 		if (!(mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
@@ -5685,16 +5631,16 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	if ((mpt3sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
 	    MPI2_SAS_EXPAND_PGAD_FORM_HNDL, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 
@@ -5702,8 +5648,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	parent_handle = le16_to_cpu(expander_pg0.ParentDevHandle);
 	if (_scsih_get_sas_address(ioc, parent_handle, &sas_address_parent)
 	    != 0) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 	if (sas_address_parent != ioc->sas_hba.sas_address) {
@@ -5730,8 +5676,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander = kzalloc(sizeof(struct _sas_node),
 	    GFP_KERNEL);
 	if (!sas_expander) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 
@@ -5740,10 +5686,9 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander->sas_address_parent = sas_address_parent;
 	sas_expander->sas_address = sas_address;
 
-	pr_info(MPT3SAS_FMT "expander_add: handle(0x%04x)," \
-	    " parent(0x%04x), sas_addr(0x%016llx), phys(%d)\n", ioc->name,
-	    handle, parent_handle, (unsigned long long)
-	    sas_expander->sas_address, sas_expander->num_phys);
+	ioc_info(ioc, "expander_add: handle(0x%04x), parent(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
+		 handle, parent_handle,
+		 (u64)sas_expander->sas_address, sas_expander->num_phys);
 
 	if (!sas_expander->num_phys) {
 		rc = -1;
@@ -5752,8 +5697,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander->phy = kcalloc(sas_expander->num_phys,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!sas_expander->phy) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -1;
 		goto out_fail;
 	}
@@ -5762,8 +5707,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	mpt3sas_port = mpt3sas_transport_port_add(ioc, handle,
 	    sas_address_parent);
 	if (!mpt3sas_port) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -1;
 		goto out_fail;
 	}
@@ -5772,8 +5717,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	for (i = 0 ; i < sas_expander->num_phys ; i++) {
 		if ((mpt3sas_config_get_expander_pg1(ioc, &mpi_reply,
 		    &expander_pg1, i, handle))) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			rc = -1;
 			goto out_fail;
 		}
@@ -5783,8 +5728,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		if ((mpt3sas_transport_add_expander_phy(ioc,
 		    &sas_expander->phy[i], expander_pg1,
 		    sas_expander->parent_dev))) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			rc = -1;
 			goto out_fail;
 		}
@@ -5931,9 +5876,8 @@ _scsih_check_access_status(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	if (!rc)
 		return 0;
 
-	pr_err(MPT3SAS_FMT
-		"discovery errors(%s): sas_address(0x%016llx), handle(0x%04x)\n",
-		ioc->name, desc, (unsigned long long)sas_address, handle);
+	ioc_err(ioc, "discovery errors(%s): sas_address(0x%016llx), handle(0x%04x)\n",
+		desc, (u64)sas_address, handle);
 	return rc;
 }
 
@@ -6027,9 +5971,8 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 	/* check if device is present */
 	if (!(le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
-		pr_err(MPT3SAS_FMT
-			"device is not present handle(0x%04x), flags!!!\n",
-			ioc->name, handle);
+		ioc_err(ioc, "device is not present handle(0x%04x), flags!!!\n",
+			handle);
 		goto out_unlock;
 	}
 
@@ -6076,16 +6019,16 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 
@@ -6099,8 +6042,8 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	/* check if device is present */
 	if (!(le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
-		pr_err(MPT3SAS_FMT "device is not present handle(0x04%x)!!!\n",
-			ioc->name, handle);
+		ioc_err(ioc, "device is not present handle(0x04%x)!!!\n",
+			handle);
 		return -1;
 	}
 
@@ -6122,16 +6065,15 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 			mpt3sas_scsih_enclosure_find_by_handle(ioc,
 			    le16_to_cpu(sas_device_pg0.EnclosureHandle));
 		if (enclosure_dev == NULL)
-			pr_info(MPT3SAS_FMT "Enclosure handle(0x%04x)"
-			    "doesn't match with enclosure device!\n",
-			    ioc->name, sas_device_pg0.EnclosureHandle);
+			ioc_info(ioc, "Enclosure handle(0x%04x) doesn't match with enclosure device!\n",
+				 sas_device_pg0.EnclosureHandle);
 	}
 
 	sas_device = kzalloc(sizeof(struct _sas_device),
 	    GFP_KERNEL);
 	if (!sas_device) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 0;
 	}
 
@@ -6140,8 +6082,8 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	if (_scsih_get_sas_address(ioc,
 	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
 	    &sas_device->sas_address_parent) != 0)
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 	sas_device->enclosure_handle =
 	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
 	if (sas_device->enclosure_handle != 0)
@@ -6206,11 +6148,10 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 		sas_device->pfa_led_on = 0;
 	}
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: enter: handle(0x%04x), sas_addr(0x%016llx)\n",
-		ioc->name, __func__,
-	    sas_device->handle, (unsigned long long)
-	    sas_device->sas_address));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: enter: handle(0x%04x), sas_addr(0x%016llx)\n",
+			    __func__,
+			    sas_device->handle, (u64)sas_device->sas_address));
 
 	dewtprintk(ioc, _scsih_display_enclosure_chassis_info(ioc, sas_device,
 	    NULL, NULL));
@@ -6228,18 +6169,15 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 		    sas_device->sas_address,
 		    sas_device->sas_address_parent);
 
-	pr_info(MPT3SAS_FMT
-		"removing handle(0x%04x), sas_addr(0x%016llx)\n",
-		ioc->name, sas_device->handle,
-	    (unsigned long long) sas_device->sas_address);
+	ioc_info(ioc, "removing handle(0x%04x), sas_addr(0x%016llx)\n",
+		 sas_device->handle, (u64)sas_device->sas_address);
 
 	_scsih_display_enclosure_chassis_info(ioc, sas_device, NULL, NULL);
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: exit: handle(0x%04x), sas_addr(0x%016llx)\n",
-		ioc->name, __func__,
-		sas_device->handle, (unsigned long long)
-		sas_device->sas_address));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: exit: handle(0x%04x), sas_addr(0x%016llx)\n",
+			    __func__,
+			    sas_device->handle, (u64)sas_device->sas_address));
 	dewtprintk(ioc, _scsih_display_enclosure_chassis_info(ioc, sas_device,
 	    NULL, NULL));
 }
@@ -6279,8 +6217,7 @@ _scsih_sas_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		status_str = "unknown status";
 		break;
 	}
-	pr_info(MPT3SAS_FMT "sas topology change: (%s)\n",
-	    ioc->name, status_str);
+	ioc_info(ioc, "sas topology change: (%s)\n", status_str);
 	pr_info("\thandle(0x%04x), enclosure_handle(0x%04x) " \
 	    "start_phy(%02d), count(%d)\n",
 	    le16_to_cpu(event_data->ExpanderDevHandle),
@@ -6357,8 +6294,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 		_scsih_sas_host_refresh(ioc);
 
 	if (fw_event->ignore) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"ignoring expander event\n", ioc->name));
+		dewtprintk(ioc, ioc_info(ioc, "ignoring expander event\n"));
 		return 0;
 	}
 
@@ -6387,8 +6323,8 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	/* handle siblings events */
 	for (i = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				"ignoring expander event\n", ioc->name));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "ignoring expander event\n"));
 			return 0;
 		}
 		if (ioc->remove_host || ioc->pci_error_recovery)
@@ -6512,15 +6448,14 @@ _scsih_sas_device_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		reason_str = "unknown reason";
 		break;
 	}
-	pr_info(MPT3SAS_FMT "device status change: (%s)\n"
-	    "\thandle(0x%04x), sas address(0x%016llx), tag(%d)",
-	    ioc->name, reason_str, le16_to_cpu(event_data->DevHandle),
-	    (unsigned long long)le64_to_cpu(event_data->SASAddress),
-	    le16_to_cpu(event_data->TaskTag));
+	ioc_info(ioc, "device status change: (%s)\thandle(0x%04x), sas address(0x%016llx), tag(%d)",
+		 reason_str, le16_to_cpu(event_data->DevHandle),
+		 (u64)le64_to_cpu(event_data->SASAddress),
+		 le16_to_cpu(event_data->TaskTag));
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA)
-		pr_info(MPT3SAS_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
-		    event_data->ASC, event_data->ASCQ);
-	pr_info("\n");
+		pr_cont(", ASC(0x%x), ASCQ(0x%x)\n",
+			event_data->ASC, event_data->ASCQ);
+	pr_cont("\n");
 }
 
 /**
@@ -6653,20 +6588,16 @@ _scsih_check_pcie_access_status(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 		desc = "nvme failure status";
 		break;
 	default:
-		pr_err(MPT3SAS_FMT
-		    " NVMe discovery error(0x%02x): wwid(0x%016llx),"
-			"handle(0x%04x)\n", ioc->name, access_status,
-			(unsigned long long)wwid, handle);
+		ioc_err(ioc, "NVMe discovery error(0x%02x): wwid(0x%016llx), handle(0x%04x)\n",
+			access_status, (u64)wwid, handle);
 		return rc;
 	}
 
 	if (!rc)
 		return rc;
 
-	pr_info(MPT3SAS_FMT
-		"NVMe discovery error(%s): wwid(0x%016llx), handle(0x%04x)\n",
-			ioc->name, desc,
-			(unsigned long long)wwid, handle);
+	ioc_info(ioc, "NVMe discovery error(%s): wwid(0x%016llx), handle(0x%04x)\n",
+		 desc, (u64)wwid, handle);
 	return rc;
 }
 
@@ -6682,22 +6613,22 @@ _scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "%s: enter: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
-	    pcie_device->handle, (unsigned long long)
-	    pcie_device->wwid));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: enter: handle(0x%04x), wwid(0x%016llx)\n",
+			    __func__,
+			    pcie_device->handle, (u64)pcie_device->wwid));
 	if (pcie_device->enclosure_handle != 0)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s: enter: enclosure logical id(0x%016llx), slot(%d)\n",
-		    ioc->name, __func__,
-		    (unsigned long long)pcie_device->enclosure_logical_id,
-		    pcie_device->slot));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enter: enclosure logical id(0x%016llx), slot(%d)\n",
+				    __func__,
+				    (u64)pcie_device->enclosure_logical_id,
+				    pcie_device->slot));
 	if (pcie_device->connector_name[0] != '\0')
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s: enter: enclosure level(0x%04x), connector name( %s)\n",
-		    ioc->name, __func__,
-		    pcie_device->enclosure_level,
-		    pcie_device->connector_name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: enter: enclosure level(0x%04x), connector name(%s)\n",
+				    __func__,
+				    pcie_device->enclosure_level,
+				    pcie_device->connector_name));
 
 	if (pcie_device->starget && pcie_device->starget->hostdata) {
 		sas_target_priv_data = pcie_device->starget->hostdata;
@@ -6706,39 +6637,35 @@ _scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
 
-	pr_info(MPT3SAS_FMT
-		"removing handle(0x%04x), wwid (0x%016llx)\n",
-		ioc->name, pcie_device->handle,
-		(unsigned long long) pcie_device->wwid);
+	ioc_info(ioc, "removing handle(0x%04x), wwid(0x%016llx)\n",
+		 pcie_device->handle, (u64)pcie_device->wwid);
 	if (pcie_device->enclosure_handle != 0)
-		pr_info(MPT3SAS_FMT
-		    "removing : enclosure logical id(0x%016llx), slot(%d)\n",
-		    ioc->name,
-		    (unsigned long long)pcie_device->enclosure_logical_id,
-		    pcie_device->slot);
+		ioc_info(ioc, "removing : enclosure logical id(0x%016llx), slot(%d)\n",
+			 (u64)pcie_device->enclosure_logical_id,
+			 pcie_device->slot);
 	if (pcie_device->connector_name[0] != '\0')
-		pr_info(MPT3SAS_FMT
-		    "removing: enclosure level(0x%04x), connector name( %s)\n",
-		    ioc->name, pcie_device->enclosure_level,
-		    pcie_device->connector_name);
+		ioc_info(ioc, "removing: enclosure level(0x%04x), connector name( %s)\n",
+			 pcie_device->enclosure_level,
+			 pcie_device->connector_name);
 
 	if (pcie_device->starget)
 		scsi_remove_target(&pcie_device->starget->dev);
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "%s: exit: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
-	    pcie_device->handle, (unsigned long long)
-	    pcie_device->wwid));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s: exit: handle(0x%04x), wwid(0x%016llx)\n",
+			    __func__,
+			    pcie_device->handle, (u64)pcie_device->wwid));
 	if (pcie_device->enclosure_handle != 0)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: exit: enclosure logical id(0x%016llx), slot(%d)\n",
-			ioc->name, __func__,
-			(unsigned long long)pcie_device->enclosure_logical_id,
-			pcie_device->slot));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: exit: enclosure logical id(0x%016llx), slot(%d)\n",
+				    __func__,
+				    (u64)pcie_device->enclosure_logical_id,
+				    pcie_device->slot));
 	if (pcie_device->connector_name[0] != '\0')
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s: exit: enclosure level(0x%04x), connector name( %s)\n",
-		    ioc->name, __func__, pcie_device->enclosure_level,
-		    pcie_device->connector_name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: exit: enclosure level(0x%04x), connector name( %s)\n",
+				    __func__,
+				    pcie_device->enclosure_level,
+				    pcie_device->connector_name));
 
 	kfree(pcie_device->serial_number);
 }
@@ -6808,9 +6735,8 @@ _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	/* check if device is present */
 	if (!(le32_to_cpu(pcie_device_pg0.Flags) &
 	    MPI26_PCIEDEV0_FLAGS_DEVICE_PRESENT)) {
-		pr_info(MPT3SAS_FMT
-		    "device is not present handle(0x%04x), flags!!!\n",
-		    ioc->name, handle);
+		ioc_info(ioc, "device is not present handle(0x%04x), flags!!!\n",
+			 handle);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 		pcie_device_put(pcie_device);
 		return;
@@ -6854,16 +6780,15 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	if ((mpt3sas_config_get_pcie_device_pg0(ioc, &mpi_reply,
 	    &pcie_device_pg0, MPI26_PCIE_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 0;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 0;
 	}
 
@@ -6873,9 +6798,8 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	/* check if device is present */
 	if (!(le32_to_cpu(pcie_device_pg0.Flags) &
 		MPI26_PCIEDEV0_FLAGS_DEVICE_PRESENT)) {
-		pr_err(MPT3SAS_FMT
-		    "device is not present handle(0x04%x)!!!\n",
-		    ioc->name, handle);
+		ioc_err(ioc, "device is not present handle(0x04%x)!!!\n",
+			handle);
 		return 0;
 	}
 
@@ -6896,8 +6820,8 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	pcie_device = kzalloc(sizeof(struct _pcie_device), GFP_KERNEL);
 	if (!pcie_device) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 0;
 	}
 
@@ -6938,16 +6862,16 @@ _scsih_pcie_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	/* TODO -- Add device name once FW supports it */
 	if (mpt3sas_config_get_pcie_device_pg2(ioc, &mpi_reply,
 		&pcie_device_pg2, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle)) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-				ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		kfree(pcie_device);
 		return 0;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		kfree(pcie_device);
 		return 0;
 	}
@@ -7004,8 +6928,7 @@ _scsih_pcie_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		status_str = "unknown status";
 		break;
 	}
-	pr_info(MPT3SAS_FMT "pcie topology change: (%s)\n",
-		ioc->name, status_str);
+	ioc_info(ioc, "pcie topology change: (%s)\n", status_str);
 	pr_info("\tswitch_handle(0x%04x), enclosure_handle(0x%04x)"
 		"start_port(%02d), count(%d)\n",
 		le16_to_cpu(event_data->SwitchDevHandle),
@@ -7078,16 +7001,15 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	if (fw_event->ignore) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT "ignoring switch event\n",
-			ioc->name));
+		dewtprintk(ioc, ioc_info(ioc, "ignoring switch event\n"));
 		return;
 	}
 
 	/* handle siblings events */
 	for (i = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				"ignoring switch event\n", ioc->name));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "ignoring switch event\n"));
 			return;
 		}
 		if (ioc->remove_host || ioc->pci_error_recovery)
@@ -7132,9 +7054,9 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			if (!test_bit(handle, ioc->pend_os_device_add))
 				break;
 
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-				"handle(0x%04x) device not found: convert "
-				"event to a device add\n", ioc->name, handle));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "handle(0x%04x) device not found: convert event to a device add\n",
+					    handle));
 			event_data->PortEntry[i].PortStatus &= 0xF0;
 			event_data->PortEntry[i].PortStatus |=
 				MPI26_EVENT_PCIE_TOPO_PS_DEV_ADDED;
@@ -7217,15 +7139,15 @@ _scsih_pcie_device_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		break;
 	}
 
-	pr_info(MPT3SAS_FMT "PCIE device status change: (%s)\n"
-		"\thandle(0x%04x), WWID(0x%016llx), tag(%d)",
-		ioc->name, reason_str, le16_to_cpu(event_data->DevHandle),
-		(unsigned long long)le64_to_cpu(event_data->WWID),
-		le16_to_cpu(event_data->TaskTag));
+	ioc_info(ioc, "PCIE device status change: (%s)\n"
+		 "\thandle(0x%04x), WWID(0x%016llx), tag(%d)",
+		 reason_str, le16_to_cpu(event_data->DevHandle),
+		 (u64)le64_to_cpu(event_data->WWID),
+		 le16_to_cpu(event_data->TaskTag));
 	if (event_data->ReasonCode == MPI26_EVENT_PCIDEV_STAT_RC_SMART_DATA)
-		pr_info(MPT3SAS_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
+		pr_cont(", ASC(0x%x), ASCQ(0x%x)\n",
 			event_data->ASC, event_data->ASCQ);
-	pr_info("\n");
+	pr_cont("\n");
 }
 
 /**
@@ -7303,12 +7225,12 @@ _scsih_sas_enclosure_dev_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 		break;
 	}
 
-	pr_info(MPT3SAS_FMT "enclosure status change: (%s)\n"
-	    "\thandle(0x%04x), enclosure logical id(0x%016llx)"
-	    " number slots(%d)\n", ioc->name, reason_str,
-	    le16_to_cpu(event_data->EnclosureHandle),
-	    (unsigned long long)le64_to_cpu(event_data->EnclosureLogicalID),
-	    le16_to_cpu(event_data->StartSlot));
+	ioc_info(ioc, "enclosure status change: (%s)\n"
+		 "\thandle(0x%04x), enclosure logical id(0x%016llx) number slots(%d)\n",
+		 reason_str,
+		 le16_to_cpu(event_data->EnclosureHandle),
+		 (u64)le64_to_cpu(event_data->EnclosureLogicalID),
+		 le16_to_cpu(event_data->StartSlot));
 }
 
 /**
@@ -7346,9 +7268,8 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 				kzalloc(sizeof(struct _enclosure_node),
 					GFP_KERNEL);
 			if (!enclosure_dev) {
-				pr_info(MPT3SAS_FMT
-					"failure at %s:%d/%s()!\n", ioc->name,
-					__FILE__, __LINE__, __func__);
+				ioc_info(ioc, "failure at %s:%d/%s()!\n",
+					 __FILE__, __LINE__, __func__);
 				return;
 			}
 			rc = mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
@@ -7406,10 +7327,8 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	u8 task_abort_retries;
 
 	mutex_lock(&ioc->tm_cmds.mutex);
-	pr_info(MPT3SAS_FMT
-		"%s: enter: phy number(%d), width(%d)\n",
-		ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth);
+	ioc_info(ioc, "%s: enter: phy number(%d), width(%d)\n",
+		 __func__, event_data->PhyNum, event_data->PortWidth);
 
 	_scsih_block_io_all_device(ioc);
 
@@ -7419,12 +7338,12 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 	/* sanity checks for retrying this loop */
 	if (max_retries++ == 5) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: giving up\n",
-		    ioc->name, __func__));
+		dewtprintk(ioc, ioc_info(ioc, "%s: giving up\n", __func__));
 		goto out;
 	} else if (max_retries > 1)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: %d retry\n",
-		    ioc->name, __func__, max_retries - 1));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: %d retry\n",
+				    __func__, max_retries - 1));
 
 	termination_count = 0;
 	query_count = 0;
@@ -7491,9 +7410,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 		task_abort_retries = 0;
  tm_retry:
 		if (task_abort_retries++ == 60) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "%s: ABORT_TASK: giving up\n", ioc->name,
-			    __func__));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "%s: ABORT_TASK: giving up\n",
+					    __func__));
 			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 			goto broadcast_aen_retry;
 		}
@@ -7522,9 +7441,10 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	if (ioc->broadcast_aen_pending) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: loop back due to pending AEN\n",
-			ioc->name, __func__));
+		dewtprintk(ioc,
+			   ioc_info(ioc,
+				    "%s: loop back due to pending AEN\n",
+				    __func__));
 		 ioc->broadcast_aen_pending = 0;
 		 goto broadcast_aen_retry;
 	}
@@ -7533,9 +7453,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
  out_no_lock:
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-	    "%s - exit, query_count = %d termination_count = %d\n",
-	    ioc->name, __func__, query_count, termination_count));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "%s - exit, query_count = %d termination_count = %d\n",
+			    __func__, query_count, termination_count));
 
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
@@ -7557,13 +7477,13 @@ _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
 		(Mpi2EventDataSasDiscovery_t *) fw_event->event_data;
 
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
-		pr_info(MPT3SAS_FMT "discovery event: (%s)", ioc->name,
-		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
-		    "start" : "stop");
+		ioc_info(ioc, "discovery event: (%s)",
+			 event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED ?
+			 "start" : "stop");
 		if (event_data->DiscoveryStatus)
-			pr_info("discovery_status(0x%08x)",
-			    le32_to_cpu(event_data->DiscoveryStatus));
-		pr_info("\n");
+			pr_cont("discovery_status(0x%08x)",
+				le32_to_cpu(event_data->DiscoveryStatus));
+		pr_cont("\n");
 	}
 
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED &&
@@ -7593,20 +7513,16 @@ _scsih_sas_device_discovery_error_event(struct MPT3SAS_ADAPTER *ioc,
 
 	switch (event_data->ReasonCode) {
 	case MPI25_EVENT_SAS_DISC_ERR_SMP_FAILED:
-		pr_warn(MPT3SAS_FMT "SMP command sent to the expander"
-			"(handle:0x%04x, sas_address:0x%016llx,"
-			"physical_port:0x%02x) has failed",
-			ioc->name, le16_to_cpu(event_data->DevHandle),
-			(unsigned long long)le64_to_cpu(event_data->SASAddress),
-			event_data->PhysicalPort);
+		ioc_warn(ioc, "SMP command sent to the expander (handle:0x%04x, sas_address:0x%016llx, physical_port:0x%02x) has failed\n",
+			 le16_to_cpu(event_data->DevHandle),
+			 (u64)le64_to_cpu(event_data->SASAddress),
+			 event_data->PhysicalPort);
 		break;
 	case MPI25_EVENT_SAS_DISC_ERR_SMP_TIMEOUT:
-		pr_warn(MPT3SAS_FMT "SMP command sent to the expander"
-			"(handle:0x%04x, sas_address:0x%016llx,"
-			"physical_port:0x%02x) has timed out",
-			ioc->name, le16_to_cpu(event_data->DevHandle),
-			(unsigned long long)le64_to_cpu(event_data->SASAddress),
-			event_data->PhysicalPort);
+		ioc_warn(ioc, "SMP command sent to the expander (handle:0x%04x, sas_address:0x%016llx, physical_port:0x%02x) has timed out\n",
+			 le16_to_cpu(event_data->DevHandle),
+			 (u64)le64_to_cpu(event_data->SASAddress),
+			 event_data->PhysicalPort);
 		break;
 	default:
 		break;
@@ -7629,11 +7545,10 @@ _scsih_pcie_enumeration_event(struct MPT3SAS_ADAPTER *ioc,
 	if (!(ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK))
 		return;
 
-	pr_info(MPT3SAS_FMT "pcie enumeration event: (%s) Flag 0x%02x",
-		ioc->name,
-		(event_data->ReasonCode == MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
-			"started" : "completed",
-		event_data->Flags);
+	ioc_info(ioc, "pcie enumeration event: (%s) Flag 0x%02x",
+		 (event_data->ReasonCode == MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
+		 "started" : "completed",
+		 event_data->Flags);
 	if (event_data->EnumerationStatus)
 		pr_cont("enumeration_status(0x%08x)",
 			le32_to_cpu(event_data->EnumerationStatus));
@@ -7665,8 +7580,7 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 	mutex_lock(&ioc->scsih_cmds.mutex);
 
 	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: scsih_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: scsih_cmd in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -7674,8 +7588,7 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
 		rc = -EAGAIN;
 		goto out;
@@ -7689,9 +7602,9 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 	mpi_request->Action = MPI2_RAID_ACTION_PHYSDISK_HIDDEN;
 	mpi_request->PhysDiskNum = phys_disk_num;
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT "IR RAID_ACTION: turning fast "\
-	    "path on for handle(0x%04x), phys_disk_num (0x%02x)\n", ioc->name,
-	    handle, phys_disk_num));
+	dewtprintk(ioc,
+		   ioc_info(ioc, "IR RAID_ACTION: turning fast path on for handle(0x%04x), phys_disk_num (0x%02x)\n",
+			    handle, phys_disk_num));
 
 	init_completion(&ioc->scsih_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
@@ -7716,15 +7629,13 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 			log_info = 0;
 		ioc_status &= MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "IR RAID_ACTION: failed: ioc_status(0x%04x), "
-			    "loginfo(0x%08x)!!!\n", ioc->name, ioc_status,
-			    log_info));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "IR RAID_ACTION: failed: ioc_status(0x%04x), loginfo(0x%08x)!!!\n",
+					    ioc_status, log_info));
 			rc = -EFAULT;
 		} else
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "IR RAID_ACTION: completed successfully\n",
-			    ioc->name));
+			dewtprintk(ioc,
+				   ioc_info(ioc, "IR RAID_ACTION: completed successfully\n"));
 	}
 
  out:
@@ -7769,9 +7680,8 @@ _scsih_sas_volume_add(struct MPT3SAS_ADAPTER *ioc,
 
 	mpt3sas_config_get_volume_wwid(ioc, handle, &wwid);
 	if (!wwid) {
-		pr_err(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name,
-		    __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
@@ -7784,9 +7694,8 @@ _scsih_sas_volume_add(struct MPT3SAS_ADAPTER *ioc,
 
 	raid_device = kzalloc(sizeof(struct _raid_device), GFP_KERNEL);
 	if (!raid_device) {
-		pr_err(MPT3SAS_FMT
-		    "failure at %s:%d/%s()!\n", ioc->name,
-		    __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
@@ -7829,9 +7738,8 @@ _scsih_sas_volume_delete(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			sas_target_priv_data = starget->hostdata;
 			sas_target_priv_data->deleted = 1;
 		}
-		pr_info(MPT3SAS_FMT "removing handle(0x%04x), wwid(0x%016llx)\n",
-			ioc->name,  raid_device->handle,
-		    (unsigned long long) raid_device->wwid);
+		ioc_info(ioc, "removing handle(0x%04x), wwid(0x%016llx)\n",
+			 raid_device->handle, (u64)raid_device->wwid);
 		list_del(&raid_device->list);
 		kfree(raid_device);
 	}
@@ -7973,16 +7881,16 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return;
 	}
 
@@ -8012,10 +7920,10 @@ _scsih_sas_ir_config_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
 
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
 
-	pr_info(MPT3SAS_FMT "raid config change: (%s), elements(%d)\n",
-	    ioc->name, (le32_to_cpu(event_data->Flags) &
-	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ?
-	    "foreign" : "native", event_data->NumElements);
+	ioc_info(ioc, "raid config change: (%s), elements(%d)\n",
+		 le32_to_cpu(event_data->Flags) & MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG ?
+		 "foreign" : "native",
+		 event_data->NumElements);
 	for (i = 0; i < event_data->NumElements; i++, element++) {
 		switch (element->ReasonCode) {
 		case MPI2_EVENT_IR_CHANGE_RC_ADDED:
@@ -8171,10 +8079,11 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
 	handle = le16_to_cpu(event_data->VolDevHandle);
 	state = le32_to_cpu(event_data->NewValue);
 	if (!ioc->hide_ir_msg)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
-		    ioc->name, __func__,  handle,
-		    le32_to_cpu(event_data->PreviousValue), state));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+				    __func__, handle,
+				    le32_to_cpu(event_data->PreviousValue),
+				    state));
 	switch (state) {
 	case MPI2_RAID_VOL_STATE_MISSING:
 	case MPI2_RAID_VOL_STATE_FAILED:
@@ -8194,17 +8103,15 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
 
 		mpt3sas_config_get_volume_wwid(ioc, handle, &wwid);
 		if (!wwid) {
-			pr_err(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name,
-			    __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			break;
 		}
 
 		raid_device = kzalloc(sizeof(struct _raid_device), GFP_KERNEL);
 		if (!raid_device) {
-			pr_err(MPT3SAS_FMT
-			    "failure at %s:%d/%s()!\n", ioc->name,
-			    __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			break;
 		}
 
@@ -8255,10 +8162,11 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 	state = le32_to_cpu(event_data->NewValue);
 
 	if (!ioc->hide_ir_msg)
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
-		    ioc->name, __func__,  handle,
-		    le32_to_cpu(event_data->PreviousValue), state));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+				    __func__, handle,
+				    le32_to_cpu(event_data->PreviousValue),
+				    state));
 
 	switch (state) {
 	case MPI2_RAID_PD_STATE_ONLINE:
@@ -8279,16 +8187,16 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 		if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
 		    handle))) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			return;
 		}
 
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			return;
 		}
 
@@ -8342,11 +8250,10 @@ _scsih_sas_ir_operation_status_event_debug(struct MPT3SAS_ADAPTER *ioc,
 	if (!reason_str)
 		return;
 
-	pr_info(MPT3SAS_FMT "raid operational status: (%s)" \
-	    "\thandle(0x%04x), percent complete(%d)\n",
-	    ioc->name, reason_str,
-	    le16_to_cpu(event_data->VolDevHandle),
-	    event_data->PercentComplete);
+	ioc_info(ioc, "raid operational status: (%s)\thandle(0x%04x), percent complete(%d)\n",
+		 reason_str,
+		 le16_to_cpu(event_data->VolDevHandle),
+		 event_data->PercentComplete);
 }
 
 /**
@@ -8427,9 +8334,8 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 			mpt3sas_scsih_enclosure_find_by_handle(ioc,
 				le16_to_cpu(sas_device_pg0->EnclosureHandle));
 		if (enclosure_dev == NULL)
-			pr_info(MPT3SAS_FMT "Enclosure handle(0x%04x)"
-			    "doesn't match with enclosure device!\n",
-			    ioc->name, sas_device_pg0->EnclosureHandle);
+			ioc_info(ioc, "Enclosure handle(0x%04x) doesn't match with enclosure device!\n",
+				 sas_device_pg0->EnclosureHandle);
 	}
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
@@ -8523,8 +8429,7 @@ _scsih_create_enclosure_list_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		enclosure_dev =
 			kzalloc(sizeof(struct _enclosure_node), GFP_KERNEL);
 		if (!enclosure_dev) {
-			pr_err(MPT3SAS_FMT
-				"failure at %s:%d/%s()!\n", ioc->name,
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
 				__FILE__, __LINE__, __func__);
 			return;
 		}
@@ -8561,7 +8466,7 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 	u16 handle;
 	u32 device_info;
 
-	pr_info(MPT3SAS_FMT "search for end-devices: start\n", ioc->name);
+	ioc_info(ioc, "search for end-devices: start\n");
 
 	if (list_empty(&ioc->sas_device_list))
 		goto out;
@@ -8582,8 +8487,7 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 	}
 
  out:
-	pr_info(MPT3SAS_FMT "search for end-devices: complete\n",
-	    ioc->name);
+	ioc_info(ioc, "search for end-devices: complete\n");
 }
 
 /**
@@ -8676,7 +8580,7 @@ _scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
 	u16 handle;
 	u32 device_info;
 
-	pr_info(MPT3SAS_FMT "search for end-devices: start\n", ioc->name);
+	ioc_info(ioc, "search for end-devices: start\n");
 
 	if (list_empty(&ioc->pcie_device_list))
 		goto out;
@@ -8688,10 +8592,9 @@ _scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from %s: "
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n", ioc->name,
-			    __func__, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from %s: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 __func__, ioc_status,
+				 le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		handle = le16_to_cpu(pcie_device_pg0.DevHandle);
@@ -8701,8 +8604,7 @@ _scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
 		_scsih_mark_responding_pcie_device(ioc, &pcie_device_pg0);
 	}
 out:
-	pr_info(MPT3SAS_FMT "search for PCIe end-devices: complete\n",
-	    ioc->name);
+	ioc_info(ioc, "search for PCIe end-devices: complete\n");
 }
 
 /**
@@ -8783,8 +8685,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->ir_firmware)
 		return;
 
-	pr_info(MPT3SAS_FMT "search for raid volumes: start\n",
-	    ioc->name);
+	ioc_info(ioc, "search for raid volumes: start\n");
 
 	if (list_empty(&ioc->raid_device_list))
 		goto out;
@@ -8827,8 +8728,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 		}
 	}
  out:
-	pr_info(MPT3SAS_FMT "search for responding raid volumes: complete\n",
-		ioc->name);
+	ioc_info(ioc, "search for responding raid volumes: complete\n");
 }
 
 /**
@@ -8900,7 +8800,7 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 	u64 sas_address;
 	u16 handle;
 
-	pr_info(MPT3SAS_FMT "search for expanders: start\n", ioc->name);
+	ioc_info(ioc, "search for expanders: start\n");
 
 	if (list_empty(&ioc->sas_expander_list))
 		goto out;
@@ -8923,7 +8823,7 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 	}
 
  out:
-	pr_info(MPT3SAS_FMT "search for expanders: complete\n", ioc->name);
+	ioc_info(ioc, "search for expanders: complete\n");
 }
 
 /**
@@ -8941,12 +8841,10 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	unsigned long flags;
 	LIST_HEAD(head);
 
-	pr_info(MPT3SAS_FMT "removing unresponding devices: start\n",
-	    ioc->name);
+	ioc_info(ioc, "removing unresponding devices: start\n");
 
 	/* removing unresponding end devices */
-	pr_info(MPT3SAS_FMT "removing unresponding devices: end-devices\n",
-	    ioc->name);
+	ioc_info(ioc, "removing unresponding devices: end-devices\n");
 	/*
 	 * Iterate, pulling off devices marked as non-responding. We become the
 	 * owner for the reference the list had on any object we prune.
@@ -8970,9 +8868,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 		sas_device_put(sas_device);
 	}
 
-	pr_info(MPT3SAS_FMT
-		" Removing unresponding devices: pcie end-devices\n"
-		, ioc->name);
+	ioc_info(ioc, "Removing unresponding devices: pcie end-devices\n");
 	INIT_LIST_HEAD(&head);
 	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
 	list_for_each_entry_safe(pcie_device, pcie_device_next,
@@ -8992,8 +8888,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 
 	/* removing unresponding volumes */
 	if (ioc->ir_firmware) {
-		pr_info(MPT3SAS_FMT "removing unresponding devices: volumes\n",
-			ioc->name);
+		ioc_info(ioc, "removing unresponding devices: volumes\n");
 		list_for_each_entry_safe(raid_device, raid_device_next,
 		    &ioc->raid_device_list, list) {
 			if (!raid_device->responding)
@@ -9005,8 +8900,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	/* removing unresponding expanders */
-	pr_info(MPT3SAS_FMT "removing unresponding devices: expanders\n",
-	    ioc->name);
+	ioc_info(ioc, "removing unresponding devices: expanders\n");
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	INIT_LIST_HEAD(&tmp_list);
 	list_for_each_entry_safe(sas_expander, sas_expander_next,
@@ -9022,8 +8916,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 		_scsih_expander_node_remove(ioc, sas_expander);
 	}
 
-	pr_info(MPT3SAS_FMT "removing unresponding devices: complete\n",
-	    ioc->name);
+	ioc_info(ioc, "removing unresponding devices: complete\n");
 
 	/* unblock devices */
 	_scsih_ublock_io_all_device(ioc);
@@ -9040,8 +8933,8 @@ _scsih_refresh_expander_links(struct MPT3SAS_ADAPTER *ioc,
 	for (i = 0 ; i < sas_expander->num_phys ; i++) {
 		if ((mpt3sas_config_get_expander_pg1(ioc, &mpi_reply,
 		    &expander_pg1, i, handle))) {
-			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				__FILE__, __LINE__, __func__);
 			return;
 		}
 
@@ -9077,11 +8970,11 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	u8 retry_count;
 	unsigned long flags;
 
-	pr_info(MPT3SAS_FMT "scan devices: start\n", ioc->name);
+	ioc_info(ioc, "scan devices: start\n");
 
 	_scsih_sas_host_refresh(ioc);
 
-	pr_info(MPT3SAS_FMT "\tscan devices: expanders start\n", ioc->name);
+	ioc_info(ioc, "\tscan devices: expanders start\n");
 
 	/* expanders */
 	handle = 0xFFFF;
@@ -9090,10 +8983,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from expander scan: " \
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from expander scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		handle = le16_to_cpu(expander_pg0.DevHandle);
@@ -9105,25 +8996,22 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			_scsih_refresh_expander_links(ioc, expander_device,
 			    handle);
 		else {
-			pr_info(MPT3SAS_FMT "\tBEFORE adding expander: " \
-			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
-			    handle, (unsigned long long)
-			    le64_to_cpu(expander_pg0.SASAddress));
+			ioc_info(ioc, "\tBEFORE adding expander: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(expander_pg0.SASAddress));
 			_scsih_expander_add(ioc, handle);
-			pr_info(MPT3SAS_FMT "\tAFTER adding expander: " \
-			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
-			    handle, (unsigned long long)
-			    le64_to_cpu(expander_pg0.SASAddress));
+			ioc_info(ioc, "\tAFTER adding expander: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(expander_pg0.SASAddress));
 		}
 	}
 
-	pr_info(MPT3SAS_FMT "\tscan devices: expanders complete\n",
-	    ioc->name);
+	ioc_info(ioc, "\tscan devices: expanders complete\n");
 
 	if (!ioc->ir_firmware)
 		goto skip_to_sas;
 
-	pr_info(MPT3SAS_FMT "\tscan devices: phys disk start\n", ioc->name);
+	ioc_info(ioc, "\tscan devices: phys disk start\n");
 
 	/* phys disk */
 	phys_disk_num = 0xFF;
@@ -9133,10 +9021,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan: "\
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from phys disk scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
@@ -9153,19 +9039,16 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan " \
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from phys disk scan ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle,
 		    &sas_address)) {
-			pr_info(MPT3SAS_FMT "\tBEFORE adding phys disk: " \
-			    " handle (0x%04x), sas_addr(0x%016llx)\n",
-			    ioc->name, handle, (unsigned long long)
-			    le64_to_cpu(sas_device_pg0.SASAddress));
+			ioc_info(ioc, "\tBEFORE adding phys disk: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt3sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5);
@@ -9179,17 +9062,15 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			    1)) {
 				ssleep(1);
 			}
-			pr_info(MPT3SAS_FMT "\tAFTER adding phys disk: " \
-			    " handle (0x%04x), sas_addr(0x%016llx)\n",
-			    ioc->name, handle, (unsigned long long)
-			    le64_to_cpu(sas_device_pg0.SASAddress));
+			ioc_info(ioc, "\tAFTER adding phys disk: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
-	pr_info(MPT3SAS_FMT "\tscan devices: phys disk complete\n",
-	    ioc->name);
+	ioc_info(ioc, "\tscan devices: phys disk complete\n");
 
-	pr_info(MPT3SAS_FMT "\tscan devices: volumes start\n", ioc->name);
+	ioc_info(ioc, "\tscan devices: volumes start\n");
 
 	/* volumes */
 	handle = 0xFFFF;
@@ -9198,10 +9079,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from volume scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		handle = le16_to_cpu(volume_pg1.DevHandle);
@@ -9218,10 +9097,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
-			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from volume scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
@@ -9230,23 +9107,19 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
 			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
 			element.VolDevHandle = volume_pg1.DevHandle;
-			pr_info(MPT3SAS_FMT
-				"\tBEFORE adding volume: handle (0x%04x)\n",
-				ioc->name, volume_pg1.DevHandle);
+			ioc_info(ioc, "\tBEFORE adding volume: handle (0x%04x)\n",
+				 volume_pg1.DevHandle);
 			_scsih_sas_volume_add(ioc, &element);
-			pr_info(MPT3SAS_FMT
-				"\tAFTER adding volume: handle (0x%04x)\n",
-				ioc->name, volume_pg1.DevHandle);
+			ioc_info(ioc, "\tAFTER adding volume: handle (0x%04x)\n",
+				 volume_pg1.DevHandle);
 		}
 	}
 
-	pr_info(MPT3SAS_FMT "\tscan devices: volumes complete\n",
-	    ioc->name);
+	ioc_info(ioc, "\tscan devices: volumes complete\n");
 
  skip_to_sas:
 
-	pr_info(MPT3SAS_FMT "\tscan devices: end devices start\n",
-	    ioc->name);
+	ioc_info(ioc, "\tscan devices: end devices start\n");
 
 	/* sas devices */
 	handle = 0xFFFF;
@@ -9256,10 +9129,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from end device scan:"\
-			    " ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, ioc_status,
-			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from end device scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
@@ -9274,10 +9145,9 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
-			pr_info(MPT3SAS_FMT "\tBEFORE adding end device: " \
-			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
-			    handle, (unsigned long long)
-			    le64_to_cpu(sas_device_pg0.SASAddress));
+			ioc_info(ioc, "\tBEFORE adding end device: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
 			retry_count = 0;
@@ -9289,16 +9159,13 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			    0)) {
 				ssleep(1);
 			}
-			pr_info(MPT3SAS_FMT "\tAFTER adding end device: " \
-			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
-			    handle, (unsigned long long)
-			    le64_to_cpu(sas_device_pg0.SASAddress));
+			ioc_info(ioc, "\tAFTER adding end device: handle (0x%04x), sas_addr(0x%016llx)\n",
+				 handle,
+				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
-	pr_info(MPT3SAS_FMT "\tscan devices: end devices complete\n",
-	    ioc->name);
-	pr_info(MPT3SAS_FMT "\tscan devices: pcie end devices start\n",
-	    ioc->name);
+	ioc_info(ioc, "\tscan devices: end devices complete\n");
+	ioc_info(ioc, "\tscan devices: pcie end devices start\n");
 
 	/* pcie devices */
 	handle = 0xFFFF;
@@ -9308,10 +9175,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus)
 				& MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			pr_info(MPT3SAS_FMT "\tbreak from pcie end device"
-				" scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
-				ioc->name, ioc_status,
-				le32_to_cpu(mpi_reply.IOCLogInfo));
+			ioc_info(ioc, "\tbreak from pcie end device scan: ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
 		handle = le16_to_cpu(pcie_device_pg0.DevHandle);
@@ -9328,14 +9193,11 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		parent_handle = le16_to_cpu(pcie_device_pg0.ParentDevHandle);
 		_scsih_pcie_add_device(ioc, handle);
 
-		pr_info(MPT3SAS_FMT "\tAFTER adding pcie end device: "
-			"handle (0x%04x), wwid(0x%016llx)\n", ioc->name,
-			handle,
-			(unsigned long long) le64_to_cpu(pcie_device_pg0.WWID));
+		ioc_info(ioc, "\tAFTER adding pcie end device: handle (0x%04x), wwid(0x%016llx)\n",
+			 handle, (u64)le64_to_cpu(pcie_device_pg0.WWID));
 	}
-	pr_info(MPT3SAS_FMT "\tpcie devices: pcie end devices complete\n",
-		ioc->name);
-	pr_info(MPT3SAS_FMT "scan devices: complete\n", ioc->name);
+	ioc_info(ioc, "\tpcie devices: pcie end devices complete\n");
+	ioc_info(ioc, "scan devices: complete\n");
 }
 
 /**
@@ -9346,8 +9208,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
  */
 void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_PRE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_PRE_RESET\n", __func__));
 }
 
 /**
@@ -9359,8 +9220,7 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_scsih_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_AFTER_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
 	if (ioc->scsih_cmds.status & MPT3_CMD_PENDING) {
 		ioc->scsih_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->scsih_cmds.smid);
@@ -9388,8 +9248,7 @@ mpt3sas_scsih_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: MPT3_IOC_DONE_RESET\n", ioc->name, __func__));
+	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
 	if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
 					   !ioc->sas_hba.num_phys)) {
 		_scsih_prep_device_scan(ioc);
@@ -9444,9 +9303,8 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		if (missing_delay[0] != -1 && missing_delay[1] != -1)
 			mpt3sas_base_update_missing_delay(ioc, missing_delay[0],
 			    missing_delay[1]);
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"port enable: complete from worker thread\n",
-			ioc->name));
+		dewtprintk(ioc,
+			   ioc_info(ioc, "port enable: complete from worker thread\n"));
 		break;
 	case MPT3SAS_TURN_ON_PFA_LED:
 		_scsih_turn_on_pfa_led(ioc, fw_event->device_handle);
@@ -9544,8 +9402,8 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
 	if (unlikely(!mpi_reply)) {
-		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 1;
 	}
 
@@ -9612,30 +9470,16 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 
 		switch (le32_to_cpu(*log_code)) {
 		case MPT2_WARPDRIVE_LC_SSDT:
-			pr_warn(MPT3SAS_FMT "WarpDrive Warning: "
-			    "IO Throttling has occurred in the WarpDrive "
-			    "subsystem. Check WarpDrive documentation for "
-			    "additional details.\n", ioc->name);
+			ioc_warn(ioc, "WarpDrive Warning: IO Throttling has occurred in the WarpDrive subsystem. Check WarpDrive documentation for additional details.\n");
 			break;
 		case MPT2_WARPDRIVE_LC_SSDLW:
-			pr_warn(MPT3SAS_FMT "WarpDrive Warning: "
-			    "Program/Erase Cycles for the WarpDrive subsystem "
-			    "in degraded range. Check WarpDrive documentation "
-			    "for additional details.\n", ioc->name);
+			ioc_warn(ioc, "WarpDrive Warning: Program/Erase Cycles for the WarpDrive subsystem in degraded range. Check WarpDrive documentation for additional details.\n");
 			break;
 		case MPT2_WARPDRIVE_LC_SSDLF:
-			pr_err(MPT3SAS_FMT "WarpDrive Fatal Error: "
-			    "There are no Program/Erase Cycles for the "
-			    "WarpDrive subsystem. The storage device will be "
-			    "in read-only mode. Check WarpDrive documentation "
-			    "for additional details.\n", ioc->name);
+			ioc_err(ioc, "WarpDrive Fatal Error: There are no Program/Erase Cycles for the WarpDrive subsystem. The storage device will be in read-only mode. Check WarpDrive documentation for additional details.\n");
 			break;
 		case MPT2_WARPDRIVE_LC_BRMF:
-			pr_err(MPT3SAS_FMT "WarpDrive Fatal Error: "
-			    "The Backup Rail Monitor has failed on the "
-			    "WarpDrive subsystem. Check WarpDrive "
-			    "documentation for additional details.\n",
-			    ioc->name);
+			ioc_err(ioc, "WarpDrive Fatal Error: The Backup Rail Monitor has failed on the WarpDrive subsystem. Check WarpDrive documentation for additional details.\n");
 			break;
 		}
 
@@ -9661,9 +9505,8 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
 		switch (ActiveCableEventData->ReasonCode) {
 		case MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER:
-			pr_notice(MPT3SAS_FMT
-			    "Currently an active cable with ReceptacleID %d\n",
-			    ioc->name, ActiveCableEventData->ReceptacleID);
+			ioc_notice(ioc, "Currently an active cable with ReceptacleID %d\n",
+				   ActiveCableEventData->ReceptacleID);
 			pr_notice("cannot be powered and devices connected\n");
 			pr_notice("to this active cable will not be seen\n");
 			pr_notice("This active cable requires %d mW of power\n",
@@ -9671,9 +9514,8 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 			break;
 
 		case MPI26_EVENT_ACTIVE_CABLE_DEGRADED:
-			pr_notice(MPT3SAS_FMT
-			    "Currently a cable with ReceptacleID %d\n",
-			    ioc->name, ActiveCableEventData->ReceptacleID);
+			ioc_notice(ioc, "Currently a cable with ReceptacleID %d\n",
+				   ActiveCableEventData->ReceptacleID);
 			pr_notice(
 			    "is not running at optimal speed(12 Gb/s rate)\n");
 			break;
@@ -9688,8 +9530,8 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
 	fw_event = alloc_fw_event_work(sz);
 	if (!fw_event) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return 1;
 	}
 
@@ -9738,11 +9580,9 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
 	    sas_expander->sas_address_parent);
 
-	pr_info(MPT3SAS_FMT
-		"expander_remove: handle(0x%04x), sas_addr(0x%016llx)\n",
-		ioc->name,
-	    sas_expander->handle, (unsigned long long)
-	    sas_expander->sas_address);
+	ioc_info(ioc, "expander_remove: handle(0x%04x), sas_addr(0x%016llx)\n",
+		 sas_expander->handle, (unsigned long long)
+		 sas_expander->sas_address);
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);
@@ -9777,16 +9617,14 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	mutex_lock(&ioc->scsih_cmds.mutex);
 
 	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: scsih_cmd in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: scsih_cmd in use\n", __func__);
 		goto out;
 	}
 	ioc->scsih_cmds.status = MPT3_CMD_PENDING;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
 		goto out;
 	}
@@ -9799,24 +9637,22 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Action = MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED;
 
 	if (!ioc->hide_ir_msg)
-		pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
+		ioc_info(ioc, "IR shutdown (sending)\n");
 	init_completion(&ioc->scsih_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		goto out;
 	}
 
 	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
 		mpi_reply = ioc->scsih_cmds.reply;
 		if (!ioc->hide_ir_msg)
-			pr_info(MPT3SAS_FMT "IR shutdown "
-			   "(complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
-			    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
-			    le32_to_cpu(mpi_reply->IOCLogInfo));
+			ioc_info(ioc, "IR shutdown (complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
+				 le16_to_cpu(mpi_reply->IOCStatus),
+				 le32_to_cpu(mpi_reply->IOCLogInfo));
 	}
 
  out:
@@ -9866,9 +9702,8 @@ static void scsih_remove(struct pci_dev *pdev)
 			sas_target_priv_data->deleted = 1;
 			scsi_remove_target(&raid_device->starget->dev);
 		}
-		pr_info(MPT3SAS_FMT "removing handle(0x%04x), wwid(0x%016llx)\n",
-			ioc->name,  raid_device->handle,
-		    (unsigned long long) raid_device->wwid);
+		ioc_info(ioc, "removing handle(0x%04x), wwid(0x%016llx)\n",
+			 raid_device->handle, (u64)raid_device->wwid);
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
 	list_for_each_entry_safe(pcie_device, pcienext, &ioc->pcie_device_list,
@@ -10278,7 +10113,7 @@ scsih_scan_start(struct Scsi_Host *shost)
 	rc = mpt3sas_port_enable(ioc);
 
 	if (rc != 0)
-		pr_info(MPT3SAS_FMT "port enable: FAILED\n", ioc->name);
+		ioc_info(ioc, "port enable: FAILED\n");
 }
 
 /**
@@ -10303,9 +10138,7 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 
 	if (time >= (300 * HZ)) {
 		ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
-		pr_info(MPT3SAS_FMT
-			"port enable: FAILED with timeout (timeout=300s)\n",
-			ioc->name);
+		ioc_info(ioc, "port enable: FAILED with timeout (timeout=300s)\n");
 		ioc->is_driver_loading = 0;
 		return 1;
 	}
@@ -10314,16 +10147,15 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 		return 0;
 
 	if (ioc->start_scan_failed) {
-		pr_info(MPT3SAS_FMT
-			"port enable: FAILED with (ioc_status=0x%08x)\n",
-			ioc->name, ioc->start_scan_failed);
+		ioc_info(ioc, "port enable: FAILED with (ioc_status=0x%08x)\n",
+			 ioc->start_scan_failed);
 		ioc->is_driver_loading = 0;
 		ioc->wait_for_discovery_to_complete = 0;
 		ioc->remove_host = 1;
 		return 1;
 	}
 
-	pr_info(MPT3SAS_FMT "port enable: SUCCESS\n", ioc->name);
+	ioc_info(ioc, "port enable: SUCCESS\n");
 	ioc->port_enable_cmds.status = MPT3_CMD_NOT_USED;
 
 	if (ioc->wait_for_discovery_to_complete) {
@@ -10634,28 +10466,22 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ioc->is_mcpu_endpoint) {
 		/* mCPU MPI support 64K max IO */
 		shost->max_sectors = 128;
-		pr_info(MPT3SAS_FMT
-				"The max_sectors value is set to %d\n",
-				ioc->name, shost->max_sectors);
+		ioc_info(ioc, "The max_sectors value is set to %d\n",
+			 shost->max_sectors);
 	} else {
 		if (max_sectors != 0xFFFF) {
 			if (max_sectors < 64) {
 				shost->max_sectors = 64;
-				pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
-				    "for max_sectors, range is 64 to 32767. " \
-				    "Assigning value of 64.\n", \
-				    ioc->name, max_sectors);
+				ioc_warn(ioc, "Invalid value %d passed for max_sectors, range is 64 to 32767. Assigning value of 64.\n",
+					 max_sectors);
 			} else if (max_sectors > 32767) {
 				shost->max_sectors = 32767;
-				pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
-				    "for max_sectors, range is 64 to 32767." \
-				    "Assigning default value of 32767.\n", \
-				    ioc->name, max_sectors);
+				ioc_warn(ioc, "Invalid value %d passed for max_sectors, range is 64 to 32767.Assigning default value of 32767.\n",
+					 max_sectors);
 			} else {
 				shost->max_sectors = max_sectors & 0xFFFE;
-				pr_info(MPT3SAS_FMT
-					"The max_sectors value is set to %d\n",
-					ioc->name, shost->max_sectors);
+				ioc_info(ioc, "The max_sectors value is set to %d\n",
+					 shost->max_sectors);
 			}
 		}
 	}
@@ -10675,16 +10501,16 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->firmware_event_thread = alloc_ordered_workqueue(
 	    ioc->firmware_event_name, 0);
 	if (!ioc->firmware_event_thread) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rv = -ENODEV;
 		goto out_thread_fail;
 	}
 
 	ioc->is_driver_loading = 1;
 	if ((mpt3sas_base_attach(ioc))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rv = -ENODEV;
 		goto out_attach_fail;
 	}
@@ -10705,8 +10531,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rv = scsi_add_host(shost, &pdev->dev);
 	if (rv) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_add_shost_fail;
 	}
 
@@ -10743,9 +10569,8 @@ scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	flush_scheduled_work();
 	scsi_block_requests(shost);
 	device_state = pci_choose_state(pdev, state);
-	pr_info(MPT3SAS_FMT
-		"pdev=0x%p, slot=%s, entering operating state [D%d]\n",
-		ioc->name, pdev, pci_name(pdev), device_state);
+	ioc_info(ioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
+		 pdev, pci_name(pdev), device_state);
 
 	pci_save_state(pdev);
 	mpt3sas_base_free_resources(ioc);
@@ -10767,9 +10592,8 @@ scsih_resume(struct pci_dev *pdev)
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
-	pr_info(MPT3SAS_FMT
-		"pdev=0x%p, slot=%s, previous operating state [D%d]\n",
-		ioc->name, pdev, pci_name(pdev), device_state);
+	ioc_info(ioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
+		 pdev, pci_name(pdev), device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
@@ -10801,8 +10625,7 @@ scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	pr_info(MPT3SAS_FMT "PCI error: detected callback, state(%d)!!\n",
-	    ioc->name, state);
+	ioc_info(ioc, "PCI error: detected callback, state(%d)!!\n", state);
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -10839,8 +10662,7 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	int rc;
 
-	pr_info(MPT3SAS_FMT "PCI error: slot reset callback!!\n",
-	     ioc->name);
+	ioc_info(ioc, "PCI error: slot reset callback!!\n");
 
 	ioc->pci_error_recovery = 0;
 	ioc->pdev = pdev;
@@ -10851,8 +10673,8 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
 
 	rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 
-	pr_warn(MPT3SAS_FMT "hard reset: %s\n", ioc->name,
-	    (rc == 0) ? "success" : "failed");
+	ioc_warn(ioc, "hard reset: %s\n",
+		 (rc == 0) ? "success" : "failed");
 
 	if (!rc)
 		return PCI_ERS_RESULT_RECOVERED;
@@ -10874,7 +10696,7 @@ scsih_pci_resume(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	pr_info(MPT3SAS_FMT "PCI error: resume callback!!\n", ioc->name);
+	ioc_info(ioc, "PCI error: resume callback!!\n");
 
 	pci_cleanup_aer_uncorrect_error_status(pdev);
 	mpt3sas_base_start_watchdog(ioc);
@@ -10891,8 +10713,7 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
-	pr_info(MPT3SAS_FMT "PCI error: mmio enabled callback!!\n",
-	    ioc->name);
+	ioc_info(ioc, "PCI error: mmio enabled callback!!\n");
 
 	/* TODO - dump whatever for debugging purposes */
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 20d36061c217..9fd89e85227a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -153,18 +153,16 @@ _transport_set_identify(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -ENXIO;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT
-			"handle(0x%04x), ioc_status(0x%04x)\nfailure at %s:%d/%s()!\n",
-			ioc->name, handle, ioc_status,
-		     __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "handle(0x%04x), ioc_status(0x%04x) failure at %s:%d/%s()!\n",
+			handle, ioc_status, __FILE__, __LINE__, __func__);
 		return -EIO;
 	}
 
@@ -318,8 +316,7 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	mutex_lock(&ioc->transport_cmds.mutex);
 
 	if (ioc->transport_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: transport_cmds in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: transport_cmds in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -329,26 +326,22 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -388,16 +381,15 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
 	    data_in_sz);
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"report_manufacture - send to sas_addr(0x%016llx)\n",
-		ioc->name, (unsigned long long)sas_address));
+	dtransportprintk(ioc,
+			 ioc_info(ioc, "report_manufacture - send to sas_addr(0x%016llx)\n",
+				  (u64)sas_address));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT3_CMD_RESET))
@@ -405,17 +397,16 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 		goto issue_host_reset;
 	}
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"report_manufacture - complete\n", ioc->name));
+	dtransportprintk(ioc, ioc_info(ioc, "report_manufacture - complete\n"));
 
 	if (ioc->transport_cmds.status & MPT3_CMD_REPLY_VALID) {
 		u8 *tmp;
 
 		mpi_reply = ioc->transport_cmds.reply;
 
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "report_manufacture - reply data transfer size(%d)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->ResponseDataLength)));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "report_manufacture - reply data transfer size(%d)\n",
+					  le16_to_cpu(mpi_reply->ResponseDataLength)));
 
 		if (le16_to_cpu(mpi_reply->ResponseDataLength) !=
 		    sizeof(struct rep_manu_reply))
@@ -439,8 +430,8 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 			    manufacture_reply->component_revision_id;
 		}
 	} else
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "report_manufacture - no reply\n", ioc->name));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "report_manufacture - no reply\n"));
 
  issue_host_reset:
 	if (issue_reset)
@@ -643,8 +634,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	mpt3sas_port = kzalloc(sizeof(struct _sas_port),
 	    GFP_KERNEL);
 	if (!mpt3sas_port) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return NULL;
 	}
 
@@ -655,22 +646,21 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	if (!sas_node) {
-		pr_err(MPT3SAS_FMT
-			"%s: Could not find parent sas_address(0x%016llx)!\n",
-			ioc->name, __func__, (unsigned long long)sas_address);
+		ioc_err(ioc, "%s: Could not find parent sas_address(0x%016llx)!\n",
+			__func__, (u64)sas_address);
 		goto out_fail;
 	}
 
 	if ((_transport_set_identify(ioc, handle,
 	    &mpt3sas_port->remote_identify))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_fail;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_PHY_UNUSED) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_fail;
 	}
 
@@ -687,20 +677,20 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	if (!mpt3sas_port->num_phys) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_fail;
 	}
 
 	if (!sas_node->parent_dev) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
 	if ((sas_port_add(port))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		goto out_fail;
 	}
 
@@ -738,8 +728,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	if ((sas_rphy_add(rphy))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -864,14 +854,14 @@ mpt3sas_transport_add_host_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	INIT_LIST_HEAD(&mpt3sas_phy->port_siblings);
 	phy = sas_phy_alloc(parent_dev, phy_index);
 	if (!phy) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 	if ((_transport_set_identify(ioc, mpt3sas_phy->handle,
 	    &mpt3sas_phy->identify))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		sas_phy_free(phy);
 		return -1;
 	}
@@ -893,8 +883,8 @@ mpt3sas_transport_add_host_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	    phy_pg0.ProgrammedLinkRate >> 4);
 
 	if ((sas_phy_add(phy))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		sas_phy_free(phy);
 		return -1;
 	}
@@ -932,14 +922,14 @@ mpt3sas_transport_add_expander_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	INIT_LIST_HEAD(&mpt3sas_phy->port_siblings);
 	phy = sas_phy_alloc(parent_dev, phy_index);
 	if (!phy) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -1;
 	}
 	if ((_transport_set_identify(ioc, mpt3sas_phy->handle,
 	    &mpt3sas_phy->identify))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		sas_phy_free(phy);
 		return -1;
 	}
@@ -963,8 +953,8 @@ mpt3sas_transport_add_expander_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	    expander_pg1.ProgrammedLinkRate >> 4);
 
 	if ((sas_phy_add(phy))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		sas_phy_free(phy);
 		return -1;
 	}
@@ -1109,8 +1099,7 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	mutex_lock(&ioc->transport_cmds.mutex);
 
 	if (ioc->transport_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: transport_cmds in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: transport_cmds in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1120,26 +1109,22 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1182,17 +1167,16 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	    data_out_dma + sizeof(struct phy_error_log_request),
 	    sizeof(struct phy_error_log_reply));
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"phy_error_log - send to sas_addr(0x%016llx), phy(%d)\n",
-		ioc->name, (unsigned long long)phy->identify.sas_address,
-		phy->number));
+	dtransportprintk(ioc,
+			 ioc_info(ioc, "phy_error_log - send to sas_addr(0x%016llx), phy(%d)\n",
+				  (u64)phy->identify.sas_address,
+				  phy->number));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT3_CMD_RESET))
@@ -1200,16 +1184,15 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 		goto issue_host_reset;
 	}
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"phy_error_log - complete\n", ioc->name));
+	dtransportprintk(ioc, ioc_info(ioc, "phy_error_log - complete\n"));
 
 	if (ioc->transport_cmds.status & MPT3_CMD_REPLY_VALID) {
 
 		mpi_reply = ioc->transport_cmds.reply;
 
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_error_log - reply data transfer size(%d)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->ResponseDataLength)));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_error_log - reply data transfer size(%d)\n",
+					  le16_to_cpu(mpi_reply->ResponseDataLength)));
 
 		if (le16_to_cpu(mpi_reply->ResponseDataLength) !=
 		    sizeof(struct phy_error_log_reply))
@@ -1218,9 +1201,9 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 		phy_error_log_reply = data_out +
 		    sizeof(struct phy_error_log_request);
 
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_error_log - function_result(%d)\n",
-		    ioc->name, phy_error_log_reply->function_result));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_error_log - function_result(%d)\n",
+					  phy_error_log_reply->function_result));
 
 		phy->invalid_dword_count =
 		    be32_to_cpu(phy_error_log_reply->invalid_dword);
@@ -1232,8 +1215,8 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 		    be32_to_cpu(phy_error_log_reply->phy_reset_problem);
 		rc = 0;
 	} else
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_error_log - no reply\n", ioc->name));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_error_log - no reply\n"));
 
  issue_host_reset:
 	if (issue_reset)
@@ -1276,17 +1259,16 @@ _transport_get_linkerrors(struct sas_phy *phy)
 	/* get hba phy error logs */
 	if ((mpt3sas_config_get_phy_pg1(ioc, &mpi_reply, &phy_pg1,
 		    phy->number))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -ENXIO;
 	}
 
 	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo)
-		pr_info(MPT3SAS_FMT
-			"phy(%d), ioc_status (0x%04x), loginfo(0x%08x)\n",
-			ioc->name, phy->number,
-			le16_to_cpu(mpi_reply.IOCStatus),
-		    le32_to_cpu(mpi_reply.IOCLogInfo));
+		ioc_info(ioc, "phy(%d), ioc_status (0x%04x), loginfo(0x%08x)\n",
+			 phy->number,
+			 le16_to_cpu(mpi_reply.IOCStatus),
+			 le32_to_cpu(mpi_reply.IOCLogInfo));
 
 	phy->invalid_dword_count = le32_to_cpu(phy_pg1.InvalidDwordCount);
 	phy->running_disparity_error_count =
@@ -1422,8 +1404,7 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	mutex_lock(&ioc->transport_cmds.mutex);
 
 	if (ioc->transport_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: transport_cmds in use\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: transport_cmds in use\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1433,26 +1414,22 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1500,17 +1477,16 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	    data_out_dma + sizeof(struct phy_control_request),
 	    sizeof(struct phy_control_reply));
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"phy_control - send to sas_addr(0x%016llx), phy(%d), opcode(%d)\n",
-		ioc->name, (unsigned long long)phy->identify.sas_address,
-		phy->number, phy_operation));
+	dtransportprintk(ioc,
+			 ioc_info(ioc, "phy_control - send to sas_addr(0x%016llx), phy(%d), opcode(%d)\n",
+				  (u64)phy->identify.sas_address,
+				  phy->number, phy_operation));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
-		pr_err(MPT3SAS_FMT "%s: timeout\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: timeout\n", __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SmpPassthroughRequest_t)/4);
 		if (!(ioc->transport_cmds.status & MPT3_CMD_RESET))
@@ -1518,16 +1494,15 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 		goto issue_host_reset;
 	}
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"phy_control - complete\n", ioc->name));
+	dtransportprintk(ioc, ioc_info(ioc, "phy_control - complete\n"));
 
 	if (ioc->transport_cmds.status & MPT3_CMD_REPLY_VALID) {
 
 		mpi_reply = ioc->transport_cmds.reply;
 
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_control - reply data transfer size(%d)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->ResponseDataLength)));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_control - reply data transfer size(%d)\n",
+					  le16_to_cpu(mpi_reply->ResponseDataLength)));
 
 		if (le16_to_cpu(mpi_reply->ResponseDataLength) !=
 		    sizeof(struct phy_control_reply))
@@ -1536,14 +1511,14 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 		phy_control_reply = data_out +
 		    sizeof(struct phy_control_request);
 
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_control - function_result(%d)\n",
-		    ioc->name, phy_control_reply->function_result));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_control - function_result(%d)\n",
+					  phy_control_reply->function_result));
 
 		rc = 0;
 	} else
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "phy_control - no reply\n", ioc->name));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "phy_control - no reply\n"));
 
  issue_host_reset:
 	if (issue_reset)
@@ -1594,16 +1569,15 @@ _transport_phy_reset(struct sas_phy *phy, int hard_reset)
 	mpi_request.PhyNum = phy->number;
 
 	if ((mpt3sas_base_sas_iounit_control(ioc, &mpi_reply, &mpi_request))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		return -ENXIO;
 	}
 
 	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo)
-		pr_info(MPT3SAS_FMT
-		"phy(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
-		ioc->name, phy->number, le16_to_cpu(mpi_reply.IOCStatus),
-		    le32_to_cpu(mpi_reply.IOCLogInfo));
+		ioc_info(ioc, "phy(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
+			 phy->number, le16_to_cpu(mpi_reply.IOCStatus),
+			 le32_to_cpu(mpi_reply.IOCLogInfo));
 
 	return 0;
 }
@@ -1650,23 +1624,23 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	    sizeof(Mpi2SasIOUnit0PhyData_t));
 	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg0) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
 	    sas_iounit_pg0, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENXIO;
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -EIO;
 		goto out;
 	}
@@ -1675,10 +1649,8 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	for (i = 0, discovery_active = 0; i < ioc->sas_hba.num_phys ; i++) {
 		if (sas_iounit_pg0->PhyData[i].PortFlags &
 		    MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS) {
-			pr_err(MPT3SAS_FMT "discovery is active on " \
-			    "port = %d, phy = %d: unable to enable/disable "
-			    "phys, try again later!\n", ioc->name,
-			    sas_iounit_pg0->PhyData[i].Port, i);
+			ioc_err(ioc, "discovery is active on port = %d, phy = %d: unable to enable/disable phys, try again later!\n",
+				sas_iounit_pg0->PhyData[i].Port, i);
 			discovery_active = 1;
 		}
 	}
@@ -1693,23 +1665,23 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	    sizeof(Mpi2SasIOUnit1PhyData_t));
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
 	    sas_iounit_pg1, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENXIO;
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -EIO;
 		goto out;
 	}
@@ -1801,23 +1773,23 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	    sizeof(Mpi2SasIOUnit1PhyData_t));
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_iounit_pg1) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
 	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
 	    sas_iounit_pg1, sz))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENXIO;
 		goto out;
 	}
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 	    MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -EIO;
 		goto out;
 	}
@@ -1836,8 +1808,8 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 
 	if (mpt3sas_config_set_sas_iounit_pg1(ioc, &mpi_reply, sas_iounit_pg1,
 	    sz)) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
 		rc = -ENXIO;
 		goto out;
 	}
@@ -1936,8 +1908,8 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		goto job_done;
 
 	if (ioc->transport_cmds.status != MPT3_CMD_NOT_USED) {
-		pr_err(MPT3SAS_FMT "%s: transport_cmds in use\n", ioc->name,
-		    __func__);
+		ioc_err(ioc, "%s: transport_cmds in use\n",
+			__func__);
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -1962,26 +1934,22 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (wait_state_count++ == 10) {
-			pr_err(MPT3SAS_FMT
-			    "%s: failed due to ioc not operational\n",
-			    ioc->name, __func__);
+			ioc_err(ioc, "%s: failed due to ioc not operational\n",
+				__func__);
 			rc = -EFAULT;
 			goto unmap_in;
 		}
 		ssleep(1);
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		pr_info(MPT3SAS_FMT
-			"%s: waiting for operational state(count=%d)\n",
-			ioc->name, __func__, wait_state_count);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+			 __func__, wait_state_count);
 	}
 	if (wait_state_count)
-		pr_info(MPT3SAS_FMT "%s: ioc is operational\n",
-		    ioc->name, __func__);
+		ioc_info(ioc, "%s: ioc is operational\n", __func__);
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
-		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-		    ioc->name, __func__);
+		ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
 		rc = -EAGAIN;
 		goto unmap_in;
 	}
@@ -2002,8 +1970,8 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	ioc->build_sg(ioc, psge, dma_addr_out, dma_len_out - 4, dma_addr_in,
 			dma_len_in - 4);
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s - sending smp request\n", ioc->name, __func__));
+	dtransportprintk(ioc,
+			 ioc_info(ioc, "%s: sending smp request\n", __func__));
 
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
@@ -2021,12 +1989,11 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		}
 	}
 
-	dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s - complete\n", ioc->name, __func__));
+	dtransportprintk(ioc, ioc_info(ioc, "%s - complete\n", __func__));
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_REPLY_VALID)) {
-		dtransportprintk(ioc, pr_info(MPT3SAS_FMT
-		    "%s - no reply\n", ioc->name, __func__));
+		dtransportprintk(ioc,
+				 ioc_info(ioc, "%s: no reply\n", __func__));
 		rc = -ENXIO;
 		goto unmap_in;
 	}
@@ -2034,9 +2001,9 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	mpi_reply = ioc->transport_cmds.reply;
 
 	dtransportprintk(ioc,
-		pr_info(MPT3SAS_FMT "%s - reply data transfer size(%d)\n",
-			ioc->name, __func__,
-			le16_to_cpu(mpi_reply->ResponseDataLength)));
+			 ioc_info(ioc, "%s: reply data transfer size(%d)\n",
+				  __func__,
+				  le16_to_cpu(mpi_reply->ResponseDataLength)));
 
 	memcpy(job->reply, mpi_reply, sizeof(*mpi_reply));
 	job->reply_len = sizeof(*mpi_reply);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index cae7c1eaef34..6ac453fd5937 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -72,8 +72,7 @@ _mpt3sas_raise_sigio(struct MPT3SAS_ADAPTER *ioc,
 	u16 sz, event_data_sz;
 	unsigned long flags;
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n",
-	    ioc->name, __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
 
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
 	    sizeof(struct SL_WH_TRIGGERS_EVENT_DATA_T) + 4;
@@ -85,23 +84,23 @@ _mpt3sas_raise_sigio(struct MPT3SAS_ADAPTER *ioc,
 	mpi_reply->EventDataLength = cpu_to_le16(event_data_sz);
 	memcpy(&mpi_reply->EventData, event_data,
 	    sizeof(struct SL_WH_TRIGGERS_EVENT_DATA_T));
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: add to driver event log\n",
-		ioc->name, __func__));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: add to driver event log\n",
+				    __func__));
 	mpt3sas_ctl_add_to_event_log(ioc, mpi_reply);
 	kfree(mpi_reply);
  out:
 
 	/* clearing the diag_trigger_active flag */
 	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: clearing diag_trigger_active flag\n",
-		ioc->name, __func__));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: clearing diag_trigger_active flag\n",
+				    __func__));
 	ioc->diag_trigger_active = 0;
 	spin_unlock_irqrestore(&ioc->diag_trigger_lock, flags);
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
 
 /**
@@ -115,22 +114,22 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *ioc,
 {
 	u8 issue_reset = 0;
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n",
-	    ioc->name, __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
 
 	/* release the diag buffer trace */
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
-		dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: release trace diag buffer\n", ioc->name, __func__));
+		dTriggerDiagPrintk(ioc,
+				   ioc_info(ioc, "%s: release trace diag buffer\n",
+					    __func__));
 		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
 		    &issue_reset);
 	}
 
 	_mpt3sas_raise_sigio(ioc, event_data);
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
 
 /**
@@ -168,9 +167,9 @@ mpt3sas_trigger_master(struct MPT3SAS_ADAPTER *ioc, u32 trigger_bitmask)
 
  by_pass_checks:
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: enter - trigger_bitmask = 0x%08x\n",
-		ioc->name, __func__, trigger_bitmask));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: enter - trigger_bitmask = 0x%08x\n",
+				    __func__, trigger_bitmask));
 
 	/* don't send trigger if an trigger is currently active */
 	if (ioc->diag_trigger_active) {
@@ -182,9 +181,9 @@ mpt3sas_trigger_master(struct MPT3SAS_ADAPTER *ioc, u32 trigger_bitmask)
 	if (ioc->diag_trigger_master.MasterData & trigger_bitmask) {
 		found_match = 1;
 		ioc->diag_trigger_active = 1;
-		dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: setting diag_trigger_active flag\n",
-		ioc->name, __func__));
+		dTriggerDiagPrintk(ioc,
+				   ioc_info(ioc, "%s: setting diag_trigger_active flag\n",
+					    __func__));
 	}
 	spin_unlock_irqrestore(&ioc->diag_trigger_lock, flags);
 
@@ -202,8 +201,8 @@ mpt3sas_trigger_master(struct MPT3SAS_ADAPTER *ioc, u32 trigger_bitmask)
 		mpt3sas_send_trigger_data_event(ioc, &event_data);
 
  out:
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
 
 /**
@@ -239,9 +238,9 @@ mpt3sas_trigger_event(struct MPT3SAS_ADAPTER *ioc, u16 event,
 		return;
 	}
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: enter - event = 0x%04x, log_entry_qualifier = 0x%04x\n",
-		ioc->name, __func__, event, log_entry_qualifier));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: enter - event = 0x%04x, log_entry_qualifier = 0x%04x\n",
+				    __func__, event, log_entry_qualifier));
 
 	/* don't send trigger if an trigger is currently active */
 	if (ioc->diag_trigger_active) {
@@ -263,26 +262,26 @@ mpt3sas_trigger_event(struct MPT3SAS_ADAPTER *ioc, u16 event,
 		}
 		found_match = 1;
 		ioc->diag_trigger_active = 1;
-		dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: setting diag_trigger_active flag\n",
-			ioc->name, __func__));
+		dTriggerDiagPrintk(ioc,
+				   ioc_info(ioc, "%s: setting diag_trigger_active flag\n",
+					    __func__));
 	}
 	spin_unlock_irqrestore(&ioc->diag_trigger_lock, flags);
 
 	if (!found_match)
 		goto out;
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: setting diag_trigger_active flag\n",
-		ioc->name, __func__));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: setting diag_trigger_active flag\n",
+				    __func__));
 	memset(&event_data, 0, sizeof(struct SL_WH_TRIGGERS_EVENT_DATA_T));
 	event_data.trigger_type = MPT3SAS_TRIGGER_EVENT;
 	event_data.u.event.EventValue = event;
 	event_data.u.event.LogEntryQualifier = log_entry_qualifier;
 	mpt3sas_send_trigger_data_event(ioc, &event_data);
  out:
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
 
 /**
@@ -319,9 +318,9 @@ mpt3sas_trigger_scsi(struct MPT3SAS_ADAPTER *ioc, u8 sense_key, u8 asc,
 		return;
 	}
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: enter - sense_key = 0x%02x, asc = 0x%02x, ascq = 0x%02x\n",
-		ioc->name, __func__, sense_key, asc, ascq));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: enter - sense_key = 0x%02x, asc = 0x%02x, ascq = 0x%02x\n",
+				    __func__, sense_key, asc, ascq));
 
 	/* don't send trigger if an trigger is currently active */
 	if (ioc->diag_trigger_active) {
@@ -347,9 +346,9 @@ mpt3sas_trigger_scsi(struct MPT3SAS_ADAPTER *ioc, u8 sense_key, u8 asc,
 	if (!found_match)
 		goto out;
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: setting diag_trigger_active flag\n",
-		ioc->name, __func__));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: setting diag_trigger_active flag\n",
+				    __func__));
 	memset(&event_data, 0, sizeof(struct SL_WH_TRIGGERS_EVENT_DATA_T));
 	event_data.trigger_type = MPT3SAS_TRIGGER_SCSI;
 	event_data.u.scsi.SenseKey = sense_key;
@@ -357,8 +356,8 @@ mpt3sas_trigger_scsi(struct MPT3SAS_ADAPTER *ioc, u8 sense_key, u8 asc,
 	event_data.u.scsi.ASCQ = ascq;
 	mpt3sas_send_trigger_data_event(ioc, &event_data);
  out:
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
 
 /**
@@ -393,9 +392,9 @@ mpt3sas_trigger_mpi(struct MPT3SAS_ADAPTER *ioc, u16 ioc_status, u32 loginfo)
 		return;
 	}
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: enter - ioc_status = 0x%04x, loginfo = 0x%08x\n",
-		ioc->name, __func__, ioc_status, loginfo));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: enter - ioc_status = 0x%04x, loginfo = 0x%08x\n",
+				    __func__, ioc_status, loginfo));
 
 	/* don't send trigger if an trigger is currently active */
 	if (ioc->diag_trigger_active) {
@@ -420,15 +419,15 @@ mpt3sas_trigger_mpi(struct MPT3SAS_ADAPTER *ioc, u16 ioc_status, u32 loginfo)
 	if (!found_match)
 		goto out;
 
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: setting diag_trigger_active flag\n",
-		ioc->name, __func__));
+	dTriggerDiagPrintk(ioc,
+			   ioc_info(ioc, "%s: setting diag_trigger_active flag\n",
+				    __func__));
 	memset(&event_data, 0, sizeof(struct SL_WH_TRIGGERS_EVENT_DATA_T));
 	event_data.trigger_type = MPT3SAS_TRIGGER_MPI;
 	event_data.u.mpi.IOCStatus = ioc_status;
 	event_data.u.mpi.IocLogInfo = loginfo;
 	mpt3sas_send_trigger_data_event(ioc, &event_data);
  out:
-	dTriggerDiagPrintk(ioc, pr_info(MPT3SAS_FMT "%s: exit\n", ioc->name,
-	    __func__));
+	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
+					 __func__));
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index b4927f2b7677..cc07ba41f507 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -127,20 +127,17 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "globally as drives are exposed\n", ioc->name);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled globally as drives are exposed\n");
 		return;
 	}
 	if (mpt3sas_get_num_volumes(ioc) > 1) {
 		_warpdrive_disable_ddio(ioc);
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "globally as number of drives > 1\n", ioc->name);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled globally as number of drives > 1\n");
 		return;
 	}
 	if ((mpt3sas_config_get_number_pds(ioc, raid_device->handle,
 	    &num_pds)) || !num_pds) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Failure in computing number of drives\n", ioc->name);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled Failure in computing number of drives\n");
 		return;
 	}
 
@@ -148,15 +145,13 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 	    sizeof(Mpi2RaidVol0PhysDisk_t));
 	vol_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!vol_pg0) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Memory allocation failure for RVPG0\n", ioc->name);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled Memory allocation failure for RVPG0\n");
 		return;
 	}
 
 	if ((mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
 	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Failure in retrieving RVPG0\n", ioc->name);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled Failure in retrieving RVPG0\n");
 		kfree(vol_pg0);
 		return;
 	}
@@ -166,10 +161,8 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 	 * assumed for WARPDRIVE, disable direct I/O
 	 */
 	if (num_pds > MPT_MAX_WARPDRIVE_PDS) {
-		pr_warn(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x): num_mem=%d, "
-		    "max_mem_allowed=%d\n", ioc->name, raid_device->handle,
-		    num_pds, MPT_MAX_WARPDRIVE_PDS);
+		ioc_warn(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x): num_mem=%d, max_mem_allowed=%d\n",
+			 raid_device->handle, num_pds, MPT_MAX_WARPDRIVE_PDS);
 		kfree(vol_pg0);
 		return;
 	}
@@ -179,22 +172,18 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 		    vol_pg0->PhysDisk[count].PhysDiskNum) ||
 		    le16_to_cpu(pd_pg0.DevHandle) ==
 		    MPT3SAS_INVALID_DEVICE_HANDLE) {
-			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
-			    "disabled for the drive with handle(0x%04x) member"
-			    "handle retrieval failed for member number=%d\n",
-			    ioc->name, raid_device->handle,
-			    vol_pg0->PhysDisk[count].PhysDiskNum);
+			ioc_info(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x) member handle retrieval failed for member number=%d\n",
+				 raid_device->handle,
+				 vol_pg0->PhysDisk[count].PhysDiskNum);
 			goto out_error;
 		}
 		/* Disable direct I/O if member drive lba exceeds 4 bytes */
 		dev_max_lba = le64_to_cpu(pd_pg0.DeviceMaxLBA);
 		if (dev_max_lba >> 32) {
-			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
-			    "disabled for the drive with handle(0x%04x) member"
-			    " handle (0x%04x) unsupported max lba 0x%016llx\n",
-			    ioc->name, raid_device->handle,
-			    le16_to_cpu(pd_pg0.DevHandle),
-			    (unsigned long long)dev_max_lba);
+			ioc_info(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x) member handle (0x%04x) unsupported max lba 0x%016llx\n",
+				 raid_device->handle,
+				 le16_to_cpu(pd_pg0.DevHandle),
+				 (u64)dev_max_lba);
 			goto out_error;
 		}
 
@@ -206,41 +195,36 @@ mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 	 * not RAID0
 	 */
 	if (raid_device->volume_type != MPI2_RAID_VOL_TYPE_RAID0) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x): type=%d, "
-		    "s_sz=%uK, blk_size=%u\n", ioc->name,
-		    raid_device->handle, raid_device->volume_type,
-		    (le32_to_cpu(vol_pg0->StripeSize) *
-		    le16_to_cpu(vol_pg0->BlockSize)) / 1024,
-		    le16_to_cpu(vol_pg0->BlockSize));
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x): type=%d, s_sz=%uK, blk_size=%u\n",
+			 raid_device->handle, raid_device->volume_type,
+			 (le32_to_cpu(vol_pg0->StripeSize) *
+			  le16_to_cpu(vol_pg0->BlockSize)) / 1024,
+			 le16_to_cpu(vol_pg0->BlockSize));
 		goto out_error;
 	}
 
 	stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
 	stripe_exp = find_first_bit(&stripe_sz, 32);
 	if (stripe_exp == 32) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		"for the drive with handle(0x%04x) invalid stripe sz %uK\n",
-		    ioc->name, raid_device->handle,
-		    (le32_to_cpu(vol_pg0->StripeSize) *
-		    le16_to_cpu(vol_pg0->BlockSize)) / 1024);
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x) invalid stripe sz %uK\n",
+			 raid_device->handle,
+			 (le32_to_cpu(vol_pg0->StripeSize) *
+			  le16_to_cpu(vol_pg0->BlockSize)) / 1024);
 		goto out_error;
 	}
 	raid_device->stripe_exponent = stripe_exp;
 	block_sz = le16_to_cpu(vol_pg0->BlockSize);
 	block_exp = find_first_bit(&block_sz, 16);
 	if (block_exp == 16) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x) invalid block sz %u\n",
-		    ioc->name, raid_device->handle,
-		    le16_to_cpu(vol_pg0->BlockSize));
+		ioc_info(ioc, "WarpDrive : Direct IO is disabled for the drive with handle(0x%04x) invalid block sz %u\n",
+			 raid_device->handle, le16_to_cpu(vol_pg0->BlockSize));
 		goto out_error;
 	}
 	raid_device->block_exponent = block_exp;
 	raid_device->direct_io_enabled = 1;
 
-	pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is Enabled for the drive"
-	    " with handle(0x%04x)\n", ioc->name, raid_device->handle);
+	ioc_info(ioc, "WarpDrive : Direct IO is Enabled for the drive with handle(0x%04x)\n",
+		 raid_device->handle);
 	/*
 	 * WARPDRIVE: Though the following fields are not used for direct IO,
 	 * stored for future purpose:
-- 
2.35.1



