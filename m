Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2919499AD9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376552AbiAXVrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456125AbiAXVhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B4EC05A1BA;
        Mon, 24 Jan 2022 12:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F9F9B8122D;
        Mon, 24 Jan 2022 20:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC5C340E5;
        Mon, 24 Jan 2022 20:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055847;
        bh=nbudAHV5Id/HIQCDuN+n30CdC18eMXg3cLWyw/aOG2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMT7UME8z65lgVs+pCJMEH15jKJm7tCnx2gKpEOjq+y9DQBCxjheY9uBCa4HI0Ezv
         Jsf8TFGfPyONWwL6NlIVdp1c+nlzGXKOAzfsuriUOCuPiIW+r1nw2PjiUdxvAxlydc
         gmotoVY2CVhoB9a+1Awgwq+O4+2aza5Mtuu5GkH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/846] Bluetooth: L2CAP: Fix using wrong mode
Date:   Mon, 24 Jan 2022 19:36:41 +0100
Message-Id: <20220124184110.724640275@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 30d57722732d9736554f85f75f9d7ad5402d192e ]

If user has a set to use SOCK_STREAM the socket would default to
L2CAP_MODE_ERTM which later needs to be adjusted if the destination
address is LE which doesn't support such mode.

Fixes: 15f02b9105625 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 4574c5cb1b596..251017c69ab7f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -161,7 +161,11 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 		break;
 	}
 
-	if (chan->psm && bdaddr_type_is_le(chan->src_type))
+	/* Use L2CAP_MODE_LE_FLOWCTL (CoC) in case of LE address and
+	 * L2CAP_MODE_EXT_FLOWCTL (ECRED) has not been set.
+	 */
+	if (chan->psm && bdaddr_type_is_le(chan->src_type) &&
+	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	chan->state = BT_BOUND;
@@ -255,7 +259,11 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 			return -EINVAL;
 	}
 
-	if (chan->psm && bdaddr_type_is_le(chan->src_type) && !chan->mode)
+	/* Use L2CAP_MODE_LE_FLOWCTL (CoC) in case of LE address and
+	 * L2CAP_MODE_EXT_FLOWCTL (ECRED) has not been set.
+	 */
+	if (chan->psm && bdaddr_type_is_le(chan->src_type) &&
+	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	l2cap_sock_init_pid(sk);
-- 
2.34.1



