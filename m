Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8013C53CC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242887AbhGLH4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350680AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A40616E9;
        Mon, 12 Jul 2021 07:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076048;
        bh=ku/sqwX/+BwqlH/1g7STkp/ar7P0nBgRAAwnfOmy/FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2UHl5rCs448XhkNfAymmjQzMJffy65DfY6knoDV1GZRki67JiX8o529medEtNZ3U
         apWvMgrfrkVDdDvroZvmntIoBEV3MITT+9qWPaeedmf3UdN39o2Ln/4GfG01sXnjcM
         hTWGYaNr5K4FLnAubMPNVxEjoY0jMRV2zy4Gh7kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 433/800] RDMA/rtrs-clt: Check if the queue_depth has changed during a reconnection
Date:   Mon, 12 Jul 2021 08:07:36 +0200
Message-Id: <20210712061013.148029507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 5b73b799c25c68a4703cd6c5ac4518006d9865b8 ]

The queue_depth is a module parameter for rtrs_server. It is used on the
client side to determing the queue_depth of the request queue for the RNBD
virtual block device.

During a reconnection event for an already mapped device, in case the
rtrs_server module queue_depth has changed, fail the reconnect attempt.

Also stop further auto reconnection attempts. A manual reconnect via
sysfs has to be triggerred.

Fixes: 6a98d71daea18 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20210528113018.52290-20-jinpu.wang@ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index a563c9b9d52c..d4d54189c878 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1791,7 +1791,19 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 				  queue_depth);
 			return -ECONNRESET;
 		}
-		if (!sess->rbufs || sess->queue_depth < queue_depth) {
+		if (sess->queue_depth > 0 && queue_depth != sess->queue_depth) {
+			rtrs_err(clt, "Error: queue depth changed\n");
+
+			/*
+			 * Stop any more reconnection attempts
+			 */
+			sess->reconnect_attempts = -1;
+			rtrs_err(clt,
+				"Disabling auto-reconnect. Trigger a manual reconnect after issue is resolved\n");
+			return -ECONNRESET;
+		}
+
+		if (!sess->rbufs) {
 			kfree(sess->rbufs);
 			sess->rbufs = kcalloc(queue_depth, sizeof(*sess->rbufs),
 					      GFP_KERNEL);
@@ -1805,7 +1817,7 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 		sess->chunk_size = sess->max_io_size + sess->max_hdr_size;
 
 		/*
-		 * Global queue depth and IO size is always a minimum.
+		 * Global IO size is always a minimum.
 		 * If while a reconnection server sends us a value a bit
 		 * higher - client does not care and uses cached minimum.
 		 *
@@ -1813,8 +1825,7 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 		 * connections in parallel, use lock.
 		 */
 		mutex_lock(&clt->paths_mutex);
-		clt->queue_depth = min_not_zero(sess->queue_depth,
-						clt->queue_depth);
+		clt->queue_depth = sess->queue_depth;
 		clt->max_io_size = min_not_zero(sess->max_io_size,
 						clt->max_io_size);
 		mutex_unlock(&clt->paths_mutex);
-- 
2.30.2



