Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E553A48B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfFIJov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:44:51 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59453 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJov (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:44:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 98D923D4;
        Sun,  9 Jun 2019 05:44:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lRYnu0
        Gk5iKMIsow8QablQxHk/9CQsrXxlQWvU0w8p0=; b=cQx/S1C9ZBWWW1hT0HnExV
        KjUF6Pk1OoVO4bVV2cWv+P5FvpUpO67H9YjCbpVDYZsiSAexBQedfjEZeLYoBSMz
        iPIdojy4NhTabfcSXWiR0lpA9Orw9SWNzcUG7JvitCRuJnHqrX7Ia+uA6hGklOcG
        BvPhvWaAIy81JfbgAgYsDo3bXt+o8fzgy/LEjSXWy+eYVcfibcdtoAaFsWdwULdR
        yBTOB0P1vermcR8kINe+s/Dc7U5N/LO5MN3Noo/HIQf+fK0TAtaPE1k28yzud99i
        K1gXbenoLXWVVBTeooMn/G2iHix0p4824XWy3M/lVAc6j61qcFVs92/EL9xxS3Rw
        ==
X-ME-Sender: <xms:EtX8XKBs5AUzeX4d7NDjavmkCEQys8MXlI30U63bNwCK1xvyDnT9jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:EtX8XMtSIm6X7NJAyDihVYGYQzUrE7iY7kP5TLmBtaHVxXG1gQjh-w>
    <xmx:EtX8XE60bBcVoYYDoHRWf8klrw_BKQk3AkzOEd_om0RQRhT2U6so5g>
    <xmx:EtX8XGf_H89VBpTA0lDD75DRH5zeHl9HsdftSBaBQ6qOH25C6erdAg>
    <xmx:EtX8XD927a-ybuN8DAGjaqEqGcQOxoGIN4gdV3QclZh4NZLKKt6yxg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D231380087;
        Sun,  9 Jun 2019 05:44:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] SUNRPC fix regression in umount of a secure mount" failed to apply to 4.14-stable tree
To:     kolga@netapp.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:44:39 +0200
Message-ID: <1560073479187217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

