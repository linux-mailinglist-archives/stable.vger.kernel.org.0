Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AEB3DD813
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhHBNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234789AbhHBNtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F1B60EBB;
        Mon,  2 Aug 2021 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912147;
        bh=XwBRdNzQ8bhr3FxMYdiLgpab1x5S1ZUiuwwhtvHt4Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpxlUDrgxdl7D/qtEkxRGJqkc6C5XWjw2CI4/EiVt9yiONh6kNdq/r0rsCn2uZ3le
         uoopBk3vN/HHeLa7QsmP8txa8MYDGQCpdr/X4KM7MyNtCIFu9ATUpaLlq7wLveFAxg
         wSnfuwTYQnWAdLGsAAscxOnAxMJ5puEPlrLBzNuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=A9rgio?= <surkamp@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/38] sctp: move 198 addresses from unusable to private scope
Date:   Mon,  2 Aug 2021 15:44:31 +0200
Message-Id: <20210802134335.132297405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
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
index d4da07048aa3..cbf96458ce22 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -348,8 +348,7 @@ enum {
 #define SCTP_SCOPE_POLICY_MAX	SCTP_SCOPE_POLICY_LINK
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -357,7 +356,6 @@ enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d5cf05efddfd..868b97607601 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -423,7 +423,8 @@ static enum sctp_scope sctp_v4_scope(union sctp_addr *addr)
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



