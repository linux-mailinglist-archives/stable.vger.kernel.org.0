Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F753A48C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfFIJox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:44:53 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35469 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJox (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:44:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 67F0C3D9;
        Sun,  9 Jun 2019 05:44:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/lvF7N
        Mb9sfcAYSboRV9UXUV9eoXDKbb287UdtSIpbE=; b=CHtVg5i0/akI17abv+ydAi
        rX+2Uug4jgdjbvkskQ/TYMlGnErkGgeYxThLYIWjiqRkItiO4CtNqBr8fe+Kqier
        QHv110pNwTbLe2XOcP1+pfqYH1hFk4JbqzFj/gB6Rp4Iw7dSrQPCxbib/NdcedtG
        KgjLKeIwS0HstpL+FO4RGSvsC/jttN8y0tDV1MF4NrN9n8eE22NeY9M9kDZ56AD1
        IPMvv4L5N+8INyPyciZXaTbH3A/uf8h0cc72pCPAvyTauaT84oRDneoKfnq5FYLO
        TGcySokz2HyzroG7WyPONF26ki+DzeOoWcpOkwLrMC+9+JlPQE3SRHp1YgPvVHXg
        ==
X-ME-Sender: <xms:E9X8XNE-UDu0yQ9uN7P8zxjSjg3l0n9LKJRD63wBI1WBL1ugR58XFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:E9X8XGl6ayHl3A4ZIT7V904bRlA6_XT0rEqMHz027tOhqmgx8Ka1kQ>
    <xmx:E9X8XKJhNHMKUF0UxkIo0TfiASMvjW9_eK55iQus-JyAw0lJ_qC4hw>
    <xmx:E9X8XHYnXKmpjbtTElquEkmOLX5XTBxVSy_NsopcRoBQLEGPErI-cQ>
    <xmx:FNX8XDY_c3EDKY69lfs6QmiIZ-VifOqBthJrRRUEiZ1uhhT8dtkP6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FC728005C;
        Sun,  9 Jun 2019 05:44:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] SUNRPC fix regression in umount of a secure mount" failed to apply to 4.9-stable tree
To:     kolga@netapp.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:44:39 +0200
Message-ID: <1560073479242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

