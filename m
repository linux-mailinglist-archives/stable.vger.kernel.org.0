Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE649A529
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370693AbiAYAF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1851185AbiAXXcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:32:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F83C019B06;
        Mon, 24 Jan 2022 11:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF4E6090B;
        Mon, 24 Jan 2022 19:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE2C340E5;
        Mon, 24 Jan 2022 19:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053932;
        bh=l6Ni9v689sSDYi8RGWJ0Fvwu5bh71a7KQRIO9ThqCxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ja2INnCtpFJvoUFie1gNGt149zvQSihO5Vbq7VquOdPjSI3br1zTWqfkRTqYWsGxl
         8SRJ6u15r8iIoxLaqywM3xaIcyOkwynbnQDJzLTdkbM15w9zAuUWWsj0xzI0Uuqzkz
         M/0VdTQ10uCk5VZV7CPhHFK/+XYx00eq4gi+i0vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/563] Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
Date:   Mon, 24 Jan 2022 19:39:50 +0100
Message-Id: <20220124184032.232010791@linuxfoundation.org>
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



