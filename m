Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235C96677FC
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbjALOvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbjALOu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A3A13CEC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 929E16203F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AD5C433D2;
        Thu, 12 Jan 2023 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534265;
        bh=jNHF3Y+GDEmJ84XErV0SJEa+tPhHUhT3hJSUQODrvbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjGAwhBbV0A7ZwtrDwwkS6mybnTtYUcVnUzAwF85I07LPqL1mhFOXT6j8agAeq5fe
         YnezOPVMOaYpWUGEX6j0u+4eYqafMCe9nHwiK2HDJ/t6eZI1DqzGOS7W4FI5JBnIam
         j/42tHePwP4OvGehmKAY6yuf5X2T8qWAudai6lC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
        <socketpair@gmail.com>, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 750/783] netfilter: ipset: fix hash:net,port,net hang with /0 subnet
Date:   Thu, 12 Jan 2023 14:57:46 +0100
Message-Id: <20230112135559.128583741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit a31d47be64b9b74f8cfedffe03e0a8a1f9e51f23 ]

The hash:net,port,net set type supports /0 subnets. However, the patch
commit 5f7b51bf09baca8e titled "netfilter: ipset: Limit the maximal range
of consecutive elements to add/delete" did not take into account it and
resulted in an endless loop. The bug is actually older but the patch
5f7b51bf09baca8e brings it out earlier.

Handle /0 subnets properly in hash:net,port,net set types.

Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 40 ++++++++++----------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 6446f4fccc72..144346faffc1 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -172,17 +172,26 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
+static u32
+hash_netportnet4_range_to_cidr(u32 from, u32 to, u8 *cidr)
+{
+	if (from == 0 && to == UINT_MAX) {
+		*cidr = 0;
+		return to;
+	}
+	return ip_set_range_to_cidr(from, to, cidr);
+}
+
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netportnet4 *h = set->data;
+	struct hash_netportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -284,19 +293,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -309,13 +305,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	do {
 		e.ip[0] = htonl(ip);
-		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip = hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip[1] = htonl(ip2);
-				ip2 = ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				if (i > IPSET_MAX_RANGE) {
+					hash_netportnet4_data_next(&h->next,
+								   &e);
+					return -ERANGE;
+				}
+				ip2 = hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret = adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-- 
2.35.1



