Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE959C030
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiHVNIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiHVNIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:08:45 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DEAD115
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:08:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.169.23])
        by mail.ispras.ru (Postfix) with ESMTPSA id 51C61401014B;
        Mon, 22 Aug 2022 13:08:25 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
Date:   Mon, 22 Aug 2022 16:08:05 +0300
Message-Id: <20220822130805.261446-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822130805.261446-1-pchelkin@ispras.ru>
References: <20220822130805.261446-1-pchelkin@ispras.ru>
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

commit 8ef49f7f8244424adcf4a546dba4cbbeb0b09c09 upstream.

We should warn user-space that it is doing something wrong when trying
to activate sessions with identical parameters but WARN_ON_ONCE macro
can not be used here as it serves a different purpose.

So it would be good to replace it with netdev_warn_once() message.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9d71dd0 ("can: add support of SAE J1939 protocol")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20220729143655.1108297-1-pchelkin@ispras.ru
[mkl: fix indention]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index e1a399821238..709141abd131 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -178,7 +178,10 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
 	if (!first)
 		return;
 
-	if (WARN_ON_ONCE(j1939_session_activate(first))) {
+	if (j1939_session_activate(first)) {
+		netdev_warn_once(first->priv->ndev,
+				 "%s: 0x%p: Identical session is already activated.\n",
+				 __func__, first);
 		first->err = -EBUSY;
 		goto activate_next;
 	} else {
-- 
2.25.1

