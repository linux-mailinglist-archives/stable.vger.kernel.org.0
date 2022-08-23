Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81C59DEEC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiHWMDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359302AbiHWMBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D3C78596;
        Tue, 23 Aug 2022 02:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAEF760F85;
        Tue, 23 Aug 2022 09:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A2C433C1;
        Tue, 23 Aug 2022 09:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247316;
        bh=ou72801z8mN71VTlq2a6SZCJ4zfndl7r4LyeKMh+suU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+mDNN/8YEyTHXTVwR+qbWZ09mZHTHRq5vga6LCmos1vj95vRxiPc/vMTsRdAC9e7
         ODLe4tABqr+AVHci7cmaD0gC+IlwIhQhNeR7qVy5i7gko6JsLuGFWdC5kJoEAlAgVB
         pvSw3wJiftU1blYvJvVH6f7vyGz9Rf5yeyR+WSnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 386/389] can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
Date:   Tue, 23 Aug 2022 10:27:44 +0200
Message-Id: <20220823080131.695842881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

commit 8ef49f7f8244424adcf4a546dba4cbbeb0b09c09 upstream.

We should warn user-space that it is doing something wrong when trying
to activate sessions with identical parameters but WARN_ON_ONCE macro
can not be used here as it serves a different purpose.

So it would be good to replace it with netdev_warn_once() message.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20220729143655.1108297-1-pchelkin@ispras.ru
[mkl: fix indention]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/socket.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -178,7 +178,10 @@ activate_next:
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


