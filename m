Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B859BFB3
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiHVMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiHVMtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:49:10 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F41A3BD
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:49:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.169.23])
        by mail.ispras.ru (Postfix) with ESMTPSA id D2E3B401014B;
        Mon, 22 Aug 2022 12:49:06 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] can: j1939: j1939_session_destroy(): fix memory leak of skbs
Date:   Mon, 22 Aug 2022 15:48:35 +0300
Message-Id: <20220822124835.254653-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822124835.254653-1-pchelkin@ispras.ru>
References: <20220822124835.254653-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 8c21c54a53ab21842f5050fa090f26b03c0313d6 upstream.

We need to drop skb references taken in j1939_session_skb_queue() when
destroying a session in j1939_session_destroy(). Otherwise those skbs
would be lost.

Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

V1: https://lore.kernel.org/all/20220708175949.539064-1-pchelkin@ispras.ru

Fixes: 9d71dd0 ("can: add support of SAE J1939 protocol")
Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20220805150216.66313-1-pchelkin@ispras.ru
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 9c39b0f5d6e0..2830a12a4dd1 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,6 +260,8 @@ static void __j1939_session_drop(struct j1939_session *session)
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
+	struct sk_buff *skb;
+
 	if (session->err)
 		j1939_sk_errqueue(session, J1939_ERRQUEUE_ABORT);
 	else
@@ -270,7 +272,11 @@ static void j1939_session_destroy(struct j1939_session *session)
 	WARN_ON_ONCE(!list_empty(&session->sk_session_queue_entry));
 	WARN_ON_ONCE(!list_empty(&session->active_session_list_entry));
 
-	skb_queue_purge(&session->skb_queue);
+	while ((skb = skb_dequeue(&session->skb_queue)) != NULL) {
+		/* drop ref taken in j1939_session_skb_queue() */
+		skb_unref(skb);
+		kfree_skb(skb);
+	}
 	__j1939_session_drop(session);
 	j1939_priv_put(session->priv);
 	kfree(session);
-- 
2.25.1

