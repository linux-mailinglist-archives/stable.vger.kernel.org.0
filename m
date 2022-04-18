Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE20550505A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiDRMY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiDRMXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:23:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D659A1B797;
        Mon, 18 Apr 2022 05:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C47CB80EDA;
        Mon, 18 Apr 2022 12:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85AFC385AB;
        Mon, 18 Apr 2022 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284331;
        bh=qChVbIlFtuidMZRuxLHN8CXCO/NsypRaqy9iBBV8y0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0ctSg5TEwWBS1hw/465mEUH7r9KRlwM74CzYaTHTXvttGYs5spkOuPsHIF3yKGSc
         CxH2IRTnhWWO00ZhT6/ZuJw234dxGdvAg+2Wn80QDiPiH6tyaMuoEMK2RpqpQuEJ0H
         97HJ3095JbVj5VAkk7+80LivKBiW1ZkSS8AJUoGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 077/219] net/sched: fix initialization order when updating chain 0 head
Date:   Mon, 18 Apr 2022 14:10:46 +0200
Message-Id: <20220418121208.242608101@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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
index 5ce1208a6ea3..130b5fda9c51 100644
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



