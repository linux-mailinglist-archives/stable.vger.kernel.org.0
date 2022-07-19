Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB4F579C30
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiGSMhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbiGSMgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357CB24944;
        Tue, 19 Jul 2022 05:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 850AECE1BE5;
        Tue, 19 Jul 2022 12:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2A1C341C6;
        Tue, 19 Jul 2022 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232842;
        bh=Y5ulbQkpBh1mvGqG++QTnnact+0szAuiE1B9TbrCcZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SO8MlbvvCIYG5mAB/6/mnwab+OXZt0ykPdjID+Yx1LHIQju1wthnXCbmyraPku6Iy
         9vJ4AhnJk5WYt34VEoxA1Wi+HTCFQcbqRZw9YdgMl8OVyJTD0pK6YlmZ0lIuhi7zNt
         RjcTyUOPyy83tLapUYHAEz5NHN04DeWB8gLHWJYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/167] netfilter: nf_log: incorrect offset to network header
Date:   Tue, 19 Jul 2022 13:53:19 +0200
Message-Id: <20220719114703.008907738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7a847c00eeba9744353ecdfad253143b9115678a ]

NFPROTO_ARP is expecting to find the ARP header at the network offset.

In the particular case of ARP, HTYPE= field shows the initial bytes of
the ethernet header destination MAC address.

 netdev out: IN= OUT=bridge0 MACSRC=c2:76:e5:71:e1:de MACDST=36:b0:4a:e2:72:ea MACPROTO=0806 ARP HTYPE=14000 PTYPE=0x4ae2 OPCODE=49782

NFPROTO_NETDEV egress hook is also expecting to find the IP headers at
the network offset.

Fixes: 35b9395104d5 ("netfilter: add generic ARP packet logger")
Reported-by: Tom Yan <tom.ty89@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_log_syslog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 13234641cdb3..7000e069bc07 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -61,7 +61,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	unsigned int logflags;
 	struct arphdr _arph;
 
-	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
+	ah = skb_header_pointer(skb, nhoff, sizeof(_arph), &_arph);
 	if (!ah) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
@@ -90,7 +90,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	    ah->ar_pln != sizeof(__be32))
 		return;
 
-	ap = skb_header_pointer(skb, sizeof(_arph), sizeof(_arpp), &_arpp);
+	ap = skb_header_pointer(skb, nhoff + sizeof(_arph), sizeof(_arpp), &_arpp);
 	if (!ap) {
 		nf_log_buf_add(m, " INCOMPLETE [%zu bytes]",
 			       skb->len - sizeof(_arph));
@@ -144,7 +144,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
 				  prefix);
-	dump_arp_packet(m, loginfo, skb, 0);
+	dump_arp_packet(m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
@@ -829,7 +829,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 	if (in)
 		dump_ipv4_mac_header(m, loginfo, skb);
 
-	dump_ipv4_packet(net, m, loginfo, skb, 0);
+	dump_ipv4_packet(net, m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
-- 
2.35.1



