Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DAA3C24BE
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhGINYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhGINYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3631613BC;
        Fri,  9 Jul 2021 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836917;
        bh=PZ6EJcrDKzfN3PJu5a68vxiQpKR6yp/1vj+22G8udRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic+2tf85Zq64GdlXAQRs9cNZu+6zhlc2aG99MDzAPyvYWEDHL+Zl3gzXNUAJoexAe
         /ju7TxDTUR6KSgLZ8nFiP0ctAbYz3lzZuXAVoN8xg3f+iSRH4Ip90GoUmRYLhKf8iP
         n2ZdEDqi78BQnufCkieLLzaDgkoAvTw/futooagU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrvsky@oracle.com>
Subject: [PATCH 4.19 29/34] xen/events: reset active flag for lateeoi events later
Date:   Fri,  9 Jul 2021 15:20:45 +0200
Message-Id: <20210709131700.340627537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 3de218ff39b9e3f0d453fe3154f12a174de44b25 upstream.

In order to avoid a race condition for user events when changing
cpu affinity reset the active flag only when EOI-ing the event.

This is working fine as all user events are lateeoi events. Note that
lateeoi_ack_mask_dynirq() is not modified as there is no explicit call
to xen_irq_lateeoi() expected later.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Fixes: b6622798bc50b62 ("xen/events: avoid handling the same event on two cpus at the same time")
Tested-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>
Link: https://lore.kernel.org/r/20210623130913.9405-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_base.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -524,6 +524,9 @@ static void xen_irq_lateeoi_locked(struc
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -1780,10 +1783,22 @@ static void lateeoi_ack_dynirq(struct ir
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


