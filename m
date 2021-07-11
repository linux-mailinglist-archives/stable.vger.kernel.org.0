Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E993C3BAC
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhGKLLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhGKLLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE998611ED;
        Sun, 11 Jul 2021 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626001714;
        bh=EFbTgLlyPAaw/OUEbY+9GdNsQgaX0C/Ebg4UB3f/0DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCX9w1t/Hrmk8vVt3wisstZLTrB2bXqk3/euu4mpCDJxaFc7GeK14H2Oy9FDjctb5
         sG1d6GfHP5hJ7rR40IsqocQq7FfQAZpjwc6Me481jXanekvW0Uz/lrA4NYqjz/0Qsb
         pLlcsxFyIjT2GgPCUn/0YMInQLWA6bGQqwG8ZuIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.275
Date:   Sun, 11 Jul 2021 13:08:24 +0200
Message-Id: <16260017029626@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1626001702192152@kroah.com>
References: <1626001702192152@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3d1fc6eb95ec..dbf282146b66 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 274
+SUBLEVEL = 275
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index 3eb018fa1a1f..c3362ddd6c4c 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -270,6 +270,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 			switch (kcb->kprobe_status) {
 			case KPROBE_HIT_ACTIVE:
 			case KPROBE_HIT_SSDONE:
+			case KPROBE_HIT_SS:
 				/* A pre- or post-handler probe got us here. */
 				kprobes_inc_nmissed_count(p);
 				save_previous_kprobe(kcb);
@@ -278,6 +279,11 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 				singlestep(p, regs, kcb);
 				restore_previous_kprobe(kcb);
 				break;
+			case KPROBE_REENTER:
+				/* A nested probe was hit in FIQ, it is a BUG */
+				pr_warn("Unrecoverable kprobe detected at %p.\n",
+					p->addr);
+				/* fall through */
 			default:
 				/* impossible cases */
 				BUG();
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 78f520d05de9..58c310930bf2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -458,7 +458,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -478,7 +478,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7dd4d9ded249..6e31cedf0b6c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -216,6 +216,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 56bf952de411..f27118923390 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -533,6 +533,9 @@ static void xen_irq_lateeoi_locked(struct irq_info *info, bool spurious)
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -1777,10 +1780,22 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 	struct irq_info *info = info_for_irq(data->irq);
 	evtchn_port_t evtchn = info ? info->evtchn : 0;
 
-	if (VALID_EVTCHN(evtchn)) {
-		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		ack_dynirq(data);
-	}
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	do_mask(info, EVT_MASK_REASON_EOI_PENDING);
+
+	if (unlikely(irqd_is_setaffinity_pending(data)) &&
+	    likely(!irqd_irq_disabled(data))) {
+		do_mask(info, EVT_MASK_REASON_TEMPORARY);
+
+		clear_evtchn(evtchn);
+
+		irq_move_masked_irq(data);
+
+		do_unmask(info, EVT_MASK_REASON_TEMPORARY);
+	} else
+		clear_evtchn(evtchn);
 }
 
 static void lateeoi_mask_ack_dynirq(struct irq_data *data)
