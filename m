Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07F5014CA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245096AbiDNOCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344666AbiDNNwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:52:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A7326DA;
        Thu, 14 Apr 2022 06:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3593B82968;
        Thu, 14 Apr 2022 13:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D73BC385A1;
        Thu, 14 Apr 2022 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943870;
        bh=KJVM8lmmOWqWU325e4Gw2XlSrizB3+aH08ELkkUoQLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnpwGGYzkfcWiKPfELpXe/mB4Y5pb336TF86L3mnP4QK2nq1j+T0cBs42rSS7DRSX
         j9KR7bnNKahr9SkRgv5TrG1nxeSMxBMd7jktWDNxMmYd9BB/zNQga6XGdgMF/sf2O4
         vtVr0jrwslTvUNQRy6XYRf4yVhs3racl2OWM3v6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 261/475] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options
Date:   Thu, 14 Apr 2022 15:10:46 +0200
Message-Id: <20220414110902.413840811@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 848b137151c2..b8cc3339a249 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -354,8 +354,8 @@ static void tcp_options(const struct sk_buff *skb,
 				 length, buff);
 	BUG_ON(ptr == NULL);
 
-	state->td_scale =
-	state->flags = 0;
+	state->td_scale = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -840,6 +840,16 @@ static bool nf_conntrack_tcp_established(const struct nf_conn *ct)
 	       test_bit(IPS_ASSURED_BIT, &ct->status);
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
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -946,8 +956,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
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



