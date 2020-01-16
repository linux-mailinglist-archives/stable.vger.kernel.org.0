Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1166A13FFF8
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgAPXqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388331AbgAPXVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22146206D9;
        Thu, 16 Jan 2020 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216896;
        bh=DpGXwf5WCT68h30EiLxwSBUtzxw2I203M5y/g0r7J7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEaTDQ6yf4XXxMOfuXBr5JUsrWWpZdQXUzeQQ8VrkfpQEWUC0DjErLHIk/UOR+RtS
         gzv6lv5P1C3jdCviBfAgLFxVYZMkiaZZ8NMKeUPu+tCIimid47QgxsnYDODoWJJVCp
         dgsaE/apwYpoQTdFXu/Dm6en3u+Lqdah+EugS/wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 064/203] RDMA/counter: Prevent QP counter manual binding in auto mode
Date:   Fri, 17 Jan 2020 00:16:21 +0100
Message-Id: <20200116231749.667062189@linuxfoundation.org>
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

From: Mark Zhang <markz@mellanox.com>

commit 663912a6378a34fd4f43b8d873f0c6c6322d9d0e upstream.

If auto mode is configured, manual counter allocation and QP bind is not
allowed.

Fixes: 1bd8e0a9d0fd ("RDMA/counter: Allow manual mode configuration support")
Link: https://lore.kernel.org/r/20190916071154.20383-3-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/counters.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -466,10 +466,15 @@ static struct rdma_counter *rdma_get_cou
 int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
 			  u32 qp_num, u32 counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;
 
+	port_counter = &dev->port_data[port].port_counter;
+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;
@@ -506,6 +511,7 @@ err:
 int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 				u32 qp_num, u32 *counter_id)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
 	struct ib_qp *qp;
 	int ret;
@@ -513,9 +519,13 @@ int rdma_counter_bind_qpn_alloc(struct i
 	if (!rdma_is_port_valid(dev, port))
 		return -EINVAL;
 
-	if (!dev->port_data[port].port_counter.hstats)
+	port_counter = &dev->port_data[port].port_counter;
+	if (!port_counter->hstats)
 		return -EOPNOTSUPP;
 
+	if (port_counter->mode.mode == RDMA_COUNTER_MODE_AUTO)
+		return -EINVAL;
+
 	qp = rdma_counter_get_qp(dev, qp_num);
 	if (!qp)
 		return -ENOENT;


