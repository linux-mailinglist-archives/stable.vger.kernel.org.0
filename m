Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E87740E4EC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244910AbhIPRGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347129AbhIPQ5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758A661ACE;
        Thu, 16 Sep 2021 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809889;
        bh=yqZajeSzuZRjAZq/e6DFxJmN7kiugX54XlOTrOdtcWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/nJ1DoR/SkWhgP7Yqb1nM89t6Tn6669siE7etvbBA/kop0Gu46s4EEqUwXH2NM4u
         7boqpKDLVcCN5/YjeFXhSc+WFJ6oLWBA8tbFU+5MuOmSotRUXF7iEwa6iCVL6lwpzg
         E6rPdWgvPOsBm4amXe9uO0aNKY89OJgInu4dBHVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 278/380] tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD
Date:   Thu, 16 Sep 2021 18:00:35 +0200
Message-Id: <20210916155813.538801797@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

[ Upstream commit e3faa49bcecdfcc80e94dd75709d6acb1a5d89f6 ]

Since the original TFO server code was implemented in commit
168a8f58059a22feb9e9a2dcc1b8053dbbbc12ef ("tcp: TCP Fast Open Server -
main code path") the TFO server code has supported the sysctl bit flag
TFO_SERVER_COOKIE_NOT_REQD. Currently, when the TFO_SERVER_ENABLE and
TFO_SERVER_COOKIE_NOT_REQD sysctl bit flags are set, a server connection
will accept a SYN with N bytes of data (N > 0) that has no TFO cookie,
create a new fast open connection, process the incoming data in the SYN,
and make the connection ready for accepting. After accepting, the
connection is ready for read()/recvmsg() to read the N bytes of data in
the SYN, ready for write()/sendmsg() calls and data transmissions to
transmit data.

This commit changes an edge case in this feature by changing this
behavior to apply to (N >= 0) bytes of data in the SYN rather than only
(N > 0) bytes of data in the SYN. Now, a server will accept a data-less
SYN without a TFO cookie if TFO_SERVER_COOKIE_NOT_REQD is set.

Caveat! While this enables a new kind of TFO (data-less empty-cookie
SYN), some firewall rules setup may not work if they assume such packets
are not legit TFOs and will filter them.

Signed-off-by: Luke Hsiao <lukehsiao@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210816205105.2533289-1-luke.w.hsiao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index d49709ba8e16..107111984384 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -379,8 +379,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (syn_data &&
-	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
+	if (tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;
 
 	if (foc->len == 0) {
-- 
2.30.2



