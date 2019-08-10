Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8088DED
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfHJUu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54546 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053h-LQ; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003kq-Ru; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.506823237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 145/157] Revert "inet: update the IP ID generation
 algorithm to higher standards."
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

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 8b197d3ce585d6777197e0633d71e5af7d98cb35, which
was a stable-specific improvement to IP ID selection.  I will apply
the upstream changes instead.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -487,15 +487,13 @@ EXPORT_SYMBOL(ip_idents_reserve);
 void __ip_select_ident(struct iphdr *iph, int segs)
 {
 	static u32 ip_idents_hashrnd __read_mostly;
-	static u32 ip_idents_hashrnd_extra __read_mostly;
 	u32 hash, id;
 
 	net_get_random_once(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
-	net_get_random_once(&ip_idents_hashrnd_extra, sizeof(ip_idents_hashrnd_extra));
 
 	hash = jhash_3words((__force u32)iph->daddr,
 			    (__force u32)iph->saddr,
-			    iph->protocol ^ ip_idents_hashrnd_extra,
+			    iph->protocol,
 			    ip_idents_hashrnd);
 	id = ip_idents_reserve(hash, segs);
 	iph->id = htons(id);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -541,15 +541,12 @@ static void ip6_copy_metadata(struct sk_
 static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
 	static u32 ip6_idents_hashrnd __read_mostly;
-	static u32 ip6_idents_hashrnd_extra __read_mostly;
 	u32 hash, id;
 
 	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
-	net_get_random_once(&ip6_idents_hashrnd_extra, sizeof(ip6_idents_hashrnd_extra));
 
 	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
 	hash = __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
-	hash = jhash_1word(hash, ip6_idents_hashrnd_extra);
 
 	id = ip_idents_reserve(hash, 1);
 	fhdr->identification = htonl(id);

