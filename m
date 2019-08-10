Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8888E4E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfHJUxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53874 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053E-5a; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Yc-PM; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Xin Long" <lucien.xin@gmail.com>,
        "Florian Westphal" <fw@strlen.de>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "Li Shuang" <shuali@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.159058855@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 015/157] netfilter: bridge: set skb transport_header
 before entering NF_INET_PRE_ROUTING
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit e166e4fdaced850bee3d5ee12a5740258fb30587 upstream.

Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
skb->transport_header has been always set before entering INET
netfilter. This patch is to set skb->transport_header for bridge
before entering INET netfilter by bridge-nf-call-iptables.

It also fixes an issue that sctp_error() couldn't compute a right
csum due to unset skb->transport_header.

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Reported-by: Li Shuang <shuali@redhat.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[bwh: Backported to 3.16: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -659,6 +659,8 @@ static unsigned int br_nf_pre_routing_ip
 		return NF_DROP;
 
 	skb->protocol = htons(ETH_P_IPV6);
+	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
 
@@ -715,6 +717,7 @@ static unsigned int br_nf_pre_routing(co
 		return NF_DROP;
 	store_orig_dstaddr(skb);
 	skb->protocol = htons(ETH_P_IP);
+	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
 
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish);

