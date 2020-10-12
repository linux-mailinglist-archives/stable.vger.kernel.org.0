Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2528B866
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbgJLNwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731823AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1080B22247;
        Mon, 12 Oct 2020 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510436;
        bh=qdiCA891/AKho+tqEgtW7e7Hq0oe8jkjymgonMTJrmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhyhY38NpJQxk3K1HIQay+aZckIPjglUFfqT9uiP+OFc4yAXdK56BGsWbDhlBvgud
         3iYovmLFtJmj0UOEDmtcdaaw29zbgW49Mn80HB9kQhTdh+uwI0dnzNhDQXL/ySNALA
         d5CgRU4lsatgXVUmSkTO7bY7n8bWW7LdFmNbXoAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 099/124] rxrpc: Fix rxkad token xdr encoding
Date:   Mon, 12 Oct 2020 15:31:43 +0200
Message-Id: <20201012133151.651850144@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit 56305118e05b2db8d0395bba640ac9a3aee92624 ]

The session key should be encoded with just the 8 data bytes and
no length; ENCODE_DATA precedes it with a 4 byte length, which
confuses some existing tools that try to parse this format.

Add an ENCODE_BYTES macro that does not include a length, and use
it for the key.  Also adjust the expected length.

Note that commit 774521f353e1d ("rxrpc: Fix an assertion in
rxrpc_read()") had fixed a BUG by changing the length rather than
fixing the encoding.  The original length was correct.

Fixes: 99455153d067 ("RxRPC: Parse security index 5 keys (Kerberos 5)")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/key.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 0c98313dd7a8c..d77e89766406a 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1073,7 +1073,7 @@ static long rxrpc_read(const struct key *key,
 
 		switch (token->security_index) {
 		case RXRPC_SECURITY_RXKAD:
-			toksize += 9 * 4;	/* viceid, kvno, key*2 + len, begin,
+			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
 						 * end, primary, tktlen */
 			toksize += RND(token->kad->ticket_len);
 			break;
@@ -1139,6 +1139,14 @@ static long rxrpc_read(const struct key *key,
 			memcpy((u8 *)xdr + _l, &zero, 4 - (_l & 3));	\
 		xdr += (_l + 3) >> 2;					\
 	} while(0)
+#define ENCODE_BYTES(l, s)						\
+	do {								\
+		u32 _l = (l);						\
+		memcpy(xdr, (s), _l);					\
+		if (_l & 3)						\
+			memcpy((u8 *)xdr + _l, &zero, 4 - (_l & 3));	\
+		xdr += (_l + 3) >> 2;					\
+	} while(0)
 #define ENCODE64(x)					\
 	do {						\
 		__be64 y = cpu_to_be64(x);		\
@@ -1166,7 +1174,7 @@ static long rxrpc_read(const struct key *key,
 		case RXRPC_SECURITY_RXKAD:
 			ENCODE(token->kad->vice_id);
 			ENCODE(token->kad->kvno);
-			ENCODE_DATA(8, token->kad->session_key);
+			ENCODE_BYTES(8, token->kad->session_key);
 			ENCODE(token->kad->start);
 			ENCODE(token->kad->expiry);
 			ENCODE(token->kad->primary_flag);
-- 
2.25.1



