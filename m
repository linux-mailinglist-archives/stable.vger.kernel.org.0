Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1DB2A2753
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgKBJqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:46:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:59290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbgKBJqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 04:46:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604310399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8iqnQe8Qguu3dvcGW8iaD4P2eyctiqhbZ2BfU+NPqrc=;
        b=QlbpM6YWLhTpHLt1suvoTQCkaObfA9Fr+Kx0uzGWTSyhEpZOcKub3zDWNmljNJT6Vd+mT/
        llqL1Ym4cmeOOmy9Ua7Lns0wnsJx//K3x5n1jJ4LVo9xdxxd0loHmAzqkEMiH9hjpehEyv
        p0AIVm+no3SoXIEbvnREkmsFGT/uP1k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9688BB23A
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 09:46:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 13/13] xen/events: block rogue events for some time
Date:   Mon,  2 Nov 2020 10:46:38 +0100
Message-Id: <20201102094638.3355-14-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102094638.3355-1-jgross@suse.com>
References: <20201102094638.3355-1-jgross@suse.com>
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
index 8dbf0d119fab..5e8e016d1935 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -460,17 +460,34 @@ static void lateeoi_list_add(struct irq_info *info)
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
@@ -507,7 +524,7 @@ static void xen_irq_lateeoi_worker(struct work_struct *work)
 
 		info->eoi_time = 0;
 
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, false);
 	}
 
 	if (info)
@@ -536,7 +553,7 @@ void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
 	info = info_for_irq(irq);
 
 	if (info)
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, eoi_flags & XEN_EOI_FLAG_SPURIOUS);
 
 	read_unlock_irqrestore(&evtchn_rwlock, flags);
 }
@@ -1439,7 +1456,7 @@ int evtchn_get(unsigned int evtchn)
 		goto done;
 
 	err = -EINVAL;
-	if (info->refcnt <= 0)
+	if (info->refcnt <= 0 || info->refcnt == SHRT_MAX)
 		goto done;
 
 	info->refcnt++;
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 756c87532d33..a35c8c7ac606 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -31,7 +31,8 @@ enum xen_irq_type {
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

