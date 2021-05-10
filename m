Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654CF3783FA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhEJKsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232165AbhEJKp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194FC61554;
        Mon, 10 May 2021 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643003;
        bh=k4gBegVAEn2jj8BmW/pCQak07gwsrGkTjFrlAu+I4w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRthBnHEPt6X9amwHEjEq30GJl7e2I9OCy3iVFWNl/OiGFab2vlb0EbGTZw5C6YSK
         5Q+k6FBfUoVlV69xddsngfoR4end8CIngJBm2cJYaskAlR1uO8o7JwlmBs5Aljutf0
         gXTe/Zb70i0JJ+Je/u+XTl3+jbJWI8oe81IopAgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaogang Chen <xiaogang.chen@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/299] drm/amdgpu/display: buffer INTERRUPT_LOW_IRQ_CONTEXT interrupt work
Date:   Mon, 10 May 2021 12:18:38 +0200
Message-Id: <20210510102008.978071102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit b6f91fc183f758461b9462cc93e673adbbf95c2d ]

amdgpu DM handles INTERRUPT_LOW_IRQ_CONTEXT interrupt(hpd, hpd_rx) by using work
queue and uses single work_struct. If new interrupt is recevied before the
previous handler finished, new interrupts(same type) will be discarded and
driver just sends "amdgpu_dm_irq_schedule_work FAILED" message out. If some
important hpd, hpd_rx related interrupts are missed by driver the hot (un)plug
devices may cause system hang or instability, such as issues with system
resume from S3 sleep with mst device connected.

This patch dynamically allocates new amdgpu_dm_irq_handler_data for new
interrupts if previous INTERRUPT_LOW_IRQ_CONTEXT interrupt work has not been
handled. So the new interrupt works can be queued to the same workqueue_struct,
instead of discard the new interrupts. All allocated amdgpu_dm_irq_handler_data
are put into a single linked list and will be reused after.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  14 +--
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 115 ++++++++++++------
 2 files changed, 80 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index a8a0e8cb1a11..1df7f1b18049 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -68,18 +68,6 @@ struct common_irq_params {
 	enum dc_irq_source irq_src;
 };
 
-/**
- * struct irq_list_head - Linked-list for low context IRQ handlers.
- *
- * @head: The list_head within &struct handler_data
- * @work: A work_struct containing the deferred handler work
- */
-struct irq_list_head {
-	struct list_head head;
-	/* In case this interrupt needs post-processing, 'work' will be queued*/
-	struct work_struct work;
-};
-
 /**
  * struct dm_compressor_info - Buffer info used by frame buffer compression
  * @cpu_addr: MMIO cpu addr
@@ -270,7 +258,7 @@ struct amdgpu_display_manager {
 	 * Note that handlers are called in the same order as they were
 	 * registered (FIFO).
 	 */
-	struct irq_list_head irq_handler_list_low_tab[DAL_IRQ_SOURCES_NUMBER];
+	struct list_head irq_handler_list_low_tab[DAL_IRQ_SOURCES_NUMBER];
 
 	/**
 	 * @irq_handler_list_high_tab:
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index 357778556b06..281b274e2b9b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -82,6 +82,7 @@ struct amdgpu_dm_irq_handler_data {
 	struct amdgpu_display_manager *dm;
 	/* DAL irq source which registered for this interrupt. */
 	enum dc_irq_source irq_source;
+	struct work_struct work;
 };
 
 #define DM_IRQ_TABLE_LOCK(adev, flags) \
@@ -111,20 +112,10 @@ static void init_handler_common_data(struct amdgpu_dm_irq_handler_data *hcd,
  */
 static void dm_irq_work_func(struct work_struct *work)
 {
-	struct irq_list_head *irq_list_head =
-		container_of(work, struct irq_list_head, work);
-	struct list_head *handler_list = &irq_list_head->head;
-	struct amdgpu_dm_irq_handler_data *handler_data;
-
-	list_for_each_entry(handler_data, handler_list, list) {
-		DRM_DEBUG_KMS("DM_IRQ: work_func: for dal_src=%d\n",
-				handler_data->irq_source);
+	struct amdgpu_dm_irq_handler_data *handler_data =
+		container_of(work, struct amdgpu_dm_irq_handler_data, work);
 
-		DRM_DEBUG_KMS("DM_IRQ: schedule_work: for dal_src=%d\n",
-			handler_data->irq_source);
-
-		handler_data->handler(handler_data->handler_arg);
-	}
+	handler_data->handler(handler_data->handler_arg);
 
 	/* Call a DAL subcomponent which registered for interrupt notification
 	 * at INTERRUPT_LOW_IRQ_CONTEXT.
@@ -156,7 +147,7 @@ static struct list_head *remove_irq_handler(struct amdgpu_device *adev,
 		break;
 	case INTERRUPT_LOW_IRQ_CONTEXT:
 	default:
-		hnd_list = &adev->dm.irq_handler_list_low_tab[irq_source].head;
+		hnd_list = &adev->dm.irq_handler_list_low_tab[irq_source];
 		break;
 	}
 
@@ -287,7 +278,8 @@ void *amdgpu_dm_irq_register_interrupt(struct amdgpu_device *adev,
 		break;
 	case INTERRUPT_LOW_IRQ_CONTEXT:
 	default:
-		hnd_list = &adev->dm.irq_handler_list_low_tab[irq_source].head;
+		hnd_list = &adev->dm.irq_handler_list_low_tab[irq_source];
+		INIT_WORK(&handler_data->work, dm_irq_work_func);
 		break;
 	}
 
@@ -369,7 +361,7 @@ void amdgpu_dm_irq_unregister_interrupt(struct amdgpu_device *adev,
 int amdgpu_dm_irq_init(struct amdgpu_device *adev)
 {
 	int src;
-	struct irq_list_head *lh;
+	struct list_head *lh;
 
 	DRM_DEBUG_KMS("DM_IRQ\n");
 
@@ -378,9 +370,7 @@ int amdgpu_dm_irq_init(struct amdgpu_device *adev)
 	for (src = 0; src < DAL_IRQ_SOURCES_NUMBER; src++) {
 		/* low context handler list init */
 		lh = &adev->dm.irq_handler_list_low_tab[src];
-		INIT_LIST_HEAD(&lh->head);
-		INIT_WORK(&lh->work, dm_irq_work_func);
-
+		INIT_LIST_HEAD(lh);
 		/* high context handler init */
 		INIT_LIST_HEAD(&adev->dm.irq_handler_list_high_tab[src]);
 	}
@@ -397,8 +387,11 @@ int amdgpu_dm_irq_init(struct amdgpu_device *adev)
 void amdgpu_dm_irq_fini(struct amdgpu_device *adev)
 {
 	int src;
-	struct irq_list_head *lh;
+	struct list_head *lh;
+	struct list_head *entry, *tmp;
+	struct amdgpu_dm_irq_handler_data *handler;
 	unsigned long irq_table_flags;
+
 	DRM_DEBUG_KMS("DM_IRQ: releasing resources.\n");
 	for (src = 0; src < DAL_IRQ_SOURCES_NUMBER; src++) {
 		DM_IRQ_TABLE_LOCK(adev, irq_table_flags);
@@ -407,7 +400,16 @@ void amdgpu_dm_irq_fini(struct amdgpu_device *adev)
 		 * (because no code can schedule a new one). */
 		lh = &adev->dm.irq_handler_list_low_tab[src];
 		DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
-		flush_work(&lh->work);
+
+		if (!list_empty(lh)) {
+			list_for_each_safe(entry, tmp, lh) {
+				handler = list_entry(
+					entry,
+					struct amdgpu_dm_irq_handler_data,
+					list);
+				flush_work(&handler->work);
+			}
+		}
 	}
 }
 
@@ -417,6 +419,8 @@ int amdgpu_dm_irq_suspend(struct amdgpu_device *adev)
 	struct list_head *hnd_list_h;
 	struct list_head *hnd_list_l;
 	unsigned long irq_table_flags;
+	struct list_head *entry, *tmp;
+	struct amdgpu_dm_irq_handler_data *handler;
 
 	DM_IRQ_TABLE_LOCK(adev, irq_table_flags);
 
@@ -427,14 +431,22 @@ int amdgpu_dm_irq_suspend(struct amdgpu_device *adev)
 	 * will be disabled from manage_dm_interrupts on disable CRTC.
 	 */
 	for (src = DC_IRQ_SOURCE_HPD1; src <= DC_IRQ_SOURCE_HPD6RX; src++) {
-		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src].head;
+		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
 			dc_interrupt_set(adev->dm.dc, src, false);
 
 		DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
-		flush_work(&adev->dm.irq_handler_list_low_tab[src].work);
 
+		if (!list_empty(hnd_list_l)) {
+			list_for_each_safe (entry, tmp, hnd_list_l) {
+				handler = list_entry(
+					entry,
+					struct amdgpu_dm_irq_handler_data,
+					list);
+				flush_work(&handler->work);
+			}
+		}
 		DM_IRQ_TABLE_LOCK(adev, irq_table_flags);
 	}
 
@@ -454,7 +466,7 @@ int amdgpu_dm_irq_resume_early(struct amdgpu_device *adev)
 
 	/* re-enable short pulse interrupts HW interrupt */
 	for (src = DC_IRQ_SOURCE_HPD1RX; src <= DC_IRQ_SOURCE_HPD6RX; src++) {
-		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src].head;
+		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
 			dc_interrupt_set(adev->dm.dc, src, true);
@@ -480,7 +492,7 @@ int amdgpu_dm_irq_resume_late(struct amdgpu_device *adev)
 	 * will be enabled from manage_dm_interrupts on enable CRTC.
 	 */
 	for (src = DC_IRQ_SOURCE_HPD1; src <= DC_IRQ_SOURCE_HPD6; src++) {
-		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src].head;
+		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
 			dc_interrupt_set(adev->dm.dc, src, true);
@@ -497,22 +509,53 @@ int amdgpu_dm_irq_resume_late(struct amdgpu_device *adev)
 static void amdgpu_dm_irq_schedule_work(struct amdgpu_device *adev,
 					enum dc_irq_source irq_source)
 {
-	unsigned long irq_table_flags;
-	struct work_struct *work = NULL;
+	struct  list_head *handler_list = &adev->dm.irq_handler_list_low_tab[irq_source];
+	struct  amdgpu_dm_irq_handler_data *handler_data;
+	bool    work_queued = false;
 
-	DM_IRQ_TABLE_LOCK(adev, irq_table_flags);
+	if (list_empty(handler_list))
+		return;
 
-	if (!list_empty(&adev->dm.irq_handler_list_low_tab[irq_source].head))
-		work = &adev->dm.irq_handler_list_low_tab[irq_source].work;
+	list_for_each_entry (handler_data, handler_list, list) {
+		if (!queue_work(system_highpri_wq, &handler_data->work)) {
+			continue;
+		} else {
+			work_queued = true;
+			break;
+		}
+	}
 
-	DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
+	if (!work_queued) {
+		struct  amdgpu_dm_irq_handler_data *handler_data_add;
+		/*get the amdgpu_dm_irq_handler_data of first item pointed by handler_list*/
+		handler_data = container_of(handler_list->next, struct amdgpu_dm_irq_handler_data, list);
 
-	if (work) {
-		if (!schedule_work(work))
-			DRM_INFO("amdgpu_dm_irq_schedule_work FAILED src %d\n",
-						irq_source);
-	}
+		/*allocate a new amdgpu_dm_irq_handler_data*/
+		handler_data_add = kzalloc(sizeof(*handler_data), GFP_KERNEL);
+		if (!handler_data_add) {
+			DRM_ERROR("DM_IRQ: failed to allocate irq handler!\n");
+			return;
+		}
+
+		/*copy new amdgpu_dm_irq_handler_data members from handler_data*/
+		handler_data_add->handler       = handler_data->handler;
+		handler_data_add->handler_arg   = handler_data->handler_arg;
+		handler_data_add->dm            = handler_data->dm;
+		handler_data_add->irq_source    = irq_source;
 
+		list_add_tail(&handler_data_add->list, handler_list);
+
+		INIT_WORK(&handler_data_add->work, dm_irq_work_func);
+
+		if (queue_work(system_highpri_wq, &handler_data_add->work))
+			DRM_DEBUG("Queued work for handling interrupt from "
+				  "display for IRQ source %d\n",
+				  irq_source);
+		else
+			DRM_ERROR("Failed to queue work for handling interrupt "
+				  "from display for IRQ source %d\n",
+				  irq_source);
+	}
 }
 
 /*
-- 
2.30.2



