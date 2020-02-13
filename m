Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810A515C395
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgBMPmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgBMP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:08 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC13624670;
        Thu, 13 Feb 2020 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607688;
        bh=rL6fDz+I5A3uyYZWOVRc2bEZCJUprRQhZbW+bndkYms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5idrao7tM3VN0zr0r7s8udfepXjs6/qrZP60xnqN1ZrpSVyq89gPhDW8SKHRmVq9
         jBfm4tR8NXjD3jTuEIFjztMp8+/VWcca4d7CeRsuRzgvem5iB3ukdpv4xeDHDBDmWx
         poobjxDL+E+K7AYaD4Wc4SUeLLhLoR7O9t4Tdiq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 024/120] netfilter: flowtable: restrict flow dissector match on meta ingress device
Date:   Thu, 13 Feb 2020 07:20:20 -0800
Message-Id: <20200213151910.353478699@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit a7521a60a5f3e1f58a015fedb6e69aed40455feb upstream.

Set on FLOW_DISSECTOR_KEY_META meta key using flow tuple ingress interface.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_offload.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -24,6 +24,7 @@ struct flow_offload_work {
 };
 
 struct nf_flow_key {
+	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
 	struct flow_dissector_key_basic			basic;
 	union {
@@ -55,6 +56,7 @@ static int nf_flow_rule_match(struct nf_
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
 
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
@@ -62,6 +64,9 @@ static int nf_flow_rule_match(struct nf_
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	key->meta.ingress_ifindex = tuple->iifidx;
+	mask->meta.ingress_ifindex = 0xffffffff;
+
 	switch (tuple->l3proto) {
 	case AF_INET:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
@@ -105,7 +110,8 @@ static int nf_flow_rule_match(struct nf_
 	key->tp.dst = tuple->dst_port;
 	mask->tp.dst = 0xffff;
 
-	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
+				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 				      BIT(FLOW_DISSECTOR_KEY_PORTS);
 	return 0;


