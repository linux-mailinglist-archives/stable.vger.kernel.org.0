Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77FE420FB3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbhJDNhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237811AbhJDNfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C3A961BA3;
        Mon,  4 Oct 2021 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353358;
        bh=yRx8cgjxY/YxB69xlXp2qebeWDPtFnn+ap4eb5bfAG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvbzsv8JF3XD4mYw7umPcb2YuegqFaMxNoqOzxkL1PFIevzo2/DUp5PCFTyGcPWs4
         Ig4Jk2QkmrtAAQ8casGb4OfCv6M4yCzvY1N9ITu+WS6Pk/e5rw/habOcqiQFkPULs/
         y2Y06Lo97+q+EOdbLAoGiyuM26/Bh3mTv3DYCC3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+dc3dfba010d7671e05f5@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 065/172] RDMA/cma: Ensure rdma_addr_cancel() happens before issuing more requests
Date:   Mon,  4 Oct 2021 14:51:55 +0200
Message-Id: <20211004125047.092504860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 305d568b72f17f674155a2a8275f865f207b3808 upstream.

The FSM can run in a circle allowing rdma_resolve_ip() to be called twice
on the same id_priv. While this cannot happen without going through the
work, it violates the invariant that the same address resolution
background request cannot be active twice.

       CPU 1                                  CPU 2

rdma_resolve_addr():
  RDMA_CM_IDLE -> RDMA_CM_ADDR_QUERY
  rdma_resolve_ip(addr_handler)  #1

			 process_one_req(): for #1
                          addr_handler():
                            RDMA_CM_ADDR_QUERY -> RDMA_CM_ADDR_BOUND
                            mutex_unlock(&id_priv->handler_mutex);
                            [.. handler still running ..]

rdma_resolve_addr():
  RDMA_CM_ADDR_BOUND -> RDMA_CM_ADDR_QUERY
  rdma_resolve_ip(addr_handler)
    !! two requests are now on the req_list

rdma_destroy_id():
 destroy_id_handler_unlock():
  _destroy_id():
   cma_cancel_operation():
    rdma_addr_cancel()

                          // process_one_req() self removes it
		          spin_lock_bh(&lock);
                           cancel_delayed_work(&req->work);
	                   if (!list_empty(&req->list)) == true

      ! rdma_addr_cancel() returns after process_on_req #1 is done

   kfree(id_priv)

			 process_one_req(): for #2
                          addr_handler():
	                    mutex_lock(&id_priv->handler_mutex);
                            !! Use after free on id_priv

rdma_addr_cancel() expects there to be one req on the list and only
cancels the first one. The self-removal behavior of the work only happens
after the handler has returned. This yields a situations where the
req_list can have two reqs for the same "handle" but rdma_addr_cancel()
only cancels the first one.

The second req remains active beyond rdma_destroy_id() and will
use-after-free id_priv once it inevitably triggers.

Fix this by remembering if the id_priv has called rdma_resolve_ip() and
always cancel before calling it again. This ensures the req_list never
gets more than one item in it and doesn't cost anything in the normal flow
that never uses this strange error path.

Link: https://lore.kernel.org/r/0-v1-3bc675b8006d+22-syz_cancel_uaf_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: e51060f08a61 ("IB: IP address based RDMA connection manager")
Reported-by: syzbot+dc3dfba010d7671e05f5@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c      |   23 +++++++++++++++++++++++
 drivers/infiniband/core/cma_priv.h |    1 +
 2 files changed, 24 insertions(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1776,6 +1776,14 @@ static void cma_cancel_operation(struct
 {
 	switch (state) {
 	case RDMA_CM_ADDR_QUERY:
+		/*
+		 * We can avoid doing the rdma_addr_cancel() based on state,
+		 * only RDMA_CM_ADDR_QUERY has a work that could still execute.
+		 * Notice that the addr_handler work could still be exiting
+		 * outside this state, however due to the interaction with the
+		 * handler_mutex the work is guaranteed not to touch id_priv
+		 * during exit.
+		 */
 		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
 		break;
 	case RDMA_CM_ROUTE_QUERY:
@@ -3410,6 +3418,21 @@ int rdma_resolve_addr(struct rdma_cm_id
 		if (dst_addr->sa_family == AF_IB) {
 			ret = cma_resolve_ib_addr(id_priv);
 		} else {
+			/*
+			 * The FSM can return back to RDMA_CM_ADDR_BOUND after
+			 * rdma_resolve_ip() is called, eg through the error
+			 * path in addr_handler(). If this happens the existing
+			 * request must be canceled before issuing a new one.
+			 * Since canceling a request is a bit slow and this
+			 * oddball path is rare, keep track once a request has
+			 * been issued. The track turns out to be a permanent
+			 * state since this is the only cancel as it is
+			 * immediately before rdma_resolve_ip().
+			 */
+			if (id_priv->used_resolve_ip)
+				rdma_addr_cancel(&id->route.addr.dev_addr);
+			else
+				id_priv->used_resolve_ip = 1;
 			ret = rdma_resolve_ip(cma_src_addr(id_priv), dst_addr,
 					      &id->route.addr.dev_addr,
 					      timeout_ms, addr_handler,
--- a/drivers/infiniband/core/cma_priv.h
+++ b/drivers/infiniband/core/cma_priv.h
@@ -91,6 +91,7 @@ struct rdma_id_private {
 	u8			afonly;
 	u8			timeout;
 	u8			min_rnr_timer;
+	u8 used_resolve_ip;
 	enum ib_gid_type	gid_type;
 
 	/*


