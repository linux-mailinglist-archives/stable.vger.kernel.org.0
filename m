Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C224F290117
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbgJPJL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405885AbgJPJLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA8620789;
        Fri, 16 Oct 2020 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839508;
        bh=ITELwDwEiHhqwrvrGUlHBLchS9AruZWKkngTQiu5Vas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrRYhlOBp8rhtZsNQ4YLNUD8e/x4fa89sqztgH81fMMDPQa61dOUmAg/xV+NgwvOn
         iRDXlcpOS4aj5LGGpMSlimqmDo//brG+42SBr7JpO4qrRstViMJzoYAa/yGTe6Pctg
         Z8uazKtiDPyQlEEo1cTCrscydgFn+XQxOOcJye3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.9 02/15] Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
Date:   Fri, 16 Oct 2020 11:08:04 +0200
Message-Id: <20201016090437.288868164@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
References: <20201016090437.170032996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f19425641cb2572a33cb074d5e30283720bd4d22 upstream.

Only sockets will have the chan->data set to an actual sk, channels
like A2MP would have its own data which would likely cause a crash when
calling sk_filter, in order to fix this a new callback has been
introduced so channels can implement their own filtering if necessary.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/l2cap.h |    2 ++
 net/bluetooth/l2cap_core.c    |    7 ++++---
 net/bluetooth/l2cap_sock.c    |   14 ++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -665,6 +665,8 @@ struct l2cap_ops {
 	struct sk_buff		*(*alloc_skb) (struct l2cap_chan *chan,
 					       unsigned long hdr_len,
 					       unsigned long len, int nb);
+	int			(*filter) (struct l2cap_chan * chan,
+					   struct sk_buff *skb);
 };
 
 struct l2cap_conn {
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7301,9 +7301,10 @@ static int l2cap_data_rcv(struct l2cap_c
 		goto drop;
 	}
 
-	if ((chan->mode == L2CAP_MODE_ERTM ||
-	     chan->mode == L2CAP_MODE_STREAMING) && sk_filter(chan->data, skb))
-		goto drop;
+	if (chan->ops->filter) {
+		if (chan->ops->filter(chan, skb))
+			goto drop;
+	}
 
 	if (!control->sframe) {
 		int err;
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1663,6 +1663,19 @@ static void l2cap_sock_suspend_cb(struct
 	sk->sk_state_change(sk);
 }
 
+static int l2cap_sock_filter(struct l2cap_chan *chan, struct sk_buff *skb)
+{
+	struct sock *sk = chan->data;
+
+	switch (chan->mode) {
+	case L2CAP_MODE_ERTM:
+	case L2CAP_MODE_STREAMING:
+		return sk_filter(sk, skb);
+	}
+
+	return 0;
+}
+
 static const struct l2cap_ops l2cap_chan_ops = {
 	.name			= "L2CAP Socket Interface",
 	.new_connection		= l2cap_sock_new_connection_cb,
@@ -1678,6 +1691,7 @@ static const struct l2cap_ops l2cap_chan
 	.get_sndtimeo		= l2cap_sock_get_sndtimeo_cb,
 	.get_peer_pid		= l2cap_sock_get_peer_pid_cb,
 	.alloc_skb		= l2cap_sock_alloc_skb_cb,
+	.filter			= l2cap_sock_filter,
 };
 
 static void l2cap_sock_destruct(struct sock *sk)


