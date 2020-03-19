Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F229B18AD38
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgCSHOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:14:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:52010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSHOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:14:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 01FE1ABDC;
        Thu, 19 Mar 2020 07:14:35 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org
Subject: [PATCH] xen/events: avoid NULL pointer dereference in evtchn_from_irq()
Date:   Thu, 19 Mar 2020 08:14:28 +0100
Message-Id: <20200319071428.12115-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There have been reports of races in evtchn_from_irq() where the info
pointer has been NULL.

Avoid that case by testing info before dereferencing it.

In order to avoid accessing a just freed info structure do the kfree()
via kfree_rcu().

Cc: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_base.c     | 10 ++++++++--
 drivers/xen/events/events_internal.h |  3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 499eff7d3f65..838762fe3d6e 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -247,10 +247,16 @@ static void xen_irq_info_cleanup(struct irq_info *info)
  */
 unsigned int evtchn_from_irq(unsigned irq)
 {
+	struct irq_info *info;
+
 	if (WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq))
 		return 0;
 
-	return info_for_irq(irq)->evtchn;
+	info = info_for_irq(irq);
+	if (info == NULL)
+		return 0;
+
+	return info->evtchn;
 }
 
 unsigned irq_from_evtchn(unsigned int evtchn)
@@ -436,7 +442,7 @@ static void xen_free_irq(unsigned irq)
 
 	WARN_ON(info->refcnt > 0);
 
-	kfree(info);
+	kfree_rcu(info, rcu);
 
 	/* Legacy IRQ descriptors are managed by the arch. */
 	if (irq < nr_legacy_irqs())
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 82938cff6c7a..c421055843c8 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -7,6 +7,8 @@
 #ifndef __EVENTS_INTERNAL_H__
 #define __EVENTS_INTERNAL_H__
 
+#include <linux/rcupdate.h>
+
 /* Interrupt types. */
 enum xen_irq_type {
 	IRQT_UNBOUND = 0,
@@ -30,6 +32,7 @@ enum xen_irq_type {
  */
 struct irq_info {
 	struct list_head list;
+	struct rcu_head rcu;
 	int refcnt;
 	enum xen_irq_type type;	/* type */
 	unsigned irq;
-- 
2.16.4

