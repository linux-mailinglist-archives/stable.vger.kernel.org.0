Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE84F2F13
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350679AbiDEJ70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344203AbiDEJSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820099E9EF;
        Tue,  5 Apr 2022 02:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E616B818F3;
        Tue,  5 Apr 2022 09:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B24C385A0;
        Tue,  5 Apr 2022 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149524;
        bh=vp5P+tlZ9AwejLKFANiTgrszGOHonIstSV2V0M0I7Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqnCy//8R9edZ3vwq/XYMmZERHy3qaimDcp6bdyOn0wO7MoF9hKc+Rc0UERUHqwoI
         XCJvSeiIJKkIhU/kGqNrxax5kgZw+PQqKEA3on9hcIDck7iJ9lbaw6Ryn3nsjFjW8r
         4zF5lh//knalq1g5JXshNdNEcWvhq4KEOkg48JOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0745/1017] net/sched: act_ct: fix ref leak when switching zones
Date:   Tue,  5 Apr 2022 09:27:38 +0200
Message-Id: <20220405070416.376431731@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 240b3c5d2eb1..553bf41671a6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -583,22 +583,25 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
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



