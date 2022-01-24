Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FDA4999C1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456001AbiAXVhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447918AbiAXVLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:11:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B936B81233;
        Mon, 24 Jan 2022 21:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C161BC340E5;
        Mon, 24 Jan 2022 21:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058702;
        bh=nbudAHV5Id/HIQCDuN+n30CdC18eMXg3cLWyw/aOG2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D2AFof3BofQ3g9/IWo4SVqQ8pKfVXZC0HRt+DwaQVXI8Q+4mSlheueNfi/ITubsJ
         jKh0e7Q0HFs+omrvWGOJXtADkvnGhd9MB6AeehUxoNEzxyoGgmOImitcuCBM6NoOta
         lv29Q1tA3f4+Cz6VKlOwjxxj61aDRkKc0CbMTLQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0342/1039] Bluetooth: L2CAP: Fix using wrong mode
Date:   Mon, 24 Jan 2022 19:35:31 +0100
Message-Id: <20220124184136.798730800@linuxfoundation.org>
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



