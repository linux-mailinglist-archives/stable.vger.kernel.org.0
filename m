Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D65322674E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbgGTQKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387677AbgGTQKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11B920672;
        Mon, 20 Jul 2020 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261431;
        bh=zSLIqHYNiz6fKO5WOj4GvcUQob4ronNMos2S6vOcuA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2Ia4ZM6xovFooyEEY4TGbL0gnC9AhJM8x8fH7+/dTScc7fR7bFapbxyZ6Rkkgk4W
         y82MtKE1B6zcgREjVac1WxcgeonqZ/kUsNrhL9HAzSNQAh4jFvO5RL9XG0lf7fdzi3
         UGhqYMTibdBZacTZ0VpWTXsddmTvjbzBmhXzLG14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/244] xprtrdma: Fix handling of connect errors
Date:   Mon, 20 Jul 2020 17:36:17 +0200
Message-Id: <20200720152830.871081296@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit af667527b0e34912d2cb3586d585f66db4e4f486 ]

Ensure that the connect worker is awoken if an attempt to establish
a connection is unsuccessful. Otherwise the worker waits forever
and the transport workload hangs.

Connect errors should not attempt to destroy the ep, since the
connect worker continues to use it after the handler runs, so these
errors are now handled independently of DISCONNECTED events.

Reported-by: Dan Aloni <dan@kernelim.com>
Fixes: e28ce90083f0 ("xprtrdma: kmalloc rpcrdma_ep separate from rpcrdma_xprt")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 220c2d2eeb3e5..26e89c65ba564 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -279,17 +279,19 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		break;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 		ep->re_connect_status = -ENOTCONN;
-		goto disconnected;
+		goto wake_connect_worker;
 	case RDMA_CM_EVENT_UNREACHABLE:
 		ep->re_connect_status = -ENETUNREACH;
-		goto disconnected;
+		goto wake_connect_worker;
 	case RDMA_CM_EVENT_REJECTED:
 		dprintk("rpcrdma: connection to %pISpc rejected: %s\n",
 			sap, rdma_reject_msg(id, event->status));
 		ep->re_connect_status = -ECONNREFUSED;
 		if (event->status == IB_CM_REJ_STALE_CONN)
 			ep->re_connect_status = -ENOTCONN;
-		goto disconnected;
+wake_connect_worker:
+		wake_up_all(&ep->re_connect_wait);
+		return 0;
 	case RDMA_CM_EVENT_DISCONNECTED:
 		ep->re_connect_status = -ECONNABORTED;
 disconnected:
-- 
2.25.1



