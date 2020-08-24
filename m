Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D2424F95C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgHXInO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgHXInM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB3221741;
        Mon, 24 Aug 2020 08:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258591;
        bh=D+Vmybzmzen28AV30V9SfoitNCjmhrlbMMUqq2jVhw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3bykwWlFVOoC48iN1If2QjnLxya5V/gr4W9mFN8TKzGfEigcZaO3mnLMtUe6ihfl
         hi9CE2IFHUMbTjHwXZCwmchdsZBK5HeUCuOsSqvAjj/U9jwjBXvYqz6Mfgh4VoFe6E
         cc4tN9oK6Jfd7zwmTuEerljDd0rp3ljN0xuGbNZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 071/124] can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
Date:   Mon, 24 Aug 2020 10:30:05 +0200
Message-Id: <20200824082412.907099546@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b43e3a82bc432c1caaed8950e7662c143470c54c ]

In current J1939 stack implementation, we process all locally send
messages as own messages. Even if it was send by CAN_RAW socket.

To reproduce it use following commands:
testj1939 -P -r can0:0x80 &
cansend can0 18238040#0123

This step will trigger false positive not critical warning:
j1939_simple_recv: Received already invalidated message

With this patch we add additional check to make sure, related skb is own
echo message.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-2-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c    | 1 +
 net/can/j1939/transport.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 1b7dc1a8547f3..bf9fd6ee88fe0 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -398,6 +398,7 @@ static int j1939_sk_init(struct sock *sk)
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
 	sk->sk_destruct = j1939_sk_sock_destruct;
+	sk->sk_protocol = CAN_J1939;
 
 	return 0;
 }
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 5bfe6bf15a999..30957c9a8eb7a 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2032,6 +2032,10 @@ void j1939_simple_recv(struct j1939_priv *priv, struct sk_buff *skb)
 	if (!skb->sk)
 		return;
 
+	if (skb->sk->sk_family != AF_CAN ||
+	    skb->sk->sk_protocol != CAN_J1939)
+		return;
+
 	j1939_session_list_lock(priv);
 	session = j1939_session_get_simple(priv, skb);
 	j1939_session_list_unlock(priv);
-- 
2.25.1



