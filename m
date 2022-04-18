Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFAE505815
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbiDROBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244676AbiDROAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A692C114;
        Mon, 18 Apr 2022 06:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DC8360F9C;
        Mon, 18 Apr 2022 13:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D70DC385C8;
        Mon, 18 Apr 2022 13:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287308;
        bh=XIPSXsMqXkgYWJscQGEr7EjgGojV+9HwO2YU2rmqgy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiWWd1b+XoUOXGNlEKl/CFgB0gT9aOrqYTOqWU5GD1o2hqGQhAqxtP9rZi9E2C1sM
         yU/vWUCmYNNXkUIpwTr/p6tohJw3/8kMFFSPpTKOf4RUys1x9vg80m5RMk0FaQzNOH
         5u9le01lTjh85elX8RvIs5FBiS9IEJ/19VkcBZa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 119/218] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options
Date:   Mon, 18 Apr 2022 14:13:05 +0200
Message-Id: <20220418121202.998475889@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
index 69f687740c76..9e9ce570bb9e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -390,8 +390,8 @@ static void tcp_options(const struct sk_buff *skb,
 				 length, buff);
 	BUG_ON(ptr == NULL);
 
-	state->td_scale =
-	state->flags = 0;
+	state->td_scale = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -806,6 +806,16 @@ static unsigned int *tcp_get_timeouts(struct net *net)
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
@@ -907,8 +917,7 @@ static int tcp_packet(struct nf_conn *ct,
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



