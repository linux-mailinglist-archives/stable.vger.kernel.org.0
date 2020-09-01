Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8B259BFA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgIAPRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgIAPRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:17:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01E820767;
        Tue,  1 Sep 2020 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973440;
        bh=Lryw0f1Nbw9zOBSfGU+aYbC7z1GWIMz3wMR7aAvU97E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCaqX0Ok2T6tOSAVDI03qKxERsAu25x0Gogr6GEjsmvA/gWegMHPvlAQinay0RuyQ
         teB7soXMJka9HOzsGa0oM8QimDwaQvM7X5fOv7PHwcUvxcTcximdbCzTYPpnoeLlMH
         uissGZhuJE/EAkbafQwJDpWLYfQ5VnroEd/a/0oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Shaposhnik <roman@zededa.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.9 62/78] XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.
Date:   Tue,  1 Sep 2020 17:10:38 +0200
Message-Id: <20200901150927.881584554@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit c330fb1ddc0a922f044989492b7fcca77ee1db46 upstream.

handler data is meant for interrupt handlers and not for storing irq chip
specific information as some devices require handler data to store internal
per interrupt information, e.g. pinctrl/GPIO chained interrupt handlers.

This obviously creates a conflict of interests and crashes the machine
because the XEN pointer is overwritten by the driver pointer.

As the XEN data is not handler specific it should be stored in
irqdesc::irq_data::chip_data instead.

A simple sed s/irq_[sg]et_handler_data/irq_[sg]et_chip_data/ cures that.

Cc: stable@vger.kernel.org
Reported-by: Roman Shaposhnik <roman@zededa.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Roman Shaposhnik <roman@zededa.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/87lfi2yckt.fsf@nanos.tec.linutronix.de
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_base.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -155,7 +155,7 @@ int get_evtchn_to_irq(unsigned evtchn)
 /* Get info for IRQ */
 struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_get_handler_data(irq);
+	return irq_get_chip_data(irq);
 }
 
 /* Constructors for packed IRQ information. */
@@ -384,7 +384,7 @@ static void xen_irq_init(unsigned irq)
 	info->type = IRQT_UNBOUND;
 	info->refcnt = -1;
 
-	irq_set_handler_data(irq, info);
+	irq_set_chip_data(irq, info);
 
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -433,14 +433,14 @@ static int __must_check xen_allocate_irq
 
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info = irq_get_handler_data(irq);
+	struct irq_info *info = irq_get_chip_data(irq);
 
 	if (WARN_ON(!info))
 		return;
 
 	list_del(&info->list);
 
-	irq_set_handler_data(irq, NULL);
+	irq_set_chip_data(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
@@ -610,7 +610,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
-	struct irq_info *info = irq_get_handler_data(irq);
+	struct irq_info *info = irq_get_chip_data(irq);
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1114,7 +1114,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info = irq_get_handler_data(irq);
+	struct irq_info *info = irq_get_chip_data(irq);
 
 	if (WARN_ON(!info))
 		return;
@@ -1148,7 +1148,7 @@ int evtchn_make_refcounted(unsigned int
 	if (irq == -1)
 		return -ENOENT;
 
-	info = irq_get_handler_data(irq);
+	info = irq_get_chip_data(irq);
 
 	if (!info)
 		return -ENOENT;
@@ -1176,7 +1176,7 @@ int evtchn_get(unsigned int evtchn)
 	if (irq == -1)
 		goto done;
 
-	info = irq_get_handler_data(irq);
+	info = irq_get_chip_data(irq);
 
 	if (!info)
 		goto done;


