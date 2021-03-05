Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F225332E7F2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhCEMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhCEMXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAD86501C;
        Fri,  5 Mar 2021 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947028;
        bh=r91vrIHAOPXRQ7PwOt/z6P6t4QK02lvrk+2C2Rg0RrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUGIwPgWCpGcwFQhSh96mMf1Z9/kY7UHs/aNgHhn2V4KJNjPNxi6SN8l6R87C/BId
         pOnKRJ9k/0fceNIYZDpoaQ0dxV2rvhM8EwSdA3DkM4VrnypEMRwe0ENakFr5IfMsjZ
         QHW/rLEyll4Mr3aX4SZ+L1PQwv1P5RZMtP2vEroQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.11 021/104] RDMA/rtrs: Do not signal for heatbeat
Date:   Fri,  5 Mar 2021 13:20:26 +0100
Message-Id: <20210305120904.216744765@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
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
@@ -666,7 +666,6 @@ static void rtrs_clt_rdma_done(struct ib
 	case IB_WC_RDMA_WRITE:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
-		 * and hb
 		 */
 		break;
 
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1244,7 +1244,6 @@ static void rtrs_srv_rdma_done(struct ib
 	case IB_WC_SEND:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
-		 * and hb
 		 */
 		atomic_add(srv->queue_depth, &con->sq_wr_avail);
 
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -310,7 +310,7 @@ void rtrs_send_hb_ack(struct rtrs_sess *
 
 	imm = rtrs_to_imm(RTRS_HB_ACK_IMM, 0);
 	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
-					      IB_SEND_SIGNALED, NULL);
+					     0, NULL);
 	if (err) {
 		sess->hb_err_handler(usr_con);
 		return;
@@ -339,7 +339,7 @@ static void hb_work(struct work_struct *
 	}
 	imm = rtrs_to_imm(RTRS_HB_MSG_IMM, 0);
 	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
-					      IB_SEND_SIGNALED, NULL);
+					     0, NULL);
 	if (err) {
 		sess->hb_err_handler(usr_con);
 		return;


