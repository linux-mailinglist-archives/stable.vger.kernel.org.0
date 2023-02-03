Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37568962C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjBCK2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjBCK2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C527A42AD
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BD6B61EBA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1833CC433EF;
        Fri,  3 Feb 2023 10:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420065;
        bh=rqBRTOyqYSMVDClp+BnF/aKDgXpRcAvEYwxWAl930t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4S/wBt4P0st7234/zsj1Tr4yniSXqRJwZol9EjUcd4DOfgfUDZ6iyH2MJn6u05c/
         leWxhRqewcXKlCnUwDDm9Ntm9Vq07l2ZX6XYSi1NNCQqhgC+s2nI5z0FcLF3zRe0JE
         zUagXxT1kNbvwH1kjQqcJr9geZx+5ygOGkv9oaX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/134] netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state
Date:   Fri,  3 Feb 2023 11:12:54 +0100
Message-Id: <20230203101026.971782958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e15d4cdf27cb0c1e977270270b2cea12e0955edd ]

Consider:
  client -----> conntrack ---> Host

client sends a SYN, but $Host is unreachable/silent.
Client eventually gives up and the conntrack entry will time out.

However, if the client is restarted with same addr/port pair, it
may prevent the conntrack entry from timing out.

This is noticeable when the existing conntrack entry has no NAT
transformation or an outdated one and port reuse happens either
on client or due to a NAT middlebox.

This change prevents refresh of the timeout for SYN retransmits,
so entry is going away after nf_conntrack_tcp_timeout_syn_sent
seconds (default: 60).

Entry will be re-created on next connection attempt, but then
nat rules will be evaluated again.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b8cc3339a249..aed967e2f30f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1158,6 +1158,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
+
+		if (index == TCP_SYN_SET && old_state == TCP_CONNTRACK_SYN_SENT) {
+			/* do not renew timeout on SYN retransmit.
+			 *
+			 * Else port reuse by client or NAT middlebox can keep
+			 * entry alive indefinitely (including nat info).
+			 */
+			return NF_ACCEPT;
+		}
+
 		/* ESTABLISHED without SEEN_REPLY, i.e. mid-connection
 		 * pickup with loose=1. Avoid large ESTABLISHED timeout.
 		 */
-- 
2.39.0



