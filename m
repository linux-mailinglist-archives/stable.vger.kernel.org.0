Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21D450AFE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhKORQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhKORPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:15:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F9561BF5;
        Mon, 15 Nov 2021 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996312;
        bh=zUQYMNJ/Ol6e7KF7fu/uGEUcN53wv9SOOTYHhTX8NAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e64xbjAyNIHomayJaxVToSEt0uN7go61Q/LrPbZ+ChMDgxynfljEaQWHj/X99hCJb
         PF69Rnm33cgj+wVcQFcxkU5wC1yhE/u2r/n6c3c9EMJhFyMWdXJMw6+xcSbhUE2Gio
         TjtqDdQydxIa2egZi7wjgetmzDJd/UnblyxwP20U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 092/355] can: j1939: j1939_can_recv(): ignore messages with invalid source address
Date:   Mon, 15 Nov 2021 18:00:16 +0100
Message-Id: <20211115165316.777117464@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit a79305e156db3d24fcd8eb649cdb3c3b2350e5c2 upstream.

According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
send TP.CM_CTS to the global address, so we can add a check in
j1939_can_recv() to drop messages with invalid source address.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1635431907-15617-3-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -75,6 +75,13 @@ static void j1939_can_recv(struct sk_buf
 	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
 	/* set default message type */
 	skcb->addr.type = J1939_TP;
+
+	if (!j1939_address_is_valid(skcb->addr.sa)) {
+		netdev_err_once(priv->ndev, "%s: sa is broadcast address, ignoring!\n",
+				__func__);
+		goto done;
+	}
+
 	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
 		/* Type 1: with destination address */
 		skcb->addr.da = skcb->addr.pgn;


