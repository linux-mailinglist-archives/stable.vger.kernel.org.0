Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7595528B9ED
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgJLNgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbgJLNfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557F22222E;
        Mon, 12 Oct 2020 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509735;
        bh=blny0vzeraY8OZXtBq/Y5u2EGZIi1QaZ1URDTNlChsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhinE0J87yHZGkVJpu71j6IEBZFg2bmorvcBofu2PN/ARF05FVziSb2zWfncEqW4z
         VEH6/Omi90+UywWQqGkyyr4FJkadbpA1IE6oKABlbeJPDWu0pj9ZAl82Mg+XsOfsSB
         lWFJzAgZAYXBdEbZY1GopkMJYFxux9sLVR7LP6TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 48/54] rxrpc: Fix rxkad token xdr encoding
Date:   Mon, 12 Oct 2020 15:27:10 +0200
Message-Id: <20201012132631.789139504@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
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
 net/rxrpc/key.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 7fc340726d034..fd9260620824e 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1139,6 +1139,14 @@ static long rxrpc_read(const struct key *key,
 			goto fault;					\
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
@@ -1167,7 +1175,7 @@ static long rxrpc_read(const struct key *key,
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



