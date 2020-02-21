Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091BE167647
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgBUILC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732627AbgBUILC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA362067D;
        Fri, 21 Feb 2020 08:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272661;
        bh=Uht5GtVklLaXQw3IXPvUNUVpdxyIbB2MtgFOyDgstrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw9+1uG/EYAuky/lnqL8m2IzB2wVEtf6GUDc+2ZkGb5rfUG+MWs4tHzwF9WZQSJU8
         Sy0rALbKVUbh/D+4UUtPB5nsEG3srhZ61okPARs87sXdpX17OOtIZ2DAwgD0aAtBAA
         4jkIxPQgI9ElGcdyU8Spq40O654Ejfx4Qmc17NNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/344] dm thin: dont allow changing data device during thin-pool reload
Date:   Fri, 21 Feb 2020 08:40:27 +0100
Message-Id: <20200221072409.955159986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 873937e75f9a8ea231a502c3d29d9cb6ad91b3ef ]

The existing code allows changing the data device when the thin-pool
target is reloaded.

This capability is not required and only complicates device lifetime
guarantees. This can cause crashes like the one reported here:
	https://bugzilla.redhat.com/show_bug.cgi?id=1788596
where the kernel tries to issue a flush bio located in a structure that
was already freed.

Take the first step to simplifying the thin-pool's data device lifetime
by disallowing changing it. Like the thin-pool's metadata device, the
data device is now set in pool_create() and it cannot be changed for a
given thin-pool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 69201bdf7f4c6..1b2c98b43519f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -231,6 +231,7 @@ struct pool {
 	struct dm_target *ti;	/* Only set if a pool target is bound */
 
 	struct mapped_device *pool_md;
+	struct block_device *data_dev;
 	struct block_device *md_dev;
 	struct dm_pool_metadata *pmd;
 
@@ -2945,6 +2946,7 @@ static struct kmem_cache *_new_mapping_cache;
 
 static struct pool *pool_create(struct mapped_device *pool_md,
 				struct block_device *metadata_dev,
+				struct block_device *data_dev,
 				unsigned long block_size,
 				int read_only, char **error)
 {
@@ -3052,6 +3054,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->last_commit_jiffies = jiffies;
 	pool->pool_md = pool_md;
 	pool->md_dev = metadata_dev;
+	pool->data_dev = data_dev;
 	__pool_table_insert(pool);
 
 	return pool;
@@ -3093,6 +3096,7 @@ static void __pool_dec(struct pool *pool)
 
 static struct pool *__pool_find(struct mapped_device *pool_md,
 				struct block_device *metadata_dev,
+				struct block_device *data_dev,
 				unsigned long block_size, int read_only,
 				char **error, int *created)
 {
@@ -3103,19 +3107,23 @@ static struct pool *__pool_find(struct mapped_device *pool_md,
 			*error = "metadata device already in use by a pool";
 			return ERR_PTR(-EBUSY);
 		}
+		if (pool->data_dev != data_dev) {
+			*error = "data device already in use by a pool";
+			return ERR_PTR(-EBUSY);
+		}
 		__pool_inc(pool);
 
 	} else {
 		pool = __pool_table_lookup(pool_md);
 		if (pool) {
-			if (pool->md_dev != metadata_dev) {
+			if (pool->md_dev != metadata_dev || pool->data_dev != data_dev) {
 				*error = "different pool cannot replace a pool";
 				return ERR_PTR(-EINVAL);
 			}
 			__pool_inc(pool);
 
 		} else {
-			pool = pool_create(pool_md, metadata_dev, block_size, read_only, error);
+			pool = pool_create(pool_md, metadata_dev, data_dev, block_size, read_only, error);
 			*created = 1;
 		}
 	}
@@ -3368,7 +3376,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out;
 	}
 
-	pool = __pool_find(dm_table_get_md(ti->table), metadata_dev->bdev,
+	pool = __pool_find(dm_table_get_md(ti->table), metadata_dev->bdev, data_dev->bdev,
 			   block_size, pf.mode == PM_READ_ONLY, &ti->error, &pool_created);
 	if (IS_ERR(pool)) {
 		r = PTR_ERR(pool);
@@ -4114,7 +4122,7 @@ static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 21, 0},
+	.version = {1, 22, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -4493,7 +4501,7 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 21, 0},
+	.version = {1, 22, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
-- 
2.20.1



