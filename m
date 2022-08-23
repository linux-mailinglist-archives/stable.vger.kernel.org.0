Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8432759D383
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiHWIOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242134AbiHWINv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:13:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E456C770;
        Tue, 23 Aug 2022 01:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8506DCE1B34;
        Tue, 23 Aug 2022 08:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FE8C433C1;
        Tue, 23 Aug 2022 08:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242164;
        bh=6RUbOO660W57gg9vcDPO2ChUAqzUiVW0WI9kwpLZkTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDWVEAqp25v+VSPfuFTr//4hUzicjdHSqWpSrG/iNF0flAiZJceTDJel+vvyGUtGI
         aT7j0FRHyR+weJJMNJE/dsnqkD6kGaSyW7uFJ4tGONfxYe/jzYFfsRQ691wBOaKil3
         HzSjHPxgTv/4/MlnXwyTzMDJEYMamjOp6+7lAQvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.19 070/365] can: j1939: j1939_session_destroy(): fix memory leak of skbs
Date:   Tue, 23 Aug 2022 09:59:31 +0200
Message-Id: <20220823080121.115741318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20220805150216.66313-1-pchelkin@ispras.ru
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,6 +260,8 @@ static void __j1939_session_drop(struct
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
+	struct sk_buff *skb;
+
 	if (session->transmission) {
 		if (session->err)
 			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
@@ -274,7 +276,11 @@ static void j1939_session_destroy(struct
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


