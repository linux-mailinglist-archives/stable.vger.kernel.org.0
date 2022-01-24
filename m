Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4E498F30
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349563AbiAXTvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344056AbiAXTo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9320961031;
        Mon, 24 Jan 2022 19:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712D1C340E5;
        Mon, 24 Jan 2022 19:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053467;
        bh=U3wisKp1DQL3P73XQGZFVVCkj4o+R4Zq2mDuqeIwGBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIXTNFha3khsigCnX+V7RuCwcSijYlXGMl7aqPKYsIq9BqOxify275iHYP8EqIgb0
         HQC5oVn/4p8pIlIHZBzhe2GjfwRzypdLpLo8xZMSLTuVj+FC7bYtPV2FFanB+lWlkB
         OnhwPtuNIpjmgLaJEpOdqb4Gc7I06RFRaR/kXcHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/563] Bluetooth: L2CAP: Fix not initializing sk_peer_pid
Date:   Mon, 24 Jan 2022 19:36:47 +0100
Message-Id: <20220124184025.878730397@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f5ff291098f70a70b344df1e388596755c3c8315 ]

In order to group sockets being connected using L2CAP_MODE_EXT_FLOWCTL
the pid is used but sk_peer_pid was not being initialized as it is
currently only done for af_unix.

Fixes: b48596d1dc25 ("Bluetooth: L2CAP: Add get_peer_pid callback")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 160c016a5dfb9..4574c5cb1b596 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -172,6 +172,21 @@ done:
 	return err;
 }
 
+static void l2cap_sock_init_pid(struct sock *sk)
+{
+	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+
+	/* Only L2CAP_MODE_EXT_FLOWCTL ever need to access the PID in order to
+	 * group the channels being requested.
+	 */
+	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
+	spin_lock(&sk->sk_peer_lock);
+	sk->sk_peer_pid = get_pid(task_tgid(current));
+	spin_unlock(&sk->sk_peer_lock);
+}
+
 static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 			      int alen, int flags)
 {
@@ -243,6 +258,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 	if (chan->psm && bdaddr_type_is_le(chan->src_type) && !chan->mode)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
+	l2cap_sock_init_pid(sk);
+
 	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
 				 &la.l2_bdaddr, la.l2_bdaddr_type);
 	if (err)
@@ -298,6 +315,8 @@ static int l2cap_sock_listen(struct socket *sock, int backlog)
 		goto done;
 	}
 
+	l2cap_sock_init_pid(sk);
+
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 
-- 
2.34.1



