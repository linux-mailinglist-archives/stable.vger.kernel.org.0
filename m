Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0059BB8F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiHVI21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiHVI2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2CE6A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C949661041
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0AEC43142;
        Mon, 22 Aug 2022 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661156895;
        bh=D8DzF1dllkZMTo0OAvwpRsIS1Wzdyd9kjmUBF/tJhIs=;
        h=Subject:To:Cc:From:Date:From;
        b=UNPFHdD+u8wnN6VxJffpLWxSsYiXSAbp5BxBRqV/yqjjQYDc92p38rq4qCJ2tn2QR
         GTt6LBrQqfoyqAPF+gEDZPEHKr1/+3bo5L6jE8P066q2x1hQpaxzPZ1Ri/D0yRgYNE
         U4G25d2BjSsSVDHoSZ12ai6Efm45EOkrH1X9I93Y=
Subject: FAILED: patch "[PATCH] can: j1939: j1939_session_destroy(): fix memory leak of skbs" failed to apply to 5.4-stable tree
To:     pchelkin@ispras.ru, khoroshilov@ispras.ru, mkl@pengutronix.de,
        o.rempel@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:28:04 +0200
Message-ID: <1661156884138166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c21c54a53ab21842f5050fa090f26b03c0313d6 Mon Sep 17 00:00:00 2001
From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Fri, 5 Aug 2022 18:02:16 +0300
Subject: [PATCH] can: j1939: j1939_session_destroy(): fix memory leak of skbs

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

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 307ee1174a6e..d7d86c944d76 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,6 +260,8 @@ static void __j1939_session_drop(struct j1939_session *session)
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
+	struct sk_buff *skb;
+
 	if (session->transmission) {
 		if (session->err)
 			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
@@ -274,7 +276,11 @@ static void j1939_session_destroy(struct j1939_session *session)
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

