Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B525461E48
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhK2SfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35672 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379397AbhK2SdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942EBB815C2;
        Mon, 29 Nov 2021 18:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DEC53FCF;
        Mon, 29 Nov 2021 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210583;
        bh=h2ZetIc4Td7TdQZhA7qTSqCRG64cFmXtD08DNteIPsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbJys3PlJrQw20Cfhv1f/qL//2bwayMqWnmmb1mfyW4Mmkn1GuA1C8d2J0fa0YAAz
         3oSwNdp+QrCgcrfKyq+ausrMkHWt+Y6Y3Hd7HBOEE/srqlAruknoWFrF7/02219j5K
         Nfp1/K/70z9I51XCUhgoyv6uROMn1uhkNS/9d9Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Will Mortensen <willmo@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/121] netfilter: flowtable: fix IPv6 tunnel addr match
Date:   Mon, 29 Nov 2021 19:17:55 +0100
Message-Id: <20211129181713.145955826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Mortensen <willmo@gmail.com>

[ Upstream commit 39f6eed4cb209643f3f8633291854ed7375d7264 ]

Previously the IPv6 addresses in the key were clobbered and the mask was
left unset.

I haven't tested this; I noticed it while skimming the code to
understand an unrelated issue.

Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Cc: wenxu <wenxu@ucloud.cn>
Signed-off-by: Will Mortensen <willmo@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a6b654b028dd4..d1862782be450 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -63,11 +63,11 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
 		       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.src, 0xff,
+			memset(&mask->enc_ipv6.src, 0xff,
 			       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.dst, 0xff,
+			memset(&mask->enc_ipv6.dst, 0xff,
 			       sizeof(struct in6_addr));
 		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
-- 
2.33.0



