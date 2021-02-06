Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCCC311CB5
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 11:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBFKuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 05:50:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:52430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhBFKul (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 05:50:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612608586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TI/KsWCKGxrmPABhxI8VTW9N3/J68xoTHMjTIJFsX+o=;
        b=tDYiLQHQ2Y3VHKT6bGCTthGsTkWsSP79d3wVp5yBPPuyeVHOi0AtUJVqbLwz1XXqsFNptC
        QG67jJ0rLSBrGdI/inYBfrWSl8RL6fq4NHsMgaa+tnF5n4VCoJqieLOjwsjXVUNIWTcS/w
        ZljrX2l+lSX/iIl9WKpsEVz8MKCRhs0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8C33AC43;
        Sat,  6 Feb 2021 10:49:46 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>
Subject: [PATCH 1/7] xen/events: reset affinity of 2-level event initially
Date:   Sat,  6 Feb 2021 11:49:26 +0100
Message-Id: <20210206104932.29064-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206104932.29064-1-jgross@suse.com>
References: <20210206104932.29064-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When creating a new event channel with 2-level events the affinity
needs to be reset initially in order to avoid using an old affinity
from earlier usage of the event channel port.

The same applies to the affinity when onlining a vcpu: all old
affinity settings for this vcpu must be reset. As percpu events get
initialized before the percpu event channel hook is called,
resetting of the affinities happens after offlining a vcpu (this is
working, as initial percpu memory is zeroed out).

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_2l.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index da87f3a1e351..23217940144a 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -47,6 +47,16 @@ static unsigned evtchn_2l_max_channels(void)
 	return EVTCHN_2L_NR_CHANNELS;
 }
 
+static int evtchn_2l_setup(evtchn_port_t evtchn)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu)
+		clear_bit(evtchn, BM(per_cpu(cpu_evtchn_mask, cpu)));
+
+	return 0;
+}
+
 static void evtchn_2l_bind_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
 				  unsigned int old_cpu)
 {
@@ -355,9 +365,18 @@ static void evtchn_2l_resume(void)
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
+	.setup             = evtchn_2l_setup,
 	.bind_to_cpu       = evtchn_2l_bind_to_cpu,
 	.clear_pending     = evtchn_2l_clear_pending,
 	.set_pending       = evtchn_2l_set_pending,
@@ -367,6 +386,7 @@ static const struct evtchn_ops evtchn_ops_2l = {
 	.unmask            = evtchn_2l_unmask,
 	.handle_events     = evtchn_2l_handle_events,
 	.resume	           = evtchn_2l_resume,
+	.percpu_deinit     = evtchn_2l_percpu_deinit,
 };
 
 void __init xen_evtchn_2l_init(void)
-- 
2.26.2

