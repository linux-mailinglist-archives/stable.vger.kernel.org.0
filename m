Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE96BB32D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjCOMmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjCOMlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B886A2198
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3569761ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB49C4339B;
        Wed, 15 Mar 2023 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884036;
        bh=4StMg3S0PTqV4b498C4qBcMyH2q0EHJpLyR63zJgfJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2ybj/vBQV+KWxOYrEDT/0bgJSLQmouPqNvDGRSibaOZ+G8M/66Ie1PhxhLCQLGMk
         bmFgVpEbsVwfLspPTdAUSO+ZGes7esISL9rO7MQWzjZpVmEeobuRymuwvumhY3cVUy
         55Wscr3cRTclaT9lawvebxG64vyu6y+lb+7FOfUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Major=20D=C3=A1vid?= <major.david@balasys.hu>
Subject: [PATCH 6.2 083/141] netfilter: tproxy: fix deadlock due to missing BH disable
Date:   Wed, 15 Mar 2023 13:13:06 +0100
Message-Id: <20230315115742.506135328@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4a02426787bf024dafdb79b362285ee325de3f5e ]

The xtables packet traverser performs an unconditional local_bh_disable(),
but the nf_tables evaluation loop does not.

Functions that are called from either xtables or nftables must assume
that they can be called in process context.

inet_twsk_deschedule_put() assumes that no softirq interrupt can occur.
If tproxy is used from nf_tables its possible that we'll deadlock
trying to aquire a lock already held in process context.

Add a small helper that takes care of this and use it.

Link: https://lore.kernel.org/netfilter-devel/401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu/
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-and-tested-by: Major Dávid <major.david@balasys.hu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tproxy.h   | 7 +++++++
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 82d0e41b76f22..faa108b1ba675 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -17,6 +17,13 @@ static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
 	return false;
 }
 
+static inline void nf_tproxy_twsk_deschedule_put(struct inet_timewait_sock *tw)
+{
+	local_bh_disable();
+	inet_twsk_deschedule_put(tw);
+	local_bh_enable();
+}
+
 /* assign a socket to the skb -- consumes sk */
 static inline void nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index b22b2c745c76c..69e3317996043 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -38,7 +38,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
 					    hp->source, lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 929502e51203b..52f828bb5a83d 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -63,7 +63,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 					    lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
-- 
2.39.2



