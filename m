Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A412B61D9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgKQNW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730581AbgKQNW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337EA2463D;
        Tue, 17 Nov 2020 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619378;
        bh=Fc/KPhkwj0ycdr2js3u3+sKqZ/nyyzaEMvYk3Zh1RG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hw+GfQR4MdwM0iQ5ZhWFNFuhRZ673uomWI1VN/9zp2n9veZhFF5/K9ZuAI3lZ2JpF
         0/MVbrZwPRfzh2upW5sIm1AznsQ3l5MFjgP4u/kfxYH53l9DTGZRyZ++J7myVsmg8i
         c5CC3bzcYBZR8WGQN+rLJypGniGaYc2SH8nYZeFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/151] netfilter: ipset: Update byte and packet counters regardless of whether they match
Date:   Tue, 17 Nov 2020 14:04:09 +0100
Message-Id: <20201117122122.340863787@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 7d10e62c2ff8e084c136c94d32d9a94de4d31248 ]

In ip_set_match_extensions(), for sets with counters, we take care of
updating counters themselves by calling ip_set_update_counter(), and of
checking if the given comparison and values match, by calling
ip_set_match_counter() if needed.

However, if a given comparison on counters doesn't match the configured
values, that doesn't mean the set entry itself isn't matching.

This fix restores the behaviour we had before commit 4750005a85f7
("netfilter: ipset: Fix "don't update counters" mode when counters used
at the matching"), without reintroducing the issue fixed there: back
then, mtype_data_match() first updated counters in any case, and then
took care of matching on counters.

Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
ip_set_update_counter() will anyway skip counter updates if desired.

The issue observed is illustrated by this reproducer:

  ipset create c hash:ip counters
  ipset add c 192.0.2.1
  iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

if we now send packets from 192.0.2.1, bytes and packets counters
for the entry as shown by 'ipset list' are always zero, and, no
matter how many bytes we send, the rule will never match, because
counters themselves are not updated.

Reported-by: Mithil Mhatre <mmhatre@redhat.com>
Fixes: 4750005a85f7 ("netfilter: ipset: Fix "don't update counters" mode when counters used at the matching")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 133a3f1b6f56c..3cc4daa856d6b 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -485,13 +485,14 @@ ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set)) {
 		struct ip_set_counter *counter = ext_counter(data, set);
 
+		ip_set_update_counter(counter, ext, flags);
+
 		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
 		    !(ip_set_match_counter(ip_set_get_packets(counter),
 				mext->packets, mext->packets_op) &&
 		      ip_set_match_counter(ip_set_get_bytes(counter),
 				mext->bytes, mext->bytes_op)))
 			return false;
-		ip_set_update_counter(counter, ext, flags);
 	}
 	if (SET_WITH_SKBINFO(set))
 		ip_set_get_skbinfo(ext_skbinfo(data, set),
-- 
2.27.0



