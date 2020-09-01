Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224692597B3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgIAQRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbgIAPdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7401521548;
        Tue,  1 Sep 2020 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974421;
        bh=VEbWXJsL5nvU8RWQzRCLenQMrZBHfB295gfdp1uzQcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh1bUKbPcpy/SP8FPVoFLtpyIoXBLYKd/Gj9vDjt98NUnljg8o4euZyUSqUdmybBV
         zUFRXPZhpKY927tX/jmNRxndZGaMXk2uBsdB0QRVU0jxig+alpj4mPc+2AYLz+k9RD
         /OpD952tGWsYRTCBGhIq4g+K2VR7pwJVu2pNP090=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Shaposhnik <roman@zededa.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 170/214] XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.
Date:   Tue,  1 Sep 2020 17:10:50 +0200
Message-Id: <20200901151001.119702265@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
@@ -376,7 +376,7 @@ static void xen_irq_init(unsigned irq)
 	info->type = IRQT_UNBOUND;
 	info->refcnt = -1;
 
-	irq_set_handler_data(irq, info);
+	irq_set_chip_data(irq, info);
 
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -425,14 +425,14 @@ static int __must_check xen_allocate_irq
 
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
 
@@ -602,7 +602,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
-	struct irq_info *info = irq_get_handler_data(irq);
+	struct irq_info *info = irq_get_chip_data(irq);
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1106,7 +1106,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info = irq_get_handler_data(irq);
+	struct irq_info *info = irq_get_chip_data(irq);
 
 	if (WARN_ON(!info))
 		return;
@@ -1140,7 +1140,7 @@ int evtchn_make_refcounted(unsigned int
 	if (irq == -1)
 		return -ENOENT;
 
-	info = irq_get_handler_data(irq);
+	info = irq_get_chip_data(irq);
 
 	if (!info)
 		return -ENOENT;
@@ -1168,7 +1168,7 @@ int evtchn_get(unsigned int evtchn)
 	if (irq == -1)
 		goto done;
 
-	info = irq_get_handler_data(irq);
+	info = irq_get_chip_data(irq);
 
 	if (!info)
 		goto done;


