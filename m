Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E902A47E0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgKCOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:20:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:45130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbgKCOT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:19:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604413164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xIJ0GL2fkDgL03yCuaoXIMC0aEKiq3hqxGIhUL0uSUw=;
        b=LWY/EehdYv2b7td2aVaPt9M3pK5/ARVQ2jjW24cSiStx5Riy5FzeCTNz1CdwGwFx4y4TQ5
        gO3OndMQf8FoJ5l3RH+ZE4KaCmF/n0H2QyiYRKh9d/PZALn6cTIewWJWpL1fi/bw9JFyVp
        nKacV1GZ25o9W3xBK4j+xv2ZyrA2NcU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F167B29F
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:19:24 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 14/14] xen/events: block rogue events for some time
Date:   Tue,  3 Nov 2020 15:19:22 +0100
Message-Id: <20201103141922.21026-15-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103141922.21026-1-jgross@suse.com>
References: <20201103141922.21026-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to avoid high dom0 load due to rogue guests sending events at
high frequency, block those events in case there was no action needed
in dom0 to handle the events.

This is done by adding a per-event counter, which set to zero in case
an EOI without the XEN_EOI_FLAG_SPURIOUS is received from a backend
driver, and incremented when this flag has been set. In case the
counter is 2 or higher delay the EOI by 1 << (cnt - 2) jiffies, but
not more than 1 second.

In order not to waste memory shorten the per-event refcnt to two bytes
(it should normally never exceed a value of 2). Add an overflow check
to evtchn_get() to make sure the 2 bytes really won't overflow.

This is part of XSA-332.

This is upstream commit 5f7f77400ab5b357b5fdb7122c3442239672186c

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_base.c     | 27 ++++++++++++++++++++++-----
 drivers/xen/events/events_internal.h |  3 ++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index d565f7ebb8ef..aca845675279 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -459,17 +459,34 @@ static void lateeoi_list_add(struct irq_info *info)
 	spin_unlock_irqrestore(&eoi->eoi_list_lock, flags);
 }
 
-static void xen_irq_lateeoi_locked(struct irq_info *info)
+static void xen_irq_lateeoi_locked(struct irq_info *info, bool spurious)
 {
 	evtchn_port_t evtchn;
 	unsigned int cpu;
+	unsigned int delay = 0;
 
 	evtchn = info->evtchn;
 	if (!VALID_EVTCHN(evtchn) || !list_empty(&info->eoi_list))
 		return;
 
+	if (spurious) {
+		if ((1 << info->spurious_cnt) < (HZ << 2))
+			info->spurious_cnt++;
+		if (info->spurious_cnt > 1) {
+			delay = 1 << (info->spurious_cnt - 2);
+			if (delay > HZ)
+				delay = HZ;
+			if (!info->eoi_time)
+				info->eoi_cpu = smp_processor_id();
+			info->eoi_time = get_jiffies_64() + delay;
+		}
+	} else {
+		info->spurious_cnt = 0;
+	}
+
 	cpu = info->eoi_cpu;
-	if (info->eoi_time && info->irq_epoch == per_cpu(irq_epoch, cpu)) {
+	if (info->eoi_time &&
+	    (info->irq_epoch == per_cpu(irq_epoch, cpu) || delay)) {
 		lateeoi_list_add(info);
 		return;
 	}
@@ -506,7 +523,7 @@ static void xen_irq_lateeoi_worker(struct work_struct *work)
 
 		info->eoi_time = 0;
 
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, false);
 	}
 
 	if (info)
@@ -535,7 +552,7 @@ void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
 	info = info_for_irq(irq);
 
 	if (info)
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, eoi_flags & XEN_EOI_FLAG_SPURIOUS);
 
 	read_unlock_irqrestore(&evtchn_rwlock, flags);
 }
@@ -1438,7 +1455,7 @@ int evtchn_get(unsigned int evtchn)
 		goto done;
 
 	err = -EINVAL;
-	if (info->refcnt <= 0)
+	if (info->refcnt <= 0 || info->refcnt == SHRT_MAX)
 		goto done;
 
 	info->refcnt++;
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 2cb9c2d2c5c0..b9b4f5919893 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -33,7 +33,8 @@ enum xen_irq_type {
 struct irq_info {
 	struct list_head list;
 	struct list_head eoi_list;
-	int refcnt;
+	short refcnt;
+	short spurious_cnt;
 	enum xen_irq_type type;	/* type */
 	unsigned irq;
 	unsigned int evtchn;	/* event channel */
-- 
2.26.2

