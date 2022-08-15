Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE61593978
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244759AbiHOTTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344975AbiHOTRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71551564E1;
        Mon, 15 Aug 2022 11:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEEB3CE1253;
        Mon, 15 Aug 2022 18:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD21C433C1;
        Mon, 15 Aug 2022 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588749;
        bh=4QTy4VuNrwHbm6F9nK5OsrjmKkU9hM9GD3lZEJ/H5jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+t4GyKuTa4WkToCH5DYkHGvUO6igRPxxk37bsVPmlVEP0chvZlsL48V4+tki55Ap
         Nsckdf7mU52cxmMAo0lNYKUiC0qThDaquCIXji7ww3ltz06JD14ZGsFRRPjdP8C/OT
         hQgdAAx1i78qKh0vpgYZljBSlqP2/AKQNsK66kVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/779] RDMA/rtrs: Fix warning when use poll mode on client side.
Date:   Mon, 15 Aug 2022 20:02:27 +0200
Message-Id: <20220815180358.762412809@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 4b6afe9bc955bee44c0527005c3fb0edac91ac30 ]

When testing with poll mode, it will fail and lead to warning below on
client side:

$ echo "sessname=bla path=gid:fe80::2:c903:4e:d0b3@gid:fe80::2:c903:8:ca17 device_path=/dev/nullb2 nr_poll_queues=-1" | \
  sudo tee /sys/devices/virtual/rnbd-client/ctl/map_device

rnbd_client L597: Mapping device /dev/nullb2 on session bla, (access_mode: rw, nr_poll_queues: 8)
WARNING: CPU: 3 PID: 9886 at drivers/infiniband/core/cq.c:447 ib_cq_pool_get+0x26f/0x2a0 [ib_core]

The problem is in case of poll queue, we need to still call
ib_alloc_cq/ib_free_cq, we can't use cq_poll api for poll queue.

As both client and server use shared function from rtrs, set irq_con_num
to con_num on server side, which is number of total connection of the
session, this way we can differ if the rtrs_con requires pollqueue.

Following up patches will replace the duplicate code with helpers.

Link: https://lore.kernel.org/r/20210922125333.351454-4-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |  1 +
 drivers/infiniband/ulp/rtrs/rtrs.c     | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 716ef7b23558..078a1cbac90c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1766,6 +1766,7 @@ static struct rtrs_srv_sess *__alloc_sess(struct rtrs_srv *srv,
 	strscpy(sess->s.sessname, str, sizeof(sess->s.sessname));
 
 	sess->s.con_num = con_num;
+	sess->s.irq_con_num = con_num;
 	sess->s.recon_cnt = recon_cnt;
 	uuid_copy(&sess->s.uuid, uuid);
 	spin_lock_init(&sess->state_lock);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index ca542e477d38..9bc323490ce3 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -228,7 +228,12 @@ static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 	struct rdma_cm_id *cm_id = con->cm_id;
 	struct ib_cq *cq;
 
-	cq = ib_cq_pool_get(cm_id->device, nr_cqe, cq_vector, poll_ctx);
+	if (con->cid >= con->sess->irq_con_num)
+		cq = ib_alloc_cq(cm_id->device, con, nr_cqe, cq_vector,
+				 poll_ctx);
+	else
+		cq = ib_cq_pool_get(cm_id->device, nr_cqe, cq_vector, poll_ctx);
+
 	if (IS_ERR(cq)) {
 		rtrs_err(con->sess, "Creating completion queue failed, errno: %ld\n",
 			  PTR_ERR(cq));
@@ -283,7 +288,10 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 	err = create_qp(con, sess->dev->ib_pd, max_send_wr, max_recv_wr,
 			max_send_sge);
 	if (err) {
-		ib_cq_pool_put(con->cq, con->nr_cqe);
+		if (con->cid >= con->sess->irq_con_num)
+			ib_free_cq(con->cq);
+		else
+			ib_cq_pool_put(con->cq, con->nr_cqe);
 		con->cq = NULL;
 		return err;
 	}
@@ -300,7 +308,10 @@ void rtrs_cq_qp_destroy(struct rtrs_con *con)
 		con->qp = NULL;
 	}
 	if (con->cq) {
-		ib_cq_pool_put(con->cq, con->nr_cqe);
+		if (con->cid >= con->sess->irq_con_num)
+			ib_free_cq(con->cq);
+		else
+			ib_cq_pool_put(con->cq, con->nr_cqe);
 		con->cq = NULL;
 	}
 }
-- 
2.35.1



