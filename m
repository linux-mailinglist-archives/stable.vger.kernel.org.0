Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71391D8356
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732714AbgERSEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbgERSD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C88120715;
        Mon, 18 May 2020 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825038;
        bh=GnBdQhONgJyiSt5zWJqn8JkDvXKh/3TzS2kKt72sA3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgYhcGADimqHCjHxob5J7IDha8UPh6FSqVhhQd9Ei6x/v3w7rXVN9KXllPPAcEqtr
         84SFqdCiGHxBxrjXiVHVNicP8hl/6XbWWppb7LOQm7uLMfTIfLMGmShZ59hSmyAleo
         Ss1Y1Nphx3cG8+deNtYhn/b9fjlFDewbhd+MXRfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yi <yiche@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 104/194] netfilter: conntrack: fix infinite loop on rmmod
Date:   Mon, 18 May 2020 19:36:34 +0200
Message-Id: <20200518173540.560612351@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 54ab49fde95605a1077f759ce454d94e84b5ca45 ]

'rmmod nf_conntrack' can hang forever, because the netns exit
gets stuck in nf_conntrack_cleanup_net_list():

i_see_dead_people:
 busy = 0;
 list_for_each_entry(net, net_exit_list, exit_list) {
  nf_ct_iterate_cleanup(kill_all, net, 0, 0);
  if (atomic_read(&net->ct.count) != 0)
   busy = 1;
 }
 if (busy) {
  schedule();
  goto i_see_dead_people;
 }

When nf_ct_iterate_cleanup iterates the conntrack table, all nf_conn
structures can be found twice:
once for the original tuple and once for the conntracks reply tuple.

get_next_corpse() only calls the iterator when the entry is
in original direction -- the idea was to avoid unneeded invocations
of the iterator callback.

When support for clashing entries was added, the assumption that
all nf_conn objects are added twice, once in original, once for reply
tuple no longer holds -- NF_CLASH_BIT entries are only added in
the non-clashing reply direction.

Thus, if at least one NF_CLASH entry is in the list then
nf_conntrack_cleanup_net_list() always skips it completely.

During normal netns destruction, this causes a hang of several
seconds, until the gc worker removes the entry (NF_CLASH entries
always have a 1 second timeout).

But in the rmmod case, the gc worker has already been stopped, so
ct.count never becomes 0.

We can fix this in two ways:

1. Add a second test for CLASH_BIT and call iterator for those
   entries as well, or:
2. Skip the original tuple direction and use the reply tuple.

2) is simpler, so do that.

Fixes: 6a757c07e51f80ac ("netfilter: conntrack: allow insertion of clashing entries")
Reported-by: Chen Yi <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6a978d7e0d639..d11a583481334 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2137,8 +2137,19 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		nf_conntrack_lock(lockp);
 		if (*bucket < nf_conntrack_htable_size) {
 			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
 					continue;
+				/* All nf_conn objects are added to hash table twice, one
+				 * for original direction tuple, once for the reply tuple.
+				 *
+				 * Exception: In the IPS_NAT_CLASH case, only the reply
+				 * tuple is added (the original tuple already existed for
+				 * a different object).
+				 *
+				 * We only need to call the iterator once for each
+				 * conntrack, so we just use the 'reply' direction
+				 * tuple while iterating.
+				 */
 				ct = nf_ct_tuplehash_to_ctrack(h);
 				if (iter(ct, data))
 					goto found;
-- 
2.20.1



