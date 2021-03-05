Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7887D32E8CA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCEM27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhCEM23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796846503D;
        Fri,  5 Mar 2021 12:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947309;
        bh=c3ICcnIU/ggw304dWB8KGw0IHl5RYZhx7iSGlP9m6gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6tZJHvlGJUj2BFjum0Lwy9bBeCaDVPz8RXZivWwfqRWwE9ZFSXDuqfFFNb7JhXrP
         IRTsOgSUU7URlogoeEDfGekg0mAPIJfQdaGIvsg/I3+3qFf6VuJXnuQiN8vIgxJ9ww
         PQQW+zvFQDoAI3ItK7/y+hItg1gEaRHjOEYNI0Is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 020/102] RDMA/rtrs: Do not signal for heatbeat
Date:   Fri,  5 Mar 2021 13:20:39 +0100
Message-Id: <20210305120904.274651575@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

commit b38041d50add1c881fbc60eb2be93b58fc58ea21 upstream.

For HB, there is no need to generate signal for completion.

Also remove a comment accordingly.

Fixes: c0894b3ea69d ("RDMA/rtrs: core: lib functions shared between client and server modules")
Link: https://lore.kernel.org/r/20201217141915.56989-16-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reported-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |    1 -
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |    1 -
 drivers/infiniband/ulp/rtrs/rtrs.c     |    4 ++--
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -672,7 +672,6 @@ static void rtrs_clt_rdma_done(struct ib
 	case IB_WC_RDMA_WRITE:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
-		 * and hb
 		 */
 		break;
 
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1260,7 +1260,6 @@ static void rtrs_srv_rdma_done(struct ib
 	case IB_WC_SEND:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
-		 * and hb
 		 */
 		atomic_add(srv->queue_depth, &con->sq_wr_avail);
 
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -325,7 +325,7 @@ void rtrs_send_hb_ack(struct rtrs_sess *
 
 	imm = rtrs_to_imm(RTRS_HB_ACK_IMM, 0);
 	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
-					      IB_SEND_SIGNALED, NULL);
+					     0, NULL);
 	if (err) {
 		sess->hb_err_handler(usr_con);
 		return;
@@ -354,7 +354,7 @@ static void hb_work(struct work_struct *
 	}
 	imm = rtrs_to_imm(RTRS_HB_MSG_IMM, 0);
 	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
-					      IB_SEND_SIGNALED, NULL);
+					     0, NULL);
 	if (err) {
 		sess->hb_err_handler(usr_con);
 		return;


