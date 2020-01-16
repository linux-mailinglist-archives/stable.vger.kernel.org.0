Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE33113FEF2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391194AbgAPX24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388441AbgAPX2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46B9206D9;
        Thu, 16 Jan 2020 23:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217335;
        bh=/nGz56sMA8caDTBApOsOknhSoqaPclZYldLAfPUelVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fY+2gUB0jnQ7jRV3ric8AngJcsJzND/HPgLE1t6wESa6ChPaBcsaPIwes1WVCpGFf
         IpwwrchCvP94a1uDdfmx1XEvfTV5E13Iqol4MEHKTFgyGdLfOM3DH1HENAQX/kfQlb
         dB7quDUNMLU2gpxFh8JVs+gxVZX5h47rrR/vsQfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 41/84] xprtrdma: Fix completion wait during device removal
Date:   Fri, 17 Jan 2020 00:18:15 +0100
Message-Id: <20200116231718.603428265@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -248,6 +248,7 @@ rpcrdma_conn_upcall(struct rdma_cm_id *i
 			ia->ri_device->name,
 			rpcrdma_addrstr(xprt), rpcrdma_portstr(xprt));
 #endif
+		init_completion(&ia->ri_remove_done);
 		set_bit(RPCRDMA_IAF_REMOVING, &ia->ri_flags);
 		ep->rep_connected = -ENODEV;
 		xprt_force_disconnect(&xprt->rx_xprt);
@@ -306,7 +307,6 @@ rpcrdma_create_id(struct rpcrdma_xprt *x
 	trace_xprtrdma_conn_start(xprt);
 
 	init_completion(&ia->ri_done);
-	init_completion(&ia->ri_remove_done);
 
 	id = rdma_create_id(xprt->rx_xprt.xprt_net, rpcrdma_conn_upcall,
 			    xprt, RDMA_PS_TCP, IB_QPT_RC);


