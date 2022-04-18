Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BC5505627
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242102AbiDRNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbiDRNag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211213FBE6;
        Mon, 18 Apr 2022 05:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2FE660FF7;
        Mon, 18 Apr 2022 12:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66FEC385A7;
        Mon, 18 Apr 2022 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286481;
        bh=JZZmyJXJTfR9m3f1cBsQ6R4p/0iYOIJFlYrSFLblW2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6OHHc/zHZEcGaaLF68cUFDjRRH6Y//RO9uCesTMQjJtOs9YnoEiXsy9FVte8QUZC
         tL8is8djPAqEFLx6ZX6hAYY6rCZEq0BIJveCfITYGfzkEsT0k6o04RNec9rifaBK2Y
         Vli1K+sbdqX8WFUydzUMv7nrxwgoJBkGobCjJ0kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/284] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options
Date:   Mon, 18 Apr 2022 14:12:09 +0200
Message-Id: <20220418121215.811257073@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f2dd495a8d589371289981d5ed33e6873df94ecc ]

Do not reset IP_CT_TCP_FLAG_BE_LIBERAL flag in out-of-sync scenarios
coming before the TCP window tracking, otherwise such connections will
fail in the window check.

Update tcp_options() to leave this flag in place and add a new helper
function to reset the tcp window state.

Based on patch from Sven Auhagen.

Fixes: c4832c7bbc3f ("netfilter: nf_ct_tcp: improve out-of-sync situation in TCP tracking")
Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index cba1c6ffe51a..5239c502c016 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -383,8 +383,8 @@ static void tcp_options(const struct sk_buff *skb,
 				 length, buff);
 	BUG_ON(ptr == NULL);
 
-	state->td_scale =
-	state->flags = 0;
+	state->td_scale = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -797,6 +797,16 @@ static unsigned int *tcp_get_timeouts(struct net *net)
 	return tcp_pernet(net)->timeouts;
 }
 
+static void nf_ct_tcp_state_reset(struct ip_ct_tcp_state *state)
+{
+	state->td_end		= 0;
+	state->td_maxend	= 0;
+	state->td_maxwin	= 0;
+	state->td_maxack	= 0;
+	state->td_scale		= 0;
+	state->flags		&= IP_CT_TCP_FLAG_BE_LIBERAL;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
@@ -897,8 +907,7 @@ static int tcp_packet(struct nf_conn *ct,
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
 				ct->proto.tcp.last_flags;
-			memset(&ct->proto.tcp.seen[dir], 0,
-			       sizeof(struct ip_ct_tcp_state));
+			nf_ct_tcp_state_reset(&ct->proto.tcp.seen[dir]);
 			break;
 		}
 		ct->proto.tcp.last_index = index;
-- 
2.34.1



