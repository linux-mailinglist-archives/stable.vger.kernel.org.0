Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D474751AA43
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356434AbiEDRWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357096AbiEDROr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4BC5418F;
        Wed,  4 May 2022 09:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65778618B4;
        Wed,  4 May 2022 16:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ABAC385AF;
        Wed,  4 May 2022 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683477;
        bh=kf3q6jXDvibRoh2l+V9FYoIeB2JPjD515DNDKpNhycI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngqrprgVvuvuMW9u4/R5gzyk1E5uNUoY4oh21rcUga/mxEa0Q+sfzKNJo1Z6+5u6C
         an9w7YcrlStt1c815ag06c8vETZML+5MtUgeIRld/nNJkUQU6ie1OX06MHkQnlx4WO
         lFOV3YeSdt0fnu2e6HXNdbwqYEqoJnHu0W/XgKwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaco Kroon <jaco@uls.co.za>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 139/225] netfilter: nf_conntrack_tcp: re-init for syn packets only
Date:   Wed,  4 May 2022 18:46:17 +0200
Message-Id: <20220504153122.642804005@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c7aab4f17021b636a0ee75bcf28e06fb7c94ab48 ]

Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
pinpointed to nf_conntrack tcp_in_window() bug.

tcp trace shows following sequence:

I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
R > I Flags [P.], seq 1:89, ack 1, [..]

Note 3rd ACK is from responder to initiator so following branch is taken:
    } else if (((state->state == TCP_CONNTRACK_SYN_SENT
               && dir == IP_CT_DIR_ORIGINAL)
               || (state->state == TCP_CONNTRACK_SYN_RECV
               && dir == IP_CT_DIR_REPLY))
               && after(end, sender->td_end)) {

... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
This causes the scaling factor to be reset to 0: window scale option
is only present in syn(ack) packets.  This in turn makes nf_conntrack
mark valid packets as out-of-window.

This was always broken, it exists even in original commit where
window tracking was added to ip_conntrack (nf_conntrack predecessor)
in 2.6.9-rc1 kernel.

Restrict to 'tcph->syn', just like the 3rd condtional added in
commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").

Upon closer look, those conditionals/branches can be merged:

Because earlier checks prevent syn-ack from showing up in
original direction, the 'dir' checks in the conditional quoted above are
redundant, remove them. Return early for pure syn retransmitted in reply
direction (simultaneous open).

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Jaco Kroon <jaco@uls.co.za>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572..204a5cdff5b1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -556,24 +556,14 @@ static bool tcp_in_window(struct nf_conn *ct,
 			}
 
 		}
-	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
-		     && dir == IP_CT_DIR_ORIGINAL)
-		   || (state->state == TCP_CONNTRACK_SYN_RECV
-		     && dir == IP_CT_DIR_REPLY))
-		   && after(end, sender->td_end)) {
+	} else if (tcph->syn &&
+		   after(end, sender->td_end) &&
+		   (state->state == TCP_CONNTRACK_SYN_SENT ||
+		    state->state == TCP_CONNTRACK_SYN_RECV)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
 		 * not wait at all; it must only be sure to use sequence
 		 * numbers larger than those recently used."
-		 */
-		sender->td_end =
-		sender->td_maxend = end;
-		sender->td_maxwin = (win == 0 ? 1 : win);
-
-		tcp_options(skb, dataoff, tcph, sender);
-	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
-		   state->state == TCP_CONNTRACK_SYN_SENT) {
-		/* Retransmitted syn-ack, or syn (simultaneous open).
 		 *
 		 * Re-init state for this direction, just like for the first
 		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
@@ -581,7 +571,8 @@ static bool tcp_in_window(struct nf_conn *ct,
 		tcp_init_sender(sender, receiver,
 				skb, dataoff, tcph,
 				end, win);
-		if (!tcph->ack)
+
+		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
 			return true;
 	}
 
-- 
2.35.1



