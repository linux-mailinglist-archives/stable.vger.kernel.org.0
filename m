Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4268B26B467
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgIOXXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgIOOiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFCB22453;
        Tue, 15 Sep 2020 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180060;
        bh=mCsVZeFmGfOlFW5jIKoW5RqqaJMHXJ4bKtdS9vWUi4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekc6VEebuq+0JvFgbZd0GiiZZnJFfPQD7+d+vSwmlVsf+kR4EPiJiSjkGkDikjxJE
         GhGjWzRmYzEPV+fodh4Gzweupi0aapkNAWDTTmkQdxnv7icMMRabDFbhFjhaDBams/
         ojhz0AgwM45scHIwqKj59POoTlaXvaIlo2/FPI+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 053/177] RDMA/rtrs-srv: Set .release function for rtrs srv device during device init
Date:   Tue, 15 Sep 2020 16:12:04 +0200
Message-Id: <20200915140656.174313908@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 39c2d639ca183a400ba3259fa0825714cbb09c53 ]

The device .release function was not being set during the device
initialization. This was leading to the below warning, in error cases when
put_srv was called before device_add was called.

Warning:

Device '(null)' does not have a release() function, it is broken and must
be fixed. See Documentation/kobject.txt.

So, set the device .release function during device initialization in the
__alloc_srv() function.

Fixes: baa5b28b7a47 ("RDMA/rtrs-srv: Replace device_register with device_initialize and device_add")
Link: https://lore.kernel.org/r/20200907102216.104041-1-haris.iqbal@cloud.ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 8 --------
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 2f981ae970767..cf6a2be61695d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -152,13 +152,6 @@ static struct attribute_group rtrs_srv_stats_attr_group = {
 	.attrs = rtrs_srv_stats_attrs,
 };
 
-static void rtrs_srv_dev_release(struct device *dev)
-{
-	struct rtrs_srv *srv = container_of(dev, struct rtrs_srv, dev);
-
-	kfree(srv);
-}
-
 static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 {
 	struct rtrs_srv *srv = sess->srv;
@@ -172,7 +165,6 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		goto unlock;
 	}
 	srv->dev.class = rtrs_dev_class;
-	srv->dev.release = rtrs_srv_dev_release;
 	err = dev_set_name(&srv->dev, "%s", sess->s.sessname);
 	if (err)
 		goto unlock;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index b61a18e57aeba..28f6414dfa3dc 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1319,6 +1319,13 @@ static int rtrs_srv_get_next_cq_vector(struct rtrs_srv_sess *sess)
 	return sess->cur_cq_vector;
 }
 
+static void rtrs_srv_dev_release(struct device *dev)
+{
+	struct rtrs_srv *srv = container_of(dev, struct rtrs_srv, dev);
+
+	kfree(srv);
+}
+
 static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 				     const uuid_t *paths_uuid)
 {
@@ -1337,6 +1344,7 @@ static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 	srv->queue_depth = sess_queue_depth;
 	srv->ctx = ctx;
 	device_initialize(&srv->dev);
+	srv->dev.release = rtrs_srv_dev_release;
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
-- 
2.25.1



