Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D7E101820
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfKSFfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbfKSFfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866E0206EC;
        Tue, 19 Nov 2019 05:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141742;
        bh=xHgii6MAlq5HkqOsnVMUg3pugEAxzewLlAAU64EAO/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvxtifbK24dLJRfN6yd516H4UlxkFYOZ/wT3U0diFYR38LKUfgt/vDlA5R7ZqEjqV
         ropyVmAxHq+bPiejnhWJzilygsAK+tx7n6wxN3prRUv5NBtwbrDaCIWgnt52WAwnVn
         bOHD0uCxCFWFMPcvBPFxxFCBWlbhCG3LxXgwsSPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/422] ip_gre: fix parsing gre header in ipgre_err
Date:   Tue, 19 Nov 2019 06:17:05 +0100
Message-Id: <20191119051413.414949209@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit b0350d51f001e6edc13ee4f253b98b50b05dd401 ]

gre_parse_header stops parsing when csum_err is encountered, which means
tpi->key is undefined and ip_tunnel_lookup will return NULL improperly.

This patch introduce a NULL pointer as csum_err parameter. Even when
csum_err is encountered, it won't return error and continue parsing gre
header as expected.

Fixes: 9f57c67c379d ("gre: Remove support for sharing GRE protocol hook.")
Reported-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/gre_demux.c | 7 ++++---
 net/ipv4/ip_gre.c    | 9 +++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index f21ea6125fc2d..511b32ea25331 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -87,13 +87,14 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 
 	options = (__be32 *)(greh + 1);
 	if (greh->flags & GRE_CSUM) {
-		if (skb_checksum_simple_validate(skb)) {
+		if (!skb_checksum_simple_validate(skb)) {
+			skb_checksum_try_convert(skb, IPPROTO_GRE, 0,
+						 null_compute_pseudo);
+		} else if (csum_err) {
 			*csum_err = true;
 			return -EINVAL;
 		}
 
-		skb_checksum_try_convert(skb, IPPROTO_GRE, 0,
-					 null_compute_pseudo);
 		options++;
 	}
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 758a0f86d499f..681276111310b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -232,13 +232,10 @@ static void gre_err(struct sk_buff *skb, u32 info)
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
 	struct tnl_ptk_info tpi;
-	bool csum_err = false;
 
-	if (gre_parse_header(skb, &tpi, &csum_err, htons(ETH_P_IP),
-			     iph->ihl * 4) < 0) {
-		if (!csum_err)		/* ignore csum errors. */
-			return;
-	}
+	if (gre_parse_header(skb, &tpi, NULL, htons(ETH_P_IP),
+			     iph->ihl * 4) < 0)
+		return;
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-- 
2.20.1



