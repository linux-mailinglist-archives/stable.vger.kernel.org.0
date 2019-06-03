Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32CE32BC3
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfFCJL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbfFCJL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F26A27E69;
        Mon,  3 Jun 2019 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553087;
        bh=p/x8X6sBEti6Y9gLNGUZJDvgAbjmXLS9dkytr/uQFnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntfp3Tx7kXy5K4e9zg6UTapuHWfKeHjTf6eqh1Ve07W59dDyE60Ven+mxxz2pSnKS
         F5z+ug+cOBFFXAe8fxvvQer/9j+ibzRiAOvNg/CsMwozPAmbjR68WOi7ez8vE+/l9L
         eT1E+tzkWK8jLyT3iLt/pWqwkK60CJGL89g/zEv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 16/36] net: sched: dont use tc_action->order during action dump
Date:   Mon,  3 Jun 2019 11:09:04 +0200
Message-Id: <20190603090522.047637373@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 4097e9d250fb17958c1d9b94538386edd3f20144 ]

Function tcf_action_dump() relies on tc_action->order field when starting
nested nla to send action data to userspace. This approach breaks in
several cases:

- When multiple filters point to same shared action, tc_action->order field
  is overwritten each time it is attached to filter. This causes filter
  dump to output action with incorrect attribute for all filters that have
  the action in different position (different order) from the last set
  tc_action->order value.

- When action data is displayed using tc action API (RTM_GETACTION), action
  order is overwritten by tca_action_gd() according to its position in
  resulting array of nl attributes, which will break filter dump for all
  filters attached to that shared action that expect it to have different
  order value.

Don't rely on tc_action->order when dumping actions. Set nla according to
action position in resulting array of actions instead.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -766,7 +766,7 @@ int tcf_action_dump(struct sk_buff *skb,
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
-		nest = nla_nest_start(skb, a->order);
+		nest = nla_nest_start(skb, i + 1);
 		if (nest == NULL)
 			goto nla_put_failure;
 		err = tcf_action_dump_1(skb, a, bind, ref);
@@ -1283,7 +1283,6 @@ tca_action_gd(struct net *net, struct nl
 			ret = PTR_ERR(act);
 			goto err;
 		}
-		act->order = i;
 		attr_size += tcf_action_fill_size(act);
 		actions[i - 1] = act;
 	}


