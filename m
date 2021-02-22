Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCFE321658
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBVMVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:21:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230459AbhBVMQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA9FD64DA1;
        Mon, 22 Feb 2021 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996180;
        bh=BamTYaZvGkdzZKkD4YSrebbvBsR0uV5wr67NCAblK+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7DXP/nS+DmIGOUoR9fntxMnPDWGTNZrtlg7dMapLFBIlgUCn7mRpDxWC6Rxef1+P
         Iv+Y/8esL9VgoiGs7XRZaJ785jjBA6bWLZuT89ZBXMvkOvBof60WROHuLGatxtH3ow
         rszYtkWuIPUhnYhS5/LtkyprAn4tTEGK8xixlxI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/50] netfilter: flowtable: fix tcp and udp header checksum update
Date:   Mon, 22 Feb 2021 13:13:10 +0100
Message-Id: <20210222121023.078460674@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 8d6bca156e47d68551750a384b3ff49384c67be3 ]

When updating the tcp or udp header checksum on port nat the function
inet_proto_csum_replace2 with the last parameter pseudohdr as true.
This leads to an error in the case that GRO is used and packets are
split up in GSO. The tcp or udp checksum of all packets is incorrect.

The error is probably masked due to the fact the most network driver
implement tcp/udp checksum offloading. It also only happens when GRO is
applied and not on single packets.

The error is most visible when using a pppoe connection which is not
triggering the tcp/udp checksum offload.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 890799c16aa41..b3957fe7eced2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -360,7 +360,7 @@ static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, true);
+	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, false);
 
 	return 0;
 }
@@ -377,7 +377,7 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 	udph = (void *)(skb_network_header(skb) + thoff);
 	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
 		inet_proto_csum_replace2(&udph->check, skb, port,
-					 new_port, true);
+					 new_port, false);
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-- 
2.27.0



