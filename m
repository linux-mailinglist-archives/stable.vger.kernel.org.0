Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC9362449
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbfGHP0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388805AbfGHP0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192EE20665;
        Mon,  8 Jul 2019 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599581;
        bh=HvHBuw5vhtQrTQzI5wIOwi6sqkK0R/TKJ+aJRAfCSjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSHNSUoc0zCMFwmKS/ae88XoDGAzyZE5lRB2Gs5c5FWcxdBPwPX6MVsGCfj6ExXCI
         5Tx+yo6082VK3FbrYB0dOKx0sxsBGIHGnzxj7WgUlGPz+NNytx4khoLzRcK4sUkTxx
         CvkyEGV6K6WZH9QQVWabICHCGMMnN3V6K6khWjO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.14 52/56] svcrdma: Ignore source port when computing DRC hash
Date:   Mon,  8 Jul 2019 17:13:44 +0200
Message-Id: <20190708150524.139654936@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 1e091c3bbf51d34d5d96337a59ce5ab2ac3ba2cc upstream.

The DRC appears to be effectively empty after an RPC/RDMA transport
reconnect. The problem is that each connection uses a different
source port, which defeats the DRC hash.

Clients always have to disconnect before they send retransmissions
to reset the connection's credit accounting, thus every retransmit
on NFS/RDMA will miss the DRC.

An NFS/RDMA client's IP source port is meaningless for RDMA
transports. The transport layer typically sets the source port value
on the connection to a random ephemeral port. The server already
ignores it for the "secure port" check. See commit 16e4d93f6de7
("NFSD: Ignore client's source port on RDMA transports").

The Linux NFS server's DRC resolves XID collisions from the same
source IP address by using the checksum of the first 200 bytes of
the RPC call header.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -524,9 +524,14 @@ static void handle_connect_req(struct rd
 	/* Save client advertised inbound read limit for use later in accept. */
 	newxprt->sc_ord = param->initiator_depth;
 
-	/* Set the local and remote addresses in the transport */
 	sa = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.dst_addr;
 	svc_xprt_set_remote(&newxprt->sc_xprt, sa, svc_addr_len(sa));
+	/* The remote port is arbitrary and not under the control of the
+	 * client ULP. Set it to a fixed value so that the DRC continues
+	 * to be effective after a reconnect.
+	 */
+	rpc_set_port((struct sockaddr *)&newxprt->sc_xprt.xpt_remote, 0);
+
 	sa = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.src_addr;
 	svc_xprt_set_local(&newxprt->sc_xprt, sa, svc_addr_len(sa));
 


