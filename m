Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82C326B5AA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgIOXsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B11923BCB;
        Tue, 15 Sep 2020 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179859;
        bh=8nQpmBYjaZnEjQBC/K8dR/WQQkqe0zsoRPOKY9J4eXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/Yq2nI5zazmOE7+BuZp2V9YLIBLyMyuTdmj9FKv6WDsr+YKyeNLXb0x3HZweB+bu
         hF1mgn7HpbD9f/KwKUbwG0Q5er08FvBmhOPrTcOSyYqaTk8+vvcKjXEqL+pWsaBgsq
         rxiT2y8carrOEVWz99sKFHvpEFumEiNqPhP+UU9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 014/177] RDMA/rtrs-srv: Replace device_register with device_initialize and device_add
Date:   Tue, 15 Sep 2020 16:11:25 +0200
Message-Id: <20200915140654.322625647@linuxfoundation.org>
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

[ Upstream commit baa5b28b7a474f66a511ebf71a2ade510652a2f6 ]

There are error cases when we will call free_srv before device kobject is
initialized; in such cases calling put_device generates the following
warning:

 kobject: '(null)' (000000009f5445ed): is not initialized, yet
 kobject_put() is being called.

So call device_initialize() only once when the server is allocated. If we
end up calling put_srv() and subsequently free_srv(), our call to
put_device() would result in deletion of the obj. Call device_add() later
when we actually have a connection. Correspondingly, call device_del()
instead of device_unregister() when srv->dev_ref falls to 0.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20200811092722.2450-1-haris.iqbal@cloud.ionos.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 8 ++++----
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 3d7877534bcc9..2f981ae970767 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -182,16 +182,16 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 	 * sysfs files are created
 	 */
 	dev_set_uevent_suppress(&srv->dev, true);
-	err = device_register(&srv->dev);
+	err = device_add(&srv->dev);
 	if (err) {
-		pr_err("device_register(): %d\n", err);
+		pr_err("device_add(): %d\n", err);
 		goto put;
 	}
 	srv->kobj_paths = kobject_create_and_add("paths", &srv->dev.kobj);
 	if (!srv->kobj_paths) {
 		err = -ENOMEM;
 		pr_err("kobject_create_and_add(): %d\n", err);
-		device_unregister(&srv->dev);
+		device_del(&srv->dev);
 		goto unlock;
 	}
 	dev_set_uevent_suppress(&srv->dev, false);
@@ -216,7 +216,7 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		kobject_del(srv->kobj_paths);
 		kobject_put(srv->kobj_paths);
 		mutex_unlock(&srv->paths_mutex);
-		device_unregister(&srv->dev);
+		device_del(&srv->dev);
 	} else {
 		mutex_unlock(&srv->paths_mutex);
 	}
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index a219bd1bdbc26..b61a18e57aeba 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1336,6 +1336,7 @@ static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 	uuid_copy(&srv->paths_uuid, paths_uuid);
 	srv->queue_depth = sess_queue_depth;
 	srv->ctx = ctx;
+	device_initialize(&srv->dev);
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
-- 
2.25.1



