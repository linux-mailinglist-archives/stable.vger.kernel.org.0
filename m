Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631813A48D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfFIJoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:44:55 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36887 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:44:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5D9133D4;
        Sun,  9 Jun 2019 05:44:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=p4n6AE
        7GP6p6dZmGeY3yt/UWwQvO8E0gBj73ZkruKDk=; b=kkE6ylW1tgfu5YMK2mI3ve
        nmlVFR+SaVj44dmEQtHznHlTdFvWIBKKINg4sMLS8OACZPI1aFrJeOrfo/dGxovY
        qLj00X27rzWsdMQ4wi5k/t4K5r8CVZ6rY+5ZISS8pSkzrNnslKqpDCFB+LrieJ5D
        GOzpmIacNxcQhO+FZcsZmMbIGYuhj/pRh/ASanjgvCVVqGicXxakauPkEDbORCDC
        18hQl3bVbkC/Mr/4dRmN+/LMYT/GYddG2C8DxEBwrSBIjIXtRW+tzO3lbgLFnfca
        zaYqM/dMbyLpgVWInvy9RP0j3HMwv3feBKnfcDPuQ3N8fdp9WJNC6Rp30lWX1L8A
        ==
X-ME-Sender: <xms:FdX8XNkJJhSPAVNnxh5mpKwBbzIj5aC9uKvqTxZrpgkoZZ60U12Xzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:FdX8XIum-SOUCHnJY1M0YA-_d-huUCziTJ2Gkvd3xGPGo1XI4zCZHA>
    <xmx:FdX8XA_S6AVwqCG9saCzKGz3K3mfiJuajaLJpSL2KwKyMevmOMD0tw>
    <xmx:FdX8XJyhX0CT9TvIH0HMhSOiqKU3OaIcmr3hHYz1jfDn0zbIBUq_ww>
    <xmx:FdX8XJRb1S_H5rVoV0Wtd7PDe7d1LyAHwxLn1jfFdteWjcgd1e1HFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 73497380086;
        Sun,  9 Jun 2019 05:44:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] SUNRPC fix regression in umount of a secure mount" failed to apply to 4.4-stable tree
To:     kolga@netapp.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:44:40 +0200
Message-ID: <15600734809372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec6017d9035986a36de064f48a63245930bfad6f Mon Sep 17 00:00:00 2001
From: Olga Kornievskaia <kolga@netapp.com>
Date: Wed, 29 May 2019 10:46:00 -0400
Subject: [PATCH] SUNRPC fix regression in umount of a secure mount

If call_status returns ENOTCONN, we need to re-establish the connection
state after. Otherwise the client goes into an infinite loop of call_encode,
call_transmit, call_status (ENOTCONN), call_encode.

Fixes: c8485e4d63 ("SUNRPC: Handle ECONNREFUSED correctly in xprt_transmit()")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Cc: stable@vger.kernel.org # v2.6.29+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index d6e57da56c94..94a653be8e25 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2288,13 +2288,13 @@ call_status(struct rpc_task *task)
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ECONNABORTED:
+	case -ENOTCONN:
 		rpc_force_rebind(clnt);
 		/* fall through */
 	case -EADDRINUSE:
 		rpc_delay(task, 3*HZ);
 		/* fall through */
 	case -EPIPE:
-	case -ENOTCONN:
 	case -EAGAIN:
 		break;
 	case -EIO:

