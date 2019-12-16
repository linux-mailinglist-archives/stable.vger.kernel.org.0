Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFFB12129A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfLPRyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbfLPRyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D200621582;
        Mon, 16 Dec 2019 17:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518852;
        bh=ekAR3ck2KgdUuuz1Bg+Oor3rUFJl91n6bzTEKuQ3JEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x37TIW1j7FXcw9gNq6AQ7LKskVGh0J5WTyk6sfgqTQv4wHc8u1U/j8/hsxdNxlYBD
         a07Ahf96CNGclyT2pVHJgJ2ajeUlowcwr9iIPTb2Nn2X+d/GXW+EM1JdoV1HlcWA2r
         yLPI+rA1bIDAAzuox0R6XtTxVUwZBqy1QNm6Ie4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/267] tcp: fix off-by-one bug on aborting window-probing socket
Date:   Mon, 16 Dec 2019 18:46:58 +0100
Message-Id: <20191216174858.352109816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 3976535af0cb9fe34a55f2ffb8d7e6b39a2f8188 ]

Previously there is an off-by-one bug on determining when to abort
a stalled window-probing socket. This patch fixes that so it is
consistent with tcp_write_timeout().

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 592d6e9967a91..04e2c43a43a5a 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -358,7 +358,7 @@ static void tcp_probe_timer(struct sock *sk)
 			return;
 	}
 
-	if (icsk->icsk_probes_out > max_probes) {
+	if (icsk->icsk_probes_out >= max_probes) {
 abort:		tcp_write_err(sk);
 	} else {
 		/* Only send another probe if we didn't close things up. */
-- 
2.20.1



