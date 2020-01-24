Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C573147F64
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbgAXLBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbgAXLBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:51 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E279020838;
        Fri, 24 Jan 2020 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863710;
        bh=anIp5eZ50UaO6uRuZfsW4C5hlp1D2NfMWszRaDFmr3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVcHLaMO6odcd4u2Wqtni9ybMxaCnNnUUI0q6qrgpSfRdnBLdspxDaNyzAYtCoqDK
         jFWIu0qIMqjIPKoKAneta4XDcQTO1odNcmOOM7Gcp94rWTtYN+aHUX/NcZ+h3W4BwL
         5jnZ7bvn0xaFQv/H0TDdsBUZvFfEUJMZXfTwIqZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/639] netfilter: nf_flow_table: do not remove offload when other netnss interface is down
Date:   Fri, 24 Jan 2020 10:23:44 +0100
Message-Id: <20200124093054.177084474@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit a3fb3698cadf27dc142b24394c401625e14d80d0 ]

When interface is down, offload cleanup function(nf_flow_table_do_cleanup)
is called and that checks whether interface index of offload and
index of link down interface is same. but only interface index checking
is not enough because flowtable is not pernet list.
So that, if other netns's interface that has index is same with offload
is down, that offload will be removed.
This patch adds netns checking code to the offload cleanup routine.

Fixes: 59c466dd68e7 ("netfilter: nf_flow_table: add a new flow state for tearing down offloading")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 70bd730ca0597..890799c16aa41 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -491,14 +491,17 @@ EXPORT_SYMBOL_GPL(nf_flow_table_init);
 static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
 
 	if (!dev) {
 		flow_offload_teardown(flow);
 		return;
 	}
-
-	if (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
-	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
+	if (net_eq(nf_ct_net(e->ct), dev_net(dev)) &&
+	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
+	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
 		flow_offload_dead(flow);
 }
 
-- 
2.20.1



