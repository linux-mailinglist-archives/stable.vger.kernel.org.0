Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4736B505346
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiDRM4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbiDRMzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F661CA;
        Mon, 18 Apr 2022 05:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83DB60FB6;
        Mon, 18 Apr 2022 12:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CA1C385A1;
        Mon, 18 Apr 2022 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285432;
        bh=WD4iaRL10tmK8wqJABIYPrj6QsBjPpiJ24L2xP1XoJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAxY1NmlDMNSYiwCH3Nooq1MB6WaJsIpKCQAmXUcJuVMHP3k406ifbxNbUckqM2am
         +rlXlXlbcvG7REo8U0+0mfm/KVZ8UCGKBiKSZWLgDLKMgpC2zfmfug41JxoW/DcAFC
         zRl3M3TC5oLXU4+LbFTBqxnYNwFWbupiBQPHDjbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/105] net/sched: fix initialization order when updating chain 0 head
Date:   Mon, 18 Apr 2022 14:12:19 +0200
Message-Id: <20220418121146.459866104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit e65812fd22eba32f11abe28cb377cbd64cfb1ba0 ]

Currently, when inserting a new filter that needs to sit at the head
of chain 0, it will first update the heads pointer on all devices using
the (shared) block, and only then complete the initialization of the new
element so that it has a "next" element.

This can lead to a situation that the chain 0 head is propagated to
another CPU before the "next" initialization is done. When this race
condition is triggered, packets being matched on that CPU will simply
miss all other filters, and will flow through the stack as if there were
no other filters installed. If the system is using OVS + TC, such
packets will get handled by vswitchd via upcall, which results in much
higher latency and reordering. For other applications it may result in
packet drops.

This is reproducible with a tc only setup, but it varies from system to
system. It could be reproduced with a shared block amongst 10 veth
tunnels, and an ingress filter mirroring packets to another veth.
That's because using the last added veth tunnel to the shared block to
do the actual traffic, it makes the race window bigger and easier to
trigger.

The fix is rather simple, to just initialize the next pointer of the new
filter instance (tp) before propagating the head change.

The fixes tag is pointing to the original code though this issue should
only be observed when using it unlocked.

Fixes: 2190d1d0944f ("net: sched: introduce helpers to work with filter chains")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/b97d5f4eaffeeb9d058155bcab63347527261abf.1649341369.git.marcelo.leitner@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9a789a057a74..b8ffb7e4f696 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1656,10 +1656,10 @@ static int tcf_chain_tp_insert(struct tcf_chain *chain,
 	if (chain->flushing)
 		return -EAGAIN;
 
+	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	if (*chain_info->pprev == chain->filter_chain)
 		tcf_chain0_head_change(chain, tp);
 	tcf_proto_get(tp);
-	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	rcu_assign_pointer(*chain_info->pprev, tp);
 
 	return 0;
-- 
2.35.1



