Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112D5657D51
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiL1PmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiL1PmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A5A1759F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABDFAB8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFE5C433D2;
        Wed, 28 Dec 2022 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242108;
        bh=bmwe9hza0Kq2PcA9tFkgJDySBGKlVx+NuVKGOQmv3Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uX/Aa9HhD8Gdr9g44u4pOXMBOUdmtEFyCr4FIWN02yuDtmIy06gq6P5wA/gO3lea
         gtOrANMcmezwp/YZe4EHlSQkFRJBBGPzh6dXlHuRGArLhA7KsEAMiEtm6/CyKQkRD0
         JdoLTUmR1mILFK0ShN2/wD+fMhfKh34VlZKCE/SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0330/1146] nvmet: only allocate a single slab for bvecs
Date:   Wed, 28 Dec 2022 15:31:09 +0100
Message-Id: <20221228144339.122726509@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fa8f9ac42350edd3ce82d0d148a60f0fa088f995 ]

There is no need to have a separate slab cache for each namespace,
and having separate ones creates duplicate debugs file names as well.

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c        | 22 ++++++++++++++--------
 drivers/nvme/target/io-cmd-file.c | 16 +++-------------
 drivers/nvme/target/nvmet.h       |  3 ++-
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index aecb5853f8da..683b75a992b3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -15,6 +15,7 @@
 
 #include "nvmet.h"
 
+struct kmem_cache *nvmet_bvec_cache;
 struct workqueue_struct *buffered_io_wq;
 struct workqueue_struct *zbd_wq;
 static const struct nvmet_fabrics_ops *nvmet_transports[NVMF_TRTYPE_MAX];
@@ -1631,26 +1632,28 @@ void nvmet_subsys_put(struct nvmet_subsys *subsys)
 
 static int __init nvmet_init(void)
 {
-	int error;
+	int error = -ENOMEM;
 
 	nvmet_ana_group_enabled[NVMET_DEFAULT_ANA_GRPID] = 1;
 
+	nvmet_bvec_cache = kmem_cache_create("nvmet-bvec",
+			NVMET_MAX_MPOOL_BVEC * sizeof(struct bio_vec), 0,
+			SLAB_HWCACHE_ALIGN, NULL);
+	if (!nvmet_bvec_cache)
+		return -ENOMEM;
+
 	zbd_wq = alloc_workqueue("nvmet-zbd-wq", WQ_MEM_RECLAIM, 0);
 	if (!zbd_wq)
-		return -ENOMEM;
+		goto out_destroy_bvec_cache;
 
 	buffered_io_wq = alloc_workqueue("nvmet-buffered-io-wq",
 			WQ_MEM_RECLAIM, 0);
-	if (!buffered_io_wq) {
-		error = -ENOMEM;
+	if (!buffered_io_wq)
 		goto out_free_zbd_work_queue;
-	}
 
 	nvmet_wq = alloc_workqueue("nvmet-wq", WQ_MEM_RECLAIM, 0);
-	if (!nvmet_wq) {
-		error = -ENOMEM;
+	if (!nvmet_wq)
 		goto out_free_buffered_work_queue;
-	}
 
 	error = nvmet_init_discovery();
 	if (error)
@@ -1669,6 +1672,8 @@ static int __init nvmet_init(void)
 	destroy_workqueue(buffered_io_wq);
 out_free_zbd_work_queue:
 	destroy_workqueue(zbd_wq);
+out_destroy_bvec_cache:
+	kmem_cache_destroy(nvmet_bvec_cache);
 	return error;
 }
 
@@ -1680,6 +1685,7 @@ static void __exit nvmet_exit(void)
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
+	kmem_cache_destroy(nvmet_bvec_cache);
 
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_entry) != 1024);
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_hdr) != 1024);
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 64b47e2a4633..e55ec6fefd7f 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -11,7 +11,6 @@
 #include <linux/fs.h>
 #include "nvmet.h"
 
-#define NVMET_MAX_MPOOL_BVEC		16
 #define NVMET_MIN_MPOOL_OBJ		16
 
 void nvmet_file_ns_revalidate(struct nvmet_ns *ns)
@@ -26,8 +25,6 @@ void nvmet_file_ns_disable(struct nvmet_ns *ns)
 			flush_workqueue(buffered_io_wq);
 		mempool_destroy(ns->bvec_pool);
 		ns->bvec_pool = NULL;
-		kmem_cache_destroy(ns->bvec_cache);
-		ns->bvec_cache = NULL;
 		fput(ns->file);
 		ns->file = NULL;
 	}
@@ -59,16 +56,8 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 	ns->blksize_shift = min_t(u8,
 			file_inode(ns->file)->i_blkbits, 12);
 
-	ns->bvec_cache = kmem_cache_create("nvmet-bvec",
-			NVMET_MAX_MPOOL_BVEC * sizeof(struct bio_vec),
-			0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!ns->bvec_cache) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
 	ns->bvec_pool = mempool_create(NVMET_MIN_MPOOL_OBJ, mempool_alloc_slab,
-			mempool_free_slab, ns->bvec_cache);
+			mempool_free_slab, nvmet_bvec_cache);
 
 	if (!ns->bvec_pool) {
 		ret = -ENOMEM;
@@ -77,9 +66,10 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 
 	return ret;
 err:
+	fput(ns->file);
+	ns->file = NULL;
 	ns->size = 0;
 	ns->blksize_shift = 0;
-	nvmet_file_ns_disable(ns);
 	return ret;
 }
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index dfe3894205aa..bda1c1f71f39 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -77,7 +77,6 @@ struct nvmet_ns {
 
 	struct completion	disable_done;
 	mempool_t		*bvec_pool;
-	struct kmem_cache	*bvec_cache;
 
 	int			use_p2pmem;
 	struct pci_dev		*p2p_dev;
@@ -393,6 +392,8 @@ struct nvmet_req {
 	u64			error_slba;
 };
 
+#define NVMET_MAX_MPOOL_BVEC		16
+extern struct kmem_cache *nvmet_bvec_cache;
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
 extern struct workqueue_struct *nvmet_wq;
-- 
2.35.1



