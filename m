Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2913C5506
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242478AbhGLIIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348205AbhGLH6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E85BF61930;
        Mon, 12 Jul 2021 07:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076372;
        bh=SkCYObAqlcGKq2DCKDL/YCNETKaIEPO8MDjwMW+p5gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s91m5OKTFJmeaHdwnDieVNNBTWGIBYLfY+mKomiQC0BfPY08jJP144TAcOAMtls3A
         01sgg8Ii9onyuDvglgBcyXP4vLKwTkBKUPWcvPQu77ryScFESON1REdojNbq+NecP9
         xDpXE8eTQx2hl08KuJ8jGNxMtdLgMNKeVrLeLam8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 572/800] ipv6: fix out-of-bound access in ip6_parse_tlv()
Date:   Mon, 12 Jul 2021 08:09:55 +0200
Message-Id: <20210712061028.250938486@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 6f7da8f3e2e5..26882e165c9e 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -135,18 +135,23 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
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
@@ -163,12 +168,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
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
@@ -188,7 +188,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				return false;
 
 			padlen = 0;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
-- 
2.30.2



