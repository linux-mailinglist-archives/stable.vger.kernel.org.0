Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAC829B8CD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802014AbgJ0PpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801051AbgJ0Phv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C74204EF;
        Tue, 27 Oct 2020 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813070;
        bh=1zDucQGoAD1pm8vzUOYZPH3EoBjMcR0w9x6+T1q1hcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvxPkNpeoGjn+zG5td5YTn5681SMuoblaa+IOMfK/XrplSebX7nncXkua28cZCAle
         c12G3fS4sFA1VWEqtg61QFcv2cNJX/EQL4kUYtplbbVVZ9he05+JVOT/Jtrui+PCU3
         ck2PYb/E2e0ZvLuxqYSi1Bv4Q82Asn09HuTattKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 427/757] RDMA/rtrs-srv: Incorporate ib_register_client into rtrs server init
Date:   Tue, 27 Oct 2020 14:51:17 +0100
Message-Id: <20201027135510.596601515@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 558d52b2976b1db3098139aa83ceb9af9066a0e7 ]

The rnbd_server module's communication manager (cm) initialization depends
on the registration of the "network namespace subsystem" of the RDMA CM
agent module. As such, when the kernel is configured to load the
rnbd_server and the RDMA cma module during initialization; and if the
rnbd_server module is initialized before RDMA cma module, a null ptr
dereference occurs during the RDMA bind operation.

Call trace:

  Call Trace:
   ? xas_load+0xd/0x80
   xa_load+0x47/0x80
   cma_ps_find+0x44/0x70
   rdma_bind_addr+0x782/0x8b0
   ? get_random_bytes+0x35/0x40
   rtrs_srv_cm_init+0x50/0x80
   rtrs_srv_open+0x102/0x180
   ? rnbd_client_init+0x6e/0x6e
   rnbd_srv_init_module+0x34/0x84
   ? rnbd_client_init+0x6e/0x6e
   do_one_initcall+0x4a/0x200
   kernel_init_freeable+0x1f1/0x26e
   ? rest_init+0xb0/0xb0
   kernel_init+0xe/0x100
   ret_from_fork+0x22/0x30
  Modules linked in:
  CR2: 0000000000000015

All this happens cause the cm init is in the call chain of the module
init, which is not a preferred practice.

So remove the call to rdma_create_id() from the module init call chain.
Instead register rtrs-srv as an ib client, which makes sure that the
rdma_create_id() is called only when an ib device is added.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20200907103106.104530-1-haris.iqbal@cloud.ionos.com
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 76 +++++++++++++++++++++++++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.h |  7 +++
 2 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 28f6414dfa3dc..d6f93601712e4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -16,6 +16,7 @@
 #include "rtrs-srv.h"
 #include "rtrs-log.h"
 #include <rdma/ib_cm.h>
+#include <rdma/ib_verbs.h>
 
 MODULE_DESCRIPTION("RDMA Transport Server");
 MODULE_LICENSE("GPL");
@@ -31,6 +32,7 @@ MODULE_LICENSE("GPL");
 static struct rtrs_rdma_dev_pd dev_pd;
 static mempool_t *chunk_pool;
 struct class *rtrs_dev_class;
+static struct rtrs_srv_ib_ctx ib_ctx;
 
 static int __read_mostly max_chunk_size = DEFAULT_MAX_CHUNK_SIZE;
 static int __read_mostly sess_queue_depth = DEFAULT_SESS_QUEUE_DEPTH;
@@ -2042,6 +2044,70 @@ static void free_srv_ctx(struct rtrs_srv_ctx *ctx)
 	kfree(ctx);
 }
 
+static int rtrs_srv_add_one(struct ib_device *device)
+{
+	struct rtrs_srv_ctx *ctx;
+	int ret = 0;
+
+	mutex_lock(&ib_ctx.ib_dev_mutex);
+	if (ib_ctx.ib_dev_count)
+		goto out;
+
+	/*
+	 * Since our CM IDs are NOT bound to any ib device we will create them
+	 * only once
+	 */
+	ctx = ib_ctx.srv_ctx;
+	ret = rtrs_srv_rdma_init(ctx, ib_ctx.port);
+	if (ret) {
+		/*
+		 * We errored out here.
+		 * According to the ib code, if we encounter an error here then the
+		 * error code is ignored, and no more calls to our ops are made.
+		 */
+		pr_err("Failed to initialize RDMA connection");
+		goto err_out;
+	}
+
+out:
+	/*
+	 * Keep a track on the number of ib devices added
+	 */
+	ib_ctx.ib_dev_count++;
+
+err_out:
+	mutex_unlock(&ib_ctx.ib_dev_mutex);
+	return ret;
+}
+
+static void rtrs_srv_remove_one(struct ib_device *device, void *client_data)
+{
+	struct rtrs_srv_ctx *ctx;
+
+	mutex_lock(&ib_ctx.ib_dev_mutex);
+	ib_ctx.ib_dev_count--;
+
+	if (ib_ctx.ib_dev_count)
+		goto out;
+
+	/*
+	 * Since our CM IDs are NOT bound to any ib device we will remove them
+	 * only once, when the last device is removed
+	 */
+	ctx = ib_ctx.srv_ctx;
+	rdma_destroy_id(ctx->cm_id_ip);
+	rdma_destroy_id(ctx->cm_id_ib);
+
+out:
+	mutex_unlock(&ib_ctx.ib_dev_mutex);
+}
+
+static struct ib_client rtrs_srv_client = {
+	.name	= "rtrs_server",
+	.add	= rtrs_srv_add_one,
+	.remove	= rtrs_srv_remove_one
+};
+
 /**
  * rtrs_srv_open() - open RTRS server context
  * @ops:		callback functions
@@ -2060,7 +2126,11 @@ struct rtrs_srv_ctx *rtrs_srv_open(struct rtrs_srv_ops *ops, u16 port)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	err = rtrs_srv_rdma_init(ctx, port);
+	mutex_init(&ib_ctx.ib_dev_mutex);
+	ib_ctx.srv_ctx = ctx;
+	ib_ctx.port = port;
+
+	err = ib_register_client(&rtrs_srv_client);
 	if (err) {
 		free_srv_ctx(ctx);
 		return ERR_PTR(err);
@@ -2099,8 +2169,8 @@ static void close_ctx(struct rtrs_srv_ctx *ctx)
  */
 void rtrs_srv_close(struct rtrs_srv_ctx *ctx)
 {
-	rdma_destroy_id(ctx->cm_id_ip);
-	rdma_destroy_id(ctx->cm_id_ib);
+	ib_unregister_client(&rtrs_srv_client);
+	mutex_destroy(&ib_ctx.ib_dev_mutex);
 	close_ctx(ctx);
 	free_srv_ctx(ctx);
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.h b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
index dc95b0932f0df..08b0b8a6eebe6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
@@ -118,6 +118,13 @@ struct rtrs_srv_ctx {
 	struct list_head srv_list;
 };
 
+struct rtrs_srv_ib_ctx {
+	struct rtrs_srv_ctx	*srv_ctx;
+	u16			port;
+	struct mutex            ib_dev_mutex;
+	int			ib_dev_count;
+};
+
 extern struct class *rtrs_dev_class;
 
 void close_sess(struct rtrs_srv_sess *sess);
-- 
2.25.1



