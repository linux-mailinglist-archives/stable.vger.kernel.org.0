Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0C11E46
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEBP1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbfEBP1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:27:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1CB216FD;
        Thu,  2 May 2019 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810857;
        bh=EkyQN7rAV/ZmEFPsoY8BzF4fbX5QKRdMXmRTLhBN8QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpeKRTcLWdRwCm0a34q8xoCDPDOkDH7iebZiYwY3nRIRLENCLKLv1Rz61iMwBrbwU
         D/u329WQUp8Jdq2+gHUgrgMSnbs8RdS+jfUNrXyFpLKqyCvBQMAcNKVqsypSe3I2qh
         NNjkbxMlzPpRcAFhhAK2VMBW+FjYswOkTwpuELT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 19/72] netfilter: ip6t_srh: fix NULL pointer dereferences
Date:   Thu,  2 May 2019 17:20:41 +0200
Message-Id: <20190502143334.892729703@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d65561f3d5ec933151939c543d006b79044e7a6 ]

skb_header_pointer may return NULL. The current code dereference
its return values without a NULL check.

The fix inserts the checks to avoid NULL pointer dereferences.

Fixes: 202a8ff545cc ("netfilter: add IPv6 segment routing header 'srh' match")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_srh.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 1059894a6f4c..4cb83fb69844 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -210,6 +210,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
+		if (!psid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -223,6 +225,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
+		if (!nsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -233,6 +237,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (srhinfo->mt_flags & IP6T_SRH_LSID) {
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
+		if (!lsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
-- 
2.19.1



