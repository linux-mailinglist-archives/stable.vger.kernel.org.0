Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDD138009
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgAKKWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgAKKV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:21:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B156220848;
        Sat, 11 Jan 2020 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738116;
        bh=oBkHsDvgkstaVNNnbYEpO4N/JGbrsZczsZ3CbOKCSQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hosYy5lk5Ioju6bdcIwGdw5dAgZ3pcngEscImfv3Y2NXI0nTZu1rtTv7aTCx7vaCg
         avg4iMuqQjv99yWUIOUIMjW+a9nqOF+JEifbkPtoNcAnnloFBrqYYIPhM6rj7ci4vR
         0vbHWK5zK3qpYLsZ9IeLgD+btq+0LbFvUjC7FnRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/165] netfilter: ctnetlink: netns exit must wait for callbacks
Date:   Sat, 11 Jan 2020 10:48:50 +0100
Message-Id: <20200111094922.099955022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 18a110b022a5c02e7dc9f6109d0bd93e58ac6ebb ]

Curtis Taylor and Jon Maxwell reported and debugged a crash on 3.10
based kernel.

Crash occurs in ctnetlink_conntrack_events because net->nfnl socket is
NULL.  The nfnl socket was set to NULL by netns destruction running on
another cpu.

The exiting network namespace calls the relevant destructors in the
following order:

1. ctnetlink_net_exit_batch

This nulls out the event callback pointer in struct netns.

2. nfnetlink_net_exit_batch

This nulls net->nfnl socket and frees it.

3. nf_conntrack_cleanup_net_list

This removes all remaining conntrack entries.

This is order is correct. The only explanation for the crash so ar is:

cpu1: conntrack is dying, eviction occurs:
 -> nf_ct_delete()
   -> nf_conntrack_event_report \
     -> nf_conntrack_eventmask_report
       -> notify->fcn() (== ctnetlink_conntrack_events).

cpu1: a. fetches rcu protected pointer to obtain ctnetlink event callback.
      b. gets interrupted.
 cpu2: runs netns exit handlers:
     a runs ctnetlink destructor, event cb pointer set to NULL.
     b runs nfnetlink destructor, nfnl socket is closed and set to NULL.
cpu1: c. resumes and trips over NULL net->nfnl.

Problem appears to be that ctnetlink_net_exit_batch only prevents future
callers of nf_conntrack_eventmask_report() from obtaining the callback.
It doesn't wait of other cpus that might have already obtained the
callbacks address.

I don't see anything in upstream kernels that would prevent similar
crash: We need to wait for all cpus to have exited the event callback.

Fixes: 9592a5c01e79dbc59eb56fa ("netfilter: ctnetlink: netns support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e2d13cd18875..aa8adf930b3c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3602,6 +3602,9 @@ static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
 
 	list_for_each_entry(net, net_exit_list, exit_list)
 		ctnetlink_net_exit(net);
+
+	/* wait for other cpus until they are done with ctnl_notifiers */
+	synchronize_rcu();
 }
 
 static struct pernet_operations ctnetlink_net_ops = {
-- 
2.20.1



