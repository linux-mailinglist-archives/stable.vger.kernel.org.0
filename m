Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3236578D9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiL1Oyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiL1Oyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C608F1260A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6608761544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721F0C433D2;
        Wed, 28 Dec 2022 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239284;
        bh=uYkr0ptwyMdaC2srWYnTT1MLtk7AGAAzURmQUDOvkHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhv/pECdCSY9TabLDKNEC2v9fB7igqJHgCgcaYaBbFoYr8JpHgbvvclJlCLoqCOIw
         CvegIsSOEySOopR7fmMEo9zyND1SYuWSWVlptu4wAKlqtReRlVUsL9nFp1ul+reNr0
         +z0f7b/85O9m/A9nOSkPax4PIryQ/GmpOqA2s57o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/731] nvmet: only allocate a single slab for bvecs
Date:   Wed, 28 Dec 2022 15:35:04 +0100
Message-Id: <20221228144302.269902737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 87a347248c38..cfd038551156 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -15,6 +15,7 @@
 
 #include "nvmet.h"
 
+struct kmem_cache *nvmet_bvec_cache;
 struct workqueue_struct *buffered_io_wq;
 struct workqueue_struct *zbd_wq;
 static const struct nvmet_fabrics_ops *nvmet_transports[NVMF_TRTYPE_MAX];
@@ -1607,26 +1608,28 @@ void nvmet_subsys_put(struct nvmet_subsys *subsys)
 
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
@@ -1645,6 +1648,8 @@ static int __init nvmet_init(void)
 	destroy_workqueue(buffered_io_wq);
 out_free_zbd_work_queue:
 	destroy_workqueue(zbd_wq);
+out_destroy_bvec_cache:
+	kmem_cache_destroy(nvmet_bvec_cache);
 	return error;
 }
 
@@ -1656,6 +1661,7 @@ static void __exit nvmet_exit(void)
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
+	kmem_cache_destroy(nvmet_bvec_cache);
 
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_entry) != 1024);
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_hdr) != 1024);
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 228871d48106..eadba13b276d 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -11,7 +11,6 @@
 #include <linux/fs.h>
 #include "nvmet.h"
 
-#define NVMET_MAX_MPOOL_BVEC		16
 #define NVMET_MIN_MPOOL_OBJ		16
 
 int nvmet_file_ns_revalidate(struct nvmet_ns *ns)
@@ -33,8 +32,6 @@ void nvmet_file_ns_disable(struct nvmet_ns *ns)
 			flush_workqueue(buffered_io_wq);
 		mempool_destroy(ns->bvec_pool);
 		ns->bvec_pool = NULL;
-		kmem_cache_destroy(ns->bvec_cache);
-		ns->bvec_cache = NULL;
 		fput(ns->file);
 		ns->file = NULL;
 	}
@@ -68,16 +65,8 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
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
@@ -86,9 +75,10 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 
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
index dbeb0b8c1194..fdb06a9d430d 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -77,7 +77,6 @@ struct nvmet_ns {
 
 	struct completion	disable_done;
 	mempool_t		*bvec_pool;
-	struct kmem_cache	*bvec_cache;
 
 	int			use_p2pmem;
 	struct pci_dev		*p2p_dev;
@@ -363,6 +362,8 @@ struct nvmet_req {
 	u64			error_slba;
 };
 
+#define NVMET_MAX_MPOOL_BVEC		16
+extern struct kmem_cache *nvmet_bvec_cache;
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
 extern struct workqueue_struct *nvmet_wq;
-- 
2.35.1



