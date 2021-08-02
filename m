Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9943DD7D7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhHBNsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234316AbhHBNr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D3F061132;
        Mon,  2 Aug 2021 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912067;
        bh=FUwFnBGkynAjzqcf5Ktzdv3yj61peikDPukjaQG6TEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp0bvWtnGmHCnyskzqw7hTgpK4EEnNfomMWE/6CzDE5pQax+v4yG/3YM3JINKdvmw
         lfOhs9xEO1SxSrewJmULsbuR9QUZB+NmaeAIS8xDhjGBsjUew5L/Qn+fyzjCpqHQDM
         m9MJKLBZzHJTINDxOxPgAQw7QY+sq/ioHTuGaA4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=A9rgio?= <surkamp@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/32] sctp: move 198 addresses from unusable to private scope
Date:   Mon,  2 Aug 2021 15:44:28 +0200
Message-Id: <20210802134333.187295749@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1d11fa231cabeae09a95cb3e4cf1d9dd34e00f08 ]

The doc draft-stewart-tsvwg-sctp-ipv4-00 that restricts 198 addresses
was never published. These addresses as private addresses should be
allowed to use in SCTP.

As Michael Tuexen suggested, this patch is to move 198 addresses from
unusable to private scope.

Reported-by: Sérgio <surkamp@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/constants.h | 4 +---
 net/sctp/protocol.c          | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 8890fd66021d..9799c300603a 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -344,8 +344,7 @@ typedef enum {
 } sctp_scope_policy_t;
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -353,7 +352,6 @@ typedef enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b2c242facf1b..b1932fd125da 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -413,7 +413,8 @@ static sctp_scope_t sctp_v4_scope(union sctp_addr *addr)
 		retval = SCTP_SCOPE_LINK;
 	} else if (ipv4_is_private_10(addr->v4.sin_addr.s_addr) ||
 		   ipv4_is_private_172(addr->v4.sin_addr.s_addr) ||
-		   ipv4_is_private_192(addr->v4.sin_addr.s_addr)) {
+		   ipv4_is_private_192(addr->v4.sin_addr.s_addr) ||
+		   ipv4_is_test_198(addr->v4.sin_addr.s_addr)) {
 		retval = SCTP_SCOPE_PRIVATE;
 	} else {
 		retval = SCTP_SCOPE_GLOBAL;
-- 
2.30.2



