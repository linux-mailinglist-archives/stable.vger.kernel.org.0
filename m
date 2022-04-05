Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475024F3520
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiDEI2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiDEIUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB96119;
        Tue,  5 Apr 2022 01:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C3EF60AFB;
        Tue,  5 Apr 2022 08:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB54C385A2;
        Tue,  5 Apr 2022 08:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146616;
        bh=dEfiMNHodUedoAdVSKWatF8SIhfkcB5hJTSU9UfBY0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbBlLNcqvG4hc9P+m5C5nx31yS30NnjhhUPlwLq2mP2P7Ct3FRaUK/NMwkKYYCC9C
         HZRYqo6FO4CWOWRVSA03MIMMLNZ4sBKsrPyhmkbAnxA5y6Q+8w5GdThR0qKMbtwm6v
         dGSk2OIPQKox9WRCvwE+rRlX2iLZtWGQMx69c8dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0827/1126] net/sched: act_ct: fix ref leak when switching zones
Date:   Tue,  5 Apr 2022 09:26:14 +0200
Message-Id: <20220405070431.836758864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit bcb74e132a76ce0502bb33d5b65533a4ed72d159 ]

When switching zones or network namespaces without doing a ct clear in
between, it is now leaking a reference to the old ct entry. That's
because tcf_ct_skb_nfct_cached() returns false and
tcf_ct_flow_table_lookup() may simply overwrite it.

The fix is to, as the ct entry is not reusable, free it already at
tcf_ct_skb_nfct_cached().

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 2f131de361f6 ("net/sched: act_ct: Fix flow table lookup after ct clear or switching zones")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ec19f625863a..25718acc0ff0 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -605,22 +605,25 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	if (!ct)
 		return false;
 	if (!net_eq(net, read_pnet(&ct->ct_net)))
-		return false;
+		goto drop_ct;
 	if (nf_ct_zone(ct)->id != zone_id)
-		return false;
+		goto drop_ct;
 
 	/* Force conntrack entry direction. */
 	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
-		nf_ct_put(ct);
-		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-
-		return false;
+		goto drop_ct;
 	}
 
 	return true;
+
+drop_ct:
+	nf_ct_put(ct);
+	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+
+	return false;
 }
 
 /* Trim the skb to the length specified by the IP/IPv6 header,
-- 
2.34.1



