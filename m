Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09C45219C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbhKPBFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245507AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E766324B;
        Mon, 15 Nov 2021 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001366;
        bh=zUQYMNJ/Ol6e7KF7fu/uGEUcN53wv9SOOTYHhTX8NAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3y/OKlcomdSWhtRmUt86++g/6AJRQO2SE9coqRx0Gmi18xp9D914Euca2RGLRNOB
         qUp3U86y9CLwje7++CN0D7SHO6unlUNCxFlpw3q77caUrN86ZMz8dfS7fKkBaS4+TJ
         Rlp+niyc5y4LPwBBFVrJWp85vY5AZVh8dmnebsKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 129/917] can: j1939: j1939_can_recv(): ignore messages with invalid source address
Date:   Mon, 15 Nov 2021 17:53:44 +0100
Message-Id: <20211115165433.135422863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


