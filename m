Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0443505263
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiDRMmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240455AbiDRMjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6287E289BB;
        Mon, 18 Apr 2022 05:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 842CAB80EC1;
        Mon, 18 Apr 2022 12:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B240C385A7;
        Mon, 18 Apr 2022 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284980;
        bh=nfX52RkVnetWwd66fWma/1wj7lQr4GstsX8X9M8mg3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH0nBEtUCDuMPn7ErTKe5mfO6eO6Fqi1343VuwuMm6JylVW6JAeTHIQNYbKpJhcy4
         Y4wGRFwnizpbaYd1dz28iezDHlMmgI0/gjjvGTkUA5+CJbBaRMePQyb2uWMSqcuYa6
         jbZTx0ZM/Xz/arzqJ7Uj45USj8u4q4kNMRSkUM7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/189] net/sched: fix initialization order when updating chain 0 head
Date:   Mon, 18 Apr 2022 14:11:29 +0200
Message-Id: <20220418121202.467365834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index cd44cac7fbcf..4b552c10e7b9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1653,10 +1653,10 @@ static int tcf_chain_tp_insert(struct tcf_chain *chain,
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



