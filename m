Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BDD3C243E
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhGINVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232012AbhGINVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7662261377;
        Fri,  9 Jul 2021 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836742;
        bh=CppCowU1aarDvakbgdnA1ps4raPDQHMaHM2QZfmD8Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI9vNVp9/RcrBmGNWZyWd3tza2bPpbdhHRBJyBgg2lC5IXQdgstYPfL9GQY5qv2/C
         edlEPIElCt7pccGeoRPIUV5OlAMhZER1wUO0zypuBSa6CijjiPL9l7qR/mK7yOXMWP
         alfCLqA8LKu0wsPG9afoHf8huOQ18l/6D76RmB8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrvsky@oracle.com>
Subject: [PATCH 4.9 9/9] xen/events: reset active flag for lateeoi events later
Date:   Fri,  9 Jul 2021 15:18:36 +0200
Message-Id: <20210709131555.133915565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
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
@@ -533,6 +533,9 @@ static void xen_irq_lateeoi_locked(struc
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -1778,10 +1781,22 @@ static void lateeoi_ack_dynirq(struct ir
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


