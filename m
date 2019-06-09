Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517423A48A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFIJon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:44:43 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57465 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJon (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:44:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 353E53D4;
        Sun,  9 Jun 2019 05:44:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aTe3+a
        si2nqE1V6A/GIG8XwFPoGtjh7Xuh564YvyRmg=; b=frQTY4AUp59Y3MhNink1vD
        u71pP95yFswdlzEhtAPcqLlTrwDZi0FFcRx/xa/9BHE0QKsDHW1cNwf3tFGXQKx+
        X9GG8QLjtx7+SjrXoycV+BM8qDfiRszAitl0mY7lcyz6yIag+m+BrfHiUmroERW8
        u6aROpNSiOiOSt1Qq8UmIVe2kT2lnxA3ICNkgD/sTdWBBe6x03fJmPQLFZN1dRcI
        dnij9Ee3hQLvApLBiLBfZxbk4KT7Y+AVlenmzgCE/v8VwSrwXom25whab10JYeBh
        0I9iAotR+ZLtbUUfKOkEbSOYEGtn/jge4doApqsUov66ycFptbEgZbPCu2UY1L9A
        ==
X-ME-Sender: <xms:CdX8XFMWrOttB9b5Ughvj7B7dYbVwX_-Qeq6E2V4OC8jI1AtO97GOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CdX8XMMI_SNa3yR6rIHyL8N5jUuGgVcIK14NU1Ikb0PssYGlrs6-tQ>
    <xmx:CdX8XPTZCpgVjrFUz8v-5PtyaFifM7SO4l2NJiKkCWTlHBKnA6ZKwg>
    <xmx:CdX8XGAOXxB9sbzg3xCcbJHYx9SVg3Wmv-QIZiiJfhHHzGFGKgZAwA>
    <xmx:CdX8XNB-oqaEgl3yBSK1ajoFC0YvDLVTxMAwnNoZFlDlao4JyHyfPQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0706080060;
        Sun,  9 Jun 2019 05:44:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] SUNRPC fix regression in umount of a secure mount" failed to apply to 4.19-stable tree
To:     kolga@netapp.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:44:39 +0200
Message-ID: <156007347916760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

