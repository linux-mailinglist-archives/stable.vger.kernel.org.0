Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1DE43A280
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhJYTta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237923AbhJYTqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:46:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05663611C4;
        Mon, 25 Oct 2021 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190790;
        bh=K+b/FxmH+5elf00PaE0iTL9bqU+4t42Ah4rBCc5X/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCTvd2tQDhKrKsAX3smFIbVDOEWPS/QYp81nScxnjRRbsZYlbzmlRt3MUrBzMys2k
         Z3mSzU7o1shFG2Oohbo47tGSwsAyutee8Wni1NtZaSLMUQRZAjGHaRpammjRpvdnFS
         EYcfOiDm2X2p7Gu+FLe7mDVGelEviV7Qhyqti2Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.14 071/169] can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
Date:   Mon, 25 Oct 2021 21:14:12 +0200
Message-Id: <20211025191026.440293612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit b504a884f6b5a77dac7d580ffa08e482f70d1a30 upstream.

When the session state is J1939_SESSION_DONE, j1939_tp_rxtimer() will
give an alert "rx timeout, send abort", but do nothing actually. Move
the alert into session active judgment condition, it is more
reasonable.

One of the scenarios is that j1939_tp_rxtimer() execute followed by
j1939_xtp_rx_abort_one(). After j1939_xtp_rx_abort_one(), the session
state is J1939_SESSION_DONE, then j1939_tp_rxtimer() give an alert.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/20210906094219.95924-1-william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1230,12 +1230,11 @@ static enum hrtimer_restart j1939_tp_rxt
 		session->err = -ETIME;
 		j1939_session_deactivate(session);
 	} else {
-		netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
-			     __func__, session);
-
 		j1939_session_list_lock(session->priv);
 		if (session->state >= J1939_SESSION_ACTIVE &&
 		    session->state < J1939_SESSION_ACTIVE_MAX) {
+			netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
+				     __func__, session);
 			j1939_session_get(session);
 			hrtimer_start(&session->rxtimer,
 				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),


