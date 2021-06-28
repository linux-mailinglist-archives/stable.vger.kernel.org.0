Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2043B6040
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhF1OXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhF1OWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE05361C7E;
        Mon, 28 Jun 2021 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889974;
        bh=CSKpV0oXRx2md4FrADuQt7C5u018lk9k7KOhngBuVMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBJ602QBcBzdVC8gMtQ8sXyjasjmZqHeerczGfWx1dVTBKNGTekTC0WYoL2BeDVNR
         xKDh1lvY/SUsv+Litnm51nHvUZwaB/yaYrsRKBXTEl4JyDd0wm0x4Q6jE9TEcSZy0G
         t/SIasf6lb4ohsDvu9PJOTRpjE46DSxx3oft1sKmgnZv2nQfjL8pnfH80LvUvN+stL
         TqrLuuJdTMxf5orOOERjN7BwIW7EqwjrEoxK+pUUDkHHakZVr1IrWya6AYST9kUuqF
         8VH0rT5Jvg+qCCipegneK7i17cpuA+/zSzwcJJychT9V5IwVrW610qf+bRCSsm9tbY
         foqFJvqZQbWGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Julien Grall <julien@xen.org>,
        Boris Ostrovsky <boris.ostrvsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 076/110] xen/events: reset active flag for lateeoi events later
Date:   Mon, 28 Jun 2021 10:17:54 -0400
Message-Id: <20210628141828.31757-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/xen/events/events_base.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 7bbfd58958bc..d7e361fb0548 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -642,6 +642,9 @@ static void xen_irq_lateeoi_locked(struct irq_info *info, bool spurious)
 	}
 
 	info->eoi_time = 0;
+
+	/* is_active hasn't been reset yet, do it now. */
+	smp_store_release(&info->is_active, 0);
 	do_unmask(info, EVT_MASK_REASON_EOI_PENDING);
 }
 
@@ -811,6 +814,7 @@ static void xen_evtchn_close(evtchn_port_t port)
 		BUG();
 }
 
+/* Not called for lateeoi events. */
 static void event_handler_exit(struct irq_info *info)
 {
 	smp_store_release(&info->is_active, 0);
@@ -1883,7 +1887,12 @@ static void lateeoi_ack_dynirq(struct irq_data *data)
 
 	if (VALID_EVTCHN(evtchn)) {
 		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
-		event_handler_exit(info);
+		/*
+		 * Don't call event_handler_exit().
+		 * Need to keep is_active non-zero in order to ignore re-raised
+		 * events after cpu affinity changes while a lateeoi is pending.
+		 */
+		clear_evtchn(evtchn);
 	}
 }
 
-- 
2.30.2

