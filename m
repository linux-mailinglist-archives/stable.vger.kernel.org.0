Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696662B6063
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgKQNIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgKQNIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EE72225B;
        Tue, 17 Nov 2020 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618519;
        bh=QV3Fo4IjQA0C6tB8n8tcPRL7CO8d6BIUo2/w7gFiEac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcb9IlVVGmoVJ/QdTdkIY0lcZWqs7kdfGEQ8X/cUZ/ardOGVhX+XSAaqnIuuHbMyX
         OTu/yXiUpNl818YZw8OHashTh2Ovlg5JKylykEgFLNY8Ih01ws1DlyvX0uVw1deip5
         8+TmVWimOXqnxJnPStnKSh2rG1+WHNzO2AVPXPq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: [PATCH 4.4 59/64] xen/events: block rogue events for some time
Date:   Tue, 17 Nov 2020 14:05:22 +0100
Message-Id: <20201117122109.095315926@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 5f7f77400ab5b357b5fdb7122c3442239672186c upstream.

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

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c     |   27 ++++++++++++++++++++++-----
 drivers/xen/events/events_internal.h |    3 ++-
 2 files changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -468,17 +468,34 @@ static void lateeoi_list_add(struct irq_
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
@@ -515,7 +532,7 @@ static void xen_irq_lateeoi_worker(struc
 
 		info->eoi_time = 0;
 
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, false);
 	}
 
 	if (info)
@@ -544,7 +561,7 @@ void xen_irq_lateeoi(unsigned int irq, u
 	info = info_for_irq(irq);
 
 	if (info)
-		xen_irq_lateeoi_locked(info);
+		xen_irq_lateeoi_locked(info, eoi_flags & XEN_EOI_FLAG_SPURIOUS);
 
 	read_unlock_irqrestore(&evtchn_rwlock, flags);
 }
@@ -1447,7 +1464,7 @@ int evtchn_get(unsigned int evtchn)
 		goto done;
 
 	err = -EINVAL;
-	if (info->refcnt <= 0)
+	if (info->refcnt <= 0 || info->refcnt == SHRT_MAX)
 		goto done;
 
 	info->refcnt++;
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


