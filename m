Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE8461EF2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhK2Sl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:41:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55154 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379790AbhK2Sj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:39:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C8DACE13F9;
        Mon, 29 Nov 2021 18:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA8EC53FC7;
        Mon, 29 Nov 2021 18:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210996;
        bh=DyY5eCplJfeJT81MQiHd8O6zjyp6P6vtlkQvw4a1E3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVT8+CyWby9cAJ5WZs86T5e82UnYV085JKRXwHTjctHRfv0j7ekTnHiNWFvwpoKYE
         4AYm4b9qxrWAFREawjyIPLtxX16gSAc5s2xawB0WNxp/9SmJaZ+EjHH0DfVT6/LVsb
         xq8u+aPvtiCIZvjRhs4mGmbMyQvFDKBgHugd4gqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Will Mortensen <willmo@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/179] netfilter: flowtable: fix IPv6 tunnel addr match
Date:   Mon, 29 Nov 2021 19:17:42 +0100
Message-Id: <20211129181721.189195670@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index d6bf1b2cd541b..b561e0a44a45f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -65,11 +65,11 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
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



