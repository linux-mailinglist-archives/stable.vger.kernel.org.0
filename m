Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23AD19B1BC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgDAQhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388988AbgDAQhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:37:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3D220772;
        Wed,  1 Apr 2020 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759060;
        bh=hftGqCuUIIoAdqQDcd+Mev2Z/qHi/EBRpyd3Yv4Zl9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT1ofjTExs5KYZPemBI1T65vie3JJrKi74rxDjb+83gYLY92TcKtPy+1RSwpQ80rD
         X0dfTpTz2eMrFtXscU+IMft2/GuO5qTg79Vikt9bqmI5UmnGd6IW466a1iU3bI76xF
         jdraH111yOG2nl+mxKbt45fLTygt3CrvSVgCceho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 064/102] genirq: Fix reference leaks on irq affinity notifiers
Date:   Wed,  1 Apr 2020 18:18:07 +0200
Message-Id: <20200401161543.662169807@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

commit df81dfcfd6991d547653d46c051bac195cd182c1 upstream.

The handling of notify->work did not properly maintain notify->kref in two
 cases:
1) where the work was already scheduled, another irq_set_affinity_locked()
   would get the ref and (no-op-ly) schedule the work.  Thus when
   irq_affinity_notify() ran, it would drop the original ref but not the
   additional one.
2) when cancelling the (old) work in irq_set_affinity_notifier(), if there
   was outstanding work a ref had been got for it but was never put.
Fix both by checking the return values of the work handling functions
 (schedule_work() for (1) and cancel_work_sync() for (2)) and put the
 extra ref if the return value indicates preexisting work.

Fixes: cd7eab44e994 ("genirq: Add IRQ affinity notifiers")
Fixes: 59c39840f5ab ("genirq: Prevent use-after-free and work list corruption")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ben Hutchings <ben@decadent.org.uk>
Link: https://lkml.kernel.org/r/24f5983f-2ab5-e83a-44ee-a45b5f9300f5@solarflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -233,7 +233,11 @@ int irq_set_affinity_locked(struct irq_d
 
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
-		schedule_work(&desc->affinity_notify->work);
+		if (!schedule_work(&desc->affinity_notify->work)) {
+			/* Work was already scheduled, drop our extra ref */
+			kref_put(&desc->affinity_notify->kref,
+				 desc->affinity_notify->release);
+		}
 	}
 	irqd_set(data, IRQD_AFFINITY_SET);
 
@@ -333,7 +337,10 @@ irq_set_affinity_notifier(unsigned int i
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	if (old_notify) {
-		cancel_work_sync(&old_notify->work);
+		if (cancel_work_sync(&old_notify->work)) {
+			/* Pending work had a ref, put that one too */
+			kref_put(&old_notify->kref, old_notify->release);
+		}
 		kref_put(&old_notify->kref, old_notify->release);
 	}
 


