Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D381D8482
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgERSEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732728AbgERSEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864F420715;
        Mon, 18 May 2020 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825053;
        bh=FkJLExItuks75TnP9rWu4Y876nPik2+uGczOJPytK8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0s1p+XESXLR2z0hudquESwOad8YbTLB5WvspfDd3VuLVa53lfB16lieqccn9mNIDf
         ezYuhqK8hc4eTBOmtLEQ/2pCy3O+B0t2LbKHAg51jb7kg5/iLwuGv7BfmIcoLLCpmK
         JD0/t+wrTKa3fw/fiDmoRrx74DbU+zXbHXFf5J2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 109/194] netfilter: flowtable: set NF_FLOW_TEARDOWN flag on entry expiration
Date:   Mon, 18 May 2020 19:36:39 +0200
Message-Id: <20200518173540.886988657@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9ed81c8e0deb7bd2aa0d69371e4a0f9a7b31205d ]

If the flow timer expires, the gc sets on the NF_FLOW_TEARDOWN flag.
Otherwise, the flowtable software path might race to refresh the
timeout, leaving the state machine in inconsistent state.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 70ebebaf5bc12..0ee78a1663786 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -271,7 +271,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(flow->ct);
-	else if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+	else
 		flow_offload_fixup_ct_timeout(flow->ct);
 
 	flow_offload_free(flow);
@@ -348,8 +348,10 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
-	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
-	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
+		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
 				nf_flow_offload_del(flow_table, flow);
-- 
2.20.1



