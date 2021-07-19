Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAACC3CDD5F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240808AbhGSO5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244007AbhGSO4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2721561363;
        Mon, 19 Jul 2021 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708856;
        bh=1cUV7uGW6YSaufCMDEt+xRmB3oqWJllfZzhRY5rHd2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQW4y8ncPbRt9bJJwk5v38mGv1IyyMgfc50pv9KEiqpf2wc34gDXHEuApKkDL2MP5
         o/d81RaA7JM/yuUDdVQTHhybRdZsD2SheDsaGMswwaZfbdUhrOKiS3l7/60r7UT71j
         1H/hFWJtGHkAlL2ERXdjKizzfY+Aj33z+qGY0lOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/421] ipv6: fix out-of-bound access in ip6_parse_tlv()
Date:   Mon, 19 Jul 2021 16:49:29 +0200
Message-Id: <20210719144951.940854357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 624085a31c1ad6a80b1e53f686bf6ee92abbf6e8 ]

First problem is that optlen is fetched without checking
there is more than one byte to parse.

Fix this by taking care of IPV6_TLV_PAD1 before
fetching optlen (under appropriate sanity checks against len)

Second problem is that IPV6_TLV_PADN checks of zero
padding are performed before the check of remaining length.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 68b8084da83a..fe2497ae4523 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -138,18 +138,23 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	len -= 2;
 
 	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-		int i;
+		int optlen, i;
 
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
+		if (nh[off] == IPV6_TLV_PAD1) {
 			padlen++;
 			if (padlen > 7)
 				goto bad;
-			break;
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			goto bad;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			goto bad;
 
-		case IPV6_TLV_PADN:
+		if (nh[off] == IPV6_TLV_PADN) {
 			/* RFC 2460 states that the purpose of PadN is
 			 * to align the containing header to multiples
 			 * of 8. 7 is therefore the highest valid value.
@@ -166,12 +171,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				if (nh[off + i] != 0)
 					goto bad;
 			}
-			break;
-
-		default: /* Other TLV code so scan list */
-			if (optlen > len)
-				goto bad;
-
+		} else {
 			tlv_count++;
 			if (tlv_count > max_count)
 				goto bad;
@@ -191,7 +191,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				return false;
 
 			padlen = 0;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
-- 
2.30.2



