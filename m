Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92326566DC6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbiGEM1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbiGEMZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E2C19030;
        Tue,  5 Jul 2022 05:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9099B61984;
        Tue,  5 Jul 2022 12:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2978C341C7;
        Tue,  5 Jul 2022 12:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023472;
        bh=U34rNph8eGw3+zf4eWrSb9z9cFtpi/8N4RJeKWPzRlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9LXiUUSolwrlQx4yIo8TGCube3h5er8nAv/PQrcpdi+xwRkDpSizbsGsnRW98TEl
         m13OmbbyF5n+zL/uGBonhH0VRjnRNfSbkydOCqZJ+ZuY0TObqOkfooNgxt0aTgAk7V
         +RBU/mT8GcT3ukG9M9cLQdi3nCoR34RDpnDE8cHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 071/102] tcp: add a missing nf_reset_ct() in 3WHS handling
Date:   Tue,  5 Jul 2022 13:58:37 +0200
Message-Id: <20220705115620.423946059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6f0012e35160cd08a53e46e3b3bbf724b92dfe68 upstream.

When the third packet of 3WHS connection establishment
contains payload, it is added into socket receive queue
without the XFRM check and the drop of connection tracking
context.

This means that if the data is left unread in the socket
receive queue, conntrack module can not be unloaded.

As most applications usually reads the incoming data
immediately after accept(), bug has been hiding for
quite a long time.

Commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") exposed this bug because
even if the application reads this data, the skb
with nfct state could stay in a per-cpu cache for
an arbitrary time, if said cpu no longer process RX softirqs.

Many thanks to Ilya Maximets for reporting this issue,
and for testing various patches:
https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/

Note that I also added a missing xfrm4_policy_check() call,
although this is probably not a big issue, as the SYN
packet should have been dropped earlier.

Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Tested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://lore.kernel.org/r/20220623050436.1290307-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1965,7 +1965,10 @@ process:
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
+		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+		else
+			drop_reason = tcp_inbound_md5_hash(sk, skb,
 						   &iph->saddr, &iph->daddr,
 						   AF_INET, dif, sdif);
 		if (unlikely(drop_reason)) {
@@ -2017,6 +2020,7 @@ process:
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);


