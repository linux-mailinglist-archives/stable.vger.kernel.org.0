Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88D13FFC9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgAPXpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390942AbgAPXWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7067B2072E;
        Thu, 16 Jan 2020 23:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216968;
        bh=i0+bc8psChPsL8aeaO1Qw8WqA3DPbGaJi4hMtSmorAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8lra9IsS41lva0u+scg77GU8IW5CMgFjblJiy4dsh5SwpjinklnJR8VZY/IxciDp
         X/Jc2fxjgQarhONil9Qhwkf4zx1SomJievRT3BhA641+4yhxAWt2/87YKunrCq9f5e
         ydXWPdbQ22/7NDtFPFmBfqa1Qx3hsDZvWyw+7AhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 094/203] xprtrdma: Fix completion wait during device removal
Date:   Fri, 17 Jan 2020 00:16:51 +0100
Message-Id: <20200116231753.886716695@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 13cb886c591f341a8759f175292ddf978ef903a1 upstream.

I've found that on occasion, "rmmod <dev>" will hang while if an NFS
is under load.

Ensure that ri_remove_done is initialized only just before the
transport is woken up to force a close. This avoids the completion
possibly getting initialized again while the CM event handler is
waiting for a wake-up.

Fixes: bebd031866ca ("xprtrdma: Support unplugging an HCA from under an NFS mount")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -245,6 +245,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_
 			ia->ri_id->device->name,
 			rpcrdma_addrstr(r_xprt), rpcrdma_portstr(r_xprt));
 #endif
+		init_completion(&ia->ri_remove_done);
 		set_bit(RPCRDMA_IAF_REMOVING, &ia->ri_flags);
 		ep->rep_connected = -ENODEV;
 		xprt_force_disconnect(xprt);
@@ -299,7 +300,6 @@ rpcrdma_create_id(struct rpcrdma_xprt *x
 	trace_xprtrdma_conn_start(xprt);
 
 	init_completion(&ia->ri_done);
-	init_completion(&ia->ri_remove_done);
 
 	id = rdma_create_id(xprt->rx_xprt.xprt_net, rpcrdma_cm_event_handler,
 			    xprt, RDMA_PS_TCP, IB_QPT_RC);


