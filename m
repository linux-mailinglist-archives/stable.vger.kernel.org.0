Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21043A214
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhJYTpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236699AbhJYTm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50960610D2;
        Mon, 25 Oct 2021 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190646;
        bh=e/K+BYN8xk5MJhcHyinzCtj4NiF+F90I3X1PgovOunA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lisTwwnBebNAlAHE1tHbHEgLOJB+hXKC1aiPP9BONiaiGDC5qCm4xVBxET/NPwwlv
         bl6G2DDrliwC1dN0GaC0Zq1q8tgNMSEMEo1d3XxtNx+WTVhR7tA3Q+LbIc7v2e01Ay
         iJpKc++2gtVKABRlJNFKNSbqrhgOVm2RGz9c7+WI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 036/169] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Mon, 25 Oct 2021 21:13:37 +0200
Message-Id: <20211025191022.455358035@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <cdleonard@gmail.com>

[ Upstream commit 86f1e3a8489f6a0232c1f3bc2bdb379f5ccdecec ]

With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
accept connection from the same client address in different VRFs. It is
also possible to set different MD5 keys for these clients which differ
only in the tcpm_l3index field.

This appears to work when distinguishing between different VRFs but not
between non-VRF and VRF connections. In particular:

 * tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key.
This means that adding a key with l3index != 0 after a key with l3index
== 0 will cause the earlier key to be deleted. Both keys can be present
if the non-vrf key is added later.
 * _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This
casues failures if the passwords differ.

Fix this by making tcp_md5_do_lookup_exact perform an actual exact
comparison on l3index and by making  __tcp_md5_do_lookup perfer
vrf-bound keys above other considerations like prefixlen.

Fixes: dea53bb80e07 ("tcp: Add l3index to tcp_md5sig_key and md5 functions")
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index db07c05736b2..609d7048d04d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1037,6 +1037,20 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
 DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
 EXPORT_SYMBOL(tcp_md5_needed);
 
+static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
+{
+	if (!old)
+		return true;
+
+	/* l3index always overrides non-l3index */
+	if (old->l3index && new->l3index == 0)
+		return false;
+	if (old->l3index == 0 && new->l3index)
+		return true;
+
+	return old->prefixlen < new->prefixlen;
+}
+
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
@@ -1074,8 +1088,7 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 			match = false;
 		}
 
-		if (match && (!best_match ||
-			      key->prefixlen > best_match->prefixlen))
+		if (match && better_md5_match(best_match, key))
 			best_match = key;
 	}
 	return best_match;
@@ -1105,7 +1118,7 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->l3index && key->l3index != l3index)
+		if (key->l3index != l3index)
 			continue;
 		if (!memcmp(&key->addr, addr, size) &&
 		    key->prefixlen == prefixlen)
-- 
2.33.0



