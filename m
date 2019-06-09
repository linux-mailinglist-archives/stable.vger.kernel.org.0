Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685313AADE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfFIQo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbfFIQoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E67620840;
        Sun,  9 Jun 2019 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098694;
        bh=4HJOMs1unhwor+6znmJULHNg5Dxzi/hapt9PN24JadI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZtxKwMcNnJccpgXIJyFLZ1/XfTlh3swiUbyKbydzKLnMwFh4M6VzcLldyvGScybD
         AcTJClnjA0bjoiJwKab9nr9G4UGEy65Hpus1UMcjHkAo0AJ/Le5EqM4EPJCjbPL7vY
         zmOv0gaWmQ/TAHuGbZ5bSFzMqb1c/wuBCCRVYOBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.1 27/70] SUNRPC fix regression in umount of a secure mount
Date:   Sun,  9 Jun 2019 18:41:38 +0200
Message-Id: <20190609164129.289731833@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit ec6017d9035986a36de064f48a63245930bfad6f upstream.

If call_status returns ENOTCONN, we need to re-establish the connection
state after. Otherwise the client goes into an infinite loop of call_encode,
call_transmit, call_status (ENOTCONN), call_encode.

Fixes: c8485e4d63 ("SUNRPC: Handle ECONNREFUSED correctly in xprt_transmit()")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Cc: stable@vger.kernel.org # v2.6.29+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2260,13 +2260,13 @@ call_status(struct rpc_task *task)
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


