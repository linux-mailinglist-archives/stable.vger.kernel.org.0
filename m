Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112BF344141
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCVMbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231354AbhCVMb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C120D61990;
        Mon, 22 Mar 2021 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416287;
        bh=eln6GSlQnXORZGT58NwAF6FdVlCh9p7wTueCfhmavS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWqk/3w7VnvGHASk3vI++LeATOlPlqxc5zmTzV1+t27OHvCpokfu5ubfawgZnpRCn
         9f/8zQJlbODoDSctEVBIQmFCuwoixtBvfXskgNx7j/MdfrM+q8st93kNHQO9b4k72t
         lXE0HSZ4ltz1pbAiyZGi8hefzz3cOJl3BfGWzVvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Rothenpieler <timo@rothenpieler.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 050/120] svcrdma: disable timeouts on rdma backchannel
Date:   Mon, 22 Mar 2021 13:27:13 +0100
Message-Id: <20210322121931.347605941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Rothenpieler <timo@rothenpieler.org>

commit 6820bf77864d5894ff67b5c00d7dba8f92011e3d upstream.

This brings it in line with the regular tcp backchannel, which also has
all those timeouts disabled.

Prevents the backchannel from timing out, getting some async operations
like server side copying getting stuck indefinitely on the client side.

Signed-off-by: Timo Rothenpieler <timo@rothenpieler.org>
Fixes: 5d252f90a800 ("svcrdma: Add class for RDMA backwards direction transport")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -252,9 +252,9 @@ xprt_setup_rdma_bc(struct xprt_create *a
 	xprt->timeout = &xprt_rdma_bc_timeout;
 	xprt_set_bound(xprt);
 	xprt_set_connected(xprt);
-	xprt->bind_timeout = RPCRDMA_BIND_TO;
-	xprt->reestablish_timeout = RPCRDMA_INIT_REEST_TO;
-	xprt->idle_timeout = RPCRDMA_IDLE_DISC_TO;
+	xprt->bind_timeout = 0;
+	xprt->reestablish_timeout = 0;
+	xprt->idle_timeout = 0;
 
 	xprt->prot = XPRT_TRANSPORT_BC_RDMA;
 	xprt->ops = &xprt_rdma_bc_procs;


