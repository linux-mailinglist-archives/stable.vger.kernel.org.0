Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D02B62D2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbgKQNcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbgKQNcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E55B8207BC;
        Tue, 17 Nov 2020 13:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619926;
        bh=U5ILUUZszFVgPDcqDtYOt4f9Ux+iVgLzLZO2zPJ9aG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJQrohkb/BfVm0mJzUVwBUZEbSQxrDBCH7xcAoggHkHnYVksPR6t9eS7y9vGMRJv4
         SG5YA8hLSn41qhOEHK19HHZahdjTWxUyNyO468AEZBlwIlpcPjoaSOXRR8nHXcZ+0r
         RKB/v/xqulIy4hbYlq9pr/NKO+JmUQeqzNPQxh6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 050/255] can: j1939: j1939_sk_bind(): return failure if netdev is down
Date:   Tue, 17 Nov 2020 14:03:10 +0100
Message-Id: <20201117122141.386940561@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 08c487d8d807535f509ed80c6a10ad90e6872139 ]

When a netdev down event occurs after a successful call to
j1939_sk_bind(), j1939_netdev_notify() can handle it correctly.

But if the netdev already in down state before calling j1939_sk_bind(),
j1939_sk_release() will stay in wait_event_interruptible() blocked
forever. Because in this case, j1939_netdev_notify() won't be called and
j1939_tp_txtimer() won't call j1939_session_cancel() or other function
to clear session for ENETDOWN error, this lead to mismatch of
j1939_session_get/put() and jsk->skb_pending will never decrease to
zero.

To reproduce it use following commands:
1. ip link add dev vcan0 type vcan
2. j1939acd -r 100,80-120 1122334455667788 vcan0
3. presses ctrl-c and thread will be blocked forever

This patch adds check for ndev->flags in j1939_sk_bind() to avoid this
kind of situation and return with -ENETDOWN.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1599460308-18770-1-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 1be4c898b2fa8..f23966526a885 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -475,6 +475,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
+		if (!(ndev->flags & IFF_UP)) {
+			dev_put(ndev);
+			ret = -ENETDOWN;
+			goto out_release_sock;
+		}
+
 		priv = j1939_netdev_start(ndev);
 		dev_put(ndev);
 		if (IS_ERR(priv)) {
-- 
2.27.0



