Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35011396201
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhEaOts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233560AbhEaOrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F9D6191F;
        Mon, 31 May 2021 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469376;
        bh=jj3v9yY4nDuM1X98v83chT6tSYrukE9hwOdA1Q/gagw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skKCtunRy9wQxqinbg4rofjXUB6/zEiOuGVvYZ8M5r8Su4thXy8YKpWim0GbsO++2
         FzkWE3fI0ga2ibm+5eacQNfFot4YuL6D5HDxCsuwFzM+wwgrfEadzeoohqdP/MZST8
         M/PsIVCanHm/Mpo7U0PEXY/c9nUg7FX0/ps0lqaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.12 139/296] netfilter: flowtable: Remove redundant hw refresh bit
Date:   Mon, 31 May 2021 15:13:14 +0200
Message-Id: <20210531130708.555869339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

commit c07531c01d8284aedaf95708ea90e76d11af0e21 upstream.

Offloading conns could fail for multiple reasons and a hw refresh bit is
set to try to reoffload it in next sw packet.
But it could be in some cases and future points that the hw refresh bit
is not set but a refresh could succeed.
Remove the hw refresh bit and do offload refresh if requested.
There won't be a new work entry if a work is already pending
anyway as there is the hw pending bit.

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_flow_table.h |    1 -
 net/netfilter/nf_flow_table_core.c    |    3 +--
 net/netfilter/nf_flow_table_offload.c |    7 ++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -130,7 +130,6 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_REFRESH,
 	NF_FLOW_HW_PENDING,
 };
 
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -259,8 +259,7 @@ void flow_offload_refresh(struct nf_flow
 {
 	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table) ||
-		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
+	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
 
 	nf_flow_offload_add(flow_table, flow);
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -753,10 +753,11 @@ static void flow_offload_work_add(struct
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
-	else
-		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+		goto out;
 
+	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+
+out:
 	nf_flow_offload_destroy(flow_rule);
 }
 


