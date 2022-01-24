Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53C84997E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378398AbiAXVRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36738 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448811AbiAXVNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62342614A8;
        Mon, 24 Jan 2022 21:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A40AC36AE2;
        Mon, 24 Jan 2022 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058828;
        bh=l6Ni9v689sSDYi8RGWJ0Fvwu5bh71a7KQRIO9ThqCxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W38MF4DRlAkuJ1I1UNwujiD9JLwIcbpPhuuLsFOY05J+M+O0j3hfCoX8rfuMOb+Go
         wtjKyP/wE/pKDAzlfTC+FLATmh2ykrlejUZVaZHyMcI/tJbW/mwYrmOvTnHyuMmwut
         6nGKfHsc08vjiJ3gjD30S4TlVu3hnlNHISN8ADaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0416/1039] Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
Date:   Mon, 24 Jan 2022 19:36:45 +0100
Message-Id: <20220124184139.296305819@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2b70d4f9b20635ac328836e50d183632e1930f94 ]

The "opt" variable is a u32, but on some paths only the top bytes
were initialized and the others contained random stack data.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 251017c69ab7f..d2c6785205992 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -903,6 +903,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	struct l2cap_conn *conn;
 	int len, err = 0;
 	u32 opt;
+	u16 mtu;
+	u8 mode;
 
 	BT_DBG("sk %p", sk);
 
@@ -1085,16 +1087,16 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u16))) {
+		if (copy_from_sockptr(&mtu, optval, sizeof(u16))) {
 			err = -EFAULT;
 			break;
 		}
 
 		if (chan->mode == L2CAP_MODE_EXT_FLOWCTL &&
 		    sk->sk_state == BT_CONNECTED)
-			err = l2cap_chan_reconfigure(chan, opt);
+			err = l2cap_chan_reconfigure(chan, mtu);
 		else
-			chan->imtu = opt;
+			chan->imtu = mtu;
 
 		break;
 
@@ -1116,14 +1118,14 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u8))) {
+		if (copy_from_sockptr(&mode, optval, sizeof(u8))) {
 			err = -EFAULT;
 			break;
 		}
 
-		BT_DBG("opt %u", opt);
+		BT_DBG("mode %u", mode);
 
-		err = l2cap_set_mode(chan, opt);
+		err = l2cap_set_mode(chan, mode);
 		if (err)
 			break;
 
-- 
2.34.1



