Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69C633B5C4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCONzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231492AbhCONyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 192D664EB6;
        Mon, 15 Mar 2021 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816489;
        bh=hm+F9/ytjl8jY3HhLNOg3aaXlrtafAjGslkFqjsSGIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bis+AP9KMwJc23iidQyK4oaM1IQ+ny5aZ7cyWWI71/MS62sYi+eT29VrqgYFEQuMw
         cTi3dvoMU2d4AeJwM6JBVeo98pUz4+dpAXX9voLn9VkyvcGU44sTaC+ZI/NLAXXnjr
         nfHBR1SUtkyeXQUH46qCTfwvVzHhwxcD77730gyA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.4 73/75] xen/events: reset affinity of 2-level event when tearing it down
Date:   Mon, 15 Mar 2021 14:52:27 +0100
Message-Id: <20210315135210.639910519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Juergen Gross <jgross@suse.com>

commit 9e77d96b8e2724ed00380189f7b0ded61113b39f upstream.

When creating a new event channel with 2-level events the affinity
needs to be reset initially in order to avoid using an old affinity
from earlier usage of the event channel port. So when tearing an event
channel down reset all affinity bits.

The same applies to the affinity when onlining a vcpu: all old
affinity settings for this vcpu must be reset. As percpu events get
initialized before the percpu event channel hook is called,
resetting of the affinities happens after offlining a vcpu (this is
working, as initial percpu memory is zeroed out).

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Link: https://lore.kernel.org/r/20210306161833.4552-2-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_2l.c       |   15 +++++++++++++++
 drivers/xen/events/events_base.c     |    1 +
 drivers/xen/events/events_internal.h |    8 ++++++++
 3 files changed, 24 insertions(+)

--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -46,6 +46,11 @@ static unsigned evtchn_2l_max_channels(v
 	return EVTCHN_2L_NR_CHANNELS;
 }
 
+static void evtchn_2l_remove(evtchn_port_t evtchn, unsigned int cpu)
+{
+	clear_bit(evtchn, BM(per_cpu(cpu_evtchn_mask, cpu)));
+}
+
 static void evtchn_2l_bind_to_cpu(struct irq_info *info, unsigned cpu)
 {
 	clear_bit(info->evtchn, BM(per_cpu(cpu_evtchn_mask, info->cpu)));
@@ -353,9 +358,18 @@ static void evtchn_2l_resume(void)
 				EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
 }
 
+static int evtchn_2l_percpu_deinit(unsigned int cpu)
+{
+	memset(per_cpu(cpu_evtchn_mask, cpu), 0, sizeof(xen_ulong_t) *
+			EVTCHN_2L_NR_CHANNELS/BITS_PER_EVTCHN_WORD);
+
+	return 0;
+}
+
 static const struct evtchn_ops evtchn_ops_2l = {
 	.max_channels      = evtchn_2l_max_channels,
 	.nr_channels       = evtchn_2l_max_channels,
+	.remove            = evtchn_2l_remove,
 	.bind_to_cpu       = evtchn_2l_bind_to_cpu,
 	.clear_pending     = evtchn_2l_clear_pending,
 	.set_pending       = evtchn_2l_set_pending,
@@ -365,6 +379,7 @@ static const struct evtchn_ops evtchn_op
 	.unmask            = evtchn_2l_unmask,
 	.handle_events     = evtchn_2l_handle_events,
 	.resume	           = evtchn_2l_resume,
+	.percpu_deinit     = evtchn_2l_percpu_deinit,
 };
 
 void __init xen_evtchn_2l_init(void)
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -286,6 +286,7 @@ static int xen_irq_info_pirq_setup(unsig
 static void xen_irq_info_cleanup(struct irq_info *info)
 {
 	set_evtchn_to_irq(info->evtchn, -1);
+	xen_evtchn_port_remove(info->evtchn, info->cpu);
 	info->evtchn = 0;
 }
 
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -67,6 +67,7 @@ struct evtchn_ops {
 	unsigned (*nr_channels)(void);
 
 	int (*setup)(struct irq_info *info);
+	void (*remove)(evtchn_port_t port, unsigned int cpu);
 	void (*bind_to_cpu)(struct irq_info *info, unsigned cpu);
 
 	void (*clear_pending)(unsigned port);
@@ -109,6 +110,13 @@ static inline int xen_evtchn_port_setup(
 	return 0;
 }
 
+static inline void xen_evtchn_port_remove(evtchn_port_t evtchn,
+					  unsigned int cpu)
+{
+	if (evtchn_ops->remove)
+		evtchn_ops->remove(evtchn, cpu);
+}
+
 static inline void xen_evtchn_port_bind_to_cpu(struct irq_info *info,
 					       unsigned cpu)
 {


